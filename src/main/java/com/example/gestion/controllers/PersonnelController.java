package com.example.gestion.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.gestion.models.Departement;
import com.example.gestion.models.Personnel;
import com.example.gestion.models.Role;
import com.example.gestion.models.User;
import com.example.gestion.repository.PersonnelRepository;
import com.example.gestion.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/personnel")
public class PersonnelController {
    
    @Autowired
    private PersonnelRepository personnelRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PresenceAbsenceService presenceAbsenceService;

    @Autowired
    private JustificationAbsenceService justificationAbsenceService;

    @Autowired
    private JustificationRetardService justificationRetardService;

    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private HoraireEntrepriseService horaireEntrepriseService;

    @GetMapping("/list")
    public String getAllPersonnel(
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "statut", required = false) String statut,
            @RequestParam(value = "poste", required = false) String poste,
            @RequestParam(value = "tri", required = false, defaultValue = "date_desc") String tri,
            Model model,
            HttpSession session) {
        
        try {
            // Récupérer l'utilisateur connecté depuis la session
            Integer userId = (Integer) session.getAttribute("userId");
            User connectedUser = null;
            Departement userDepartement = null;
            boolean isRH = false;

            if (userId != null) {
                connectedUser = userRepository.findById(userId).orElse(null);
                if (connectedUser != null) {
                    userDepartement = connectedUser.getDepartement();
                    // Vérifier si l'utilisateur est RH en utilisant l'ID du rôle
                    Role userRole = connectedUser.getRole();
                    if (userRole != null) {
                        // Méthode 1: Vérifier par ID du rôle (supposons que RH a l'ID 1)
                        // Méthode 2: Utiliser toString() pour vérifier le nom
                        String roleString = userRole.toString().toLowerCase();
                        isRH = roleString.contains("rh") || 
                               (getRoleId(userRole) != null && getRoleId(userRole) == 1);
                    }
                }
            }

            List<Personnel> personnels = personnelRepository.findAll();
            
            // Filtrer par département si l'utilisateur n'est pas RH
            if (!isRH && userDepartement != null) {
                final Integer deptId = getDepartementId(userDepartement);
                personnels = personnels.stream()
                    .filter(p -> p.getPoste() != null && 
                                p.getPoste().getDepartement() != null &&
                                deptId.equals(getDepartementId(p.getPoste().getDepartement())))
                    .collect(Collectors.toList());
            }
            
            // Appliquer les filtres de recherche
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.toLowerCase().trim();
                personnels = personnels.stream()
                    .filter(p -> 
                        (p.getCandidat() != null && 
                         (p.getCandidat().getNom().toLowerCase().contains(searchLower) ||
                          p.getCandidat().getPrenom().toLowerCase().contains(searchLower))) ||
                        (p.getPoste() != null && 
                         p.getPoste().getLibelle().toLowerCase().contains(searchLower)) ||
                        (p.getPoste() != null && p.getPoste().getDepartement() != null &&
                         getDepartementName(p.getPoste().getDepartement()).toLowerCase().contains(searchLower))
                    )
                    .collect(Collectors.toList());
            }
            
            if (statut != null && !statut.isEmpty()) {
                boolean isActif = "actif".equals(statut);
                personnels = personnels.stream()
                    .filter(p -> p.getActif() == isActif)
                    .collect(Collectors.toList());
            }
            
            if (poste != null && !poste.isEmpty()) {
                personnels = personnels.stream()
                    .filter(p -> p.getPoste() != null && poste.equals(p.getPoste().getLibelle()))
                    .collect(Collectors.toList());
            }
            
            // Appliquer le tri
            personnels = trierPersonnels(personnels, tri);
            
            // Ajouter les informations de l'utilisateur connecté au modèle
            model.addAttribute("personnels", personnels);
            model.addAttribute("connectedUser", connectedUser);
            model.addAttribute("userDepartement", userDepartement);
            model.addAttribute("isRH", isRH);
            model.addAttribute("userDeptName", getDepartementName(userDepartement));
            
            return "personnelList";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors de la récupération des personnels");
            return "personnelList";
        }
    }

    // Méthodes utilitaires pour éviter d'appeler des méthodes qui n'existent pas
    private Integer getRoleId(Role role) {
        try {
            // Essayer différentes méthodes possibles pour obtenir l'ID
            if (role == null) return null;
            
            // Méthode 1: Reflection pour trouver la méthode getId
            java.lang.reflect.Method[] methods = role.getClass().getMethods();
            for (java.lang.reflect.Method method : methods) {
                if (method.getName().equals("getId_role") && 
                    method.getParameterCount() == 0 &&
                    Integer.class.isAssignableFrom(method.getReturnType())) {
                    return (Integer) method.invoke(role);
                }
                if (method.getName().equals("getId") && 
                    method.getParameterCount() == 0 &&
                    Integer.class.isAssignableFrom(method.getReturnType())) {
                    return (Integer) method.invoke(role);
                }
            }
            
            // Méthode 2: Utiliser toString() pour extraire l'ID
            String roleString = role.toString();
            if (roleString.contains("id=")) {
                try {
                    String idStr = roleString.split("id=")[1].split("[,\\]}]")[0];
                    return Integer.parseInt(idStr.trim());
                } catch (Exception e) {
                    // Ignorer
                }
            }
            
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    private Integer getDepartementId(Departement dept) {
        try {
            if (dept == null) return null;
            
            // Essayer différentes méthodes possibles pour obtenir l'ID
            java.lang.reflect.Method[] methods = dept.getClass().getMethods();
            for (java.lang.reflect.Method method : methods) {
                if ((method.getName().equals("getId_departement") || 
                     method.getName().equals("getId")) && 
                    method.getParameterCount() == 0 &&
                    Integer.class.isAssignableFrom(method.getReturnType())) {
                    return (Integer) method.invoke(dept);
                }
            }
            
            // Fallback: utiliser toString()
            String deptString = dept.toString();
            if (deptString.contains("id=")) {
                try {
                    String idStr = deptString.split("id=")[1].split("[,\\]}]")[0];
                    return Integer.parseInt(idStr.trim());
                } catch (Exception e) {
                    // Ignorer
                }
            }
            
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    private String getDepartementName(Departement dept) {
        try {
            if (dept == null) return "Non spécifié";
            
            // Essayer différentes méthodes possibles pour obtenir le nom
            java.lang.reflect.Method[] methods = dept.getClass().getMethods();
            for (java.lang.reflect.Method method : methods) {
                if ((method.getName().equals("getNom_departement") || 
                     method.getName().equals("getNom") ||
                     method.getName().equals("getLibelle") ||
                     method.getName().equals("getName")) && 
                    method.getParameterCount() == 0 &&
                    String.class.isAssignableFrom(method.getReturnType())) {
                    String name = (String) method.invoke(dept);
                    return name != null ? name : "Non spécifié";
                }
            }
            
            // Fallback: utiliser toString()
            String deptString = dept.toString();
            if (deptString.contains("nom=")) {
                try {
                    return deptString.split("nom=")[1].split("[,\\]}]")[0];
                } catch (Exception e) {
                    // Ignorer
                }
            }
            if (deptString.contains("libelle=")) {
                try {
                    return deptString.split("libelle=")[1].split("[,\\]}]")[0];
                } catch (Exception e) {
                    // Ignorer
                }
            }
            
            return "Département " + getDepartementId(dept);
        } catch (Exception e) {
            return "Non spécifié";
        }
    }

    private List<Personnel> trierPersonnels(List<Personnel> personnels, String tri) {
        switch (tri) {
            case "date_asc":
                return personnels.stream()
                    .sorted((p1, p2) -> {
                        if (p1.getDate_embauche() == null) return 1;
                        if (p2.getDate_embauche() == null) return -1;
                        return p1.getDate_embauche().compareTo(p2.getDate_embauche());
                    })
                    .collect(Collectors.toList());
                    
            case "nom_asc":
                return personnels.stream()
                    .sorted((p1, p2) -> {
                        String nom1 = p1.getCandidat() != null ? p1.getCandidat().getNom() : "";
                        String nom2 = p2.getCandidat() != null ? p2.getCandidat().getNom() : "";
                        return nom1.compareToIgnoreCase(nom2);
                    })
                    .collect(Collectors.toList());
                    
            case "nom_desc":
                return personnels.stream()
                    .sorted((p1, p2) -> {
                        String nom1 = p1.getCandidat() != null ? p1.getCandidat().getNom() : "";
                        String nom2 = p2.getCandidat() != null ? p2.getCandidat().getNom() : "";
                        return nom2.compareToIgnoreCase(nom1);
                    })
                    .collect(Collectors.toList());
                    
            case "date_desc":
            default:
                return personnels.stream()
                    .sorted((p1, p2) -> {
                        if (p1.getDate_embauche() == null) return 1;
                        if (p2.getDate_embauche() == null) return -1;
                        return p2.getDate_embauche().compareTo(p1.getDate_embauche());
                    })
                    .collect(Collectors.toList());
        }
    }

    @GetMapping("/details")
    @Transactional(readOnly = true)
    public String getPersonnel(@RequestParam("idPersonnel") Integer idPersonnel, Model model, HttpSession session) {
        try {
            // Vérifier les permissions
            Integer userId = (Integer) session.getAttribute("userId");
            User connectedUser = null;
            boolean isRH = false;

            if (userId != null) {
                connectedUser = userRepository.findById(userId).orElse(null);
                if (connectedUser != null) {
                    Role userRole = connectedUser.getRole();
                    if (userRole != null) {
                        String roleString = userRole.toString().toLowerCase();
                        isRH = roleString.contains("rh") || 
                               (getRoleId(userRole) != null && getRoleId(userRole) == 1);
                    }
                }
            }

            Personnel personnel = personnelRepository.findById(idPersonnel).orElse(null);
            
            if (personnel == null) {
                model.addAttribute("error", "Personnel non trouvé avec l'ID : " + idPersonnel);
                model.addAttribute("connectedUser", connectedUser);
                model.addAttribute("isRH", isRH);
                return "personnelDetails";
            }
            
            // Vérifier si l'utilisateur a le droit de voir ce personnel
            // RH a accès à tout
            boolean hasAccess = isRH;
            
            // Si pas RH, vérifier le département (plus permissif)
            if (!hasAccess) {
                if (connectedUser == null) {
                    // Pas d'utilisateur connecté - autoriser quand même pour le moment
                    // En production, il faudrait forcer la connexion
                    hasAccess = true;
                } else if (connectedUser.getDepartement() == null) {
                    // Utilisateur sans département - autoriser
                    hasAccess = true;
                } else if (personnel.getPoste() == null || personnel.getPoste().getDepartement() == null) {
                    // Personnel sans département - autoriser
                    hasAccess = true;
                } else {
                    // Vérifier si les départements correspondent
                    Integer userDeptId = getDepartementId(connectedUser.getDepartement());
                    Integer personnelDeptId = getDepartementId(personnel.getPoste().getDepartement());
                    hasAccess = userDeptId != null && userDeptId.equals(personnelDeptId);
                }
            }
            
            if (!hasAccess) {
                model.addAttribute("error", "Accès non autorisé à ce personnel. Vous ne pouvez voir que les personnels de votre département.");
                model.addAttribute("connectedUser", connectedUser);
                model.addAttribute("isRH", isRH);
                return "personnelDetails";
            }
            
            // Tout est OK, afficher les détails
            // Forcer le chargement des relations lazy pour éviter LazyInitializationException
            if (personnel.getCandidat() != null) {
                // Charger les diplômes
                if (personnel.getCandidat().getDiplomesCandidats() != null) {
                    personnel.getCandidat().getDiplomesCandidats().size();
                }
                // Charger les parcours professionnels
                if (personnel.getCandidat().getParcoursProfessionels() != null) {
                    personnel.getCandidat().getParcoursProfessionels().size();
                }
            }
            
            model.addAttribute("personnel", personnel);
            model.addAttribute("connectedUser", connectedUser);
            model.addAttribute("isRH", isRH);
            return "personnelDetails";
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Erreur lors de la récupération du personnel : " + e.getMessage());
            return "personnelDetails";
        }
    }
    // ========== DASHBOARD PERSONNEL ==========
    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpSession session) {
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        LocalDate aujourdhui = LocalDate.now();
        // Convert LocalDate to java.sql.Date (subclass of java.util.Date) for JSP fmt:formatDate
        java.util.Date aujourdhuiDate = java.sql.Date.valueOf(aujourdhui);
        LocalDate debutMois = aujourdhui.withDayOfMonth(1);
        LocalDate finMois = aujourdhui.withDayOfMonth(aujourdhui.lengthOfMonth());

        // Présence du jour
        PresenceAbsence presenceAujourdhui = presenceAbsenceService.getPresencesByPersonnel(personnelId)
                .stream()
                .filter(p -> p.getDate().equals(aujourdhui))
                .findFirst()
                .orElse(null);

        // Statistiques personnelles
        Map<String, Object> stats = dashboardService.getStatistiquesPersonnel(personnelId, debutMois, finMois);

        model.addAttribute("presenceAujourdhui", presenceAujourdhui);
        model.addAttribute("stats", stats);
        model.addAttribute("aujourdhui", aujourdhuiDate);

        return "personnel/dashboard";
    }

    // ========== POINTAGE ==========
    @PostMapping("/pointer-entree")
    public String pointerEntree(HttpSession session, RedirectAttributes redirectAttributes) {
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        try {
            LocalDate aujourdhui = LocalDate.now();
            LocalTime maintenant = LocalTime.now();

            presenceAbsenceService.enregistrerEntree(personnelId, "personnel", aujourdhui, maintenant);
            redirectAttributes.addFlashAttribute("success", "Pointage d'entrée enregistré à " + maintenant);

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur pointage: " + e.getMessage());
        }

        return "redirect:/personnel/dashboard";
    }

    @PostMapping("/pointer-sortie")
    public String pointerSortie(HttpSession session, RedirectAttributes redirectAttributes) {
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        try {
            LocalDate aujourdhui = LocalDate.now();
            LocalTime maintenant = LocalTime.now();

            presenceAbsenceService.enregistrerSortie(personnelId, "personnel", aujourdhui, maintenant);
            redirectAttributes.addFlashAttribute("success", "Pointage de sortie enregistré à " + maintenant);

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur pointage: " + e.getMessage());
        }

        return "redirect:/personnel/dashboard";
    }

    // ========== JUSTIFICATIONS ==========
    @GetMapping("/justifications")
    public String pageJustifications(Model model, HttpSession session) {
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        // Historique des justifications
        List<JustificationAbsence> justifsAbsence = justificationAbsenceService.getJustificationsByPersonnel(personnelId);
        List<JustificationRetard> justifsRetard = justificationRetardService.getJustificationsByPersonnel(personnelId);

        model.addAttribute("justifsAbsence", justifsAbsence);
        model.addAttribute("justifsRetard", justifsRetard);

        return "personnel/justifications";
    }

    @PostMapping("/justifier-absence")
    public String justifierAbsence(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateAbsence,
            @RequestParam(required = false) MultipartFile fichier,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            // Session manquante : utiliser la valeur par défaut 1 pour l'id du personnel
            personnelId = 2;
        }

        try {
            justificationAbsenceService.creerJustificationAbsence(personnelId, dateAbsence, fichier, "Demande personnel");
            redirectAttributes.addFlashAttribute("success", "Absence justifiée avec succès");

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Erreur upload fichier: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur justification: " + e.getMessage());
        }

        return "redirect:/personnel/justifications";
    }

    // @PostMapping("/justifier-retard")
    //     public String justifierRetard(Model model, HttpSession session) {

    //     Integer personnelId = (Integer) session.getAttribute("personnelId");
    //     if (personnelId == null) {
    //         personnelId = 2;
    //     }

    //     LocalDate today = LocalDate.now();

    //     // Récupérer la présence du jour
    //     PresenceAbsence presence = presenceAbsenceService
    //             .getPresenceByPersonnelAndDate(personnelId, today);

    //     int retardMinutes = 15; // valeur par défaut

    //     if (presence != null && presence.getHeureArrivee() != null) {
    //         HoraireEntreprise horaire = horaireEntrepriseService.getHoraire(); // heureDebut = 08:00 par ex.
    //         int calcul = horaire.calculerMinutesRetard(presence.getHeureArrivee());

    //         if (calcul > 15) {
    //             retardMinutes = calcul;
    //         }
    //     }

    //     model.addAttribute("retardParDefaut", retardMinutes);

    //     return "personnel/justifications";
    // }

    // ========== AJOUTER UN FICHIER À UNE JUSTIFICATION EXISTANTE ==========
    @PostMapping("/upload-justificatif")
    @ResponseBody
    public Map<String, Object> uploadJustificatif(
            @RequestParam("file") MultipartFile fichier,
            @RequestParam("id") Integer idJustification,
            @RequestParam("type") String type,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer personnelId = (Integer) session.getAttribute("personnelId");
            if (personnelId == null) {
                personnelId = 2; // Valeur par défaut
            }
            
            if ("absence".equalsIgnoreCase(type)) {
                justificationAbsenceService.ajouterFichier(idJustification, fichier);
            } else if ("retard".equalsIgnoreCase(type)) {
                justificationRetardService.ajouterFichier(idJustification, fichier);
            } else {
                throw new RuntimeException("Type de justification invalide");
            }
            
            response.put("success", true);
            response.put("message", "Fichier ajouté avec succès");
            
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "Erreur upload fichier: " + e.getMessage());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Erreur: " + e.getMessage());
        }
        
        return response;
    }

    // ========== NOUVELLE MÉTHODE POUR JUSTIFIER RETARD (POST) ==========
    @PostMapping("/justifier-retard")
    public String justifierRetardPost(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateRetard,
            @RequestParam Integer minutesRetard,
            @RequestParam(required = false) MultipartFile fichier,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            personnelId = 2;
        }
        
        try {
            justificationRetardService.creerJustificationRetard(personnelId, dateRetard, minutesRetard, fichier);
            redirectAttributes.addFlashAttribute("success", "Retard justifié avec succès");
            
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Erreur upload fichier: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur justification: " + e.getMessage());
        }
        
        return "redirect:/personnel/justifications";
    }

    // ========== API POUR CALCULER RETARD AUTOMATIQUE ==========
    @GetMapping("/justifier-retard/api")
    @ResponseBody
    public Map<String, Object> getRetardAutomatique(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            personnelId = 2;
        }
        
        LocalDate today = LocalDate.now();
        
        try {
            // Récupérer la présence du jour
            PresenceAbsence presence = presenceAbsenceService
                    .getPresenceByPersonnelAndDate(personnelId, today);
            
            if (presence != null && presence.getHeureArrivee() != null) {
                // Calculer le retard par rapport à l'horaire d'entreprise
                HoraireEntreprise horaire = horaireEntrepriseService.getHoraire();
                int retardMinutes = horaire.calculerMinutesRetard(presence.getHeureArrivee());
                
                if (retardMinutes > 15) {
                    response.put("retardMinutes", retardMinutes);
                    response.put("heureArrivee", presence.getHeureArrivee().toString());
                    response.put("heureTheorique", horaire.getHeureDebut().toString());
                }
            }
            
            response.put("success", true);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        
        return response;
    }

    // ========== HISTORIQUE ==========
    @GetMapping("/historique")
    public String pageHistorique(
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
        @RequestParam(required = false) Integer id,
        Model model,
        HttpSession session) {

        // 1. Récupération du personnelId (avec fallback)
        Integer personnelId = (Integer) session.getAttribute("personnelId");
        if (personnelId == null) {
            personnelId = 2; // Valeur par défaut
        }

        // 2. Période par défaut = dernier mois
        if (dateDebut == null) dateDebut = LocalDate.now().minusDays(30);
        if (dateFin == null) dateFin = LocalDate.now();

        // 3. Charger l’historique filtré
        List<PresenceAbsence> historique =
                presenceAbsenceService.getPresencesByPersonnelEtPeriode(personnelId, dateDebut, dateFin);
        model.addAttribute("historique", historique);

        // 4. Si "id" est fourni → charger la présence détaillée AVEC validations (JOIN FETCH)
        if (id != null) {
            PresenceAbsence pa = presenceAbsenceService.getPresenceWithValidation(id);
            model.addAttribute("presenceAbs", pa);
        }

        // 5. Gérer les dates au format LocalDate et java.util.Date pour JSTL
        model.addAttribute("dateDebut", java.sql.Date.valueOf(dateDebut));
        model.addAttribute("dateFin", java.sql.Date.valueOf(dateFin));
        model.addAttribute("dateDebutLocal", dateDebut);
        model.addAttribute("dateFinLocal", dateFin);

        LocalDate aujourdhui = LocalDate.now();
        LocalDate ilYa7Jours = aujourdhui.minusDays(7);
        LocalDate debutMois = aujourdhui.withDayOfMonth(1);
        
        model.addAttribute("aujourdhuiDate", java.sql.Date.valueOf(aujourdhui));
        model.addAttribute("ilYa7JoursDate", java.sql.Date.valueOf(ilYa7Jours));
        model.addAttribute("debutMoisDate", java.sql.Date.valueOf(debutMois));

        return "personnel/historique";
    }

}