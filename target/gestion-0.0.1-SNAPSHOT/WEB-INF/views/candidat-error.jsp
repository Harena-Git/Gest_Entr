<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil non retenu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body class="centered-container">
    <div class="error-container">
        <!-- En-tête avec icône -->
        <div class="error-header">
            <div class="error-icon">✕</div>
            <h2>Candidature non retenue</h2>
            <p>Nous vous remercions pour votre intérêt</p>
        </div>

        <!-- Contenu principal -->
        <div class="error-content">
            <!-- Section raison -->
            <div class="reason-section">
                <h3>
                    <span>⚠️</span>
                    Motif de refus
                </h3>
                <p>${erreur}</p>
            </div>

            <!-- Information supplémentaire -->
            <div class="info-box">
                <p>
                    Nous apprécions le temps que vous avez consacré à votre candidature. 
                    Bien que votre profil ne corresponde pas aux exigences actuelles, 
                    nous vous encourageons à postuler à nouveau lorsque d'autres opportunités seront disponibles.
                </p>
            </div>

            <!-- Boutons d'action -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/acceuil" class="btn btn-primary">
                    <span>🏠</span>
                    Retour à l'accueil
                </a>
            </div>

            <div class="divider"></div>

            <!-- Informations de contact -->
            <div class="contact-info">
                <p>
                    Des questions ? Contactez-nous à 
                    <a href="mailto:recrutement@entreprise.com">recrutement@entreprise.com</a>
                </p>
            </div>
        </div>
    </div>
</body>
</html>