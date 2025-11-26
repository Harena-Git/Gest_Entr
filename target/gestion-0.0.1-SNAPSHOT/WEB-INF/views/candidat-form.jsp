<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CV - Informations Personnelles</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cv-styles.css">
</head>
<body>
    <div class="container">
        <!-- Barre de progression compacte -->
        <div class="progress-container">
            <div class="progress-steps">
                <div class="progress-step active">
                    <div class="step-circle">1</div>
                    <span class="step-label">Informations personnelles</span>
                </div>
                <div class="progress-step">
                    <div class="step-circle">2</div>
                    <span class="step-label">Diplômes</span>
                </div>
                <div class="progress-step">
                    <div class="step-circle">3</div>
                    <span class="step-label">Parcours professionnel</span>
                </div>
            </div>
        </div>

        <!-- Layout à 2 colonnes -->
        <div class="form-wrapper">
            <div class="form-layout">
                <!-- Sidebar de navigation -->
                <div class="form-sidebar">
                    <h2 class="sidebar-title">Création de CV</h2>
                    <div class="form-sections">
                        <div class="section-nav active">
                            <span class="section-icon">👤</span>
                            <span>Infos personnelles</span>
                        </div>
                        <div class="section-nav">
                            <span class="section-icon">🎓</span>
                            <span>Diplômes</span>
                        </div>
                        <div class="section-nav">
                            <span class="section-icon">💼</span>
                            <span>Parcours</span>
                        </div>
                    </div>
                </div>

                <!-- Contenu du formulaire -->
                <div class="form-content">
                    <form action="${pageContext.request.contextPath}/candidat/save" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="idAnnonce" value="${idAnnonce}" />
                        
                        <h3>Informations personnelles</h3>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="nom">Nom *</label>
                                <input type="text" name="nom" id="nom" required/>
                            </div>

                            <div class="form-group">
                                <label for="prenom">Prénom *</label>
                                <input type="text" name="prenom" id="prenom" required/>
                            </div>

                            <div class="form-group">
                                <label for="email">Email *</label>
                                <input type="email" name="email" id="email" required/>
                            </div>

                            <div class="form-group">
                                <label for="telephone">Téléphone</label>
                                <input type="text" name="telephone" id="telephone"/>
                            </div>

                            <div class="form-group">
                                <label for="genre">Genre</label>
                                <select name="genre" id="genre">
                                    <option value="Homme">Homme</option>
                                    <option value="Femme">Femme</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="date_naissance">Date de naissance</label>
                                <input type="date" name="date_naissance" id="date_naissance"/>
                            </div>

                            <div class="form-group full-width">
                                <label for="adresse">Adresse</label>
                                <textarea name="adresse" id="adresse" rows="3"></textarea>
                            </div>

                            <div class="form-group full-width">
                                <label for="competences">Compétences professionnelles</label>
                                <textarea name="competences_personnelles" id="competences" rows="4" placeholder="Ex: Gestion de projet, Leadership, Communication..."></textarea>
                            </div>

                            <c:if test="${not empty posteNom}">
                                <div class="form-group">
                                    <label for="anneeExperience">Années d'expérience (${posteNom})</label>
                                    <input type="number" name="annee_experience" id="anneeExperience" min="0" value="0"/>
                                </div>
                            </c:if>

                            <div class="form-group">
                                <label for="idLieu">Lieu</label>
                                <select name="lieu.id_lieu" id="idLieu">
                                    <c:forEach var="lieu" items="${lieux}">
                                        <option value="${lieu.id_lieu}">${lieu.lieu}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group full-width">
                                <label for="file">Photo de profil</label>
                                <input type="file" name="file" id="file" accept="image/*"/>
                            </div>
                        </div>

                        <div class="button-group">
                            <button type="submit">Suivant</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>