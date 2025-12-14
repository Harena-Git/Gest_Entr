<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${contrat.id_contrat_essai != null ? 'Modifier' : 'Nouveau'} Contrat d'Essai</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            min-height: 100vh;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: #495057;
            color: white;
            padding: 0;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 30px 20px;
            background: #343a40;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h4 {
            font-size: 1.5em;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            font-size: 0.85em;
            opacity: 0.8;
        }

        .nav-menu {
            padding: 20px 0;
        }

        .nav-item {
            margin-bottom: 5px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-left-color: white;
        }

        .nav-link.active {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            border-left-color: white;
            font-weight: 500;
        }

        .nav-icon {
            margin-right: 12px;
            font-size: 1.2em;
        }

        .logout-section {
            padding: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: auto;
        }

        .btn-logout {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 12px;
            background: rgba(220, 53, 69, 0.2);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.3);
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-logout:hover {
            background: #dc3545;
            border-color: #dc3545;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 30px;
        }

        .content-header {
            background: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .content-header h2 {
            color: #495057;
            font-size: 1.8em;
            font-weight: 600;
        }

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            max-width: 800px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #495057;
            font-weight: 500;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #007bff;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .required {
            color: #dc3545;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            font-size: 1em;
            margin-right: 10px;
        }

        .btn-primary {
            background: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #545b62;
        }

        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h4>👨‍💼 Admin Panel</h4>
                <p>Gestion des contrats</p>
            </div>
            
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="<c:url value='/admin/annonces'/>" class="nav-link">
                        <span class="nav-icon">📋</span>
                        Annonces
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/Embauche'/>" class="nav-link">
                        <span class="nav-icon">👔</span>
                        Embaucher
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/mes-entretiens'/>" class="nav-link">
                        <span class="nav-icon">📅</span>
                        Mes entretiens
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/candidat/list'/>" class="nav-link">
                        <span class="nav-icon">👥</span>
                        Liste des Candidats
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/personnel/list'/>" class="nav-link">
                        <span class="nav-icon">👥</span>
                        Liste des personnels
                    </a>
                </li>
                <li class="nav-item">
                    <a href="<c:url value='/contrat/list'/>" class="nav-link active">
                        <span class="nav-icon">📄</span>
                        Gestion contrats d'essai
                    </a>
                </li>
                
                <!-- Nouvelle section : Gestion du Personnel -->
                <li class="nav-item" style="margin-top: 20px; padding: 10px 20px; background: rgba(255,255,255,0.1);">
                    <strong style="color: white; font-size: 0.9em;">📁 GESTION DU PERSONNEL</strong>
                </li>
                
                <li class="nav-item">
                    <a href="<c:url value='/admin/contrats'/>" class="nav-link">
                        <span class="nav-icon">📝</span>
                        Contrats de Travail
                    </a>
                </li>
                
                <li class="nav-item">
                    <a href="<c:url value='/admin/historique-postes'/>" class="nav-link">
                        <span class="nav-icon">📈</span>
                        Historique Postes
                    </a>
                </li>
                
                <li class="nav-item">
                    <a href="<c:url value='/admin/documents'/>" class="nav-link">
                        <span class="nav-icon">📂</span>
                        Documents RH
                    </a>
                </li>
            </ul>

            <div class="logout-section">
                <a href="<c:url value='/acceuil'/>" class="btn-logout">
                    <span style="margin-right: 8px;">🚪</span>
                    Déconnexion
                </a>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h2>📄 ${contrat.id_contrat_essai != null ? 'Modifier' : 'Nouveau'} Contrat d'Essai</h2>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="form-container">
                <form action="<c:url value='/contrat/save'/>" method="post">
                    <input type="hidden" name="id_contrat_essai" value="${contrat.id_contrat_essai}"/>
                    
                    <div class="form-group">
                        <label for="candidatId">
                            Candidat <span class="required">*</span>
                        </label>
                        <select id="candidatId" name="candidatId" required>
                            <option value="">-- Sélectionner un candidat --</option>
                            <c:forEach items="${candidats}" var="cand">
                                <option value="${cand.id_candidat}" 
                                    ${contrat.candidat != null && contrat.candidat.id_candidat == cand.id_candidat ? 'selected' : ''}>
                                    ${cand.nom} ${cand.prenom} - ${cand.email}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="date_debut">
                            Date de début <span class="required">*</span>
                        </label>
                        <input type="date" 
                               id="date_debut" 
                               name="date_debut" 
                               value="<fmt:formatDate value='${contrat.date_debut}' pattern='yyyy-MM-dd'/>"
                               required/>
                    </div>

                    <div class="form-group">
                        <label for="date_fin">
                            Date de fin <span class="required">*</span>
                        </label>
                        <input type="date" 
                               id="date_fin" 
                               name="date_fin" 
                               value="<fmt:formatDate value='${contrat.date_fin}' pattern='yyyy-MM-dd'/>"
                               required/>
                    </div>

                    <div class="form-group">
                        <label for="salaire">
                            Salaire (Ar) <span class="required">*</span>
                        </label>
                        <input type="number" 
                               id="salaire" 
                               name="salaire" 
                               step="0.01"
                               value="${contrat.salaire}"
                               placeholder="Ex: 500000"
                               required/>
                    </div>

                    <div class="form-group">
                        <label for="poste">
                            Poste <span class="required">*</span>
                        </label>
                        <input type="text" 
                               id="poste" 
                               name="poste" 
                               value="${contrat.poste}"
                               placeholder="Ex: Développeur Java"
                               required/>
                    </div>

                    <div class="form-group">
                        <label for="conditions">
                            Conditions du contrat
                        </label>
                        <textarea id="conditions" 
                                  name="conditions" 
                                  placeholder="Décrivez les conditions et clauses du contrat d'essai...">${contrat.conditions}</textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            💾 ${contrat.id_contrat_essai != null ? 'Mettre à jour' : 'Enregistrer'}
                        </button>
                        <a href="<c:url value='/contrat/list'/>" class="btn btn-secondary">
                            ❌ Annuler
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
