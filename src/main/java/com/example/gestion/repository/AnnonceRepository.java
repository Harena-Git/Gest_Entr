package com.example.gestion.repository;

import com.example.gestion.models.Annonce;
import com.example.gestion.models.Profil;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AnnonceRepository extends JpaRepository<Annonce, Integer> {
    @Query("SELECT a.poste.libelle FROM Annonce a WHERE a.id_annonce = :idAnnonce")
    String findPosteByIdAnnonce(@Param("idAnnonce") Integer idAnnonce);

   @Query("SELECT a FROM Annonce a WHERE a.profil.lieu.id_lieu = :idLieu")
    List<Annonce> findByLieu(@Param("idLieu") Integer idLieu);

    List<Annonce> findByProfil( Profil profil);

    @Query("SELECT q.idQcm FROM Annonce a " +
       "JOIN a.poste p " +
       "JOIN Qcm q ON q.poste.id_poste = p.id_poste " +
       "WHERE a.id_annonce = :idAnnonce")
    Integer findQcmIdByAnnonceId(@Param("idAnnonce") Integer idAnnonce);

    @Query("SELECT a FROM Annonce a WHERE a.date_fin < :now")
    List<Annonce> findExpiredAnnonces(@Param("now") LocalDateTime now);

}
