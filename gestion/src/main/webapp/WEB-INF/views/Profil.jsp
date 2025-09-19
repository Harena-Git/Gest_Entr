<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil - Gestion RH</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --sidebar-width: 250px;
        }
        
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
        .profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .profile-header {
            background: linear-gradient(to right, #f8f9fa, white);
            padding: 25px;
            border-radius: 15px 15px 0 0;
            border-bottom: 1px solid #e9ecef;
        }
        .profile-body {
            padding: 25px;
        }
        .info-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .info-icon {
            width: 40px;
            height: 40px;
            background-color: #e9ecef;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: #495057;
        }
        .badge-custom {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.9rem;
        }
        .btn-return {
            padding: 10px 25px;
            border-radius: 25px;
            transition: all 0.3s;
        }
        .btn-return:hover {
            transform: translateX(-5px);
        }
        .error-alert {
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(220,53,69,0.1);
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/menu_bar.jsp" %>
    
    <div class="main-content">
        <!-- Header Section -->
        <div class="header-section text-center">
            <h1><i class="fas fa-user-tie"></i> Détails du Profil</h1>
            <p class="mb-0">Informations détaillées sur le profil requis</p>
        </div>

        <c:if test="${not empty error}">
            <div class="error-alert alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>

        <c:if test="${not empty profil}">
            <div class="profile-card">
                <div class="profile-header">
                    <div class="d-flex justify-content-between align-items-center">
                        <h4 class="mb-0"><i class="fas fa-id-card"></i> Profil #${profil.id_profil}</h4>
                        <span class="badge badge-custom bg-primary">
                            <i class="fas fa-user"></i> ${profil.genre}
                        </span>
                    </div>
                </div>

                <div class="profile-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="d-flex align-items-center">
                                    <div class="info-icon">
                                        <i class="fas fa-birthday-cake"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Âge</h6>
                                        <p class="mb-0 text-primary">${profil.age} ans</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="d-flex align-items-center">
                                    <div class="info-icon">
                                        <i class="fas fa-briefcase"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Expérience</h6>
                                        <p class="mb-0 text-primary">${profil.annee_experience} années</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="d-flex align-items-center">
                                    <div class="info-icon">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Lieu</h6>
                                        <c:choose>
                                            <c:when test="${not empty profil.lieu}">
                                                <p class="mb-0 text-primary">${profil.lieu.lieu}</p>
                                                <small class="text-muted">ID: ${profil.lieu.id_lieu}</small>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="mb-0 text-muted">Non spécifié</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-card">
                                <div class="d-flex align-items-center">
                                    <div class="info-icon">
                                        <i class="fas fa-graduation-cap"></i>
                                    </div>
                                    <div>
                                        <h6 class="mb-1">Diplôme</h6>
                                        <c:choose>
                                            <c:when test="${not empty profil.diplome}">
                                                <p class="mb-0 text-primary">${profil.diplome.niveau}</p>
                                                <small class="text-muted">ID: ${profil.diplome.id_diplome}</small>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="mb-0 text-muted">Non spécifié</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-end p-3 border-top">
                <form action="/postuler" method="get">
                    <input type="hidden" name="idProfil" value="${profil.id_profil}">
                    <button type="submit" class="btn btn-success btn-return">
                        <i class="fas fa-paper-plane"></i> Postuler avec cette offre
                    </button>
                </form>
                </div>

                <div class="text-end p-3 border-top">
                    <a href="/acceuil" class="btn btn-primary btn-return">
                        <i class="fas fa-arrow-left"></i> Retour aux offres
                    </a>
                </div>

            </div>
        </c:if>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
</body>
</html>