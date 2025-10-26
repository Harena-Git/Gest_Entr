<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultats du Test QCM</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        /* Styles additionnels pour la page de résultats */
        body {
            background: linear-gradient(135deg, #343a40 0%, #495057 100%);
            padding: 20px;
        }
        
        .result-page {
            max-width: 700px;
            margin: 0 auto;
        }
        
        .result-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }
        
        .score-header {
            background: white;
            padding: 50px 40px;
            text-align: center;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .score-circle {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3em;
            font-weight: bold;
            margin: 0 auto 25px;
            color: white;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
        }
        
        .score-header h1 {
            color: #1e293b;
            margin: 0 0 10px 0;
            font-size: 2em;
        }
        
        .score-details {
            color: #64748b;
            font-size: 1.1em;
        }
        
        .result-content {
            padding: 40px;
        }
        
        .success-banner {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
        }
        
        .success-icon {
            font-size: 3.5em;
            margin-bottom: 15px;
        }
        
        .success-banner h2 {
            margin: 0 0 10px 0;
            font-size: 2em;
        }
        
        .success-banner p {
            margin: 0;
            font-size: 1.1em;
            opacity: 0.95;
        }
        
        .failure-banner {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }
        
        .failure-icon {
            font-size: 3.5em;
            margin-bottom: 15px;
        }
        
        .failure-banner h2 {
            margin: 0 0 10px 0;
            font-size: 2em;
        }
        
        .failure-banner p {
            margin: 5px 0;
            font-size: 1.1em;
            opacity: 0.95;
        }
        
        .entretien-section {
            background: #f0fdf4;
            border: 2px solid #10b981;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .entretien-section h3 {
            color: #047857;
            margin: 0 0 25px 0;
            font-size: 1.4em;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .info-row {
            background: white;
            border-left: 4px solid #10b981;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        
        .info-row:last-of-type {
            margin-bottom: 20px;
        }
        
        .info-label {
            color: #047857;
            font-weight: 600;
            display: block;
            margin-bottom: 8px;
            font-size: 1.05em;
        }
        
        .info-value {
            color: #065f46;
            margin: 0;
            line-height: 1.6;
            font-size: 1em;
        }
        
        .info-note {
            font-size: 0.9em;
            color: #047857;
            margin-top: 5px;
        }
        
        .alert-box {
            background: #dbeafe;
            border-left: 4px solid #2563eb;
            padding: 15px 20px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .alert-box p {
            color: #1e40af;
            margin: 0;
            font-size: 0.95em;
            line-height: 1.6;
        }
        
        .thank-you-message {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        
        .thank-you-message p {
            color: #475569;
            margin: 0;
            line-height: 1.6;
        }
        
        .action-footer {
            text-align: center;
            padding-top: 25px;
            margin-top: 25px;
            border-top: 1px solid #e2e8f0;
        }
        
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .result-page {
                margin: 0;
            }
            
            .result-card {
                border-radius: 8px;
            }
            
            .score-header {
                padding: 40px 30px;
            }
            
            .score-circle {
                width: 120px;
                height: 120px;
                font-size: 2.5em;
            }
            
            .score-header h1 {
                font-size: 1.6em;
            }
            
            .result-content {
                padding: 30px 20px;
            }
            
            .entretien-section {
                padding: 20px;
            }
            
            .success-banner,
            .failure-banner {
                padding: 25px 20px;
            }
            
            .success-banner h2,
            .failure-banner h2 {
                font-size: 1.6em;
            }
        }
    </style>
</head>
<body>
    <div class="result-page">
        <div class="result-card">
            <!-- En-tête avec le score -->
            <div class="score-header">
                <div class="score-circle">
                    <fmt:formatNumber value="${resultat.pourcentage}" pattern="#"/>%
                </div>
                <h1>RÉSULTATS DU TEST</h1>
                <p class="score-details">
                    ${resultat.bonnesReponses} bonnes réponses sur ${resultat.totalQuestions} questions
                </p>
            </div>

            <div class="result-content">
                <c:choose>
                    <c:when test="${resultat.estReussi}">
                        <!-- Message de réussite -->
                        <div class="success-banner">
                            <div class="success-icon">🎉</div>
                            <h2>FÉLICITATIONS !</h2>
                            <p>Vous avez réussi le test avec <strong><fmt:formatNumber value="${resultat.pourcentage}" pattern="#"/>%</strong> de bonnes réponses.</p>
                        </div>

                        <!-- Informations sur l'entretien -->
                        <c:if test="${not empty entretien}">
                            <div class="entretien-section">
                                <h3>📅 Votre Entretien est Planifié</h3>
                                
                                <div class="info-row">
                                    <span class="info-label">📆 Date de l'entretien</span>
                                    <p class="info-value">
                                        ${dateEntretienFormatted}
                                    </p>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">🕐 Heure</span>
                                    <p class="info-value">
                                       ${heureEntretienFormatted}
                                    </p>
                                    <p class="info-note">
                                        Veuillez vous présenter 15 minutes avant l'heure prévue
                                    </p>
                                </div>
                                
                                <div class="info-row">
                                    <span class="info-label">📍 Lieu</span>
                                    <p class="info-value">Dans l'enceinte de notre entreprise</p>
                                </div>
                                
                                <div class="alert-box">
                                    <p>
                                        <strong>📧 Important :</strong> Un email de confirmation contenant tous les détails 
                                        (adresse exacte, plan d'accès, documents à apporter) vous a été envoyé. 
                                        Veuillez vérifier votre boîte de réception.
                                    </p>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${empty entretien}">
                            <div class="entretien-section">
                                <h3>📅 Planification de l'Entretien</h3>
                                <div class="info-row">
                                    <p class="info-value">
                                        Votre entretien est en cours de planification. Vous recevrez un email 
                                        de confirmation avec la date, l'heure et le lieu de l'entretien dans les plus brefs délais.
                                    </p>
                                </div>
                                <div class="alert-box">
                                    <p>
                                        <strong>📧 Note :</strong> Pensez à vérifier régulièrement votre boîte email, 
                                        y compris vos courriers indésirables.
                                    </p>
                                </div>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <!-- Message d'échec -->
                        <div class="failure-banner">
                            <div class="failure-icon">📚</div>
                            <h2>SCORE INSUFFISANT</h2>
                            <p>
                                Votre score : <strong><fmt:formatNumber value="${resultat.pourcentage}" pattern="#"/>%</strong>
                            </p>
                            <p>
                                Le score minimum requis est de 50%
                            </p>
                        </div>
                        
                        <div class="thank-you-message">
                            <p>
                                Nous vous remercions pour votre participation et votre intérêt pour notre entreprise. 
                                N'hésitez pas à postuler à nouveau pour de futures opportunités.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Bouton d'action -->
                <div class="action-footer">
                    <a href="${pageContext.request.contextPath}/acceuil" class="btn btn-primary" style="font-size: 1.1em; padding: 14px 32px;">
                        🏠 Retour à l'Accueil
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>