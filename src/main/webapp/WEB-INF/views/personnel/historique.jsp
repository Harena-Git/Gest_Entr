<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Mon historique" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<%
    // Calculer les dates pour les boutons de période rapide
    java.time.LocalDate aujourdhuiLocal = java.time.LocalDate.now();
    java.time.LocalDate ilYa7Jours = aujourdhuiLocal.minusDays(7);
    java.time.LocalDate debutMois = aujourdhuiLocal.withDayOfMonth(1);
    
    // Convertir en java.sql.Date pour JSTL
    pageContext.setAttribute("aujourdhuiDate", java.sql.Date.valueOf(aujourdhuiLocal));
    pageContext.setAttribute("ilYa7JoursDate", java.sql.Date.valueOf(ilYa7Jours));
    pageContext.setAttribute("debutMoisDate", java.sql.Date.valueOf(debutMois));
%>

<div class="main-container">
    <!-- Filtres de période -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📅 Filtres de période</h2>
        </div>
        
        <form action="${pageContext.request.contextPath}/personnel/historique" method="get" style="display: grid; grid-template-columns: 1fr 1fr auto; gap: 15px; align-items: end;">
            <div class="form-group">
                <label for="dateDebut">Date début</label>
                <input type="date" id="dateDebut" name="dateDebut" 
                    value="<fmt:formatDate value='${dateDebut}' pattern='yyyy-MM-dd' />" 
                    class="form-control" style="padding: 10px; font-size: 15px;" />
            </div>
            
            <div class="form-group">
                <label for="dateFin">Date fin</label>
                <input type="date" id="dateFin" name="dateFin" 
                    value="<fmt:formatDate value='${dateFin}' pattern='yyyy-MM-dd' />"
                    class="form-control" style="padding: 10px; font-size: 15px;" />
            </div>
            
            <div class="form-group">
                <button type="submit" class="btn btn-primary" style="height: 44px; padding: 10px 20px; font-size: 15px; min-width: 100px;">
                    🔍 Filtrer
                </button>
            </div>
        </form>
        
        <!-- Boutons de période rapide -->
        <div style="display: flex; gap: 10px; margin-top: 20px; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/personnel/historique?dateDebut=<fmt:formatDate value='${aujourdhuiDate}' pattern='yyyy-MM-dd' />&dateFin=<fmt:formatDate value='${aujourdhuiDate}' pattern='yyyy-MM-dd' />" 
               class="btn btn-secondary" style="padding: 8px 15px; font-size: 14px;">
                Aujourd'hui
            </a>
            <a href="${pageContext.request.contextPath}/personnel/historique?dateDebut=<fmt:formatDate value='${ilYa7JoursDate}' pattern='yyyy-MM-dd' />&dateFin=<fmt:formatDate value='${aujourdhuiDate}' pattern='yyyy-MM-dd' />" 
               class="btn btn-secondary" style="padding: 8px 15px; font-size: 14px;">
                7 derniers jours
            </a>
            <a href="${pageContext.request.contextPath}/personnel/historique?dateDebut=<fmt:formatDate value='${debutMoisDate}' pattern='yyyy-MM-dd' />&dateFin=<fmt:formatDate value='${aujourdhuiDate}' pattern='yyyy-MM-dd' />" 
               class="btn btn-secondary" style="padding: 8px 15px; font-size: 14px;">
                Ce mois
            </a>
            <a href="${pageContext.request.contextPath}/personnel/dashboard" 
               class="btn btn-secondary" style="padding: 8px 15px; font-size: 14px;">
                ← Retour au dashboard
            </a>
        </div>
    </div>
    
    <!-- Tableau d'historique -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📊 Historique des présences</h2>
            <div class="card-subtitle">
                Période : <fmt:formatDate value="${dateDebut}" pattern="dd/MM/yyyy" /> 
                au <fmt:formatDate value="${dateFin}" pattern="dd/MM/yyyy" />
                <span style="margin-left: 15px; color: #666; font-size: 14px;">
                    Total : ${fn:length(historique)} jour(s)
                </span>
            </div>
        </div>
        
        <div class="table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="min-width: 100px;">Date</th>
                        <th>Jour</th>
                        <th>Heure arrivée</th>
                        <th>Heure départ</th>
                        <th>Présent</th>
                        <th>Retard</th>
                        <th>Validation Chef</th>
                        <th>Validation RH</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="presence" items="${historique}">
                        <tr>
                            <td>
                                <!-- Formatage de la date sans fmt:formatDate -->
                                <c:out value="${presence.date.dayOfMonth}/${presence.date.monthValue}/${presence.date.year}" />
                            </td>
                            <td>
                                <!-- Affichage du jour de la semaine -->
                                <c:choose>
                                    <c:when test="${presence.date.dayOfWeek.value == 1}">Lundi</c:when>
                                    <c:when test="${presence.date.dayOfWeek.value == 2}">Mardi</c:when>
                                    <c:when test="${presence.date.dayOfWeek.value == 3}">Mercredi</c:when>
                                    <c:when test="${presence.date.dayOfWeek.value == 4}">Jeudi</c:when>
                                    <c:when test="${presence.date.dayOfWeek.value == 5}">Vendredi</c:when>
                                    <c:when test="${presence.date.dayOfWeek.value == 6}">Samedi</c:when>
                                    <c:when test="${presence.date.dayOfWeek.value == 7}">Dimanche</c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${presence.heureArrivee != null}">
                                        ${presence.heureArrivee}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${presence.heureDepart != null}">
                                        ${presence.heureDepart}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${presence.present}">
                                        <span class="status status-present" style="padding: 4px 10px; font-size: 13px;">
                                            ✅ Présent
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status status-absent" style="padding: 4px 10px; font-size: 13px;">
                                            ❌ Absent
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${presence.heureArrivee != null}">
                                    <c:set var="heureArriveeStr" value="${presence.heureArrivee}" />
                                    <c:set var="heureArriveeParts" value="${fn:split(heureArriveeStr, ':')}" />
                                    
                                    <c:if test="${fn:length(heureArriveeParts) >= 2}">
                                        <c:set var="arriveeHour" value="${fn:substring(heureArriveeParts[0], 0, 2)}" />
                                        <c:set var="arriveeMinute" value="${fn:substring(heureArriveeParts[1], 0, 2)}" />
                                        
                                        <c:catch var="exception">
                                            <c:set var="arriveeHourInt" value="${Integer.parseInt(arriveeHour)}" />
                                            <c:set var="arriveeMinuteInt" value="${Integer.parseInt(arriveeMinute)}" />
                                            <c:set var="arriveeTotalMinutes" value="${arriveeHourInt * 60 + arriveeMinuteInt}" />
                                            <c:set var="retardMinutes" value="${arriveeTotalMinutes - (8 * 60)}" />
                                            
                                            <c:choose>
                                                <c:when test="${retardMinutes > 0}">
                                                    <span class="status-pending" style="padding: 4px 10px; font-size: 13px; background-color: #fff3cd; color: #856404;">
                                                        ⏰ ${retardMinutes} min
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #28a745; font-size: 13px;">
                                                        ✅ À l'heure
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:catch>
                                        
                                        <c:if test="${not empty exception}">
                                            <span style="color: #6c757d; font-size: 13px;">-</span>
                                        </c:if>
                                    </c:if>
                                </c:if>
                                <c:if test="${presence.heureArrivee == null}">-</c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty presence.validationsChef}">
                                        <c:set var="validationChef" value="${presence.validationsChef[0]}" />
                                        <c:choose>
                                            <c:when test="${validationChef.decisionValidation.libelle == 'accepté'}">
                                                <span style="color: #28a745; font-size: 13px;">✅ Validé</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #dc3545; font-size: 13px;">❌ Refusé</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #ffc107; font-size: 13px;">⏳ En attente</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${presence.valideParRh}">
                                        <span style="color: #28a745; font-size: 13px;">✅ Finalisé</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #6c757d; font-size: 13px;">⏳ En attente</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${presence.heureArrivee != null || presence.heureDepart != null}">
                                    <a href="${pageContext.request.contextPath}/personnel/historique?id=${presence.idPresenceAbsence}" 
                                       class="btn btn-sm btn-secondary" style="padding: 4px 10px; font-size: 12px;">
                                        👁️ Détails
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty historique}">
                        <tr>
                            <td colspan="9" style="text-align: center; padding: 50px;">
                                <div style="font-size: 16px; color: #6c757d; margin-bottom: 20px;">
                                    Aucune présence enregistrée pour cette période
                                </div>
                                <a href="${pageContext.request.contextPath}/personnel/historique" 
                                   class="btn btn-primary" style="padding: 10px 20px; font-size: 14px;">
                                    Voir tout l'historique
                                </a>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <!-- Pagination ou résumé -->
        <c:if test="${not empty historique}">
            <div style="padding: 15px; border-top: 1px solid #dee2e6; background-color: #f8f9fa; display: flex; justify-content: space-between; align-items: center;">
                <div style="font-size: 14px; color: #495057;">
                    ${fn:length(historique)} résultat(s)
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/personnel/dashboard" 
                       class="btn btn-secondary" style="padding: 8px 15px; font-size: 14px;">
                        ← Retour au dashboard
                    </a>
                </div>
            </div>
        </c:if>
    </div>
    
    <!-- Section détaillée si ID fourni -->
    <c:if test="${not empty presenceAbs}">
        <div class="card" style="margin-top: 20px;">
            <div class="card-header">
                <h2 class="card-title">📋 Détails de la présence</h2>
            </div>
            <div class="card-body">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                    <div class="detail-item">
                        <strong>Date:</strong> 
                        <c:out value="${presenceAbs.date.dayOfMonth}/${presenceAbs.date.monthValue}/${presenceAbs.date.year}" />
                    </div>
                    <div class="detail-item">
                        <strong>Heure d'arrivée:</strong> 
                        <c:choose>
                            <c:when test="${presenceAbs.heureArrivee != null}">
                                ${presenceAbs.heureArrivee}
                            </c:when>
                            <c:otherwise>Non enregistrée</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="detail-item">
                        <strong>Heure de départ:</strong> 
                        <c:choose>
                            <c:when test="${presenceAbs.heureDepart != null}">
                                ${presenceAbs.heureDepart}
                            </c:when>
                            <c:otherwise>Non enregistrée</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="detail-item">
                        <strong>Statut:</strong> 
                        <c:choose>
                            <c:when test="${presenceAbs.present}">
                                <span class="status-present">✅ Présent</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-absent">❌ Absent</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- Validations -->
                <c:if test="${not empty presenceAbs.validationsChef}">
                    <div style="margin-top: 30px;">
                        <h3 style="font-size: 18px; margin-bottom: 15px; color: #495057;">Validations</h3>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px;">
                            <c:forEach var="validation" items="${presenceAbs.validationsChef}">
                                <div style="border: 1px solid #dee2e6; border-radius: 5px; padding: 15px; background-color: #f8f9fa;">
                                    <div><strong>Validation par:</strong> ${validation.user.nom}</div>
                                    <div><strong>Date validation:</strong> 
                                        <c:if test="${validation.dateValidation != null}">
                                            <fmt:formatDate value="${validation.dateValidation}" pattern="dd/MM/yyyy HH:mm" />
                                        </c:if>
                                        <c:if test="${validation.dateValidation == null}">
                                            Non spécifiée
                                        </c:if>
                                    </div>
                                    <div><strong>Décision:</strong> 
                                        <c:choose>
                                            <c:when test="${validation.decisionValidation.libelle == 'accepté'}">
                                                <span style="color: #28a745;">✅ Accepté</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #dc3545;">❌ Refusé</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </c:if>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>