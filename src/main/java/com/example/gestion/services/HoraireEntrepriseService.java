package com.example.gestion.services;

import com.example.gestion.models.HoraireEntreprise;
import com.example.gestion.models.AuditLog;
import com.example.gestion.repository.HoraireEntrepriseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.util.List;

@Service
@Transactional
public class HoraireEntrepriseService {

    @Autowired
    private HoraireEntrepriseRepository horaireEntrepriseRepository;

    @Autowired
    private AuditLogService auditLogService;

    // ========== CRÉER HORAIRE ==========
    public HoraireEntreprise creerHoraire(LocalTime heureDebut, LocalTime heureFin, 
                                          LocalTime pauseDebut, LocalTime pauseFin, Integer userId) {
        HoraireEntreprise horaire = new HoraireEntreprise();
        horaire.setHeureDebut(heureDebut);
        horaire.setHeureFin(heureFin);
        horaire.setPauseDebut(pauseDebut);
        horaire.setPauseFin(pauseFin);

        HoraireEntreprise saved = horaireEntrepriseRepository.save(horaire);

        // Audit log
        auditLogService.log("horaire_entreprise", saved.getIdHoraire(), 
                "CREATE", userId, AuditLog.UserType.USER,
                "Création horaire: " + heureDebut + "-" + heureFin);

        return saved;
    }

    // ========== MODIFIER HORAIRE ==========
    public HoraireEntreprise modifierHoraire(Integer idHoraire, LocalTime heureDebut, LocalTime heureFin, 
                                             LocalTime pauseDebut, LocalTime pauseFin, Integer userId) {
        HoraireEntreprise horaire = horaireEntrepriseRepository.findById(idHoraire)
                .orElseThrow(() -> new RuntimeException("Horaire non trouvé"));

        horaire.setHeureDebut(heureDebut);
        horaire.setHeureFin(heureFin);
        horaire.setPauseDebut(pauseDebut);
        horaire.setPauseFin(pauseFin);

        HoraireEntreprise saved = horaireEntrepriseRepository.save(horaire);

        // Audit log
        auditLogService.log("horaire_entreprise", idHoraire, 
                "UPDATE", userId, AuditLog.UserType.USER,
                "Modification horaire");

        return saved;
    }

    // ========== RÉCUPÉRER HORAIRE ACTIF ==========
    public HoraireEntreprise getHoraireActif() {
        return horaireEntrepriseRepository.findHoraireActif()
                .orElseGet(() -> horaireEntrepriseRepository.findFirstByOrderByIdHoraireAsc()
                        .orElseThrow(() -> new RuntimeException("Aucun horaire configuré")));
    }

    // ========== RÉCUPÉRER HORAIRE PAR ID ==========
    public HoraireEntreprise getHoraireById(Integer id) {
        return horaireEntrepriseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Horaire non trouvé"));
    }

    // ========== RÉCUPÉRER TOUS LES HORAIRES ==========
    public List<HoraireEntreprise> getTousLesHoraires() {
        return horaireEntrepriseRepository.findAll();
    }

    // ========== SUPPRIMER HORAIRE ==========
    public void supprimerHoraire(Integer id, Integer userId) {
        HoraireEntreprise horaire = getHoraireById(id);
        horaireEntrepriseRepository.delete(horaire);

        // Audit log
        auditLogService.log("horaire_entreprise", id, "DELETE", userId, 
                AuditLog.UserType.USER,
                "Suppression horaire");
    }

    // ========== CALCULER SI RETARD ==========
    public boolean estEnRetard(LocalTime heureArrivee) {
        HoraireEntreprise horaire = getHoraireActif();
        return horaire.estEnRetard(heureArrivee);
    }

    // ========== CALCULER MINUTES DE RETARD ==========
    public int calculerMinutesRetard(LocalTime heureArrivee) {
        HoraireEntreprise horaire = getHoraireActif();
        return horaire.calculerMinutesRetard(heureArrivee);
    }

    public HoraireEntreprise getHoraire() {
        return getHoraireActif();
    }
}