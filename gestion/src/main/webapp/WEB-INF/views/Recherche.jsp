<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Offres d'Emploi - Gestion RH</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .main-content {
            margin-left: var(--sidebar-width);
            padding: 30px;
            min-height: 100vh;
        }
        .header-section {
            background: linear-gradient(135deg, #343a40 0%, #495057 100%);
            padding: 40px 0;
            margin-bottom: 30px;
            color: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .search-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .job-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 25px;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
        }
        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            border-color: #007bff;
        }
        .job-header {
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
            background: linear-gradient(to right, #f8f9fa, white);
        }
        .job-body {
            padding: 20px;
        }
        .job-footer {
            padding: 15px 20px;
            background-color: #f8f9fa;
            border-top: 1px solid #e9ecef;
            border-radius: 0 0 12px 12px;
        }
        .badge-custom {
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
        }
        .job-title {
            color: #343a40;
            font-size: 1.25rem;
            font-weight: 600;
        }
        .job-company {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .job-tags {
            margin: 15px 0;
        }
        .job-tag {
            background-color: #e9ecef;
            color: #495057;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 0.85rem;
            margin-right: 8px;
            display: inline-block;
            margin-bottom: 8px;
        }
        .btn-apply {
            padding: 8px 25px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-apply:hover {
            transform: translateY(-2px);
        }
        .search-box {
            border-radius: 25px;
            padding: 10px 20px;
            border: 2px solid #e9ecef;
        }
        .search-btn {
            border-radius: 25px;
            padding: 10px 25px;
        }
        .filters {
            display: flex;
            gap: 15px;
            margin-top: 15px;
        }
        .filter-select {
            border-radius: 20px;
            border: 1px solid #e9ecef;
            padding: 8px 15px;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/menu_bar.jsp" %>
</body>
</html>