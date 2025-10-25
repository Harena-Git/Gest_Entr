<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Résultats du Test QCM</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .result-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 30px;
            background: white;
            min-height: 100vh;
            box-shadow: 0 0 30px rgba(0,0,0,0.1);
        }
        
        .test-mode-banner {
            background: #ff9800;
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: bold;
        }
        
        .score-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 15px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .success-card { 
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin: 25px 0;
            text-align: center;
            box-shadow: 0 8px 25px rgba(76, 175, 80, 0.3);
        }
        
        .failure-card { 
            background: linear-gradient(135deg, #f44336, #e53935);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin: 25px 0;
            text-align: center;
            box-shadow: 0 8px 25px rgba(244, 67, 54, 0.3);
        }
        
        .entretien-info {
            background: #e8f5e8;
            border: 3px solid #4CAF50;
            border-radius: 15px;
            padding: 30px;
            margin: 30px 0;
            position: relative;
        }
        
        .entretien-info::before {
            content: "📅";
            position: absolute;
            top: -20px;
            left: 30px;
            background: #4CAF50;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2em;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #2196F3;
        }
        
        .btn-container {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 40px 0;
            flex-wrap: wrap;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 15px 25px;
            background: #2196F3;
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3);
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(33, 150, 243, 0.4);
        }
        
        .btn-success { 
            background: linear-gradient(135deg, #4CAF50, #45a049);
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }
        
        .btn-danger { 
            background: linear-gradient(135deg, #f44336, #e53935);
            box-shadow: 0 4px 15px rgba(244, 67, 54, 0.3);
        }
        
        .debug-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 30px;
            border: 1px solid #e0e0e0;
        }
        
        .score-circle {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5em;
            font-weight: bold;
            margin: 0 auto 20px;
            border: 5px solid rgba(255,255,255,0.3);
        }
    </style>
</head>
<body>
    <div class="result-container">
        <div class="test-mode-banner">
            🧪 MODE TEST - Candidat ID: ${candidatId} | QCM ID: ${qcmId}
        </div>
        
        <div class="score-card">
            <div class="score-circle">
                <fmt:formatNumber value="${resultat.pourcentage}" pattern="#"/>%
            </div>
            <h1 style="margin: 0; font-size: 2em;">RÉSULTATS DU TEST</h1>
            <p style="font-size: 1.3em; margin: 10px 0;">
                ${resultat.bonnesReponses} bonnes réponses sur ${resultat.totalQuestions} questions
            </p>
        </div>

        <c:choose>
            <c:when test="${resultat.estReussi}">
                <div class="success-card">
                    <div style="font-size: 4em; margin-bottom: 10px;">🎉</div>
                    <h2 style="margin: 0; font-size: 2em;">FÉLICITATIONS !</h2>
                    <p style="font-size: 1.2em; margin: 15px 0;">
                        Vous avez réussi le test avec <strong>${resultat.pourcentage}%</strong> de bonnes réponses.
                    </p>
                </div>

                <div class="entretien-info">
                    <h3>ENTRETIEN AUTOMATIQUEMENT PLANIFIÉ</h3>
                    <p style="font-size: 1.1em; margin-bottom: 20px;">
                        <strong>Selon notre système de gestion des entretiens :</strong>
                    </p>
                    
                    <div class="info-grid">
                        <div class="info-item">
                            <strong>📅 Date proposée :</strong><br>
                            5 jours ouvrables après réussite
                        </div>
                        <div class="info-item">
                            <strong>⏰ Créneaux :</strong><br>
                            Lundi-Vendredi<br>
                            8h-12h / 14h-17h
                        </div>
                        <div class="info-item">
                            <strong>👥 Interlocuteur :</strong><br>
                            Responsable RH attribué automatiquement
                        </div>
                        <div class="info-item">
                            <strong>📍 Lieu :</strong><br>
                            Nos locaux (adresse envoyée par email)
                        </div>
                    </div>
                    
                    <div style="background: #d4edda; padding: 15px; border-radius: 8px; margin-top: 20px;">
                        <strong>📧 Email de confirmation :</strong><br>
                        Vous recevrez sous peu un email avec :
                        <ul style="margin: 10px 0;">
                            <li>Date et heure précises de l'entretien</li>
                            <li>Nom de votre interlocuteur RH</li>
                            <li>Adresse exacte et plan d'accès</li>
                            <li>Documents à apporter</li>
                        </ul>
                    </div>
                    
                    <p style="margin-top: 20px; font-style: italic; color: #2e7d32;">
                        <strong>Note :</strong> Le système utilise un algorithme intelligent pour répartir équitablement 
                        les entretiens entre les responsables RH disponibles.
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="failure-card">
                    <div style="font-size: 4em; margin-bottom: 10px;">💪</div>
                    <h2 style="margin: 0; font-size: 2em;">SCORE INSUFFISANT</h2>
                    <p style="font-size: 1.2em; margin: 15px 0;">
                        Votre score : <strong>${resultat.pourcentage}%</strong> (minimum requis : 50%)
                    </p>
                    <p>Nous vous remercions pour votre participation et votre intérêt.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="btn-container">
            <a href="/acceuil" class="btn btn-danger">
                🏠 Page d'accueil
            </a>
        </div>
        
        <!-- Informations de débogage -->
        <div class="debug-info">
            <h4>📊 Informations techniques :</h4>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-top: 15px;">
                <div><strong>Score:</strong> <fmt:formatNumber value="${resultat.pourcentage}" pattern="#.##"/>%</div>
                <div><strong>Bonnes réponses:</strong> ${resultat.bonnesReponses}</div>
                <div><strong>Total questions:</strong> ${resultat.totalQuestions}</div>
                <div><strong>Réussi:</strong> ${resultat.estReussi ? 'OUI' : 'NON'}</div>
                <div><strong>Date:</strong> ${resultat.dateReponse}</div>
                <div><strong>Candidat ID:</strong> ${candidatId}</div>
            </div>
        </div>
    </div>
</body>
</html>