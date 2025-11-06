<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Planification d'Entretien</title>
    <style>
        /* Reset et base */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Container principal */
        .container {
            max-width: 600px;
            width: 100%;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            overflow: hidden;
            animation: slideIn 0.6s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(30px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Header */
        h1 {
            background: linear-gradient(45deg, #2c3e50, #34495e);
            color: white;
            padding: 30px;
            text-align: center;
            font-size: 2em;
            font-weight: 300;
            letter-spacing: 2px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        /* Formulaire */
        .form-container {
            padding: 40px;
        }

        .form-subtitle {
            text-align: center;
            color: #7f8c8d;
            margin-bottom: 30px;
            font-size: 1.1em;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .input-group {
            position: relative;
        }

        .input-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.9em;
        }

        input[type="date"], 
        input[type="time"], 
        select {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background: white;
            font-family: inherit;
        }

        input[type="date"]:focus, 
        input[type="time"]:focus, 
        select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.1);
            transform: translateY(-2px);
        }

        /* Select styling */
        select {
            cursor: pointer;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3e%3c/svg%3e");
            background-position: right 12px center;
            background-repeat: no-repeat;
            background-size: 16px;
            padding-right: 40px;
            appearance: none;
        }

        select option {
            padding: 10px;
        }

        /* Bouton de validation */
        .btn-submit {
            background: linear-gradient(45deg, #27ae60, #2ecc71);
            color: white;
            border: none;
            padding: 18px 40px;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(46, 204, 113, 0.3);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: linear-gradient(45deg, #229954, #27ae60);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(46, 204, 113, 0.4);
        }

        .btn-submit:active {
            transform: translateY(-1px);
        }

        /* Icônes pour les inputs */
        .input-group::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px;
            height: 20px;
            opacity: 0.5;
            z-index: 1;
            pointer-events: none;
        }

        .date-input::before {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%233498db'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z'/%3E%3C/svg%3E");
        }

        .time-input::before {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%233498db'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z'/%3E%3C/svg%3E");
        }

        .user-input::before {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%233498db'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z'/%3E%3C/svg%3E");
        }

        /* Ajustement pour les icônes */
        .has-icon input,
        .has-icon select {
            padding-left: 50px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 10px;
                align-items: flex-start;
                padding-top: 30px;
            }
            
            .container {
                border-radius: 10px;
                margin: 0;
            }
            
            h1 {
                font-size: 1.6em;
                padding: 20px;
            }
            
            .form-container {
                padding: 25px;
            }
            
            input[type="date"], 
            input[type="time"], 
            select {
                padding: 12px 15px;
                font-size: 14px;
            }
            
            .has-icon input,
            .has-icon select {
                padding-left: 40px;
            }
            
            .btn-submit {
                padding: 15px 30px;
                font-size: 14px;
            }
        }

        /* Animation pour les elements du formulaire */
        .input-group {
            animation: slideInUp 0.6s ease-out;
            animation-fill-mode: both;
        }

        .input-group:nth-child(1) { animation-delay: 0.1s; }
        .input-group:nth-child(2) { animation-delay: 0.2s; }
        .input-group:nth-child(3) { animation-delay: 0.3s; }
        .btn-submit { animation-delay: 0.4s; }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Planification d'Entretien</h1>
        <div class="form-container">
            <p class="form-subtitle">Veuillez definir la date, l'heure et l'evaluateur pour ce deuxième entretien</p>
            <form action="/date-entretien" method="get">
                <div class="input-group has-icon date-input">
                    <label class="input-label" for="date_entretien">Date d'entretien</label>
                    <input type="date" id="date_entretien" name="date_entretien" required>
                </div>
                
                <div class="input-group has-icon time-input">
                    <label class="input-label" for="heure_entretien">Heure d'entretien</label>
                    <input type="time" id="heure_entretien" name="heure_entretien" required>
                </div>
                
                <input type="hidden" name="id_entretien" value="${entretien2.entretien1.idEntretien}">
                
                <div class="input-group has-icon user-input">
                    <label class="input-label" for="id_user">evaluateur</label>
                    <select name="id_user" id="id_user" required>
                        <option value="">Selectionner un evaluateur du departement...</option>
                        <c:forEach var="userDept" items="${usersDept}">
                            <option value="${userDept.id_user}">${userDept.nom}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <input type="submit" class="btn-submit" value="Planifier l'entretien">
            </form>
        </div>
    </div>
</body>
</html>