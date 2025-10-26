<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Sidebar -->
<div class="sidebar">
    <div class="company-name">
        <h4>Gestion RH
            <a href="/admin/login">Admin</a>
        </h4>
    </div>
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link active" href="/acceuil">
                <i class="fas fa-home"></i> Accueil
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="fas fa-briefcase"></i> Offres d'emploi
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="fas fa-users"></i> Candidats
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="/admin_recherche">
                <i class="fas fa-chart-line"></i> Recherches
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="#">
                <i class="fas fa-cog"></i> Paramètres
            </a>
        </li>
    </ul>
</div>

<style>
    :root {
        --sidebar-width: 250px;
    }
    .sidebar {
        width: var(--sidebar-width);
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        background-color: #343a40;
        padding-top: 20px;
        color: white;
        z-index: 1000;
    }
    .company-name {
        padding: 20px;
        border-bottom: 1px solid #495057;
        margin-bottom: 20px;
    }
    .sidebar .nav-link {
        color: #ffffff;
        padding: 10px 20px;
        transition: all 0.3s;
    }
    .sidebar .nav-link:hover {
        background-color: #495057;
        padding-left: 25px;
    }
    .sidebar .nav-link i {
        margin-right: 10px;
    }
    .active {
        background-color: #495057;
    }
</style>