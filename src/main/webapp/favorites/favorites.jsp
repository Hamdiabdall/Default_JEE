<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Favorites</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
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
        .card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 20px;
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        .card-img-top {
            height: 200px;
            object-fit: cover;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .card-body {
            padding: 1.5rem;
        }
        .card-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .card-text {
            color: #6c757d;
            margin-bottom: 1rem;
        }
        .product-price {
            font-weight: 700;
            color: #007bff;
            font-size: 1.2rem;
            margin-bottom: 1rem;
        }
        .empty-favorites {
            text-align: center;
            padding: 50px 0;
        }
        .empty-favorites i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 1rem;
        }
        .empty-favorites h3 {
            color: #6c757d;
            margin-bottom: 1rem;
        }
        .btn-cart {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            font-weight: 500;
        }
        .btn-heart {
            background: none;
            border: none;
            color: #dc3545;
            font-size: 1.2rem;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/acceuil">
                <i class="fas fa-store"></i> Product Management System
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/acceuil">Products</a>
                    </li>
                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/category/list">Categories</a>
                        </li>
                    </c:if>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/favorites/list">
                            <i class="fas fa-heart"></i> Favorites
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart/view">
                            <i class="fas fa-shopping-cart"></i> Cart
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/profile">
                            <i class="fas fa-user"></i> Profile
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h1 class="mb-4"><i class="fas fa-heart text-danger"></i> My Favorite Products</h1>
        
        <c:choose>
            <c:when test="${empty favorites}">
                <div class="empty-favorites">
                    <i class="fas fa-heart-broken"></i>
                    <h3>Your favorites list is empty</h3>
                    <p>Products you mark as favorites will appear here</p>
                    <a href="${pageContext.request.contextPath}/acceuil" class="btn btn-primary mt-3">Browse Products</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach items="${favorites}" var="product">
                        <div class="col-md-4">
                            <div class="card">
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <img src="${product.image}" class="card-img-top" alt="${product.nom}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-top d-flex align-items-center justify-content-center bg-light">
                                            <i class="fas fa-box fa-4x text-secondary"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body">
                                    <h5 class="card-title">${product.nom}</h5>
                                    <c:if test="${not empty product.categorie}">
                                        <span class="product-category">
                                            <i class="fas fa-tag"></i> ${product.categorie.nom}
                                        </span>
                                    </c:if>
                                    <p class="card-text">
                                        ${product.description != null ? product.description : 'No description available'}
                                    </p>
                                    <div class="product-price">$${product.prix}</div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <form action="${pageContext.request.contextPath}/cart/add" method="get">
                                            <input type="hidden" name="productId" value="${product.id}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-cart">
                                                <i class="fas fa-shopping-cart"></i> Add to Cart
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/favorites/remove" method="get">
                                            <input type="hidden" name="productId" value="${product.id}">
                                            <button type="submit" class="btn-heart">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 