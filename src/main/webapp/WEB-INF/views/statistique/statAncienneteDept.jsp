<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistique Ancienneté</title>
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
            <h2>Ancienneté du Personnel</h2>
            <div class="breadcrumb">
                <a href="/admin/dashboard">Tableau de bord</a> / Ancienneté par département
            </div>
        </div>

        <div class="nav-section">
            <div class="nav-links">
                <a href="/stat/personnel">Personnel par département</a>
                <a href="/stat/absenteisme">Absentéisme</a>
                <a href="/admin/dashboard" class="back-link">← Retour</a>
            </div>
        </div>

        <div class="chart-card">
            <div class="chart-wrapper">
                <canvas id="ancienneteChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        const stats = JSON.parse('${statsAsJson}');
        const departements = [...new Set(stats.map(s => s.departement))];
        const ranges = ['0-1 an','1-3 ans','3-5 ans','5+ ans'];

        const colors = [
            { bg: 'rgba(73, 80, 87, 0.9)', border: '#495057' },
            { bg: 'rgba(108, 117, 125, 0.9)', border: '#6c757d' },
            { bg: 'rgba(134, 142, 150, 0.9)', border: '#868e96' },
            { bg: 'rgba(173, 181, 189, 0.9)', border: '#adb5bd' }
        ];

        const datasets = ranges.map((range, index) => {
            return {
                label: range,
                data: departements.map(dep => {
                    const item = stats.find(s => s.departement === dep && s.range === range);
                    return item ? item.total : 0;
                }),
                backgroundColor: colors[index].bg,
                borderColor: colors[index].border,
                borderWidth: 2
            };
        });

        const ctx = document.getElementById('ancienneteChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: departements,
                datasets: datasets
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Répartition du personnel selon l\'ancienneté par département',
                        font: {
                            size: 16,
                            weight: '600',
                            family: "'Segoe UI', sans-serif"
                        },
                        color: '#495057',
                        padding: {
                            top: 10,
                            bottom: 30
                        }
                    },
                    legend: {
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
                    x: { 
                        stacked: true,
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
                    },
                    y: { 
                        stacked: true, 
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
                    }
                }
            }
        });
    </script>
</body>
</html>