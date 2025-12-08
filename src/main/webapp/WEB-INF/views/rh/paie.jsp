<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Intégration Paie" />
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
            <h2 class="card-title">💰 Export des données de paie</h2>
            <div class="card-subtitle">
                Générer les fichiers pour l'intégration avec le système de paie
            </div>
        </div>
        
        <!-- Sélection de période -->
        <div style="background: #f8f9fa; padding: 25px; border-radius: 10px; margin-bottom: 30px;">
            <h3 style="margin-bottom: 20px; color: #495057;">📅 Sélection de la période</h3>
            
            <form id="paieForm" action="${pageContext.request.contextPath}/rh/charger-donnees-paie" method="post" 
                  style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
                <div class="form-group">
                    <label for="paieMois">Mois</label>
                    <select id="paieMois" name="mois" style="width: 100%; padding: 12px; border: 1px solid #dee2e6; border-radius: 4px;" required>
                        <option value="">Sélectionnez un mois</option>
                        <option value="1">Janvier</option>
                        <option value="2">Février</option>
                        <option value="3">Mars</option>
                        <option value="4">Avril</option>
                        <option value="5">Mai</option>
                        <option value="6">Juin</option>
                        <option value="7">Juillet</option>
                        <option value="8">Août</option>
                        <option value="9">Septembre</option>
                        <option value="10">Octobre</option>
                        <option value="11">Novembre</option>
                        <option value="12">Décembre</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="paieAnnee">Année</label>
                    <input type="number" id="paieAnnee" name="annee" 
                           min="2023" max="2030"
                           style="width: 100%; padding: 12px; border: 1px solid #dee2e6; border-radius: 4px;" required />
                </div>
                
                <div class="form-group">
                    <label>Inclure :</label>
                    <div style="display: flex; flex-direction: column; gap: 8px; margin-top: 5px;">
                        <label style="display: flex; align-items: center; gap: 8px;">
                            <input type="checkbox" name="includeHeures" checked />
                            <span>Heures supplémentaires</span>
                        </label>
                        <label style="display: flex; align-items: center; gap: 8px;">
                            <input type="checkbox" name="includeAbsences" checked />
                            <span>Absences non justifiées</span>
                        </label>
                        <label style="display: flex; align-items: center; gap: 8px;">
                            <input type="checkbox" name="includeRetards" />
                            <span>Retards non justifiés</span>
                        </label>
                    </div>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px 20px;">
                        🔍 Charger les données
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Données de paie -->
        <c:if test="${not empty donneesPaie}">
            <div id="paieData">
                <h3 style="margin-bottom: 20px; color: #495057;">📊 Aperçu des données - ${moisPaie}/${anneePaie}</h3>
                
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px;">
                    <div style="background: #e9ecef; padding: 20px; border-radius: 8px; text-align: center;">
                        <div style="font-size: 2em; color: #495057; margin-bottom: 10px;">👥</div>
                        <div style="font-size: 1.8em; font-weight: 600;">${donneesPaie.totalPersonnel}</div>
                        <div style="color: #6c757d; font-size: 0.9em;">Personnel inclus</div>
                    </div>
                    
                    <div style="background: #e9ecef; padding: 20px; border-radius: 8px; text-align: center;">
                        <div style="font-size: 2em; color: #495057; margin-bottom: 10px;">💰</div>
                        <div style="font-size: 1.8em; font-weight: 600;">
                            <fmt:formatNumber value="${donneesPaie.totalMontant}" type="currency" currencyCode="EUR" />
                        </div>
                        <div style="color: #6c757d; font-size: 0.9em;">Montant total</div>
                    </div>
                    
                    <div style="background: #e9ecef; padding: 20px; border-radius: 8px; text-align: center;">
                        <div style="font-size: 2em; color: #495057; margin-bottom: 10px;">⏰</div>
                        <div style="font-size: 1.8em; font-weight: 600;">${donneesPaie.totalHeuresSup}h</div>
                        <div style="color: #6c757d; font-size: 0.9em;">Heures supplémentaires</div>
                    </div>
                    
                    <div style="background: #e9ecef; padding: 20px; border-radius: 8px; text-align: center;">
                        <div style="font-size: 2em; color: #495057; margin-bottom: 10px;">⚠️</div>
                        <div style="font-size: 1.8em; font-weight: 600;">${donneesPaie.totalAbsences}</div>
                        <div style="color: #6c757d; font-size: 0.9em;">Absences non justifiées</div>
                    </div>
                </div>
                
                <!-- Options d'export -->
                <div style="border-top: 2px solid #e9ecef; padding-top: 30px;">
                    <h3 style="margin-bottom: 20px; color: #495057;">📤 Options d'export</h3>
                    
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                        <div style="border: 2px solid #dee2e6; border-radius: 10px; padding: 25px; text-align: center;">
                            <div style="font-size: 3em; margin-bottom: 15px;">📊</div>
                            <h4 style="margin-bottom: 10px;">Excel (Paie)</h4>
                            <p style="color: #6c757d; font-size: 0.9em; margin-bottom: 20px;">
                                Format optimisé pour l'import dans le système de paie
                            </p>
                            <form action="${pageContext.request.contextPath}/rh/exporter-paie-excel" method="post">
                                <input type="hidden" name="mois" value="${moisPaie}" />
                                <input type="hidden" name="annee" value="${anneePaie}" />
                                <button type="submit" class="btn btn-success" style="width: 100%; padding: 12px 20px;">
                                    📥 Exporter Excel
                                </button>
                            </form>
                        </div>
                        
                        <div style="border: 2px solid #dee2e6; border-radius: 10px; padding: 25px; text-align: center;">
                            <div style="font-size: 3em; margin-bottom: 15px;">📄</div>
                            <h4 style="margin-bottom: 10px;">PDF (Rapport)</h4>
                            <p style="color: #6c757d; font-size: 0.9em; margin-bottom: 20px;">
                                Rapport détaillé avec justificatifs et synthèse
                            </p>
                            <form action="${pageContext.request.contextPath}/rh/exporter-paie-pdf" method="post">
                                <input type="hidden" name="mois" value="${moisPaie}" />
                                <input type="hidden" name="annee" value="${anneePaie}" />
                                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px 20px;">
                                    📥 Exporter PDF
                                </button>
                            </form>
                        </div>
                        
                        <div style="border: 2px solid #dee2e6; border-radius: 10px; padding: 25px; text-align: center;">
                            <div style="font-size: 3em; margin-bottom: 15px;">🔗</div>
                            <h4 style="margin-bottom: 10px;">API JSON</h4>
                            <p style="color: #6c757d; font-size: 0.9em; margin-bottom: 20px;">
                                Données brutes pour intégration API avec le système de paie
                            </p>
                            <form action="${pageContext.request.contextPath}/rh/exporter-paie-json" method="post">
                                <input type="hidden" name="mois" value="${moisPaie}" />
                                <input type="hidden" name="annee" value="${anneePaie}" />
                                <button type="submit" class="btn btn-info" style="width: 100%; padding: 12px 20px;">
                                    🔗 Générer JSON
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
        
        <!-- Historique des exports -->
        <div style="margin-top: 40px; padding-top: 30px; border-top: 2px solid #e9ecef;">
            <h3 style="margin-bottom: 20px; color: #495057;">📁 Historique des exports</h3>
            
            <c:if test="${not empty historiqueExports}">
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Date export</th>
                                <th>Période</th>
                                <th>Format</th>
                                <th>Personnel</th>
                                <th>Montant total</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="export" items="${historiqueExports}">
                                <tr>
                                    <td>
                                        <fmt:parseDate value="${export.dateExport}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDateExport" type="both" />
                                        <fmt:formatDate value="${parsedDateExport}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>${export.periode}</td>
                                    <td>
                                        <span class="status ${export.format == 'excel' ? 'status-present' : export.format == 'pdf' ? 'status-pending' : 'status-absent'}">
                                            ${export.format}
                                        </span>
                                    </td>
                                    <td>${export.nombrePersonnel}</td>
                                    <td>
                                        <fmt:formatNumber value="${export.montantTotal}" type="currency" currencyCode="EUR" />
                                    </td>
                                    <td>
                                        <span class="status ${export.statut == 'INTEGRE' ? 'status-present' : 'status-pending'}">
                                            ${export.statut == 'INTEGRE' ? '✅ Intégré' : '⏳ En attente'}
                                        </span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/rh/regenerer-export" method="post" style="display: inline;">
                                            <input type="hidden" name="idExport" value="${export.id}" />
                                            <button type="submit" class="btn btn-primary" style="padding: 6px 12px; font-size: 0.85em;">
                                                🔄 Re-générer
                                            </button>
                                        </form>
                                        <c:if test="${not empty export.fichier}">
                                            <a href="${pageContext.request.contextPath}/rh/telecharger-export/${export.fichier}" 
                                               class="btn btn-success" style="padding: 6px 12px; font-size: 0.85em; margin-left: 5px;">
                                                📥 Télécharger
                                            </a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
            
            <c:if test="${empty historiqueExports}">
                <div style="text-align: center; padding: 40px; color: #6c757d;">
                    📁 Aucun export de paie dans l'historique
                </div>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jsp" %>