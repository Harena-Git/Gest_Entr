<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Génération de relevés" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

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
                    <button type="button" class="btn btn-success" onclick="previewReport()">👁️ Prévisualiser</button>
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
                        <th>Période</th>
                        <th>Format</th>
                        <th>Taille</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="filesTableBody">
                    <tr id="noFilesRow">
                        <td colspan="5" class="no-files">
                            <div style="font-size: 40px; margin-bottom: 10px;">📁</div>
                            <p>Aucun fichier généré</p>
                        </td>
                    </tr>
                </tbody>
            </table>
            
            <div style="margin-top: 20px; text-align: center;">
                <button type="button" class="btn btn-outline" onclick="refreshFilesList()">🔄 Actualiser la liste</button>
            </div>
        </div>
    </div>

    <script>
    // Fichiers simulés
    let generatedFiles = [];
    
    // Afficher les fichiers
    function displayFiles() {
        const tbody = document.getElementById('filesTableBody');
        const noFilesRow = document.getElementById('noFilesRow');
        
        tbody.innerHTML = '';
        
        if (generatedFiles.length === 0) {
            tbody.appendChild(noFilesRow);
            noFilesRow.style.display = '';
        } else {
            noFilesRow.style.display = 'none';
            
            generatedFiles.forEach(file => {
                const row = document.createElement('tr');
                const formatBadge = file.format === 'PDF' 
                    ? '<span class="badge badge-danger">PDF</span>' 
                    : '<span class="badge badge-success">Excel</span>';
                
                row.innerHTML = `
                    <td><strong>${file.filename}</strong></td>
                    <td>${file.periode}</td>
                    <td>${formatBadge}</td>
                    <td>${file.size}</td>
                    <td>
                        <a href="${file.url}" class="btn btn-primary" style="padding: 5px 10px; font-size: 13px;">
                            📥 Télécharger
                        </a>
                    </td>
                `;
                
                tbody.appendChild(row);
            });
        }
    }
    
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
    
    function previewReport() {
        const dateDebut = document.getElementById('dateDebut').value;
        const dateFin = document.getElementById('dateFin').value;
        const format = document.querySelector('input[name="format"]:checked').value;
        
        alert(`Prévisualisation:\nPériode: ${dateDebut} au ${dateFin}\nFormat: ${format.toUpperCase()}`);
    }
    
    function refreshFilesList() {
        // Simulation d'actualisation
        alert('Liste actualisée (simulation)');
    }
    
    // Initialiser
    displayFiles();
    </script>
