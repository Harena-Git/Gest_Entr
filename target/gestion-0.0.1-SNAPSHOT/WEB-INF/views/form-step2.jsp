<form action="${pageContext.request.contextPath}/candidat/save" method="post">
    <input type="hidden" name="nbDiplomes" value="${nbDiplomes}"/>
    <input type="hidden" name="nbParcours" value="${nbParcours}"/>

    <c:if test="${not empty nbDiplomes}">
        <h3>Diplômes (${nbDiplomes})</h3>
        <c:forEach var="i" begin="0" end="${nbDiplomes-1}">
            <label>Établissement :</label>
            <input type="text" name="diplomes[${i}].etablissement"/>

            <label>Année d'obtention :</label>
            <input type="number" name="diplomes[${i}].annee_obtention"/>

            <label>Filière :</label>
            <select name="diplomes[${i}].idFiliere">
                <c:forEach var="f" items="${filieres}">
                    <option value="${f.idFiliere}">${f.libelle}</option>
                </c:forEach>
            </select>

            <label>Niveau :</label>
            <select name="diplomes[${i}].idNiveau">
                <c:forEach var="n" items="${niveaux}">
                    <option value="${n.idNiveau}">${n.libelle}</option>
                </c:forEach>
            </select>

            <hr>
        </c:forEach>
    </c:if>

    <c:if test="${not empty nbParcours}">
        <h3>Parcours (${nbParcours})</h3>
        <c:forEach var="j" begin="0" end="${nbParcours-1}">
            <label>Entreprise :</label>
            <input type="text" name="parcours[${j}].entreprise"/>

            <label>Poste :</label>
            <input type="text" name="parcours[${j}].poste"/>

            <label>Date début :</label>
            <input type="date" name="parcours[${j}].dateDebut"/>

            <label>Date fin :</label>
            <input type="date" name="parcours[${j}].dateFin"/>

            <hr>
        </c:forEach>
    </c:if>

    <button type="submit">Enregistrer</button>
</form>
