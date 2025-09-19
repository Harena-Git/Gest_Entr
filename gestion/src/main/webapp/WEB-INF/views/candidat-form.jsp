<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    form {
        max-width: 600px;
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
        margin: 5px;
    }

    form button:hover {
        background-color: #45a049;
    }

    .step { display: none; }
    .step.active { display: block; }
</style>

<!-- Templates cachés -->
<div id="template-niveau" style="display:none;">
    <c:forEach var="n" items="${niveaux}">
        <option value="${n.idNiveau}">${n.libelle}</option>
    </c:forEach>
</div>

<div id="template-filiere" style="display:none;">
    <c:forEach var="f" items="${filieres}">
        <label>
            <input type="checkbox" value="${f.idFiliere}"/> ${f.libelle}
        </label><br/>
    </c:forEach>
</div>

<form action="${pageContext.request.contextPath}/candidat/save" method="post" enctype="multipart/form-data">
    <input type="hidden" name="idAnnonce" value="${idAnnonce}" />

    <!-- Step 1 : Infos personnelles -->
    <div class="step active" id="step1">
        <h3>Informations personnelles</h3>

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

        <c:if test="${not empty posteNom}">
            <label for="anneeExperience">Années d'expérience en tant que ${posteNom} :</label>
            <input type="number" name="anneeExperience" id="anneeExperience"/>
        </c:if>

        <label for="file">Photo :</label>
        <input type="file" name="file" id="file"/>

        <label for="idLieu">Lieu :</label>
        <select name="idLieu" id="idLieu">
            <c:forEach var="lieu" items="${lieux}">
                <option value="${lieu.id_lieu}">${lieu.lieu}</option>
            </c:forEach>
        </select>

        <button type="button" onclick="nextStep(1)">Suivant</button>
    </div>

    <!-- Step 2 : Diplômes -->
    <div class="step" id="step2">
        <h3>Diplômes</h3>
        <div id="diplomes">
            <div class="diplome">
                <label>Établissement :</label>
                <input type="text" name="diplomes[0].etablissement"/>

                <label>Année d'obtention :</label>
                <input type="number" name="diplomes[0].annee_obtention"/>
                
                <label for="filiere">Filière :</label>
                    <select id="filiere" name="diplomes[0].idFiliere" onchange="afficherNiveau(this)">
                        <option value="">-- Choisir une filière --</option>
                        <c:forEach var="f" items="${filieres}">
                            <option value="${f.idFiliere}">${f.libelle}</option>
                        </c:forEach>
                    </select>

                    <!-- Niveau (caché par défaut) -->
                    <div id="niveau-container" style="display:none; margin-top:10px;">
                        <label for="niveau">Niveau :</label>
                        <select id="niveau" name="diplomes[0].idNiveau">
                            <c:forEach var="n" items="${niveaux}">
                                <option value="${n.idNiveau}">${n.libelle}</option>
                            </c:forEach>
                        </select>
                    </div>

                
            </div>
        </div>
        <button type="button" onclick="ajouterDiplome()">+ Ajouter un diplôme</button><br/>
        <button type="button" onclick="prevStep(2)">Précédent</button>
        <button type="button" onclick="nextStep(2)">Suivant</button>
    </div>

    <!-- Step 3 : Parcours professionnel -->
    <div class="step" id="step3">
        <h3>Parcours professionnel</h3>
        <div id="parcours">
            <div class="parc">
                <label>Entreprise :</label>
                <input type="text" name="parcours[0].entreprise"/>

                <label>Poste :</label>
                <input type="text" name="parcours[0].poste"/>

                <label>Date début :</label>
                <input type="date" name="parcours[0].dateDebut"/>

                <label>Date fin :</label>
                <input type="date" name="parcours[0].dateFin"/>
            </div>
        </div>
        <button type="button" onclick="ajouterParcours()">+ Ajouter un parcours</button><br/>
        <button type="button" onclick="prevStep(3)">Précédent</button>
        <button type="submit">Enregistrer</button>
    </div>
</form>

<script>
let currentStep = 1;

function nextStep(step) {
    document.getElementById("step" + step).classList.remove("active");
    document.getElementById("step" + (step + 1)).classList.add("active");
    currentStep = step + 1;
}

function prevStep(step) {
    document.getElementById("step" + step).classList.remove("active");
    document.getElementById("step" + (step - 1)).classList.add("active");
    currentStep = step - 1;
}

let indexDiplome = 1;
function ajouterDiplome() {
    let container = document.getElementById("diplomes");
    let div = document.createElement("div");
    div.className = "diplome";

    let niveauOptions = document.querySelector("#template-niveau").innerHTML;
    let filiereChecks = document.querySelector("#template-filiere").innerHTML;

    // Mettre à jour les name dynamiquement pour ce diplôme
    filiereChecks = filiereChecks.replace(/value="/g, `name="diplomes[${indexDiplome}].idFilieres" value="`);

    div.innerHTML = `
        <label>Établissement :</label>
        <input type="text" name="diplomes[${indexDiplome}].etablissement"/>

        <label>Année d'obtention :</label>
        <input type="number" name="diplomes[${indexDiplome}].annee_obtention"/>

        <label>Filières :</label>
                <div class="filieres">
                    <c:forEach var="f" items="${filieres}">
                        <label>
                            <input type="checkbox" name="diplomes[${indexDiplome}].idFilieres" value="${f.idFiliere}"/> ${f.libelle}
                        </label><br/>
                    </c:forEach>
                </div>
        <label>Niveau :</label>
                <select name="diplomes[${indexDiplome}].idNiveau">
                    <c:forEach var="n" items="${niveaux}">
                        <option value="${n.idNiveau}">${n.libelle}</option>
                    </c:forEach>
                </select>
    `;
    container.appendChild(div);
    indexDiplome++;
}


let indexParcours = 1;
function ajouterParcours() {
    let container = document.getElementById("parcours");
    let div = document.createElement("div");
    div.className = "parc";
    div.innerHTML = `
        <label>Entreprise :</label>
        <input type="text" name="parcours[${indexParcours}].entreprise"/>

        <label>Poste :</label>
        <input type="text" name="parcours[${indexParcours}].poste"/>

        <label>Date début :</label>
        <input type="date" name="parcours[${indexParcours}].dateDebut"/>

        <label>Date fin :</label>
        <input type="date" name="parcours[${indexParcours}].dateFin"/>
    `;
    container.appendChild(div);
    indexParcours++;
}
</script>
