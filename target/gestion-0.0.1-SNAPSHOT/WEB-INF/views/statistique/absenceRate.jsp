<!-- ==================== FICHIER 1: Absentéisme ==================== -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistique Absentéisme</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f6fa;
            min-height: 100vh;
            padding: 30px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .page-header {
            background: white;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
            margin-bottom: 25px;
            border-left: 4px solid #495057;
        }

        .page-header h2 {
            color: #495057;
            font-size: 1.8em;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .breadcrumb {
            color: #6c757d;
            font-size: 0.9em;
        }

        .breadcrumb a {
            color: #495057;
            text-decoration: none;
            transition: color 0.3s;
        }

        .breadcrumb a:hover {
            color: #212529;
        }

        .nav-section {
            background: white;
            padding: 20px 40px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
            margin-bottom: 25px;
        }

        .nav-section h3 {
            color: #495057;
            font-size: 1.1em;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .nav-links {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .nav-links a {
            padding: 10px 20px;
            background: #f8f9fa;
            color: #495057;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            font-size: 0.95em;
            transition: all 0.3s ease;
            border: 1px solid #dee2e6;
        }

        .nav-links a:hover {
            background: #495057;
            color: white;
            border-color: #495057;
        }

        .nav-links a.back-link {
            background: #6c757d;
            color: white;
            border-color: #6c757d;
        }

        .nav-links a.back-link:hover {
            background: #5a6268;
        }

        .filter-card {
            background: white;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
            margin-bottom: 25px;
        }

        .filter-form {
            display: flex;
            gap: 25px;
            align-items: end;
            flex-wrap: wrap;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            color: #495057;
            font-weight: 600;
            font-size: 0.9em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group select {
            padding: 10px 16px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 1em;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 140px;
            color: #495057;
        }

        .form-group select:focus {
            outline: none;
            border-color: #495057;
            box-shadow: 0 0 0 3px rgba(73, 80, 87, 0.1);
        }

        .btn-filter {
            padding: 10px 30px;
            background: #495057;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-filter:hover {
            background: #343a40;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .chart-card {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
        }

        .chart-wrapper {
            height: 550px;
            position: relative;
        }

        @media (max-width: 768px) {
            body {
                padding: 15px;
            }

            .page-header, .nav-section, .filter-card, .chart-card {
                padding: 20px;
            }

            .filter-form {
                flex-direction: column;
                align-items: stretch;
            }

            .btn-filter {
                width: 100%;
            }

            .chart-wrapper {
                height: 400px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h2>Statistiques d'Absentéisme</h2>
            <div class="breadcrumb">
                <a href="/admin/dashboard">Tableau de bord</a> / Taux d'absentéisme par département
            </div>
        </div>

        <div class="nav-section">
            <h3>Navigation</h3>
            <div class="nav-links">
                <a href="/stat/stat-anciennete-dept">Ancienneté du personnel</a>
                <a href="/stat/personnel">Personnel par département</a>
                <a href="/admin/dashboard" class="back-link">← Retour</a>
            </div>
        </div>

        <div class="filter-card">
            <form id="filterForm" method="get" action="/stat/absenteisme" class="filter-form">
                <div class="form-group">
                    <label for="month">Mois</label>
                    <select name="month" id="month">
                        <c:forEach var="m" begin="1" end="12">
                            <option value="${m}" ${m == currentMonth ? 'selected' : ''}>${m}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="year">Année</label>
                    <select name="year" id="year">
                        <c:forEach var="y" begin="2023" end="2030">
                            <option value="${y}" ${y == currentYear ? 'selected' : ''}>${y}</option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit" class="btn-filter">Filtrer</button>
            </form>
        </div>

        <div class="chart-card">
            <div class="chart-wrapper">
                <canvas id="absenceChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        const labels = JSON.parse('${labels}');
        const values = JSON.parse('${values}');

        const ctx = document.getElementById('absenceChart').getContext('2d');
        const absenceChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Taux d\'absentéisme (%)',
                    data: values,
                    backgroundColor: 'rgba(73, 80, 87, 0.8)',
                    borderColor: '#495057',
                    borderWidth: 2,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        labels: {
                            font: {
                                size: 13,
                                family: "'Segoe UI', sans-serif"
                            },
                            color: '#495057',
                            padding: 15
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        grid: {
                            color: '#e9ecef'
                        },
                        ticks: {
                            color: '#6c757d',
                            font: {
                                size: 12
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            color: '#495057',
                            font: {
                                size: 12,
                                weight: '500'
                            }
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>