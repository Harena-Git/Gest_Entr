<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Evaluation</title>
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
            max-width: 800px;
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

        /* Contenu */
        .content {
            padding: 40px;
        }

        .subtitle {
            text-align: center;
            color: #7f8c8d;
            margin-bottom: 30px;
            font-size: 1.1em;
        }

        /* Grille des evaluations */
        .evaluations-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        /* Boutons d'evaluation */
        .eval-btn {
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white;
            border: none;
            padding: 20px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
            text-align: center;
            width: 100%;
            position: relative;
            overflow: hidden;
        }

        .eval-btn:hover {
            background: linear-gradient(45deg, #2980b9, #2471a3);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(52, 152, 219, 0.4);
        }

        .eval-btn:active {
            transform: translateY(-1px);
        }

        .eval-btn::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }

        .eval-btn:hover::after {
            transform: translateX(0);
        }

        /* Formulaires */
        form {
            display: contents; /* Permet aux formulaires de s'integrer dans la grille */
        }

        /* Animation pour les elements */
        .evaluations-grid form {
            animation: slideInUp 0.6s ease-out;
            animation-fill-mode: both;
        }

        .evaluations-grid form:nth-child(1) { animation-delay: 0.1s; }
        .evaluations-grid form:nth-child(2) { animation-delay: 0.2s; }
        .evaluations-grid form:nth-child(3) { animation-delay: 0.3s; }
        .evaluations-grid form:nth-child(4) { animation-delay: 0.4s; }
        .evaluations-grid form:nth-child(5) { animation-delay: 0.5s; }

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
            
            .content {
                padding: 25px;
            }
            
            .evaluations-grid {
                grid-template-columns: 1fr;
            }
            
            .eval-btn {
                padding: 15px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Evaluation</h1>
        <div class="content">
            <p class="subtitle">Selectionnez un critere d'evaluation</p>
            <div class="evaluations-grid">
                <c:forEach var="entretien" items="${appreciations}">
                    <form action="/eval" method="post">
                        <input type="hidden" name="id_appreciation" value="${entretien.id_appreciation}">
                        <input type="hidden" name="id_entretien" value="${idEntretien}">
                        <input type="hidden" name="id_user" value="${id_user}">
                        <input type="submit" class="eval-btn" value="${entretien.libelle}">
                    </form>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>