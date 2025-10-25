<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Liste des évaluations réussies</title>
    <style>
        table {
            border-collapse: collapse;
            width: 90%;
            margin: 20px auto;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px 12px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even){
            background-color: #f9f9f9;
        }
        input.filter {
            width: 100%;
            box-sizing: border-box;
            padding: 4px;
        }
    </style>
</head>
<body>
<h2 style="text-align:center;">Évaluations Entretien 2 réussies</h2>

<c:choose>
    <c:when test="${not empty eval2}">

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
                            <td>
                                <form action="/inputvalider" method="post">
                                    <input type="hidden" name="id_candidat" value="${e.entretien2.entretien1.candidat.id_candidat}" />
                                    <button type="submit">Valider</button>
                                </form>
                            </td>
                            <td>
                                <form action="/rejeter" method="post">
                                    <input type="hidden" name="id_candidat" value="${e.entretien2.entretien1.candidat.id_candidat}" />
                                    <button type="submit">Rejeter</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:forEach>
            </tbody>
        </table>
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
        <p style="text-align:center; color:red;">⚠️ Aucun résultat trouvé !</p>
    </c:otherwise>
</c:choose>

</body>
</html>
