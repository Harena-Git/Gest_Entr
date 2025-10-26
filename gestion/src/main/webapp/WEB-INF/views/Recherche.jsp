<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche de Candidats - Gestion RH</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .main-content {
            margin-left: var(--sidebar-width);
            padding: 30px;
            min-height: 100vh;
        }
        .header-section {
            background: linear-gradient(135deg, #343a40 0%, #495057 100%);
            padding: 40px 0;
            margin-bottom: 30px;
            color: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .search-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .candidate-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        .candidate-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            border-color: #007bff;
        }
        .candidate-header {
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
            background: linear-gradient(to right, #f8f9fa, white);
        }
        .candidate-body {
            padding: 20px;
        }
        .candidate-footer {
            padding: 15px 20px;
            background-color: #f8f9fa;
            border-top: 1px solid #e9ecef;
            border-radius: 0 0 12px 12px;
        }
        .badge-custom {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
        }
        .candidate-title {
            color: #343a40;
            font-size: 1.25rem;
            font-weight: 600;
        }
        .candidate-info {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .candidate-tags {
            margin: 15px 0;
        }
        .candidate-tag {
            background-color: #e9ecef;
            color: #495057;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            margin-right: 8px;
            display: inline-block;
            margin-bottom: 8px;
        }
        .btn-details {
            padding: 8px 25px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-details:hover {
            transform: translateY(-2px);
        }
        .search-box {
            border-radius: 25px;
            padding: 10px 20px;
            border: 2px solid #e9ecef;
        }
        .search-btn {
            border-radius: 25px;
            padding: 10px 25px;
        }
        .filters {
            display: flex;
            gap: 15px;
            margin-top: 15px;
        }
        .filter-select {
            border-radius: 20px;
            border: 1px solid #e9ecef;
            padding: 8px 15px;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/menu_bar.jsp" %>

    <div class="main-content">
        <!-- Header Section -->
        <div class="header-section text-center">
            <h1><i class="fas fa-users"></i> Recherche de Candidats</h1>
            <p class="mb-0">Trouvez les candidats correspondant à vos critères</p>
        </div>

        <!-- Search Section -->
        <div class="search-section">
            <div class="row">
                <div class="col-md-8 mx-auto">
                    <form action="/recherche" method="get">
                        <div class="input-group">
                            <input type="text" name="nom" class="form-control search-box" placeholder="Rechercher par nom ou prénom..." value="${param.nom}">
                            <button class="btn btn-primary search-btn" type="submit">
                                <i class="fas fa-search"></i> Rechercher
                            </button>
                        </div>
                        <div class="filters">
                            <select name="lieu" class="form-select filter-select">
                                <option value="">Tous les lieux</option>
                                <c:forEach var="lieu" items="${lieux}">
                                    <option value="${lieu.id_lieu}" ${param.lieu == lieu.id_lieu.toString() ? 'selected' : ''}>${lieu.lieu}</option>
                                </c:forEach>
                            </select>
                            <select name="experience" class="form-select filter-select">
                                <option value="">Années d'expérience</option>
                                <option value="0" ${param.experience == '0' ? 'selected' : ''}>0 an</option>
                                <option value="1" ${param.experience == '1' ? 'selected' : ''}>1 an</option>
                                <option value="2" ${param.experience == '2' ? 'selected' : ''}>2 ans</option>
                                <option value="3" ${param.experience == '3' ? 'selected' : ''}>3 ans et plus</option>
                            </select>
                            <select name="diplome" class="form-select filter-select">
                                <option value="">Tous les diplômes</option>
                                <c:forEach var="diplome" items="${diplomes}">
                                    <option value="${diplome.id_diplome}" ${param.diplome == diplome.id_diplome.toString() ? 'selected' : ''}>${diplome.filiere.libelle} - ${diplome.niveau.libelle}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Candidate Listings -->
        <div class="row">
            <c:forEach var="candidat" items="${candidats}">
                <div class="col-12 col-lg-6">
                    <div class="candidate-card">
                        <div class="candidate-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h2 class="candidate-title">${candidat.nom} ${candidat.prenom}</h2>
                                    <p class="candidate-info mb-0">
                                        <i class="fas fa-envelope"></i> ${candidat.email}
                                    </p>
                                </div>
                                <span class="badge badge-custom bg-primary">
                                    <i class="far fa-clock"></i> Candidature: ${candidat.date_candidature}
                                </span>
                            </div>
                        </div>
                        
                        <div class="candidate-body">
                            <div class="candidate-tags">
                                <span class="candidate-tag">
                                    <i class="fas fa-map-marker-alt"></i> ${candidat.lieu != null ? candidat.lieu.lieu : 'Non précisé'}
                                </span>
                                <span class="candidate-tag">
                                    <i class="fas fa-briefcase"></i> Expérience: ${candidat.annee_experience != null ? candidat.annee_experience : 0} an(s)
                                </span>
                            </div>
                            <h6 class="mb-3"><i class="fas fa-graduation-cap"></i> Diplômes :</h6>
                            <p class="text-muted">
                                <c:forEach var="diplomeCandidat" items="${candidat.diplomesCandidats}">
                                    ${diplomeCandidat.diplome.filiere.libelle} - ${diplomeCandidat.diplome.niveau.libelle}<br>
                                </c:forEach>
                                <c:if test="${empty candidat.diplomesCandidats}">
                                    Aucun diplôme enregistré.
                                </c:if>
                            </p>
                        </div>
                        
                        <div class="candidate-footer">
                            <div class="d-flex justify-content-between align-items-center">
                                <form action="#" method="get">
                                    <input type="hidden" name="idCandidat" value="${candidat.id_candidat}">
                                    <button type="submit" class="btn btn-primary btn-details">
                                        <i class="fas fa-user-check"></i> Voir le candidat
                                    </button>
                                </form>
                                <div class="text-muted">
                                    <small><i class="fas fa-id-card"></i> ID: ${candidat.id_candidat}</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty candidats}">
                <div class="col-12 text-center">
                    <p class="text-muted">Aucun candidat trouvé pour ces critères.</p>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
</body>
</html>