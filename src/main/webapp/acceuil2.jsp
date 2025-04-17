<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product List</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <!-- Custom Styles -->
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            margin-top: 2rem;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        th, td {
            text-align: center;
            padding: 12px;
            vertical-align: middle;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e0e0e0;
        }
        .btn-edit {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-edit:hover, .btn-delete:hover {
            opacity: 0.9;
        }
        .search-form {
            margin-bottom: 20px;
        }
        .search-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1 class="text-center mb-4">Product Management</h1>
        
        <!-- Search Form -->
        <form class="search-form d-flex justify-content-center" method="get" action="search">
            <input name="mc" type="text" id="searchInput" class="search-input" placeholder="Search by Name or ID..." value="${mc}">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>

        <c:choose>
            <c:when test="${empty products}">
                <p class="text-center text-danger">There are no products.</p>
            </c:when>
            <c:otherwise>
                <table class="table table-bordered">
                    <thead class="bg-primary text-white">
                        <tr>
                            <th scope="col">#</th>
                            <th scope="col">Name</th>
                            <th scope="col">Price</th>
                            <th scope="col">Quantity</th>
                            <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="productTableBody">
                        <c:forEach items="${products}" var="p">
                            <tr>
                                <td>${p.id}</td>
                                <td>${p.nom}</td>
                                <td>${p.prix}</td>
                                <td>${p.quantite}</td>
                                <td>
                                    <a href="update?id=${p.id}" class="btn-edit" title="Edit"><i class="fas fa-edit"></i></a>
                                    <a href="delete?id=${p.id}" class="btn-delete" title="Delete"><i class="fas fa-trash-alt"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
