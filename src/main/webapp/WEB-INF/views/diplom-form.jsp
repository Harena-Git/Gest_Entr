<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CV - Diplômes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cv-styles.css">
</head>
<body>
    <div class="container">
        <div class="progress-container">
            <div class="progress-steps">
                <div class="progress-step completed">
                    <div class="step-circle">1</div>
                    <span class="step-label">Informations personnelles</span>
                </div>
                <div class="progress-step active">
                    <div class="step-circle">2</div>
                    <span class="step-label">Diplômes</span>
                </div>
                <div class="progress-step">
                    <div class="step-circle">3</div>
                    <span class="step-label">Parcours professionnel</span>
                </div>
            </div>
        </div>

        <div class="form-wrapper">
            <div class="form-layout">
                <div class="form-sidebar">
                    <h2 class="sidebar-title">Création de CV</h2>
                    <div class="form-sections">
                        <div class="section-nav completed">
                            <span class="section-icon">✓</span>
                            <span>Infos personnelles</span>
                        </div>
                        <div class="section-nav active">
                            <span class="section-icon">🎓</span>
                            <span>Diplômes</span>
                        </div>
                        <div class="section-nav">
                            <span class="section-icon">💼</span>
                            <span>Parcours</span>
                        </div>
                    </div>
                </div>

                <div class="form-content">
                    <form action="diplome-save" method="post">
                        <h3>Diplômes</h3>
                        
                        <input type="hidden" name="idCandidat" value="${candidatId}" />

                        <div class="diplome-block">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Établissement *</label>
                                    <input type="text" name="diplomes.etablissement" required/>
                                </div>

                                <div class="form-group">
                                    <label>Année d'obtention</label>
                                    <input type="number" name="diplomes.annee_obtention" min="1950" max="2025"/>
                                </div>

                                <div class="form-group full-width">
                                    <label>Niveau *</label>
                                    <select name="diplomes.id_niveau">
                                        <c:forEach var="n" items="${niveaux}">
                                            <option value="${n.id_niveau}">${n.libelle}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-group full-width">
                                    <label>Filière *</label>
                                    <div id="filieres">
                                        <c:forEach var="f" items="${filieres}">
                                            <div class="filiere-block">
                                                <label>
                                                    <input type="radio" name="diplomes.idFiliere" value="${f.idFiliere}" required/>
                                                    <span>${f.libelle}</span>
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="button-group">
                            <button type="submit" name="action" value="ajouter">Ajouter un autre diplôme</button>
                            <button type="submit" name="action" value="suivant">Suivant</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>