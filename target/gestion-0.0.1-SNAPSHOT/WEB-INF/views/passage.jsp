<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test QCM - ${qcm.titre}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>
        /* Styles additionnels spécifiques au test */
        body {
            background: linear-gradient(135deg, #343a40 0%, #495057 100%);
            padding: 20px;
        }
        
        .test-page {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        .timer-container {
            position: sticky;
            top: 20px;
            background: white;
            padding: 20px 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #2563eb;
            z-index: 1000;
        }
        
        .timer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .timer-label {
            color: #334155;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .time-display {
            font-size: 2.5em;
            font-weight: bold;
            font-family: 'Courier New', monospace;
            color: #2563eb;
            line-height: 1;
        }
        
        .time-warning {
            color: #ff9800;
            animation: pulse 1s infinite;
        }
        
        .time-critical {
            color: #dc2626;
            animation: blink 0.5s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
        
        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }
        
        .progress-bar {
            background: #e2e8f0;
            border-radius: 10px;
            height: 6px;
            margin-top: 15px;
            overflow: hidden;
        }
        
        .progress {
            background: linear-gradient(90deg, #2563eb, #3b82f6);
            height: 100%;
            transition: width 0.3s ease, background 0.3s ease;
        }
        
        .test-header {
            background: white;
            padding: 40px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            text-align: center;
        }
        
        .test-header h1 {
            color: #1e293b;
            margin: 0 0 15px 0;
            font-size: 2em;
        }
        
        .test-header p {
            color: #64748b;
            margin: 0 0 20px 0;
            font-size: 1.1em;
        }
        
        .test-meta {
            color: #475569;
            font-size: 0.95em;
        }
        
        .instructions {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .instructions h3 {
            color: #856404;
            margin: 0 0 15px 0;
            font-size: 18px;
        }
        
        .instructions ul {
            margin: 0;
            padding-left: 20px;
            color: #856404;
        }
        
        .instructions li {
            margin-bottom: 8px;
        }
        
        .question-section {
            margin-bottom: 40px;
        }
        
        .section-title {
            background: white;
            color: #1e293b;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 1.1em;
            font-weight: 600;
            border-left: 4px solid #2563eb;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        
        .question {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.2s ease;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        
        .question:hover {
            border-color: #2563eb;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.1);
        }
        
        .question-header {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        
        .question-number {
            background: #2563eb;
            color: white;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 15px;
            flex-shrink: 0;
        }
        
        .question-text {
            font-weight: 600;
            font-size: 1.05em;
            color: #1e293b;
            flex: 1;
        }
        
        .choices {
            padding-left: 51px;
        }
        
        .choice {
            margin: 10px 0;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            background: white;
        }
        
        .choice:hover {
            border-color: #2563eb;
            background: #f0f7ff;
        }
        
        .choice.selected {
            border-color: #2563eb;
            background: #eff6ff;
        }
        
        .choice input[type="radio"] {
            margin-right: 10px;
            width: 18px;
            height: 18px;
            accent-color: #2563eb;
            cursor: pointer;
        }
        
        .choice label {
            cursor: pointer;
            margin: 0;
            flex: 1;
            color: #334155;
        }
        
        .submit-section {
            text-align: center;
            margin: 40px 0;
            padding: 40px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }
        
        .submit-section h3 {
            color: #1e293b;
            margin: 0 0 15px 0;
        }
        
        .submit-section p {
            color: #64748b;
            margin: 0 0 25px 0;
        }
        
        @media (max-width: 768px) {
            .test-page {
                padding: 0;
            }
            
            .timer-container {
                padding: 15px 20px;
                border-radius: 8px;
            }
            
            .timer {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
            
            .time-display {
                font-size: 2em;
            }
            
            .test-header {
                padding: 30px 20px;
            }
            
            .test-header h1 {
                font-size: 1.5em;
            }
            
            .question {
                padding: 20px 15px;
            }
            
            .choices {
                padding-left: 0;
            }
            
            .submit-section {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="test-page">
        <!-- Timer et informations -->
        <div class="timer-container">
            <div class="timer">
                <div>
                    <div class="timer-label">⏱️ TEMPS RESTANT</div>
                    <div id="time-remaining" class="time-display">${qcm.dureeMinutes}:00</div>
                </div>
                <div style="text-align: right;">
                    <div class="timer-label">🧪 TEST EN COURS</div>
                    <div style="color: #64748b; font-size: 0.9em; margin-top: 5px;">Restez concentré</div>
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
            <div class="test-meta">
                <strong>Durée:</strong> ${qcm.dureeMinutes} minutes | 
                <strong>Mode:</strong> Test de sélection
            </div>
        </div>

        <!-- Instructions -->
        <div class="instructions">
            <h3>📋 Instructions importantes</h3>
            <ul>
                <li>Le test se soumettra automatiquement lorsque le temps sera écoulé</li>
                <li>Vous ne pouvez pas revenir en arrière après avoir répondu</li>
                <li>Toutes les questions sont obligatoires</li>
                <li>Le score minimum requis est de 50%</li>
            </ul>
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
                            <div class="question-header">
                                <span class="question-number">${question.ordre}</span>
                                <div class="question-text">${question.libelle}</div>
                            </div>
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
            <c:if test="${not empty questions}">
                <div class="question-section">
                    <div class="section-title">
                        🎯 QUESTIONS SPÉCIFIQUES (${questions.size()} questions)
                    </div>
                    <c:forEach var="question" items="${questions}">
                        <div class="question">
                            <div class="question-header">
                                <span class="question-number">${question.ordre}</span>
                                <div class="question-text">${question.libelle}</div>
                            </div>
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
                </div>
            </c:if>

            <!-- Section de soumission -->
            <div class="submit-section">
                <h3>Vous avez terminé ?</h3>
                <p>Vérifiez vos réponses avant de soumettre. Vous ne pourrez plus modifier vos réponses après validation.</p>
                <button type="button" onclick="submitForm()" class="btn btn-primary" style="font-size: 1.1em; padding: 14px 32px;">
                    ✅ VALIDER ET SOUMETTRE LE TEST
                </button>
            </div>
        </form>
    </div>

    <script>
        let totalTime = ${qcm.dureeMinutes} * 60;
        let remainingTime = totalTime;
        let timerInterval;
        const warningThreshold = 300;
        const criticalThreshold = 60;

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
            
            const progressBar = document.getElementById('time-progress');
            if (remainingTime <= criticalThreshold) {
                progressBar.style.background = 'linear-gradient(90deg, #dc2626, #b91c1c)';
            } else if (remainingTime <= warningThreshold) {
                progressBar.style.background = 'linear-gradient(90deg, #ff9800, #f57c00)';
            }
        }

        function selectChoice(choiceElement) {
            const questionDiv = choiceElement.closest('.question');
            questionDiv.querySelectorAll('.choice').forEach(choice => {
                choice.classList.remove('selected');
            });
            
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
                background: #dc2626;
                color: white;
                padding: 30px 50px;
                border-radius: 12px;
                text-align: center;
                font-size: 1.5em;
                font-weight: bold;
                z-index: 10000;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            `;
            alertDiv.innerHTML = `
                <div style="font-size: 3em; margin-bottom: 10px;">⏰</div>
                <div>Temps écoulé !</div>
                <div style="font-size: 0.7em; margin-top: 10px; opacity: 0.9;">Le test sera soumis automatiquement...</div>
            `;
            document.body.appendChild(alertDiv);
        }

        function submitForm() {
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

        window.addEventListener('beforeunload', function (e) {
            if (remainingTime > 0) {
                e.preventDefault();
                e.returnValue = 'Voulez-vous vraiment quitter ? Votre progression sera perdue.';
            }
        });

        window.onload = function() {
            startTimer();
            updateTimerDisplay();
            updateProgressBar();
        };
    </script>
</body>
</html>