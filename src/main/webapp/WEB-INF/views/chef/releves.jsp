<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Génération de relevés" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="java.time.LocalDate" %>

<%
    // Dates pour les valeurs par défaut
    LocalDate aujourdhui = LocalDate.now();
    LocalDate debutMois = aujourdhui.withDayOfMonth(1);
    LocalDate hier = aujourdhui.minusDays(1);
    LocalDate debutMoisDernier = aujourdhui.minusMonths(1).withDayOfMonth(1);
    LocalDate finMoisDernier = aujourdhui.withDayOfMonth(1).minusDays(1);
    
    pageContext.setAttribute("aujourdhuiDate", java.sql.Date.valueOf(aujourdhui));
    pageContext.setAttribute("debutMoisDate", java.sql.Date.valueOf(debutMois));
    pageContext.setAttribute("hierDate", java.sql.Date.valueOf(hier));
    pageContext.setAttribute("debutMoisDernierDate", java.sql.Date.valueOf(debutMoisDernier));
    pageContext.setAttribute("finMoisDernierDate", java.sql.Date.valueOf(finMoisDernier));
%>

<div class="container">
    <!-- Messages -->
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>
    
    <!-- Formulaire de génération -->
    <div class="card">
        <h2>📊 Générer un relevé de département</h2>
        
        <form action="${pageContext.request.contextPath}/chef/generer-releve-departement" method="post">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div class="form-group">
                    <label for="dateDebut">Date début</label>
                    <input type="date" id="dateDebut" name="dateDebut" required 
                           value="<fmt:formatDate value='${debutMoisDate}' pattern='yyyy-MM-dd' />" />
                </div>
                
                <div class="form-group">
                    <label for="dateFin">Date fin</label>
                    <input type="date" id="dateFin" name="dateFin" required 
                           value="<fmt:formatDate value='${aujourdhuiDate}' pattern='yyyy-MM-dd' />" />
                </div>
            </div>
            
            <div class="form-group">
                <label>Format du rapport</label>
                <div class="radio-group">
                    <label class="radio-label">
                        <input type="radio" name="format" value="pdf" checked />
                        <span>📄 PDF</span>
                    </label>
                    <label class="radio-label">
                        <input type="radio" name="format" value="excel" />
                        <span>📊 Excel</span>
                    </label>
                </div>
            </div>
            
            <!-- Périodes rapides -->
            <div>
                <label style="margin-bottom: 5px; display: block;">Périodes rapides :</label>
                <div class="quick-buttons">
                    <button type="button" class="btn btn-outline" onclick="setPeriod('today')">Aujourd'hui</button>
                    <button type="button" class="btn btn-outline" onclick="setPeriod('week')">7 derniers jours</button>
                    <button type="button" class="btn btn-outline" onclick="setPeriod('month')">Ce mois</button>
                    <button type="button" class="btn btn-outline" onclick="setPeriod('lastMonth')">Mois dernier</button>
                </div>
            </div>
            
            <!-- Boutons d'action -->
            <div class="button-group">
                <button type="submit" class="btn btn-primary">🔄 Générer le rapport</button>
            </div>
        </form>
    </div>
    
    <!-- Tableau des fichiers générés -->
    <div class="card">
        <h2>📁 Fichiers générés</h2>
        
        <table>
            <thead>
                <tr>
                    <th>Nom du fichier</th>
                    <th>Date</th>
                    <th>Format</th>
                    <th>Taille</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="filesTableBody">
                <c:choose>
                    <c:when test="${not empty fichiers}">
                        <c:forEach var="file" items="${fichiers}">
                            <tr>
                                <td><strong>${file.nom}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty file.formattedDate}">
                                            ${file.formattedDate}
                                        </c:when>
                                        <c:when test="${not empty file.dateModification}">
                                            <fmt:formatDate value="${file.dateModification}" pattern="dd/MM/yyyy" />
                                        </c:when>
                                        <c:otherwise>
                                            -
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${fn:endsWith(file.nom, '.pdf')}">
                                            <span class="badge badge-danger">PDF</span>
                                        </c:when>
                                        <c:when test="${fn:endsWith(file.nom, '.xlsx')}">
                                            <span class="badge badge-success">Excel</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-secondary">Autre</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <!-- CORRECTION ICI -->
                                    <c:choose>
                                        <c:when test="${not empty file.tailleFormatee}">
                                            ${file.tailleFormatee}
                                        </c:when>
                                        <c:when test="${not empty file.tailleKb}">
                                            <fmt:formatNumber value="${file.tailleKb}" pattern="0.00" /> KB
                                        </c:when>
                                        <c:otherwise>
                                            0 KB
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/chef/telecharger-releve/${file.nom}" 
                                    class="btn btn-primary" style="padding: 5px 10px; font-size: 13px;">
                                        📥 Télécharger
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr id="noFilesRow">
                            <td colspan="5" class="no-files">
                                <div style="font-size: 40px; margin-bottom: 10px;">📁</div>
                                <p>Aucun fichier généré</p>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        
        <div style="margin-top: 20px; text-align: center;">
            <button type="button" class="btn btn-outline" onclick="window.location.reload()">🔄 Actualiser la liste</button>
        </div>
    </div>
</div>

<script>
// Périodes rapides
function setPeriod(type) {
    const today = new Date();
    const dateDebut = document.getElementById('dateDebut');
    const dateFin = document.getElementById('dateFin');
    
    const formatDate = (date) => {
        return date.getFullYear() + '-' + 
               String(date.getMonth() + 1).padStart(2, '0') + '-' + 
               String(date.getDate()).padStart(2, '0');
    };
    
    switch(type) {
        case 'today':
            dateDebut.value = formatDate(today);
            dateFin.value = formatDate(today);
            break;
        case 'week':
            const weekAgo = new Date();
            weekAgo.setDate(today.getDate() - 7);
            dateDebut.value = formatDate(weekAgo);
            dateFin.value = formatDate(today);
            break;
        case 'month':
            const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
            dateDebut.value = formatDate(firstDay);
            dateFin.value = formatDate(today);
            break;
        case 'lastMonth':
            const lastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1);
            const lastMonthEnd = new Date(today.getFullYear(), today.getMonth(), 0);
            dateDebut.value = formatDate(lastMonth);
            dateFin.value = formatDate(lastMonthEnd);
            break;
    }
}
</script>