<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Génération de relevés" />
<%@ include file="/WEB-INF/views/layout/header.jsp" %>

<div class="main-container">
    <c:if test="${not empty success}">
        <div class="alert alert-success">✅ ${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>
    
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">📊 Génération de relevés RH</h2>
            <div class="card-subtitle">
                Générer des rapports globaux ou par département
            </div>
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
            <!-- Relevé global -->
            <div style="border-right: 1px solid #e9ecef; padding-right: 30px;">
                <h3 style="margin-bottom: 20px; color: #495057;">🌍 Relevé global</h3>
                <p style="color: #6c757d; margin-bottom: 25px;">
                    Rapport complet de toutes les présences, absences et heures supplémentaires de l'entreprise.
                </p>
                
                <form action="${pageContext.request.contextPath}/rh/generer-releve-global" method="post">
                    <div class="form-group">
                        <label for="globalDateDebut">Période</label>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                            <input type="date" id="globalDateDebut" name="dateDebut" 
                                   required style="padding: 12px; border: 1px solid #dee2e6; border-radius: 4px;" />
                            <input type="date" id="globalDateFin" name="dateFin" 
                                   required style="padding: 12px; border: 1px solid #dee2e6; border-radius: 4px;" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Format</label>
                        <div style="display: flex; gap: 10px; margin-top: 5px;">
                            <label style="flex: 1; text-align: center;">
                                <input type="radio" name="format" value="pdf" checked />
                                <div style="padding: 15px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer; transition: all 0.3s;">
                                    <div style="font-size: 2em;">📄</div>
                                    <div>PDF</div>
                                </div>
                            </label>
                            <label style="flex: 1; text-align: center;">
                                <input type="radio" name="format" value="excel" />
                                <div style="padding: 15px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer; transition: all 0.3s;">
                                    <div style="font-size: 2em;">📊</div>
                                    <div>Excel</div>
                                </div>
                            </label>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Options</label>
                        <div style="display: flex; flex-direction: column; gap: 8px; margin-top: 5px;">
                            <label style="display: flex; align-items: center; gap: 8px;">
                                <input type="checkbox" name="includeAbsences" checked />
                                <span>Inclure les absences</span>
                            </label>
                            <label style="display: flex; align-items: center; gap: 8px;">
                                <input type="checkbox" name="includeRetards" checked />
                                <span>Inclure les retards</span>
                            </label>
                            <label style="display: flex; align-items: center; gap: 8px;">
                                <input type="checkbox" name="includeHeuresSup" checked />
                                <span>Inclure les heures supplémentaires</span>
                            </label>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 14px 24px; margin-top: 20px;">
                        🚀 Générer le relevé global
                    </button>
                </form>
            </div>
            
            <!-- Relevé par département -->
            <div>
                <h3 style="margin-bottom: 20px; color: #495057;">🏢 Relevé par département</h3>
                <p style="color: #6c757d; margin-bottom: 25px;">
                    Rapport détaillé pour un département spécifique avec statistiques personnelles.
                </p>
                
                <form action="${pageContext.request.contextPath}/rh/generer-releve-departement" method="post">
                    <div class="form-group">
                        <label for="deptSelect">Département</label>
                        <select id="deptSelect" name="departement" required style="width: 100%; padding: 12px; border: 1px solid #dee2e6; border-radius: 4px;">
                            <option value="">Sélectionnez un département</option>
                            <c:forEach var="dept" items="${departements}">
                                <option value="${dept.id_departement}">${dept.departement}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="deptDateDebut">Période</label>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                            <input type="date" id="deptDateDebut" name="dateDebut" 
                                   required style="padding: 12px; border: 1px solid #dee2e6; border-radius: 4px;" />
                            <input type="date" id="deptDateFin" name="dateFin" 
                                   required style="padding: 12px; border: 1px solid #dee2e6; border-radius: 4px;" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Format</label>
                        <div style="display: flex; gap: 10px; margin-top: 5px;">
                            <label style="flex: 1; text-align: center;">
                                <input type="radio" name="format" value="pdf" checked />
                                <div style="padding: 15px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer; transition: all 0.3s;">
                                    <div style="font-size: 2em;">📄</div>
                                    <div>PDF</div>
                                </div>
                            </label>
                            <label style="flex: 1; text-align: center;">
                                <input type="radio" name="format" value="excel" />
                                <div style="padding: 15px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer; transition: all 0.3s;">
                                    <div style="font-size: 2em;">📊</div>
                                    <div>Excel</div>
                                </div>
                            </label>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-success" style="width: 100%; padding: 14px 24px; margin-top: 20px;">
                        📊 Générer rapport département
                    </button>
                </form>
            </div>
        </div>
        
        <!-- Historique des relevés générés -->
        <div style="margin-top: 40px; padding-top: 30px; border-top: 2px solid #e9ecef;">
            <h3 style="margin-bottom: 20px; color: #495057;">📁 Historique des relevés générés</h3>
            
            <c:if test="${not empty relevesGeneres}">
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Nom du fichier</th>
                                <th>Type</th>
                                <th>Période</th>
                                <th>Date génération</th>
                                <th>Taille</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="releve" items="${relevesGeneres}">
                                <tr>
                                    <td>${releve.nomFichier}</td>
                                    <td>
                                        <span class="status ${releve.format == 'pdf' ? 'status-present' : 'status-pending'}">
                                            ${releve.format}
                                        </span>
                                    </td>
                                    <td>${releve.periode}</td>
                                    <td>${releve.dateGeneration}</td>
                                    <td>${releve.taille}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/rh/telecharger-releve/${releve.nomFichier}" 
                                           class="btn btn-primary" style="padding: 6px 12px; font-size: 0.85em;">
                                            📥 Télécharger
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
            
            <c:if test="${empty relevesGeneres}">
                <div style="text-align: center; padding: 40px; color: #6c757d;">
                    📊 Aucun relevé généré récemment
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
// Script pour la prévisualisation des relevés
function previewReleve(type) {
    const dateDebut = document.getElementById(type + 'DateDebut').value;
    const dateFin = document.getElementById(type + 'DateFin').value;
    const format = document.querySelector('input[name="format"]:checked').value;
    
    if (!dateDebut || !dateFin) {
        alert('Veuillez sélectionner une période');
        return;
    }
    
    fetch('${pageContext.request.contextPath}/rh/preview-releve', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `type=${type}&dateDebut=${dateDebut}&dateFin=${dateFin}&format=${format}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert(`Prévisualisation du relevé:\n\nPériode: ${data.periode}\nFormat: ${data.format}\nNombre de lignes estimées: ${data.nbLignes}\nTaille estimée: ${data.tailleEstimee}`);
        } else {
            alert('Erreur: ' + data.message);
        }
    })
    .catch(error => {
        alert('Erreur lors de la prévisualisation');
    });
}
</script>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>