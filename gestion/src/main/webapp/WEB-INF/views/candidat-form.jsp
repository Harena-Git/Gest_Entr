<style>
    form {
        max-width: 500px;
        margin: 30px auto;
        padding: 20px;
        border: 1px solid #ccc;
        border-radius: 10px;
        background-color: #f9f9f9;
        font-family: Arial, sans-serif;
    }

    form input[type="text"],
    form input[type="email"],
    form input[type="number"],
    form input[type="file"],
    form textarea,
    form select {
        width: 100%;
        padding: 8px 10px;
        margin: 5px 0 15px 0;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }

    form label {
        font-weight: bold;
        margin-top: 10px;
        display: block;
    }

    form button {
        background-color: #4CAF50;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
    }

    form button:hover {
        background-color: #45a049;
    }

    form textarea {
        resize: vertical;
        min-height: 60px;
    }
</style>

<form action="${pageContext.request.contextPath}/candidat/save" method="post" enctype="multipart/form-data">
    <input type="hidden" name="idAnnonce" value="${idAnnonce}" />

    <label for="nom">Nom :</label>
    <input type="text" name="nom" id="nom"/>

    <label for="prenom">Prénom :</label>
    <input type="text" name="prenom" id="prenom"/>

    <label for="email">Email :</label>
    <input type="email" name="email" id="email"/>

    <label for="telephone">Téléphone :</label>
    <input type="text" name="telephone" id="telephone"/>

    <label for="adresse">Adresse :</label>
    <textarea name="adresse" id="adresse"></textarea>

    <label for="anneeExperience">Années d’expérience :</label>
    <input type="number" name="anneeExperience" id="anneeExperience"/>

    <label for="file">Photo :</label>
    <input type="file" name="file" id="file"/>

    <label for="idLieu">Lieu :</label>
    <select name="idLieu" id="idLieu">
        <c:forEach var="lieu" items="${lieux}">
            <option value="${lieu.idLieu}">${lieu.libelle}</option>
        </c:forEach>
    </select>

    <button type="submit">Enregistrer</button>
</form>