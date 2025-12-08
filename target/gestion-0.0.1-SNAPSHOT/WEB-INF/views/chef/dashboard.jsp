<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Tableau de bord Chef" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="main-container">
        <!-- Messages de notification -->
        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">❌ ${error}</div>
        </c:if>
        
        <!-- Statistiques département -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div class="stat-number">${stats.nombrePresences}</div>
                <div class="stat-label">Présences aujourd'hui</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">📄</div>
                <div class="stat-number">${stats.justificationsAbsenceEnAttente}</div>
                <div class="stat-label">Absences à valider</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">⏰</div>
                <div class="stat-number">${stats.justificationsRetardEnAttente}</div>
                <div class="stat-label">Retards à valider</div>
            </div>
            
            <div class="stat-card">
                <div class="stat-icon">💼</div>
                <div class="stat-number">${stats.heuresSupDepartement}</div>
                <div class="stat-label">Heures sup total</div>
            </div>
        </div>
        
        <!-- Présences du jour -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">👥 Présences du jour</h2>
                <div class="card-date">
                    ${aujourdhuiFormatted} (${aujourdhuiDay})
                </div>
            </div>
            
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Personnel</th>
                            <th>Poste</th>
                            <th>Heure arrivée</th>
                            <th>Heure départ</th>
                            <th>Statut</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="presence" items="${presencesDuJour}">
                            <tr>
                                <td>
                                    <strong>${presence.personnel.candidat.nom} ${presence.personnel.candidat.prenom}</strong><br>
                                    <small>${presence.personnel.candidat.email}</small>
                                </td>
                                <td>${presence.personnel.poste.libelle}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${presence.heureArrivee != null}">
                                            ${presence.heureArrivee}
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #dc3545;">❌ Non pointé</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${presence.heureDepart != null}">
                                            ${presence.heureDepart}
                                        </c:when>
                                        <c:when test="${presence.heureArrivee != null && presence.heureDepart == null}">
                                            <span style="color: #ffc107; font-weight: 500;">⏳ En cours</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #6c757d;">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${presence.present}">
                                            <span class="status status-present">✅ Présent</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status status-absent">❌ Absent</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty presencesDuJour}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 50px; color: #6c757d;">
                                    Aucune présence enregistrée aujourd'hui dans votre département
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>