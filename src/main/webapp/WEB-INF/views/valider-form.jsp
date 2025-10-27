<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contrat d'Essai - Validation</title>
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2980b9;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --border-color: #dee2e6;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --radius: 8px;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            width: 100%;
            max-width: 500px;
            background-color: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 25px 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 1.8rem;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .header p {
            opacity: 0.9;
            font-size: 0.95rem;
        }
        
        .form-container {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark-color);
        }
        
        input[type="date"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--border-color);
            border-radius: var(--radius);
            font-size: 16px;
            transition: all 0.3s;
            background-color: #f8f9fa;
        }
        
        input[type="date"]:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
            background-color: white;
        }
        
        .date-range {
            display: flex;
            gap: 15px;
        }
        
        .date-range .form-group {
            flex: 1;
        }
        
        .btn-submit {
            display: block;
            width: 100%;
            padding: 14px;
            background: linear-gradient(to right, var(--success-color), #27ae60);
            color: white;
            border: none;
            border-radius: var(--radius);
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
        }
        
        .btn-submit:active {
            transform: translateY(0);
        }
        
        .info-box {
            background-color: #e8f4fd;
            border-left: 4px solid var(--primary-color);
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 25px;
            font-size: 0.9rem;
        }
        
        .info-box p {
            margin: 0;
        }
        
        .candidate-id {
            text-align: center;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: var(--radius);
            font-weight: 500;
        }
        
        @media (max-width: 576px) {
            .container {
                max-width: 100%;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 1.5rem;
            }
            
            .form-container {
                padding: 20px;
            }
            
            .date-range {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Contrat d'Essai</h1>
            <p>Veuillez définir la période d'essai du candidat</p>
        </div>
        
        <div class="form-container">
            <div class="info-box">
                <p>Le contrat d'essai permet d'évaluer les compétences du candidat dans un environnement professionnel avant une éventuelle embauche définitive.</p>
            </div>
            
            <div class="candidate-id">
                Candidat ID: <strong>${param.id_candidat}</strong>
            </div>
            
            <form action="/valider" method="post">
                <input type="hidden" name="id_candidat" value="${param.id_candidat}" />
                
                <div class="date-range">
                    <div class="form-group">
                        <label for="date_debut">Date de début :</label>
                        <input type="date" id="date_debut" name="date_debut" required />
                    </div>
                    
                    <div class="form-group">
                        <label for="date_fin">Date de fin :</label>
                        <input type="date" id="date_fin" name="date_fin" required />
                    </div>
                </div>
                
                <button type="submit" class="btn-submit">Valider le contrat d'essai</button>
            </form>
        </div>
    </div>

    <script>
        // Validation des dates
        document.addEventListener('DOMContentLoaded', function() {
            const dateDebut = document.getElementById('date_debut');
            const dateFin = document.getElementById('date_fin');
            
            // Définir la date minimale à aujourd'hui
            const today = new Date().toISOString().split('T')[0];
            dateDebut.min = today;
            dateFin.min = today;
            
            // Validation pour s'assurer que la date de fin est après la date de début
            dateDebut.addEventListener('change', function() {
                if (dateDebut.value) {
                    dateFin.min = dateDebut.value;
                    
                    // Si la date de fin est antérieure à la nouvelle date de début
                    if (dateFin.value && dateFin.value < dateDebut.value) {
                        dateFin.value = '';
                    }
                }
            });
            
            // Validation côté client avant soumission
            document.querySelector('form').addEventListener('submit', function(e) {
                if (!dateDebut.value || !dateFin.value) {
                    e.preventDefault();
                    alert('Veuillez remplir les deux dates.');
                    return;
                }
                
                if (dateFin.value <= dateDebut.value) {
                    e.preventDefault();
                    alert('La date de fin doit être postérieure à la date de début.');
                    return;
                }
                
                // Calcul de la durée en jours
                const start = new Date(dateDebut.value);
                const end = new Date(dateFin.value);
                const diffTime = Math.abs(end - start);
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                
                if (diffDays < 7) {
                    if (!confirm(`La période d'essai que vous avez définie est de seulement ${diffDays} jour(s). Êtes-vous sûr de vouloir continuer ?`)) {
                        e.preventDefault();
                    }
                }
            });
        });
    </script>
</body>
</html>