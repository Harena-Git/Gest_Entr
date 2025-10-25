<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test QCM - ${qcm.titre}</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
            background: white;
            min-height: 100vh;
            box-shadow: 0 0 30px rgba(0,0,0,0.1);
        }
        
        .timer-container {
            position: sticky;
            top: 0;
            background: #2c3e50;
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            z-index: 1000;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .timer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1.2em;
        }
        
        .time-display {
            font-size: 2em;
            font-weight: bold;
            font-family: 'Courier New', monospace;
        }
        
        .time-warning {
            color: #ffeb3b;
            animation: pulse 1s infinite;
        }
        
        .time-critical {
            color: #f44336;
            animation: blink 0.5s infinite;
        }
        
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.7; }
            100% { opacity: 1; }
        }
        
        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }
        
        .test-header {
            background: linear-gradient(135deg, #2196F3, #21CBF3);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .test-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 5px solid #2196F3;
            margin-bottom: 30px;
        }
        
        .entretien-info {
            background: #e8f5e8;
            border: 2px solid #4CAF50;
            border-radius: 10px;
            padding: 20px;
            margin: 25px 0;
        }
        
        .entretien-info h3 {
            color: #2e7d32;
            margin-top: 0;
        }
        
        .question-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            background: #ff9800;
            color: white;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 1.3em;
        }
        
        .question {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .question:hover {
            border-color: #2196F3;
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.2);
        }
        
        .question-number {
            background: #2196F3;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 15px;
            float: left;
        }
        
        .question-text {
            font-weight: bold;
            font-size: 1.1em;
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .choices {
            margin-left: 55px;
        }
        
        .choice {
            margin: 12px 0;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .choice:hover {
            border-color: #2196F3;
            background: #f3f9ff;
        }
        
        .choice input[type="radio"] {
            margin-right: 10px;
            transform: scale(1.2);
        }
        
        .choice.selected {
            border-color: #2196F3;
            background: #e3f2fd;
        }
        
        .submit-section {
            text-align: center;
            margin: 40px 0;
            padding: 30px;
            background: #f8f9fa;
            border-radius: 15px;
        }
        
        .submit-btn {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            padding: 15px 40px;
            border: none;
            border-radius: 50px;
            font-size: 1.2em;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }
        
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
        }
        
        .progress-bar {
            background: #e0e0e0;
            border-radius: 10px;
            height: 8px;
            margin: 10px 0;
            overflow: hidden;
        }
        
        .progress {
            background: linear-gradient(90deg, #4CAF50, #8BC34A);
            height: 100%;
            transition: width 0.3s ease;
        }
        
        .instructions {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Timer et informations importantes -->
        <div class="timer-container">
            <div class="timer">
                <div>
                    <strong>⏱️ TEMPS RESTANT</strong>
                    <div id="time-remaining" class="time-display">${qcm.dureeMinutes}:00</div>
                </div>
                <div>
                    <strong>🧪 TEST EN COURS</strong><br>
                    <span>Candidat ID: ${candidatId}</span>
                </div>
            </div>
            <div class="progress-bar">
                <div id="time-progress" class="progress" style="width: 100%"></div>
            </div>
        </div>

        <!-- En-tête du test -->
        <div class="test-header">
            <h1>${qcm.titre}</h1>
            <p>${qcm.description}</p>
            <div style="margin-top: 15px;">
                <strong>Durée:</strong> ${qcm.dureeMinutes} minutes | 
                <strong>Mode:</strong> Test de sélection
            </div>
        </div>

        <!-- Instructions importantes -->
        <div class="instructions">
            <h3>📋 Instructions importantes</h3>
            <ul>
                <li>Le test se soumettra automatiquement lorsque le temps sera écoulé</li>
                <li>Vous ne pouvez pas revenir en arrière après avoir répondu</li>
                <li>Toutes les questions sont obligatoires</li>
                <li>Le score minimum requis est de 50%</li>
            </ul>
        </div>

        <!-- Informations sur l'entretien (si réussi) -->
        <div class="entretien-info">
            <h3>🎯 PROCÉDURE APRÈS RÉUSSITE</h3>
            <p><strong>Si vous obtenez 50% ou plus :</strong></p>
            <ul>
                <li>✅ Un entretien sera automatiquement planifié dans nos locaux</li>
                <li>📅 Date proposée : <strong>5 jours ouvrables</strong> après votre réussite</li>
                <li>⏰ Créneaux disponibles : <strong>Lundi au Vendredi, 8h-12h et 14h-17h</strong></li>
                <li>👥 Entretien avec un responsable des Ressources Humaines</li>
                <li>🆔 Présentation obligatoire d'une pièce d'identité 15 minutes avant</li>
            </ul>
            <p style="margin-top: 15px; font-style: italic;">
                <strong>Note :</strong> Le système attribue automatiquement les créneaux en fonction des disponibilités
            </p>
        </div>

        <form id="qcm-form" action="/qcm/${qcm.idQcm}/submit" method="post">
            <input type="hidden" name="candidatId" value="${candidatId}">

            <!-- Questions Générales -->
            <c:if test="${not empty questionsGenerales}">
                <div class="question-section">
                    <div class="section-title">
                        📊 QUESTIONS GÉNÉRALES (${questionsGenerales.size()} questions)
                    </div>
                    <c:forEach var="question" items="${questionsGenerales}">
                        <div class="question">
                            <div class="question-number">${question.ordre}</div>
                            <div class="question-text">${question.libelle}</div>
                            <div class="choices">
                                <c:forEach var="choix" items="${choixParQuestionGenerale[question.idQuestionGenerale]}">
                                    <div class="choice" onclick="selectChoice(this)">
                                        <input type="radio" name="reponse_${question.idQuestionGenerale}" 
                                               value="${choix.id_choix}" id="choix_${choix.id_choix}">
                                        <label for="choix_${choix.id_choix}">${choix.libelle}</label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Questions Spécifiques -->
            <!-- <c:if test="${not empty questions}"> -->
                <!-- <p>fefewgergerge</p>
                <div class="question-section">
                    <div class="section-title">
                        🎯 QUESTIONS SPÉCIFIQUES (${questions.size()} questions)
                    </div>
                    <c:forEach var="question" items="${questions}">
                        <div class="question">
                            <div class="question-number">${question.ordre}</div>
                            <div class="question-text">${question.libelle}</div>
                            <div class="choices">
                                <c:forEach var="choix" items="${choixParQuestion[question.idQuestion]}">
                                    <div class="choice" onclick="selectChoice(this)">
                                        <input type="radio" name="reponse_${question.idQuestion}" 
                                               value="${choix.id_choix}" id="choix_${choix.id_choix}">
                                        <label for="choix_${choix.id_choix}">${choix.libelle}</label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div> -->
            <!-- </c:if> -->
             <div class="question-section">
    <div class="section-title">
        🎯 QUESTIONS SPÉCIFIQUES (${not empty questions ? questions.size() : 0} questions)
    </div>
    <c:if test="${not empty questions}">
        <c:forEach var="question" items="${questions}">
            <div class="question">
                <div class="question-number">${question.ordre}</div>
                <div class="question-text">${question.libelle}</div>
                <div class="choices">
                    <c:forEach var="choix" items="${choixParQuestion[question.idQuestion]}">
                        <div class="choice" onclick="selectChoice(this)">
                            <input type="radio" name="reponse_${question.idQuestion}" 
                                    value="${choix.id_choix}" id="choix_${choix.id_choix}">
                            <label for="choix_${choix.id_choix}">${choix.libelle}</label>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
    </c:if>
</div>


            <!-- Section de soumission -->
            <div class="submit-section">
                <h3>Vous avez terminé ?</h3>
                <p>Vérifiez vos réponses avant de soumettre. Vous ne pourrez plus modifier vos réponses après validation.</p>
                <button type="button" onclick="submitForm()" class="submit-btn">
                    ✅ VALIDER ET SOUMETTRE LE TEST
                </button>
            </div>
        </form>
    </div>

    <script>
        // Configuration du timer
        let totalTime = ${qcm.dureeMinutes} * 60;
        let remainingTime = totalTime;
        let timerInterval;
        const warningThreshold = 300; // 5 minutes
        const criticalThreshold = 60; // 1 minute

        function startTimer() {
            timerInterval = setInterval(() => {
                remainingTime--;
                if (remainingTime <= 0) {
                    clearInterval(timerInterval);
                    showTimeUpAlert();
                    setTimeout(() => {
                        document.getElementById('qcm-form').submit();
                    }, 3000);
                }
                updateTimerDisplay();
                updateProgressBar();
            }, 1000);
        }

        function updateTimerDisplay() {
            const minutes = Math.floor(remainingTime / 60);
            const seconds = remainingTime % 60;
            const timeDisplay = document.getElementById('time-remaining');
            
            timeDisplay.textContent = 
                `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            
            // Changer les couleurs selon le temps restant
            timeDisplay.className = 'time-display';
            if (remainingTime <= criticalThreshold) {
                timeDisplay.classList.add('time-critical');
            } else if (remainingTime <= warningThreshold) {
                timeDisplay.classList.add('time-warning');
            }
        }

        function updateProgressBar() {
            const progress = (remainingTime / totalTime) * 100;
            document.getElementById('time-progress').style.width = progress + '%';
            
            // Changer la couleur de la barre de progression
            const progressBar = document.getElementById('time-progress');
            if (remainingTime <= criticalThreshold) {
                progressBar.style.background = 'linear-gradient(90deg, #f44336, #e53935)';
            } else if (remainingTime <= warningThreshold) {
                progressBar.style.background = 'linear-gradient(90deg, #ff9800, #f57c00)';
            }
        }

        function selectChoice(choiceElement) {
            // Désélectionner les autres choix de la même question
            const questionDiv = choiceElement.closest('.question');
            questionDiv.querySelectorAll('.choice').forEach(choice => {
                choice.classList.remove('selected');
            });
            
            // Sélectionner le choix actuel
            choiceElement.classList.add('selected');
            const radioInput = choiceElement.querySelector('input[type="radio"]');
            radioInput.checked = true;
        }

        function showTimeUpAlert() {
            const alertDiv = document.createElement('div');
            alertDiv.style.cssText = `
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: #f44336;
                color: white;
                padding: 30px;
                border-radius: 15px;
                text-align: center;
                font-size: 1.5em;
                font-weight: bold;
                z-index: 10000;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            `;
            alertDiv.innerHTML = `
                <div style="font-size: 3em; margin-bottom: 10px;">⏰</div>
                <div>Temps écoulé !</div>
                <div style="font-size: 0.8em; margin-top: 10px;">Le test sera soumis automatiquement...</div>
            `;
            document.body.appendChild(alertDiv);
        }

        function submitForm() {
            // Vérifier si toutes les questions ont été répondues
            const totalQuestions = document.querySelectorAll('.question').length;
            const answeredQuestions = document.querySelectorAll('input[type="radio"]:checked').length;
            
            if (answeredQuestions < totalQuestions) {
                if (!confirm(`Vous n'avez répondu qu'à ${answeredQuestions} sur ${totalQuestions} questions. Êtes-vous sûr de vouloir soumettre ?`)) {
                    return;
                }
            } else {
                if (!confirm("Êtes-vous sûr de vouloir soumettre votre test ? Vous ne pourrez plus modifier vos réponses.")) {
                    return;
                }
            }
            
            document.getElementById('qcm-form').submit();
        }

        // Empêcher la fermeture accidentelle de la page
        window.addEventListener('beforeunload', function (e) {
            if (remainingTime > 0) {
                e.preventDefault();
                e.returnValue = 'Voulez-vous vraiment quitter ? Votre progression sera perdue.';
            }
        });

        // Démarrer le timer au chargement
        window.onload = function() {
            startTimer();
            updateTimerDisplay();
            updateProgressBar();
            
            // Ajouter l'interaction de sélection aux choix
            document.querySelectorAll('.choice').forEach(choice => {
                choice.addEventListener('click', function() {
                    selectChoice(this);
                });
            });
        };
    </script>
</body>
</html>