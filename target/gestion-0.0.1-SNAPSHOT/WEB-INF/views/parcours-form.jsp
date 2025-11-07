<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CV - Parcours Professionnel</title>
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
                <div class="progress-step completed">
                    <div class="step-circle">2</div>
                    <span class="step-label">Diplômes</span>
                </div>
                <div class="progress-step active">
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
                        <div class="section-nav completed">
                            <span class="section-icon">✓</span>
                            <span>Diplômes</span>
                        </div>
                        <div class="section-nav active">
                            <span class="section-icon">💼</span>
                            <span>Parcours</span>
                        </div>
                    </div>
                </div>

                <div class="form-content">
                    <form action="parcours-save" method="post">
                        <h3>Parcours professionnel</h3>
                        
                        <input type="hidden" name="idCandidat" value="${candidatId}" />
                        
                        <div class="parcours-block">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Entreprise *</label>
                                    <input type="text" name="entreprise" required/>
                                </div>

                                <div class="form-group">
                                    <label>Poste *</label>
                                    <input type="text" name="poste" required/>
                                </div>

                                <div class="form-group">
                                    <label>Date de début</label>
                                    <input type="date" name="dateDebut"/>
                                </div>

                                <div class="form-group">
                                    <label>Date de fin</label>
                                    <input type="date" name="dateFin"/>
                                </div>
                            </div>
                        </div>

                        <div class="button-group">
                            <button type="submit" name="action" value="ajouter">Ajouter un autre parcours</button>
                            <button type="submit" name="action" value="suivant">Terminer</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>