<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Gestion de l'équipe" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="main-container">
        <!-- Statistiques rapides -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${fn:length(presencesEquipe)}</div>
                <div class="stat-label">Total équipe</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="presentCount" value="0" />
                    <c:forEach var="presence" items="${presencesEquipe}">
                        <c:if test="${presence.present}">
                            <c:set var="presentCount" value="${presentCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${presentCount}
                </div>
                <div class="stat-label">Présents</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="absentCount" value="${fn:length(presencesEquipe) - presentCount}" />
                    ${absentCount}
                </div>
                <div class="stat-label">Absents</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">
                    <c:set var="retardCount" value="0" />
                    <c:forEach var="presence" items="${presencesEquipe}">
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
                                    <c:if test="${arriveeTotalMinutes > (8 * 60)}">
                                        <c:set var="retardCount" value="${retardCount + 1}" />
                                    </c:if>
                                </c:catch>
                            </c:if>
                        </c:if>
                    </c:forEach>
                    ${retardCount}
                </div>
                <div class="stat-label">En retard</div>
            </div>
        </div>
        
        <!-- Tableau des présences -->
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">👥 Mon équipe - Présences du jour</h2>
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
                            <th>Retard</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="presence" items="${presencesEquipe}">
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
                                                    <c:if test="${retardMinutes > 0}">
                                                        <br><small class="status-pending" style="font-size: 12px;">⏰ En retard</small>
                                                    </c:if>
                                                </c:catch>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status status-absent">❌ Non pointé</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${presence.heureDepart != null}">
                                            ${presence.heureDepart}
                                        </c:when>
                                        <c:when test="${presence.heureArrivee != null && presence.heureDepart == null}">
                                            <span class="status-pending">⏳ En cours</span>
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
                                                <c:if test="${retardMinutes > 0}">
                                                    <span style="color: #dc3545; font-weight: bold;">${retardMinutes} min</span>
                                                </c:if>
                                                <c:if test="${retardMinutes <= 0}">
                                                    <span style="color: #28a745;">À l'heure</span>
                                                </c:if>
                                            </c:catch>
                                        </c:if>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="btn-group">
                                        <c:choose>
                                            <c:when test="${not presence.present}">
                                                <a href="${pageContext.request.contextPath}/chef/validations?type=absence&personnel=${presence.personnel.id_personnel}" 
                                                   class="btn btn-primary">
                                                    📝 Absence
                                                </a>
                                            </c:when>
                                            <c:otherwise>
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
                                                            <c:if test="${retardMinutes >= 15}">
                                                                <a href="${pageContext.request.contextPath}/chef/validations?type=retard&personnel=${presence.personnel.id_personnel}" 
                                                                   class="btn btn-warning">
                                                                    ⏰ Retard
                                                                </a>
                                                            </c:if>
                                                        </c:catch>
                                                    </c:if>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty presencesEquipe}">
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 50px; color: #6c757d;">
                                    Aucun membre dans l'équipe aujourd'hui
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>