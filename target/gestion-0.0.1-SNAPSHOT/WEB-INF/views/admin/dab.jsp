<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            min-height: 100vh;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: #495057;
            color: white;
            padding: 0;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 30px 20px;
            background: #343a40;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h4 {
            font-size: 1.5em;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            font-size: 0.85em;
            opacity: 0.8;
        }

        .nav-menu {
            padding: 20px 0;
        }

        .nav-item {
            margin-bottom: 5px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border-left-color: white;
        }

        .nav-link.active {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            border-left-color: white;
            font-weight: 500;
        }

        .nav-icon {
            margin-right: 12px;
            font-size: 1.2em;
        }

        /* Section repliable */
        .nav-section {
            margin-bottom: 5px;
        }

        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 20px;
            color: white;
            background: rgba(255, 255, 255, 0.05);
            cursor: pointer;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
            font-weight: 500;
        }

        .section-header:hover {
            background: rgba(255, 255, 255, 0.1);
            border-left-color: white;
        }

        .section-header.active {
            background: rgba(255, 255, 255, 0.15);
            border-left-color: white;
        }

        .section-title {
            display: flex;
            align-items: center;
        }

        .chevron {
            font-size: 0.8em;
            transition: transform 0.3s ease;
        }

        .chevron.open {
            transform: rotate(180deg);
        }

        .section-content {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease;
            background: rgba(0, 0, 0, 0.1);
        }

        .section-content.open {
            max-height: 500px;
        }

        .section-content .nav-link {
            padding-left: 52px;
            font-size: 0.95em;
        }

        .logout-section {
            padding: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: auto;
        }

        .btn-logout {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 12px;
            background: rgba(220, 53, 69, 0.2);
            color: white;
            border: 1px solid rgba(220, 53, 69, 0.3);
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-logout:hover {
            background: #dc3545;
            border-color: #dc3545;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 30px;
        }

        .content-header {
            background: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        .content-header h2 {
            color: #495057;
            font-size: 1.8em;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .main-content {
                margin-left: 0;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h4>👨‍💼 Admin Panel</h4>
                <p>Gestion des annonces</p>
            </div>
            
            <ul class="nav-menu">
                <!-- Section Personnel -->
                <li class="nav-section">
                    <div class="section-header" onclick="toggleSection('personnel')">
                        <div class="section-title">
                            <span class="nav-icon">👔</span>
                            Personnel
                        </div>
                        <span class="chevron" id="chevron-personnel">▼</span>
                    </div>
                    <div class="section-content" id="section-personnel">
                        <a href="/admin/annonces" class="nav-link">
                            <span class="nav-icon">📋</span>
                            Annonces
                        </a>
                        <a href="/Embauche" class="nav-link">
                            <span class="nav-icon">👔</span>
                            Embaucher
                        </a>
                        <a href="/mes-entretiens" class="nav-link">
                            <span class="nav-icon">📅</span>
                            Mes entretiens
                        </a>
                        <a href="/expirees" class="nav-link">
                            <span class="nav-icon">⏰</span>
                            Annonces expirées
                        </a>
                    </div>
                </li>

                <!-- Section Candidat -->
                <li class="nav-section">
                    <div class="section-header" onclick="toggleSection('candidat')">
                        <div class="section-title">
                            <span class="nav-icon">👥</span>
                            Candidat
                        </div>
                        <span class="chevron" id="chevron-candidat">▼</span>
                    </div>
                    <div class="section-content" id="section-candidat">
                        <a href="/candidat/list" class="nav-link">
                            <span class="nav-icon">📋</span>
                            Liste des Candidats
                        </a>
                        <a href="/candidat/statistique" class="nav-link">
                            <span class="nav-icon">📊</span>
                            Statistique
                        </a>
                    </div>
                </li>
            </ul>

            <div class="logout-section">
                <a href="/acceuil" class="btn-logout">
                    <span style="margin-right: 8px;">🚪</span>
                    Déconnexion
                </a>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <h2>Tableau de bord</h2>
            </div>
            <p style="color: #6c757d;">Cliquez sur "Personnel" ou "Candidat" dans le menu pour voir les sections.</p>
        </div>
    </div>

    <script>
        let currentOpenSection = null;

        function toggleSection(sectionName) {
            const section = document.getElementById('section-' + sectionName);
            const chevron = document.getElementById('chevron-' + sectionName);
            const header = chevron.parentElement;

            // Si on clique sur la section déjà ouverte, on la ferme
            if (currentOpenSection === sectionName) {
                section.classList.remove('open');
                chevron.classList.remove('open');
                header.classList.remove('active');
                currentOpenSection = null;
                return;
            }

            // Fermer la section actuellement ouverte
            if (currentOpenSection) {
                const oldSection = document.getElementById('section-' + currentOpenSection);
                const oldChevron = document.getElementById('chevron-' + currentOpenSection);
                const oldHeader = oldChevron.parentElement;
                
                oldSection.classList.remove('open');
                oldChevron.classList.remove('open');
                oldHeader.classList.remove('active');
            }

            // Ouvrir la nouvelle section
            section.classList.add('open');
            chevron.classList.add('open');
            header.classList.add('active');
            currentOpenSection = sectionName;
        }
    </script>
</body>
</html>