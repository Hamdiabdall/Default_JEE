<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${produit.nom} - Product Details</title>
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
        .product-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .product-image-placeholder {
            width: 100%;
            height: 400px;
            background-color: #e9ecef;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #adb5bd;
            font-size: 4rem;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .product-info {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .product-title {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .product-category {
            display: inline-block;
            background-color: #e9ecef;
            color: #495057;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        .product-price {
            font-size: 1.8rem;
            font-weight: 700;
            color: #007bff;
            margin-bottom: 20px;
        }
        .product-description {
            color: #6c757d;
            margin-bottom: 25px;
            line-height: 1.6;
        }
        .product-stock {
            margin-bottom: 25px;
            font-weight: 500;
        }
        .in-stock {
            color: #28a745;
        }
        .low-stock {
            color: #ffc107;
        }
        .out-of-stock {
            color: #dc3545;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            margin-bottom: 25px;
        }
        .quantity-btn {
            background-color: #e9ecef;
            border: none;
            color: #495057;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 1.2rem;
        }
        .quantity-input {
            width: 60px;
            height: 40px;
            text-align: center;
            margin: 0 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 1.1rem;
        }
        .btn-cart {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 600;
            margin-right: 10px;
        }
        .btn-heart {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 600;
        }
        .admin-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
        }
        .navbar {
            margin-bottom: 30px;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/favorites/list">
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
        <div class="row">
            <div class="col-md-6">
                <c:choose>
                    <c:when test="${not empty produit.image}">
                        <img src="${produit.image}" class="product-image" alt="${produit.nom}">
                    </c:when>
                    <c:otherwise>
                        <div class="product-image-placeholder">
                            <i class="fas fa-box"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="col-md-6">
                <div class="product-info">
                    <h1 class="product-title">${produit.nom}</h1>
                    
                    <c:if test="${not empty produit.categorie}">
                        <div class="product-category">
                            <i class="fas fa-tag"></i> ${produit.categorie.nom}
                        </div>
                    </c:if>
                    
                    <div class="product-price">$${produit.prix}</div>
                    
                    <div class="product-description">
                        ${not empty produit.description ? produit.description : 'No description available for this product.'}
                    </div>
                    
                    <div class="product-stock">
                        <c:choose>
                            <c:when test="${produit.quantite > 10}">
                                <span class="in-stock"><i class="fas fa-check-circle"></i> In Stock (${produit.quantite} available)</span>
                            </c:when>
                            <c:when test="${produit.quantite > 0}">
                                <span class="low-stock"><i class="fas fa-exclamation-circle"></i> Low Stock (Only ${produit.quantite} left)</span>
                            </c:when>
                            <c:otherwise>
                                <span class="out-of-stock"><i class="fas fa-times-circle"></i> Out of Stock</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <c:if test="${produit.quantite > 0}">
                        <form action="${pageContext.request.contextPath}/cart/add" method="get">
                            <input type="hidden" name="productId" value="${produit.id}">
                            
                            <div class="quantity-control">
                                <button type="button" class="quantity-btn" onclick="decrementQuantity()">-</button>
                                <input type="number" id="quantity" name="quantity" value="1" min="1" max="${produit.quantite}" class="quantity-input">
                                <button type="button" class="quantity-btn" onclick="incrementQuantity(parseInt('${produit.quantite}'))">+</button>
                            </div>
                            
                            <div class="d-flex">
                                <button type="submit" class="btn btn-cart">
                                    <i class="fas fa-shopping-cart"></i> Add to Cart
                                </button>
                                
                                <a href="${pageContext.request.contextPath}/favorites/add?productId=${produit.id}" class="btn btn-heart ms-2">
                                    <i class="fas fa-heart"></i> Add to Favorites
                                </a>
                            </div>
                        </form>
                    </c:if>
                    
                    <c:if test="${isAdmin}">
                        <div class="admin-actions">
                            <h5>Admin Actions</h5>
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/product/update?id=${produit.id}" class="btn btn-warning">
                                    <i class="fas fa-edit"></i> Edit Product
                                </a>
                                <a href="${pageContext.request.contextPath}/product/delete?id=${produit.id}" class="btn btn-danger" 
                                   onclick="return confirm('Are you sure you want to delete this product?')">
                                    <i class="fas fa-trash"></i> Delete Product
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function decrementQuantity() {
            const input = document.getElementById('quantity');
            const value = parseInt(input.value);
            if (value > 1) {
                input.value = value - 1;
            }
        }
        
        function incrementQuantity(max) {
            const input = document.getElementById('quantity');
            const value = parseInt(input.value);
            const maxValue = parseInt(max);
            if (value < maxValue) {
                input.value = value + 1;
            }
        }
    </script>
</body>
</html> 