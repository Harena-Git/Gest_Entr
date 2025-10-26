<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Contrat d'Essai</title>
</head>
<body>
    <form action="/valider" method="post">
        <input type="hidden" name="id_candidat" value="${param.id_candidat}" />
        <label for="date_debut">Date de début :</label>
        <input type="date" id="date_debut" name="date_debut" required />
        <label for="date_fin">Date de fin :</label>
        <input type="date" id="date_fin" name="date_fin" required />
        <button type="submit">Valider</button>
    </form>


</body>
</html>