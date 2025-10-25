<form action="${pageContext.request.contextPath}/candidat/save" method="post" enctype="multipart/form-data">
    <input type="hidden" name="idAnnonce" value="${idAnnonce}" />

    Nom : <input type="text" name="nom" /><br/>
    Prénom : <input type="text" name="prenom" /><br/>
    Email : <input type="email" name="email" /><br/>
    Téléphone : <input type="text" name="telephone" /><br/>
    Adresse : <textarea name="adresse"></textarea><br/>
    Années d’expérience : <input type="number" name="anneeExperience" /><br/>
    Photo : <input type="file" name="file" /><br/>

    Lieu :
    <select name="idLieu">
        <c:forEach var="lieu" items="${lieux}">
            <option value="${lieu.idLieu}">${lieu.libelle}</option>
        </c:forEach>
    </select><br/>

   

    <button type="submit">Enregistrer</button>
</form>
