<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Liste des évaluations réussies</title>
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --border-color: #dee2e6;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: var(--shadow);
            padding: 20px;
        }
        
        h2 {
            text-align: center;
            color: var(--dark-color);
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--border-color);
            font-weight: 600;
        }
        
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
            font-size: 14px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            border-radius: 8px;
            overflow: hidden;
        }
        
        thead {
            background-color: var(--primary-color);
            color: white;
        }
        
        th, td {
            padding: 12px 15px;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
        }
        
        th {
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 13px;
        }
        
        tbody tr {
            transition: all 0.3s ease;
        }
        
        tbody tr:nth-child(even) {
            background-color: rgba(0, 0, 0, 0.02);
        }
        
        tbody tr:hover {
            background-color: rgba(52, 152, 219, 0.08);
            transform: translateY(-1px);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        input.filter {
            width: 100%;
            box-sizing: border-box;
            padding: 8px 10px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        input.filter:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
        }
        
        button {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            font-size: 13px;
        }
        
        button[type="submit"] {
            background-color: var(--success-color);
            color: white;
        }
        
        button[type="submit"]:hover {
            background-color: #27ae60;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        
        .reject-btn {
            background-color: var(--danger-color);
            color: white;
        }
        
        .reject-btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        
        .alert {
            padding: 12px 20px;
            border-radius: 4px;
            margin: 20px 0;
            font-weight: 500;
        }
        
        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .no-results {
            text-align: center;
            color: var(--danger-color);
            font-weight: 500;
            padding: 30px;
            background-color: white;
            border-radius: 8px;
            box-shadow: var(--shadow);
            margin: 20px 0;
        }
        
        .table-container {
            overflow-x: auto;
            border-radius: 8px;
        }
        
        .action-cell {
            white-space: nowrap;
        }
        
        @media (max-width: 1200px) {
            .container {
                padding: 15px;
            }
            
            table {
                font-size: 13px;
            }
            
            th, td {
                padding: 10px 8px;
            }
        }
        
        @media (max-width: 768px) {
            body {
                padding: 10px;
            }
            
            .container {
                padding: 10px;
            }
            
            h2 {
                font-size: 1.3rem;
            }
            
            .table-container {
                font-size: 12px;
            }
            
            th, td {
                padding: 8px 5px;
            }
            
            button {
                padding: 6px 10px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Évaluations Entretien 2 réussies</h2>

    <c:choose>
        <c:when test="${not empty eval2}">
            <div class="table-container">
                <table id="evalTable">
                    <thead>
                        <tr>
                            <th><input class="filter" placeholder="Nom"></th>
                            <th><input class="filter" placeholder="Prénom"></th>
                            <th><input class="filter" placeholder="Téléphone"></th>
                            <th><input class="filter" placeholder="Email"></th>
                            <th><input class="filter" placeholder="Adresse"></th>
                            <th><input class="filter" placeholder="Année exp."></th>
                            <th><input class="filter" placeholder="Résultat Entretien 1"></th>
                            <th><input class="filter" placeholder="Note Entretien 1"></th>
                            <th><input class="filter" placeholder="Résultat Entretien 2"></th>
                            <th><input class="filter" placeholder="Note Entretien 2"></th>
                            <th>Action</th>
                            <th>Action</th>
                        </tr>
                        <tr>
                            <th>Nom</th>
                            <th>Prénom</th>
                            <th>Téléphone</th>
                            <th>Email</th>
                            <th>Adresse</th>
                            <th>Année exp.</th>
                            <th>Résultat Entretien 1</th>
                            <th>Note Entretien 1 ( / 5)</th>
                            <th>Résultat Entretien 2</th>
                            <th>Note Entretien 2 ( / 5)</th>
                            <th>Valider</th>
                            <th>Rejeter</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="e" items="${eval2}">
                            <c:forEach var="ev1" items="${eval1}">
                                <tr>
                                    <td>${e.entretien2.entretien1.candidat.nom}</td>
                                    <td>${e.entretien2.entretien1.candidat.prenom}</td>
                                    <td>${e.entretien2.entretien1.candidat.telephone}</td>
                                    <td>${e.entretien2.entretien1.candidat.email}</td>
                                    <td>${e.entretien2.entretien1.candidat.adresse}</td>
                                    <td>${e.entretien2.entretien1.candidat.annee_experience} ans</td>
                                    <td>${ev1.appreciation.libelle}</td>
                                    <td>${ev1.appreciation.note}</td>
                                    <td>${e.appreciation.libelle}</td>
                                    <td>${e.appreciation.note}</td>
                                    <td class="action-cell">
                                        <form action="/inputvalider" method="post">
                                            <input type="hidden" name="id_candidat" value="${e.entretien2.entretien1.candidat.id_candidat}" />
                                            <button type="submit">Valider</button>
                                        </form>
                                    </td>
                                    <td class="action-cell">
                                        <form action="/rejeter" method="post">
                                            <input type="hidden" name="id_candidat" value="${e.entretien2.entretien1.candidat.id_candidat}" />
                                            <button type="submit" class="reject-btn">Rejeter</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <c:if test="${not empty message}">
                <div class="alert alert-info">
                    ${message}
                </div>
            </c:if>

            <script>
                // Filtrage simple pour chaque colonne
                const table = document.getElementById('evalTable');
                const filters = document.querySelectorAll('input.filter');
                const tbody = table.tBodies[0];

                filters.forEach((input, index) => {
                    input.addEventListener('keyup', function() {
                        const filterValue = input.value.toLowerCase();

                        for (let row of tbody.rows) {
                            const cellValue = row.cells[index].textContent.toLowerCase();
                            if (cellValue.includes(filterValue)) {
                                row.style.display = '';
                            } else {
                                row.style.display = 'none';
                            }
                        }
                    });
                });
            </script>

        </c:when>
        <c:otherwise>
            <div class="no-results">
                ⚠️ Aucun résultat trouvé !
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>