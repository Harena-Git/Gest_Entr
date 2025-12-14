package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;
import java.util.Collections;

@Service
@Transactional
public class PresenceAbsenceService {

    @Autowired
    private PresenceAbsenceRepository presenceAbsenceRepository;

    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private HoraireEntrepriseRepository horaireEntrepriseRepository;

    @Autowired
    private JustificationRetardRepository justificationRetardRepository;

    @Autowired
    private AuditLogService auditLogService;

    private PresenceAbsence getPresenceForJustification(Personnel personnel, LocalDate date) {
        return presenceAbsenceRepository.findByPersonnelAndDate(personnel, date)
                .orElseGet(() -> {
                    // Créer une présence d'absence si non trouvée
                    PresenceAbsence presence = new PresenceAbsence();
                    presence.setPersonnel(personnel);
                    presence.setDate(date);
                    presence.setPresent(false);
                    return presenceAbsenceRepository.save(presence);
                });
    }

    public PresenceAbsence getOrCreatePresenceByPersonnelAndDate(Integer idPersonnel, LocalDate date) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        
        return presenceAbsenceRepository.findByPersonnelAndDate(personnel, date)
                .orElseGet(() -> {
                    PresenceAbsence presence = new PresenceAbsence();
                    presence.setPersonnel(personnel);
                    presence.setDate(date);
                    presence.setPresent(false);
                    return presenceAbsenceRepository.save(presence);
                });
    }

    // ========== POINTAGE ENTRÉE ==========
    public PresenceAbsence enregistrerEntree(Integer actorId, String actorType, LocalDate date, LocalTime heureArrivee) {
        // Vérifier si une entrée existe déjà
        if ("personnel".equalsIgnoreCase(actorType)) {
            Personnel personnel = personnelRepository.findById(actorId)
                    .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
            
            if (presenceAbsenceRepository.existsEntreeByPersonnelAndDate(personnel, date)) {
                throw new RuntimeException("Une entrée existe déjà pour ce personnel à cette date");
            }
            
            PresenceAbsence presence = new PresenceAbsence();
            presence.setPersonnel(personnel);
            presence.setDate(date);
            presence.setHeureArrivee(heureArrivee);
            presence.setPresent(true);
            
            PresenceAbsence saved = presenceAbsenceRepository.save(presence);
            
            // Audit log
            auditLogService.log("presence_absence", saved.getIdPresenceAbsence(), 
                    "ENTREE", actorId, AuditLog.UserType.PERSONNEL, 
                    "Pointage entrée à " + heureArrivee);
            
            // Vérifier retard (sera géré par le trigger, mais on peut aussi le faire ici)
            verifierEtCreerJustificationRetard(personnel, date, heureArrivee);
            
            return saved;
            
        } else if ("user".equalsIgnoreCase(actorType)) {
            User user = userRepository.findById(actorId)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
            
            if (presenceAbsenceRepository.existsEntreeByUserAndDate(user, date)) {
                throw new RuntimeException("Une entrée existe déjà pour cet utilisateur à cette date");
            }
            
            PresenceAbsence presence = new PresenceAbsence();
            presence.setUser(user);
            presence.setDate(date);
            presence.setHeureArrivee(heureArrivee);
            presence.setPresent(true);
            
            PresenceAbsence saved = presenceAbsenceRepository.save(presence);
            
            // Audit log
            auditLogService.log("presence_absence", saved.getIdPresenceAbsence(), 
                    "ENTREE", actorId, AuditLog.UserType.USER, 
                    "Pointage entrée responsable à " + heureArrivee);
            
            return saved;
        }
        
        throw new RuntimeException("Type d'acteur invalide");
    }

    // ========== POINTAGE SORTIE ==========
    public PresenceAbsence enregistrerSortie(Integer actorId, String actorType, LocalDate date, LocalTime heureDepart) {
        PresenceAbsence presence = null;
        
        if ("personnel".equalsIgnoreCase(actorType)) {
            Personnel personnel = personnelRepository.findById(actorId)
                    .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
            
            presence = presenceAbsenceRepository.findByPersonnelAndDate(personnel, date)
                    .orElseThrow(() -> new RuntimeException("Aucune entrée trouvée pour cette date"));
            
        } else if ("user".equalsIgnoreCase(actorType)) {
            User user = userRepository.findById(actorId)
                    .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
            
            presence = presenceAbsenceRepository.findByUserAndDate(user, date)
                    .orElseThrow(() -> new RuntimeException("Aucune entrée trouvée pour cette date"));
        } else {
            throw new RuntimeException("Type d'acteur invalide");
        }
        
        if (presence.getHeureArrivee() == null) {
            throw new RuntimeException("Impossible d'enregistrer une sortie sans entrée");
        }
        
        presence.setHeureDepart(heureDepart);
        PresenceAbsence saved = presenceAbsenceRepository.save(presence);
        
        // Audit log
        auditLogService.log("presence_absence", saved.getIdPresenceAbsence(), 
                "SORTIE", actorId, 
                "personnel".equalsIgnoreCase(actorType) ? AuditLog.UserType.PERSONNEL : AuditLog.UserType.USER,
                "Pointage sortie à " + heureDepart);
        
        return saved;
    }

    // ========== VÉRIFIER ET CRÉER JUSTIFICATION RETARD ==========
    private void verifierEtCreerJustificationRetard(Personnel personnel, LocalDate date, LocalTime heureArrivee) {
        Optional<HoraireEntreprise> horaireOpt = horaireEntrepriseRepository.findHoraireActif();
        
        if (horaireOpt.isPresent()) {
            HoraireEntreprise horaire = horaireOpt.get();
            int minutesRetard = horaire.calculerMinutesRetard(heureArrivee);
            
            // Si retard >= 15 minutes, créer une justification automatiquement
            if (minutesRetard >= 15) {
                if (!justificationRetardRepository.existsByPersonnelAndDateRetard(personnel, date)) {
                    JustificationRetard justifRetard = new JustificationRetard();
                    justifRetard.setPersonnel(personnel);
                    justifRetard.setDateRetard(date);
                    justifRetard.setMinutesRetard(minutesRetard);
                    justifRetard.setEstJustifie(false);
                    
                    justificationRetardRepository.save(justifRetard);
                }
            }
        }
    }

    // ========== RÉCUPÉRER PRÉSENCE PAR ID ==========
    public PresenceAbsence getPresenceById(Integer id) {
        return presenceAbsenceRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Présence non trouvée"));
    }

    public PresenceAbsence getPresenceByPersonnelAndDate(Integer personnelId, LocalDate date) {
        return presenceAbsenceRepository.findByPersonnelIdAndDate(personnelId, date)
            .orElseThrow(() -> new RuntimeException("Présence non trouvée pour le personnel à cette date")); 
    }

    // ========== RÉCUPÉRER PRÉSENCES D'UN PERSONNEL ==========
    public List<PresenceAbsence> getPresencesByPersonnel(Integer idPersonnel) {
        return personnelRepository.findById(idPersonnel)
            .map(personnel -> {
                List<PresenceAbsence> presences = presenceAbsenceRepository.findByPersonnelOrderByDateDesc(personnel);
                // Initialize lazy collections used in views (validationsChef) while session is open
                if (presences != null) {
                    for (PresenceAbsence pa : presences) {
                        if (pa.getValidationsChef() != null) {
                            pa.getValidationsChef().size();
                        }
                    }
                }
                return presences;
            })
            .orElse(Collections.emptyList());
    }

    // ========== RÉCUPÉRER PRÉSENCES D'UN PERSONNEL SUR PÉRIODE ==========
    public List<PresenceAbsence> getPresencesByPersonnelEtPeriode(Integer idPersonnel, LocalDate dateDebut, LocalDate dateFin) {
        return personnelRepository.findById(idPersonnel)
            .map(personnel -> {
                List<PresenceAbsence> presences = presenceAbsenceRepository.findByPersonnelAndDateBetween(personnel, dateDebut, dateFin);
                // Initialize lazy collections used in views (validationsChef) while session is open
                if (presences != null) {
                    for (PresenceAbsence pa : presences) {
                        if (pa.getValidationsChef() != null) {
                            pa.getValidationsChef().size();
                        }
                    }
                }
                return presences;
            })
            .orElse(Collections.emptyList());
    }

    // ========== RÉCUPÉRER PRÉSENCES DU JOUR ==========
    public List<PresenceAbsence> getPresencesDuJour(LocalDate date) {
        return presenceAbsenceRepository.findByDate(date);
    }

    // ========== RÉCUPÉRER PRÉSENCES PAR DÉPARTEMENT ==========
    public List<PresenceAbsence> getPresencesByDepartementEtDate(Integer idDepartement, LocalDate date) {
        return presenceAbsenceRepository.findByDepartementAndDate(idDepartement, date);
    }

    // ========== RÉCUPÉRER PRÉSENCES EN ATTENTE VALIDATION CHEF ==========
    public List<PresenceAbsence> getPresencesEnAttenteValidationChef() {
        return presenceAbsenceRepository.findPresencesEnAttenteValidationChef();
    }

    // ========== RÉCUPÉRER PRÉSENCES EN ATTENTE VALIDATION CHEF PAR DÉPARTEMENT ==========
    public List<PresenceAbsence> getPresencesEnAttenteValidationChefByDepartement(Integer idDepartement) {
        return presenceAbsenceRepository.findPresencesEnAttenteValidationChefByDepartement(idDepartement);
    }

    // ========== RÉCUPÉRER PRÉSENCES EN ATTENTE VALIDATION RH ==========
    public List<PresenceAbsence> getPresencesEnAttenteValidationRh() {
        return presenceAbsenceRepository.findPresencesEnAttenteValidationRh();
    }

    // ========== RÉCUPÉRER PRÉSENCES SANS SORTIE ==========
    public List<PresenceAbsence> getPresencesSansSortie(LocalDate dateLimite) {
        return presenceAbsenceRepository.findPresencesSansSortie(dateLimite);
    }

    // ========== CALCULER HEURES TRAVAILLÉES ==========
    public int calculerHeuresTravaillees(PresenceAbsence presence) {
        if (presence.getHeureArrivee() == null || presence.getHeureDepart() == null) {
            return 0;
        }
        
        int totalMinutes = (int) java.time.Duration.between(
                presence.getHeureArrivee(), 
                presence.getHeureDepart()
        ).toMinutes();
        
        // Soustraire la pause
        Optional<HoraireEntreprise> horaireOpt = horaireEntrepriseRepository.findHoraireActif();
        if (horaireOpt.isPresent()) {
            HoraireEntreprise horaire = horaireOpt.get();
            totalMinutes -= horaire.getDureePauseMinutes();
        }
        
        return Math.max(0, totalMinutes);
    }

    // ========== CALCULER HEURES SUPPLÉMENTAIRES ==========
    public int calculerHeuresSupplementaires(PresenceAbsence presence) {
        if (presence.getHeureArrivee() == null || presence.getHeureDepart() == null) {
            return 0;
        }
        
        int minutesTravaillees = calculerHeuresTravaillees(presence);
        
        Optional<HoraireEntreprise> horaireOpt = horaireEntrepriseRepository.findHoraireActif();
        if (horaireOpt.isPresent()) {
            HoraireEntreprise horaire = horaireOpt.get();
            int minutesTheorique = horaire.getDureeJourneeMinutes();
            
            return Math.max(0, minutesTravaillees - minutesTheorique);
        }
        
        return 0;
    }

    // ========== STATISTIQUES PERSONNEL ==========
    public long compterPresences(Integer idPersonnel, LocalDate dateDebut, LocalDate dateFin) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        return presenceAbsenceRepository.countPresencesByPersonnelAndPeriode(personnel, dateDebut, dateFin);
    }

    public long compterAbsences(Integer idPersonnel, LocalDate dateDebut, LocalDate dateFin) {
        Personnel personnel = personnelRepository.findById(idPersonnel)
                .orElseThrow(() -> new RuntimeException("Personnel non trouvé"));
        return presenceAbsenceRepository.countAbsencesByPersonnelAndPeriode(personnel, dateDebut, dateFin);
    }

    // ========== SUPPRIMER PRÉSENCE ==========
    public void supprimerPresence(Integer id, Integer userId, String userType) {
        PresenceAbsence presence = getPresenceById(id);
        presenceAbsenceRepository.delete(presence);
        
        // Audit log
        auditLogService.log("presence_absence", id, "DELETE", userId, 
                "user".equalsIgnoreCase(userType) ? AuditLog.UserType.USER : AuditLog.UserType.PERSONNEL,
                "Suppression de la présence du " + presence.getDate());
    }

    public PresenceAbsence getPresenceWithValidation(int id) {
        return presenceAbsenceRepository.findWithValidations(id);
    }

}