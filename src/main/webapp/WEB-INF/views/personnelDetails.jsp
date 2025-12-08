<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails du Personnel</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            font-weight: 500;
        }

        .back-button:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateX(-5px);
        }

        .header {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 30px;
        }

        .photo-container {
            flex-shrink: 0;
        }

        .profile-photo {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #667eea;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .default-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
            color: white;
            font-weight: bold;
            border: 5px solid white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .header-info {
            flex: 1;
        }

        .header-info h1 {
            font-size: 2.5em;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .header-info .subtitle {
            font-size: 1.3em;
            color: #667eea;
            margin-bottom: 15px;
            font-weight: 500;
        }

        .status-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.9em;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .content-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e9ecef;
        }

        .card-icon {
            font-size: 2em;
        }

        .card-title {
            font-size: 1.4em;
            color: #2c3e50;
            font-weight: 600;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 0.95em;
        }

        .info-value {
            color: #2c3e50;
            font-size: 1em;
            text-align: right;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .diplomes-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .diplome-item {
            background: #f8f9fa;
            padding: 15px 20px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .diplome-item h4 {
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 1.1em;
        }

        .diplome-item p {
            color: #6c757d;
            font-size: 0.9em;
            margin: 4px 0;
        }

        .parcours-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .parcours-item {
            background: #f8f9fa;
            padding: 15px 20px;
            border-radius: 8px;
            border-left: 4px solid #764ba2;
        }

        .parcours-item h4 {
            color: #2c3e50;
            margin-bottom: 8px;
            font-size: 1.1em;
        }

        .parcours-item p {
            color: #6c757d;
            font-size: 0.9em;
            margin: 4px 0;
        }

        .error-message {
            background: white;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        }

        .error-message h2 {
            color: #dc3545;
            margin-bottom: 15px;
        }

        .error-message p {
            color: #6c757d;
            font-size: 1.1em;
        }

        .empty-state {
            text-align: center;
            padding: 30px;
            color: #6c757d;
            font-style: italic;
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                text-align: center;
            }

            .header-info h1 {
                font-size: 1.8em;
            }

            .header-info .subtitle {
                font-size: 1.1em;
            }

            .content-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/personnel/list" class="back-button">
            ← Retour à la liste
        </a>

        <c:choose>
            <c:when test="${not empty error}">
                <div class="error-message">
                    <h2>❌ Erreur</h2>
                    <p>${error}</p>
                    <a href="${pageContext.request.contextPath}/personnel/list" class="back-button" style="margin-top: 20px;">
                        Retour à la liste
                    </a>
                </div>
            </c:when>
            <c:when test="${not empty personnel}">
                <!-- En-tête avec photo et infos principales -->
                <div class="header">
                    <div class="photo-container">
                        <c:choose>
                            <c:when test="${not empty personnel.candidat.photo}">
                                <img src="${personnel.candidat.photo}" alt="Photo" class="profile-photo">
                            </c:when>
                            <c:otherwise>
                                <div class="default-avatar">
                                    ${personnel.candidat.prenom.substring(0, 1)}${personnel.candidat.nom.substring(0, 1)}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="header-info">
                        <h1>${personnel.candidat.prenom} ${personnel.candidat.nom}</h1>
                        <div class="subtitle">
                            <c:if test="${not empty personnel.poste}">
                                ${personnel.poste.libelle}
                                <c:if test="${not empty personnel.poste.departement}">
                                    - ${personnel.poste.departement.departement}
                                </c:if>
                            </c:if>
                        </div>
                        <c:choose>
                            <c:when test="${personnel.actif}">
                                <span class="status-badge status-active">✓ Actif</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-inactive">✗ Inactif</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Grille de contenu -->
                <div class="content-grid">
                    <!-- Informations personnelles -->
                    <div class="card">
                        <div class="card-header">
                            <span class="card-icon">👤</span>
                            <h2 class="card-title">Informations Personnelles</h2>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Genre</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${personnel.candidat.genre == 'M'}">Masculin</c:when>
                                    <c:when test="${personnel.candidat.genre == 'F'}">Féminin</c:when>
                                    <c:otherwise>${personnel.candidat.genre}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Date de naissance</span>
                            <span class="info-value">
                                <c:if test="${not empty personnel.candidat.date_naissance}">
                                    <fmt:formatDate value="${personnel.candidat.date_naissance}" pattern="dd/MM/yyyy" />
                                </c:if>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Adresse</span>
                            <span class="info-value">${personnel.candidat.adresse}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Lieu</span>
                            <span class="info-value">
                                <c:if test="${not empty personnel.candidat.lieu}">
                                    ${personnel.candidat.lieu.lieu}
                                </c:if>
                            </span>
                        </div>
                    </div>

                    <!-- Coordonnées -->
                    <div class="card">
                        <div class="card-header">
                            <span class="card-icon">📞</span>
                            <h2 class="card-title">Coordonnées</h2>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Email</span>
                            <span class="info-value">
                                <a href="mailto:${personnel.candidat.email}" style="color: #667eea;">
                                    ${personnel.candidat.email}
                                </a>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Téléphone</span>
                            <span class="info-value">
                                <a href="tel:${personnel.candidat.telephone}" style="color: #667eea;">
                                    ${personnel.candidat.telephone}
                                </a>
                            </span>
                        </div>
                    </div>

                    <!-- Informations professionnelles -->
                    <div class="card">
                        <div class="card-header">
                            <span class="card-icon">💼</span>
                            <h2 class="card-title">Informations Professionnelles</h2>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Date d'embauche</span>
                            <span class="info-value">
                                <c:if test="${not empty personnel.date_embauche}">
                                    <fmt:formatDate value="${personnel.date_embauche}" pattern="dd/MM/yyyy" />
                                </c:if>
                            </span>
                        </div>
                        <c:if test="${not empty personnel.poste}">
                            <div class="info-row">
                                <span class="info-label">Poste</span>
                                <span class="info-value">${personnel.poste.libelle}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Salaire</span>
                                <span class="info-value">
                                    <c:if test="${not empty personnel.poste.salaire}">
                                        <fmt:formatNumber value="${personnel.poste.salaire}" type="currency" currencySymbol="Ar" />
                                    </c:if>
                                </span>
                            </div>
                            <c:if test="${not empty personnel.poste.departement}">
                                <div class="info-row">
                                    <span class="info-label">Département</span>
                                    <span class="info-value">${personnel.poste.departement.departement}</span>
                                </div>
                            </c:if>
                        </c:if>
                    </div>

                    <!-- Expérience -->
                    <div class="card">
                        <div class="card-header">
                            <span class="card-icon">⭐</span>
                            <h2 class="card-title">Expérience</h2>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Années d'expérience</span>
                            <span class="info-value">
                                <c:choose>
                                    <c:when test="${not empty personnel.candidat.annee_experience}">
                                        ${personnel.candidat.annee_experience} an(s)
                                    </c:when>
                                    <c:otherwise>Non renseigné</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Date de candidature</span>
                            <span class="info-value">
                                <c:if test="${not empty personnel.candidat.date_candidature}">
                                    <fmt:formatDate value="${personnel.candidat.date_candidature}" pattern="dd/MM/yyyy" />
                                </c:if>
                            </span>
                        </div>
                    </div>

                    <!-- Diplômes -->
                    <c:if test="${not empty personnel.candidat.diplomesCandidats}">
                        <div class="card full-width">
                            <div class="card-header">
                                <span class="card-icon">🎓</span>
                                <h2 class="card-title">Diplômes et Formation</h2>
                            </div>
                            <div class="diplomes-list">
                                <c:forEach var="diplomeCandidat" items="${personnel.candidat.diplomesCandidats}">
                                    <div class="diplome-item">
                                        <h4>
                                            <c:if test="${not empty diplomeCandidat.diplome}">
                                                <c:if test="${not empty diplomeCandidat.diplome.niveau}">
                                                    ${diplomeCandidat.diplome.niveau.libelle}
                                                </c:if>
                                                <c:if test="${not empty diplomeCandidat.diplome.filiere}">
                                                    en ${diplomeCandidat.diplome.filiere.libelle}
                                                </c:if>
                                            </c:if>
                                        </h4>
                                        <p><strong>Établissement :</strong> ${diplomeCandidat.etablissement}</p>
                                        <p><strong>Année d'obtention :</strong> ${diplomeCandidat.annee_obtention}</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Parcours professionnel -->
                    <c:if test="${not empty personnel.candidat.parcoursProfessionels}">
                        <div class="card full-width">
                            <div class="card-header">
                                <span class="card-icon">📋</span>
                                <h2 class="card-title">Parcours Professionnel</h2>
                            </div>
                            <div class="parcours-list">
                                <c:forEach var="parcours" items="${personnel.candidat.parcoursProfessionels}">
                                    <div class="parcours-item">
                                        <h4>${parcours.poste} - ${parcours.entreprise}</h4>
                                        <p>
                                            <strong>Période :</strong> 
                                            <fmt:formatDate value="${parcours.date_debut}" pattern="MM/yyyy" />
                                            - 
                                            <c:choose>
                                                <c:when test="${not empty parcours.date_fin}">
                                                    <fmt:formatDate value="${parcours.date_fin}" pattern="MM/yyyy" />
                                                </c:when>
                                                <c:otherwise>
                                                    Actuellement
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Compétences personnelles -->
                    <c:if test="${not empty personnel.candidat.competences_personnelles}">
                        <div class="card full-width">
                            <div class="card-header">
                                <span class="card-icon">💡</span>
                                <h2 class="card-title">Compétences Personnelles</h2>
                            </div>
                            <p style="color: #6c757d; line-height: 1.8;">
                                ${personnel.candidat.competences_personnelles}
                            </p>
                        </div>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div class="error-message">
                    <h2>Personnel non trouvé</h2>
                    <p>Aucune information disponible pour ce personnel.</p>
                    <a href="${pageContext.request.contextPath}/personnel/list" class="back-button" style="margin-top: 20px;">
                        Retour à la liste
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
