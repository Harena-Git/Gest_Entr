package com.example.gestion.services;

import com.example.gestion.models.*;
import com.example.gestion.repository.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

@Service
public class QcmService {
    
    @Autowired
    private QcmRepository qcmRepository;
    
    @Autowired
    private QuestionRepository questionRepository;
    
    @Autowired
    private QuestionGeneraleRepository questionGeneraleRepository;
    
    @Autowired
    private ChoixRepository choixRepository;
    
    @Autowired
    private ResultatQcmRepository resultatQcmRepository;
    
    @Autowired
    private ReponseRepository reponseRepository;
    
    @Autowired
    private CandidatService candidatService;
    
    public List<Qcm> getAllQcms() {
        List<Qcm> qcms = qcmRepository.findAll();
        
        return qcms;
    }

    
    public Optional<Qcm> getQcmById(Integer id) {
        return qcmRepository.findById(id);
    }
    
    public List<Question> getQuestionsByQcmId(Integer qcmId) {
        return questionRepository.findQuestionsByQcmId(qcmId);
    }
    
    public List<QuestionGenerale> getGeneralQuestions() {
        return questionGeneraleRepository.findAllOrderByOrdre();
    }
    
    public Map<String, Object> getQcmData(Integer qcmId) {
        Map<String, Object> data = new HashMap<>();
        
        Optional<Qcm> qcmOpt = qcmRepository.findById(qcmId);
        if (qcmOpt.isPresent()) {
            Qcm qcm = qcmOpt.get();
            data.put("qcm", qcm);
            
            // Questions spécifiques au QCM
            List<Question> questions = questionRepository.findQuestionsByQcmId(qcmId);
            Map<Integer, List<Choix>> choixParQuestion = new HashMap<>();
            
            for (Question question : questions) {
                List<Choix> choix = choixRepository.findByQuestionIdQuestion(question.getIdQuestion());
                choixParQuestion.put(question.getIdQuestion(), choix);
            }
            
            data.put("questions", questions);
            data.put("choixParQuestion", choixParQuestion);
            
            // Questions générales
            List<QuestionGenerale> questionsGenerales = questionGeneraleRepository.findAllOrderByOrdre();
            Map<Integer, List<Choix>> choixParQuestionGenerale = new HashMap<>();
            
            for (QuestionGenerale questionGenerale : questionsGenerales) {
                List<Choix> choix = choixRepository.findByQuestionGeneraleIdQuestionGenerale(questionGenerale.getIdQuestionGenerale());
                choixParQuestionGenerale.put(questionGenerale.getIdQuestionGenerale(), choix);
            }
            
            data.put("questionsGenerales", questionsGenerales);
            data.put("choixParQuestionGenerale", choixParQuestionGenerale);
        }
        
        return data;
    }

    private void insererReponses(Candidat candidat, Map<Integer, Integer> reponses) {
        System.out.println("=== DÉBUT INSERTION RÉPONSES ===");
        
        // reponses = {101: 5, 102: 8} 
        // → Clé: ID Question (qu'on ignore)
        // → Valeur: ID Choix (ce qui nous intéresse)
        
        for (Map.Entry<Integer, Integer> entry : reponses.entrySet()) {
            Integer questionId = entry.getKey();   // On n'utilise pas ça pour l'insertion
            Integer choixId = entry.getValue();    // C'EST ÇA QUI NOUS INTÉRESSE !
            
            System.out.println("Question " + questionId + " → Choix sélectionné: " + choixId);
            
            // Vérifier que le choix existe
            Optional<Choix> choixOpt = choixRepository.findById(choixId);
            if (choixOpt.isPresent()) {
                Choix choix = choixOpt.get();
                
                // Créer la réponse
                Reponse reponse = new Reponse();
                reponse.setCandidat(candidat);
                reponse.setChoix(choix);
                
                // Sauvegarder
                try {
                    Reponse savedReponse = reponseRepository.save(reponse);
                    System.out.println("✓ Réponse insérée - ID: " + savedReponse.getId_reponse() + 
                                     " (Choix: " + choix.getLibelle() + ")");
                } catch (Exception e) {
                    System.out.println("✗ Erreur insertion: " + e.getMessage());
                    throw e;
                }
            } else {
                System.out.println("✗ Choix ID " + choixId + " non trouvé en base!");
            }
        }
        System.out.println("=== FIN INSERTION RÉPONSES ===");
    }
    
    // @Transactional
    public ResultatQcm evaluerQcm(Integer candidatId, Integer qcmId, Map<Integer, Integer> reponses) {
    try {
        Optional<Qcm> qcmOpt = qcmRepository.findById(qcmId);

        if (qcmOpt.isEmpty()) {
            throw new RuntimeException("QCM non trouvé pour l'id : " + qcmId);
        }

        Qcm qcm = qcmOpt.get();

        // Pour le test, créer un candidat fictif si nécessaire
        Candidat candidat = candidatService.getCandidatById(candidatId)
                .orElseGet(() -> {
                    Candidat c = new Candidat();
                    c.setId_candidat(candidatId);
                    c.setNom("Test");
                    c.setPrenom("Candidat");
                    c.setEmail("test@example.com");
                    return c;
                });

        // INSÉRER LES RÉPONSES
        insererReponses(candidat, reponses);

        // 🔹 Forcer flush pour que le trigger s'exécute immédiatement
        reponseRepository.flush();

        // Attendre un peu pour le trigger (optionnel)
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Récupérer le résultat calculé par le trigger
        Optional<ResultatQcm> resultatOpt = resultatQcmRepository
                .findTopByCandidatAndQcmOrderByDateReponseDesc(candidat, qcm);

        if (resultatOpt.isPresent()) {
            return resultatOpt.get();
        } else {
            throw new RuntimeException("Aucun résultat trouvé par le trigger pour le candidat id="
                    + candidatId + " et QCM id=" + qcmId);
        }

    } catch (Exception e) {
        // Affiche la vraie cause de l'exception
        System.err.println("💥 Exception lors de l'évaluation du QCM : " + e.getMessage());
        e.printStackTrace();

        // Relancer l'exception originale avec cause
        throw new RuntimeException("Erreur lors de l'évaluation du QCM", e);
    }
}


    // private void createReponse(Candidat )
}