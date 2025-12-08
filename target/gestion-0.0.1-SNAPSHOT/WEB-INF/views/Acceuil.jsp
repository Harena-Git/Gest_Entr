<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Offres d'Emploi - Gestion RH</title>
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
        .job-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            border-color: #007bff;
        }
        .job-header {
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
            background: linear-gradient(to right, #f8f9fa, white);
        }
        .job-body {
            padding: 20px;
        }
        .job-footer {
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
        .job-title {
            color: #343a40;
            font-size: 1.25rem;
            font-weight: 600;
        }
        .job-company {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .job-tags {
            margin: 15px 0;
        }
        .job-tag {
            background-color: #e9ecef;
            color: #495057;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            margin-right: 8px;
            display: inline-block;
            margin-bottom: 8px;
        }
        .btn-apply {
            padding: 8px 25px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-apply:hover {
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
            <h1><i class="fas fa-briefcase"></i> Offres d'Emploi</h1>
            <p class="mb-0">Découvrez nos opportunités de carrière</p>
        </div>

        <!-- Search Section -->
        <div class="search-section">
            <div class="row">
                <div class="col-md-8 mx-auto">
                     <input type="text" class="form-control search-box" placeholder="Rechercher responsabilite" id="searchInput">

                    <div class="filters">
                        <form method="get" action="acceuil">
                            <select class="form-select filter-select" style="width:250px;" name="lieu" onchange="this.form.submit()">
                                <option value="">Tous les lieux</option>
                                <c:forEach var="lieu" items="${lieux}">
                                    <option value="${lieu.id_lieu}"
                                        <c:if test="${lieu.id_lieu == param.lieu}">selected</c:if>>
                                        ${lieu.lieu}
                                    </option>
                                </c:forEach>
                            </select>
                        </form>

                        <!-- Filtre Département -->
                        <form method="get" action="acceuil" style="display:inline-block; margin-right:10px;">
                            <select class="form-select filter-select" style="width:250px;" name="departement" onchange="this.form.submit()">
                                <option value="">Tous les domaines</option>
                                <c:forEach var="dep" items="${departements}">
                                    <option value="${dep.id_departement}" 
                                        <c:if test="${dep.id_departement == departementSelectionne}">selected</c:if>>
                                        ${dep.departement}
                                    </option>
                                </c:forEach>
                            </select>
                        </form>

                         <!-- Filtre Expérience -->
                        <form method="get" action="acceuil" style="display:inline-block; margin-right:10px;">
                            <select class="form-select filter-select" style="width:180px;" name="experience" onchange="this.form.submit()">
                                <option value="">Expérience requise</option>
                                <option value="0-0" <c:if test="${experienceSelectionnee == '0-0'}">selected</c:if>>Débutant / Sans expérience</option>
                                <option value="1-2" <c:if test="${experienceSelectionnee == '1-2'}">selected</c:if>>1 à 2 ans</option>
                                <option value="3-5" <c:if test="${experienceSelectionnee == '3-5'}">selected</c:if>>3 à 5 ans</option>
                                <option value="5+" <c:if test="${experienceSelectionnee == '5+'}">selected</c:if>>+5 ans</option>
                            </select>
                        </form>
                        
                        <form method="get" action="acceuil">
                            <select class="form-select filter-select" name="salaireMax" style="width:120px;" onchange="this.form.submit()">
                                <option value="">Salaire max</option>
                                <option value="1000000" <c:if test="${param.salaireMax == '1000000'}">selected</c:if>>1 000 000 Ar</option>
                                <option value="1200000" <c:if test="${param.salaireMax == '1200000'}">selected</c:if>>1 200 000 Ar</option>
                                <option value="1500000" <c:if test="${param.salaireMax == '1500000'}">selected</c:if>>1 500 000 Ar</option>
                                <option value="2000000" <c:if test="${param.salaireMax == '2000000'}">selected</c:if>>2 000 000 Ar</option>
                            </select>
                        </form>   
                    </div>
                </div>
            </div>
        </div>

        <!-- Job Listings -->
        <div class="row">
            <c:forEach var="annonce" items="${annonces}">
                <div class="col-12 col-lg-6" data-responsabilite="${annonce.responsabilite}">
                    <div class="job-card">
                        <div class="job-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h2 class="job-title">${annonce.poste.id_poste}</h2>
                                    <p class="job-company mb-0">
                                        <i class="fas fa-building"></i> Réf: #${annonce.id_annonce}
                                    </p>
                                </div>
                                <span class="badge badge-custom bg-primary">
                                    <i class="far fa-clock"></i> ${annonce.date_annonce}
                                </span>
                            </div>
                        </div>
                        
                        <div class="job-body">
                            <div class="job-tags">
                                <span class="job-tag">
                                    <i class="fas fa-map-marker-alt"></i> Madagascar
                                </span>
                                <span class="job-tag">
                                    <i class="fas fa-clock"></i> Date limite: ${annonce.date_fin}
                                </span>
                            </div>
                            
                            <h6 class="mb-3"><i class="fas fa-tasks"></i> Responsabilités :</h6>
                            <p class="text-muted">${annonce.responsabilite}</p>
                        </div>
                        
                        <div class="job-footer">
                            <div class="d-flex justify-content-between align-items-center">
                                <form action="profil" method="get">
                                    <input type="hidden" name="idProfil" value="${annonce.profil.id_profil}">
                                    <input type="hidden" name="idAnnonce" value="${annonce.id_annonce}">
                                    <button type="submit" class="btn btn-primary btn-apply">
                                        <i class="fas fa-user-check"></i> Voir le profil requis
                                    </button>
                                </form>
                                <div class="text-muted">
                                  <!--  <small><i class="fas fa-users"></i> Profil ID: ${annonce.profil.id_profil}</small> -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $("#searchInput").on("input", function() {
        let filtreMot = $(this).val().toLowerCase();

        $(".col-12.col-lg-6").each(function() {
            let responsabilite = $(this).data("responsabilite").toLowerCase();
            
            if (responsabilite.includes(filtreMot)) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });
});
</script>


    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
</body>
</html>