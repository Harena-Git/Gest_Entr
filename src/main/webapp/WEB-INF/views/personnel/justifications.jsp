<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Mes justifications" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<%
    // Date d'aujourd'hui pour les valeurs par défaut
    java.time.LocalDate aujourdhuiLocal = java.time.LocalDate.now();
    pageContext.setAttribute("aujourdhuiDate", java.sql.Date.valueOf(aujourdhuiLocal));
%>

<div class="main-container">
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>
    
    <!-- Formulaire de justification d'absence -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📄 Justifier une absence</h2>
        </div>
        
        <form action="${pageContext.request.contextPath}/personnel/justifier-absence" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="dateAbsence">Date de l'absence</label>
                <div class="input-wrapper">
                    <span class="input-icon">📅</span>
                    <input type="date" id="dateAbsence" name="dateAbsence" 
                           value="<fmt:formatDate value='${aujourdhuiDate}' pattern='yyyy-MM-dd' />" 
                           required class="form-control" style="padding: 12px; font-size: 15px;" />
                </div>
            </div>
            
            <div class="form-group">
                <label for="motif">Motif (facultatif)</label>
                <div class="input-wrapper">
                    <span class="input-icon">📝</span>
                    <input type="text" id="motif" name="motif" 
                           placeholder="Ex: Maladie, rendez-vous médical..."
                           class="form-control" style="padding: 12px; font-size: 15px;" />
                </div>
            </div>
            
            <div class="form-group">
                <label for="fichier">Justificatif (PDF, JPG, PNG)</label>
                <div class="input-wrapper">
                    <span class="input-icon">📎</span>
                    <input type="file" id="fichier" name="fichier" 
                           accept=".pdf,.jpg,.jpeg,.png" 
                           class="form-control" style="padding: 10px; font-size: 15px;" />
                </div>
                <small style="color: #6c757d; margin-top: 5px; display: block;">
                    Format acceptés : PDF, JPG, PNG (max 10MB)
                </small>
            </div>
            
            <div style="display: flex; gap: 15px; margin-top: 20px;">
                <button type="submit" class="btn btn-primary" style="padding: 12px 24px; font-size: 16px; min-width: 200px;">
                    📤 Soumettre la justification
                </button>
                <a href="${pageContext.request.contextPath}/personnel/dashboard" 
                   class="btn btn-secondary" style="padding: 12px 24px; font-size: 16px;">
                    ← Retour
                </a>
            </div>
        </form>
    </div>
    
    <!-- Formulaire de justification de retard -->
    <div class="card" style="margin-top: 30px;">
        <div class="card-header">
            <h2 class="card-title">⏰ Justifier un retard</h2>
        </div>
        
        <form action="${pageContext.request.contextPath}/personnel/justifier-retard" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="submit" />
            
            <div class="form-group">
                <label for="dateRetard">Date du retard</label>
                <div class="input-wrapper">
                    <span class="input-icon">📅</span>
                    <input type="date" id="dateRetard" name="dateRetard"
                           value="<fmt:formatDate value='${aujourdhuiDate}' pattern='yyyy-MM-dd' />" 
                           required class="form-control" style="padding: 12px; font-size: 15px;" />
                </div>
            </div>
            
            <div class="form-group">
                <label for="minutesRetard">Minutes de retard</label>
                <div class="input-wrapper">
                    <span class="input-icon">⏱️</span>
                    <input type="number" id="minutesRetard" name="minutesRetard" 
                           min="1" max="480" value="${not empty retardParDefaut ? retardParDefaut : 15}" 
                           required class="form-control" style="padding: 12px; font-size: 15px;" />
                </div>
                <small style="color: #6c757d; margin-top: 5px; display: block;">
                    Saisissez le nombre de minutes de retard (15 minutes minimum)
                </small>
            </div>
            
            <div class="form-group">
                <label for="fichierRetard">Justificatif (PDF, JPG, PNG)</label>
                <div class="input-wrapper">
                    <span class="input-icon">📎</span>
                    <input type="file" id="fichierRetard" name="fichier" 
                           accept=".pdf,.jpg,.jpeg,.png" 
                           class="form-control" style="padding: 10px; font-size: 15px;" />
                </div>
                <small style="color: #6c757d; margin-top: 5px; display: block;">
                    Un justificatif est recommandé pour les retards de plus de 30 minutes
                </small>
            </div>
            
            <div style="display: flex; gap: 15px; margin-top: 20px;">
                <button type="submit" class="btn btn-primary" style="padding: 12px 24px; font-size: 16px; min-width: 200px;">
                    📤 Soumettre la justification
                </button>
                <a href="${pageContext.request.contextPath}/personnel/dashboard" 
                   class="btn btn-secondary" style="padding: 12px 24px; font-size: 16px;">
                    ← Retour
                </a>
            </div>
        </form>
    </div>
    
    <!-- Historique des justifications -->
    <div class="card" style="margin-top: 30px;">
        <div class="card-header">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <h2 class="card-title">📋 Mes justifications</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/personnel/justifications?filter=all" 
                       class="btn btn-sm btn-secondary" style="padding: 6px 12px; font-size: 14px; margin-right: 10px;">
                        Toutes
                    </a>
                    <a href="${pageContext.request.contextPath}/personnel/justifications?filter=pending" 
                       class="btn btn-sm btn-secondary" style="padding: 6px 12px; font-size: 14px;">
                        En attente
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Absences -->
        <div style="padding: 20px;">
            <h3 style="margin: 0 0 20px 0; color: #495057; font-size: 18px; padding-bottom: 10px; border-bottom: 2px solid #007bff;">
                Absences (${fn:length(justifsAbsence)})
            </h3>
            
            <c:choose>
                <c:when test="${not empty justifsAbsence}">
                    <div class="table-responsive">
                        <table class="data-table" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th style="min-width: 120px;">Date absence</th>
                                    <th style="min-width: 120px;">Date demande</th>
                                    <th>Justificatif</th>
                                    <th style="min-width: 120px;">Statut</th>
                                    <th style="min-width: 100px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="justif" items="${justifsAbsence}">
                                    <tr>
                                        <td>
                                            <!-- Formatage manuel de LocalDate -->
                                            <c:out value="${justif.dateAbsence.dayOfMonth}/${justif.dateAbsence.monthValue}/${justif.dateAbsence.year}" />
                                            <br/>
                                            <small style="color: #6c757d; font-size: 12px;">
                                                <c:choose>
                                                    <c:when test="${justif.dateAbsence.dayOfWeek.value == 1}">Lundi</c:when>
                                                    <c:when test="${justif.dateAbsence.dayOfWeek.value == 2}">Mardi</c:when>
                                                    <c:when test="${justif.dateAbsence.dayOfWeek.value == 3}">Mercredi</c:when>
                                                    <c:when test="${justif.dateAbsence.dayOfWeek.value == 4}">Jeudi</c:when>
                                                    <c:when test="${justif.dateAbsence.dayOfWeek.value == 5}">Vendredi</c:when>
                                                    <c:when test="${justif.dateAbsence.dayOfWeek.value == 6}">Samedi</c:when>
                                                    <c:when test="${justif.dateAbsence.dayOfWeek.value == 7}">Dimanche</c:when>
                                                </c:choose>
                                            </small>
                                        </td>
                                        <td>
                                            <!-- Formatage manuel de LocalDate -->
                                            <c:out value="${justif.dateDemande.dayOfMonth}/${justif.dateDemande.monthValue}/${justif.dateDemande.year}" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty justif.fichierJustification}">
                                                    <c:set var="filePath" value="/static/${justif.fichierJustification}" />
                                                    <a href="${filePath}" target="_blank" 
                                                       class="btn btn-sm btn-primary" style="padding: 5px 12px; font-size: 13px;">
                                                        📄 Voir
                                                    </a>
                                                    <br/>
                                                    <small style="color: #6c757d; font-size: 11px;">
                                                        ${fn:substring(justif.fichierJustification, fn:indexOf(justif.fichierJustification, '/')+1, fn:length(justif.fichierJustification))}
                                                    </small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #6c757d; font-style: italic;">Aucun fichier</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${justif.estJustifie}">
                                                    <span class="badge badge-success" style="padding: 6px 12px; font-size: 13px; background-color: #28a745; color: white;">
                                                        ✅ Accepté
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-warning" style="padding: 6px 12px; font-size: 13px; background-color: #ffc107; color: #212529;">
                                                        ⏳ En attente
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${not justif.estJustifie and empty justif.fichierJustification}">
                                                <button type="button" class="btn btn-sm btn-outline-secondary" 
                                                        style="padding: 4px 10px; font-size: 12px;"
                                                        onclick="document.getElementById('file-${justif.idJustificationAbsence}').click()">
                                                    + Ajouter fichier
                                                </button>
                                                <input type="file" id="file-${justif.idJustificationAbsence}" 
                                                       style="display: none;" 
                                                       onchange="uploadFile(this, ${justif.idJustificationAbsence}, 'absence')" />
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 40px; color: #6c757d;">
                        <div style="font-size: 48px; margin-bottom: 20px;">📭</div>
                        <h4 style="margin-bottom: 15px;">Aucune justification d'absence</h4>
                        <p>Vous n'avez soumis aucune justification d'absence pour le moment.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Retards -->
        <div style="padding: 20px; border-top: 1px solid #dee2e6;">
            <h3 style="margin: 0 0 20px 0; color: #495057; font-size: 18px; padding-bottom: 10px; border-bottom: 2px solid #dc3545;">
                Retards (${fn:length(justifsRetard)})
            </h3>
            
            <c:choose>
                <c:when test="${not empty justifsRetard}">
                    <div class="table-responsive">
                        <table class="data-table" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th style="min-width: 120px;">Date retard</th>
                                    <th style="min-width: 100px;">Retard</th>
                                    <th>Justificatif</th>
                                    <th style="min-width: 120px;">Statut</th>
                                    <th style="min-width: 100px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="justif" items="${justifsRetard}">
                                    <tr>
                                        <td>
                                            <!-- Formatage manuel de LocalDate -->
                                            <c:out value="${justif.dateRetard.dayOfMonth}/${justif.dateRetard.monthValue}/${justif.dateRetard.year}" />
                                            <br/>
                                            <small style="color: #6c757d; font-size: 12px;">
                                                <c:choose>
                                                    <c:when test="${justif.dateRetard.dayOfWeek.value == 1}">Lundi</c:when>
                                                    <c:when test="${justif.dateRetard.dayOfWeek.value == 2}">Mardi</c:when>
                                                    <c:when test="${justif.dateRetard.dayOfWeek.value == 3}">Mercredi</c:when>
                                                    <c:when test="${justif.dateRetard.dayOfWeek.value == 4}">Jeudi</c:when>
                                                    <c:when test="${justif.dateRetard.dayOfWeek.value == 5}">Vendredi</c:when>
                                                    <c:when test="${justif.dateRetard.dayOfWeek.value == 6}">Samedi</c:when>
                                                    <c:when test="${justif.dateRetard.dayOfWeek.value == 7}">Dimanche</c:when>
                                                </c:choose>
                                            </small>
                                        </td>
                                        <td>
                                            <span style="font-weight: bold; color: #dc3545;">
                                                ${justif.minutesRetard} min
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty justif.fichierJustification}">
                                                    <c:set var="filePath" value="/static/${justif.fichierJustification}" />
                                                    <a href="${filePath}" target="_blank" 
                                                       class="btn btn-sm btn-primary" style="padding: 5px 12px; font-size: 13px;">
                                                        📄 Voir
                                                    </a>
                                                    <br/>
                                                    <small style="color: #6c757d; font-size: 11px;">
                                                        ${fn:substring(justif.fichierJustification, fn:indexOf(justif.fichierJustification, '/')+1, fn:length(justif.fichierJustification))}
                                                    </small>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: #6c757d; font-style: italic;">Aucun fichier</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${justif.estJustifie}">
                                                    <span class="badge badge-success" style="padding: 6px 12px; font-size: 13px; background-color: #28a745; color: white;">
                                                        ✅ Accepté
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-warning" style="padding: 6px 12px; font-size: 13px; background-color: #ffc107; color: #212529;">
                                                        ⏳ En attente
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${not justif.estJustifie and empty justif.fichierJustification}">
                                                <button type="button" class="btn btn-sm btn-outline-secondary" 
                                                        style="padding: 4px 10px; font-size: 12px;"
                                                        onclick="document.getElementById('file-retard-${justif.idJustificationRetard}').click()">
                                                    + Ajouter fichier
                                                </button>
                                                <input type="file" id="file-retard-${justif.idJustificationRetard}" 
                                                       style="display: none;" 
                                                       onchange="uploadFile(this, ${justif.idJustificationRetard}, 'retard')" />
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 40px; color: #6c757d;">
                        <div style="font-size: 48px; margin-bottom: 20px;">⏰</div>
                        <h4 style="margin-bottom: 15px;">Aucun retard justifié</h4>
                        <p>Vous n'avez soumis aucune justification de retard pour le moment.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div style="padding: 15px; border-top: 1px solid #dee2e6; text-align: center;">
            <a href="${pageContext.request.contextPath}/personnel/dashboard" 
               class="btn btn-primary" style="padding: 10px 24px; font-size: 16px;">
                ← Retour au dashboard
            </a>
        </div>
    </div>
</div>

<script>
function uploadFile(input, id, type) {
    if (input.files && input.files[0]) {
        const formData = new FormData();
        formData.append('file', input.files[0]);
        formData.append('id', id);
        formData.append('type', type);
        
        fetch('${pageContext.request.contextPath}/personnel/upload-justificatif', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Fichier ajouté avec succès !');
                location.reload();
            } else {
                alert('Erreur: ' + data.message);
            }
        })
        .catch(error => {
            alert('Erreur lors de l\'upload: ' + error);
        });
    }
}

// Auto-calcul du retard si date d'aujourd'hui
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0];
    const dateRetardInput = document.getElementById('dateRetard');
    
    if (dateRetardInput && dateRetardInput.value === today) {
        // Essayer de récupérer le retard automatique
        fetch('${pageContext.request.contextPath}/personnel/justifier-retard?action=calculate')
            .then(response => response.json())
            .then(data => {
                if (data.retardMinutes && data.retardMinutes > 0) {
                    document.getElementById('minutesRetard').value = data.retardMinutes;
                }
            });
    }
});
</script>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>