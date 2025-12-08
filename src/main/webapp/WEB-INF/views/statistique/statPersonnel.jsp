<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistique du personnel</title>
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

        .page-header h1 {
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

        .chart-card {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
        }

        .chart-wrapper {
            height: 600px;
            position: relative;
        }

        @media (max-width: 768px) {
            body {
                padding: 15px;
            }

            .page-header, .nav-section, .chart-card {
                padding: 20px;
            }

            .chart-wrapper {
                height: 450px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h1>Personnel par Département</h1>
            <div class="breadcrumb">
                <a href="/admin/dashboard">Tableau de bord</a> / Nombre de personnel
            </div>
        </div>

        <div class="nav-section">
            <h3>Navigation</h3>
            <div class="nav-links">
                <a href="/stat/stat-anciennete-dept">Ancienneté du personnel</a>
                <a href="/stat/absenteisme">Absentéisme</a>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-wrapper">
                <canvas id="chartPersonnel"></canvas>
            </div>
        </div>
    </div>

    <script>
        const labels = JSON.parse('${labels}');
        const values = JSON.parse('${values}');

        const ctx = document.getElementById("chartPersonnel").getContext('2d');
        new Chart(ctx, {
            type: "bar",
            data: {
                labels: labels,
                datasets: [{
                    label: "Nombre de personnel",
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