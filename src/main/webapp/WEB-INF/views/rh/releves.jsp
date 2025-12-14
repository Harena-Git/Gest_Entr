<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="Génération de relevés RH" />
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
        </div>
        
        <!-- Relevé Personnel -->
        <div style="margin-bottom: 40px;">
            <h3 style="margin-bottom: 15px; color: #495057;">👤 Relevé personnel</h3>
            
            <form action="${pageContext.request.contextPath}/rh/generer-releve-personnel" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px; margin-bottom: 15px;">
                    <div class="form-group">
                        <label>ID Personnel</label>
                        <input type="number" name="idPersonnel" required 
                               style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;" 
                               placeholder="ID du personnel" />
                    </div>
                    
                    <div class="form-group">
                        <label>Date début</label>
                        <input type="date" name="dateDebut" required 
                               style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;" />
                    </div>
                    
                    <div class="form-group">
                        <label>Date fin</label>
                        <input type="date" name="dateFin" required 
                               style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;" />
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                    <label style="flex: 1; text-align: center;">
                        <input type="radio" name="format" value="pdf" checked />
                        <div style="padding: 12px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer;">
                            <div style="font-size: 1.5em;">📄</div>
                            <div>PDF</div>
                        </div>
                    </label>
                    <label style="flex: 1; text-align: center;">
                        <input type="radio" name="format" value="excel" />
                        <div style="padding: 12px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer;">
                            <div style="font-size: 1.5em;">📊</div>
                            <div>Excel</div>
                        </div>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px 24px;">
                    🚀 Générer relevé personnel
                </button>
            </form>
        </div>
        
        <!-- Relevé Département -->
        <div style="margin-bottom: 40px;">
            <h3 style="margin-bottom: 15px; color: #495057;">🏢 Relevé département</h3>
            
            <form action="${pageContext.request.contextPath}/rh/generer-releve-departement" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px; margin-bottom: 15px;">
                    <div class="form-group">
                        <label>Département</label>
                        <select name="idDepartement" required style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;">
                            <option value="">Sélectionnez un département</option>
                            <c:forEach var="dept" items="${departements}">
                                <option value="${dept.id_departement}">${dept.departement}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Date début</label>
                        <input type="date" name="dateDebut" required 
                               style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;" />
                    </div>
                    
                    <div class="form-group">
                        <label>Date fin</label>
                        <input type="date" name="dateFin" required 
                               style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;" />
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                    <label style="flex: 1; text-align: center;">
                        <input type="radio" name="format" value="pdf" checked />
                        <div style="padding: 12px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer;">
                            <div style="font-size: 1.5em;">📄</div>
                            <div>PDF</div>
                        </div>
                    </label>
                    <label style="flex: 1; text-align: center;">
                        <input type="radio" name="format" value="excel" />
                        <div style="padding: 12px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer;">
                            <div style="font-size: 1.5em;">📊</div>
                            <div>Excel</div>
                        </div>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-success" style="width: 100%; padding: 12px 24px;">
                    📊 Générer relevé département
                </button>
            </form>
        </div>
        
        <!-- Relevé Global -->
        <div style="margin-bottom: 40px;">
            <h3 style="margin-bottom: 15px; color: #495057;">🌍 Relevé global</h3>
            
            <form action="${pageContext.request.contextPath}/rh/generer-releve-global" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 15px;">
                    <div class="form-group">
                        <label>Date début</label>
                        <input type="date" name="dateDebut" required 
                               style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;" />
                    </div>
                    
                    <div class="form-group">
                        <label>Date fin</label>
                        <input type="date" name="dateFin" required 
                               style="width: 100%; padding: 10px; border: 1px solid #dee2e6; border-radius: 4px;" />
                    </div>
                </div>
                
                <div style="display: flex; gap: 10px; margin-bottom: 15px;">
                    <label style="flex: 1; text-align: center;">
                        <input type="radio" name="format" value="pdf" checked />
                        <div style="padding: 12px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer;">
                            <div style="font-size: 1.5em;">📄</div>
                            <div>PDF</div>
                        </div>
                    </label>
                    <label style="flex: 1; text-align: center;">
                        <input type="radio" name="format" value="excel" />
                        <div style="padding: 12px; border: 2px solid #dee2e6; border-radius: 8px; margin-top: 5px; cursor: pointer;">
                            <div style="font-size: 1.5em;">📊</div>
                            <div>Excel</div>
                        </div>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-info" style="width: 100%; padding: 12px 24px;">
                    🌐 Générer relevé global
                </button>
            </form>
        </div>
    </div>
</div>