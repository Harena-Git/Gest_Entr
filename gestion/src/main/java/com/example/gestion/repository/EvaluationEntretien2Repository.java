package com.example.gestion.repository;


import com.example.gestion.models.EvaluationEntretien2;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
<<<<<<< Updated upstream

@Repository
public interface EvaluationEntretien2Repository extends JpaRepository<EvaluationEntretien2, Integer> {
=======
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Query;
import java.util.Optional;
import java.util.List;
import java.util.ArrayList;

@Repository
public interface EvaluationEntretien2Repository extends JpaRepository<EvaluationEntretien2, Integer> {
    Optional<EvaluationEntretien2> findByEntretien2(Entretien2 entretien2);
    
    @Query(value = "SELECT ev.* FROM evaluation_entretien_2 ev " +
                   "JOIN appreciation app ON app.id_appreciation = ev.id_appreciation " +
                   "WHERE app.note > :note", nativeQuery = true)
    List<EvaluationEntretien2> findEvaluationsWithNoteGreaterThan(@Param("note") int note);

    // @Query(value = "SELECT e1.id_evaluation_entretien_1, e1.presence, e1.id_appreciation, e1.id_entretien_ " +
    //             "FROM ( " +
    //             "    SELECT id_entretien_ " +
    //             "    FROM ( " +
    //             "        SELECT ev.* " +
    //             "        FROM evaluation_entretien_2 ev " +
    //             "        JOIN appreciation app ON app.id_appreciation = ev.id_appreciation " +
    //             "        WHERE app.note > :note " +
    //             "    ) ev2 " +
    //             "    JOIN entretien_2 e2 ON e2.id_entretien_2 = ev2.id_entretien_2 " +
    //             ") ev " +
    //             "JOIN evaluation_entretien_1 e1 ON e1.id_entretien_ = ev.id_entretien_", 
    //     nativeQuery = true)
    // List<Object[]> findEvaluationsEntretien1FromEntretien2(@Param("note") int note);

    @Query( value = "SELECT e1.id_evaluation_entretien_1, e1.presence, e1.id_appreciation, e1.id_entretien_ " +
                    "FROM ( " +
                    "    SELECT MAX(Id_etat_candidat) as etat, id_candidat, id_entretien_, date_entretien, heure_entretien, id_user FROM (" +
                    "        SELECT query_alias2.*, he.Id_etat_candidat FROM (" +
                    "            SELECT e1.* from (" +
                    "                SELECT id_entretien_ " +
                    "                FROM ( " +
                    "                    SELECT ev.* " +
                    "                    FROM evaluation_entretien_2 ev " +
                    "                    JOIN appreciation app ON app.id_appreciation = ev.id_appreciation " +
                    "                    WHERE app.note > 2 " +
                    "                ) ev2 " +
                    "                JOIN entretien_2 e2 ON e2.id_entretien_2 = ev2.id_entretien_2 " +
                                ") query_alias JOIN entretien_1 e1 ON e1.id_entretien_ = query_alias.id_entretien_" +
                            ") query_alias2 JOIN historique_etat he ON he.Id_candidat = query_alias2.id_candidat" +
                        ") a" +
                    ") ev " +
                    "JOIN evaluation_entretien_1 e1 ON e1.id_entretien_ = ev.id_entretien_ " +
                    "WHERE ev.etat = 5", nativeQuery = true)
    List<Object[]> findEvaluationsEntretien1FromEntretien2(@Param("note") int note);
>>>>>>> Stashed changes
}

