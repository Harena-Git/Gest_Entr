package com.example.gestion.repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.gestion.models.DemandeConge;
import com.example.gestion.models.Personnel;
import com.example.gestion.models.StatutDemande;

@Repository
public interface DemandeCongeRepository extends JpaRepository<DemandeConge, Integer> {

    // Trouver les demandes d'un personnel par statut
    List<DemandeConge> findByPersonnelAndStatutDemande(Personnel personnel, StatutDemande statut);

    // Trouver les demandes en attente d'un personnel
    @Query("SELECT d FROM DemandeConge d WHERE d.personnel = :personnel AND d.statutDemande.libelle = :statut")
    List<DemandeConge> findByPersonnelAndStatutLibelle(@Param("personnel") Personnel personnel, 
                                                        @Param("statut") String statut);

    // Trouver les demandes d'un personnel entre deux dates
    @Query("SELECT d FROM DemandeConge d WHERE d.personnel.id_personnel = :idPersonnel " +
           "AND d.date_debut >= :debut AND d.date_fin <= :fin")
    List<DemandeConge> findCongesBetweenDates(@Param("idPersonnel") Integer idPersonnel,
                                              @Param("debut") Date debut,
                                              @Param("fin") Date fin);

    // Trouver les demandes approuvées par chef
    @Query("SELECT d FROM DemandeConge d WHERE d.statutDemande.libelle = :statut")
    List<DemandeConge> findByStatutLibelle(@Param("statut") String statut);

    // Vérifier les conflits de congés (deux congés simultanés)
    @Query("SELECT COUNT(d) FROM DemandeConge d WHERE d.personnel.id_personnel = :idPersonnel " +
           "AND d.date_debut <= :fin AND d.date_fin >= :debut " +
           "AND (d.statutDemande.libelle = 'Approuvée par chef' OR d.statutDemande.libelle = 'Approuvée par RH')")
    Long countConflictingCongees(@Param("idPersonnel") Integer idPersonnel,
                                  @Param("debut") Date debut,
                                  @Param("fin") Date fin);

    // Trouver les demandes en attente de validation chef pour un département
    @Query("SELECT d FROM DemandeConge d " +
           "WHERE d.statutDemande.libelle = 'En attente' " +
           "AND d.personnel.poste.departement.id_departement = :idDept")
    List<DemandeConge> findPendingCongeesByDepartment(@Param("idDept") Integer idDept);

    // Trouver les demandes approuvées par chef en attente de RH
    @Query("SELECT d FROM DemandeConge d " +
           "WHERE d.statutDemande.libelle = 'Approuvée par chef'")
    List<DemandeConge> findApprovedByChef();

    // Compte les demandes par statut
    @Query("SELECT COUNT(d) FROM DemandeConge d WHERE d.statutDemande.libelle = :statut")
    Long countDemandesEnAttenteParStatut(@Param("statut") String statut);
    
    // Ou plus spécifique pour le chef (par département)
    @Query("SELECT COUNT(d) FROM DemandeConge d " +
           "WHERE d.statutDemande.libelle = :statut " +
           "AND d.personnel.poste.departement.id_departement = :departementId")
    Long countDemandesEnAttenteParStatutEtDepartement(
        @Param("statut") String statut,
        @Param("departementId") Integer departementId);
    
    // Pour RH : toutes les demandes approuvées par les chefs
    @Query("SELECT COUNT(d) FROM DemandeConge d WHERE d.statutDemande.libelle = 'Approuvée par chef'")
    Long countDemandesApprouveesParChefEnAttente();
}
