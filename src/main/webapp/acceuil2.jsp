<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management System</title>
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
        .product-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            margin-bottom: 20px;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.15);
        }
        .card-img-top {
            height: 200px;
            object-fit: cover;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .card-img-placeholder {
            height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #e9ecef;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            color: #6c757d;
        }
        .card-body {
            padding: 1.25rem;
        }
        .card-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .product-category {
            display: inline-block;
            background-color: #e9ecef;
            color: #495057;
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            font-size: 0.85rem;
            margin-bottom: 0.5rem;
        }
        .product-price {
            font-weight: 700;
            color: #007bff;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
        }
        .product-stock {
            font-size: 0.85rem;
            margin-bottom: 1rem;
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
        .card-actions {
            display: flex;
            justify-content: space-between;
        }
        .btn-view {
            color: #007bff;
            background-color: transparent;
            border: 1px solid #007bff;
            font-size: 0.9rem;
        }
        .btn-view:hover {
            background-color: #007bff;
            color: white;
        }
        .btn-admin {
            font-size: 0.9rem;
        }
        .btn-favorite {
            background-color: transparent;
            border: none;
            color: #dc3545;
            font-size: 1.2rem;
            cursor: pointer;
        }
        .search-container {
            background-color: white;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .filter-dropdown {
            min-width: 200px;
        }
        .dropdown-toggle::after {
            display: none;
        }
        .sort-dropdown {
            min-width: 200px;
        }
        .empty-products {
            text-align: center;
            padding: 50px 0;
        }
        .empty-products i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 1rem;
        }
        .empty-products h3 {
            color: #6c757d;
            margin-bottom: 1rem;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/acceuil">Products</a>
                    </li>
                    <c:if test="${isAdmin}">
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>Products</h1>
            <c:if test="${isAdmin}">
                <a href="${pageContext.request.contextPath}/product/add" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Product
                </a>
            </c:if>
        </div>
        
        <!-- Search and Filter Container -->
        <div class="search-container">
            <div class="row g-3">
                <!-- Search Bar -->
                <div class="col-md-6">
                    <form class="d-flex" method="get" action="${pageContext.request.contextPath}/search">
                        <input name="mc" type="text" class="form-control me-2" placeholder="Search by name..." value="${mc}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>
                
                <!-- Category Filter -->
                <div class="col-md-3">
                    <div class="dropdown">
                        <button class="btn btn-outline-secondary dropdown-toggle w-100 d-flex justify-content-between align-items-center" type="button" id="categoryFilterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <span>Filter by Category</span>
                            <i class="fas fa-filter"></i>
                        </button>
                        <ul class="dropdown-menu filter-dropdown" aria-labelledby="categoryFilterDropdown">
                            <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/acceuil">All Categories</a></li>
                            <c:forEach items="${categories}" var="category">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/search?categoryId=${category.id}">${category.nom}</a></li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                
                <!-- Sort Options -->
                <div class="col-md-3">
                    <div class="dropdown">
                        <button class="btn btn-outline-secondary dropdown-toggle w-100 d-flex justify-content-between align-items-center" type="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <span>Sort by</span>
                            <i class="fas fa-sort"></i>
                        </button>
                        <ul class="dropdown-menu sort-dropdown" aria-labelledby="sortDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/acceuil?sort=name_asc">Name (A-Z)</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/acceuil?sort=name_desc">Name (Z-A)</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/acceuil?sort=price_asc">Price (Low to High)</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/acceuil?sort=price_desc">Price (High to Low)</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Grid -->
        <c:choose>
            <c:when test="${empty products}">
                <div class="empty-products">
                    <i class="fas fa-box-open"></i>
                    <h3>No products found</h3>
                    <p>Try adjusting your search or filter criteria</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <c:forEach items="${products}" var="p">
                        <div class="col">
                            <div class="card product-card">
                                <!-- Product Image -->
                                <c:choose>
                                    <c:when test="${not empty p.image}">
                                        <img src="${p.image}" class="card-img-top" alt="${p.nom}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-placeholder">
                                            <i class="fas fa-box fa-3x"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="card-body">
                                    <!-- Product Category -->
                                    <c:if test="${not empty p.categorie}">
                                        <div class="product-category">
                                            <i class="fas fa-tag"></i> ${p.categorie.nom}
                                        </div>
                                    </c:if>
                                    
                                    <!-- Product Name -->
                                    <h5 class="card-title">${p.nom}</h5>
                                    
                                    <!-- Product Price -->
                                    <div class="product-price">$${p.prix}</div>
                                    
                                    <!-- Product Stock Status -->
                                    <div class="product-stock">
                                        <c:choose>
                                            <c:when test="${p.quantite > 10}">
                                                <span class="in-stock"><i class="fas fa-check-circle"></i> In Stock</span>
                                            </c:when>
                                            <c:when test="${p.quantite > 0}">
                                                <span class="low-stock"><i class="fas fa-exclamation-circle"></i> Low Stock (${p.quantite})</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="out-of-stock"><i class="fas fa-times-circle"></i> Out of Stock</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <!-- Product Actions -->
                                    <div class="card-actions">
                                        <a href="${pageContext.request.contextPath}/product/view?id=${p.id}" class="btn btn-view btn-sm">
                                            <i class="fas fa-eye"></i> View Details
                                        </a>
                                        
                                        <div>
                                            <a href="${pageContext.request.contextPath}/favorites/add?productId=${p.id}" class="btn-favorite">
                                                <i class="fas fa-heart"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/cart/add?productId=${p.id}&quantity=1" class="btn-favorite">
                                                <i class="fas fa-shopping-cart"></i>
                                            </a>
                                        </div>
                                    </div>
                                    
                                    <!-- Admin Actions -->
                                    <c:if test="${isAdmin}">
                                        <hr>
                                        <div class="d-flex justify-content-between">
                                            <a href="${pageContext.request.contextPath}/product/update?id=${p.id}" class="btn btn-warning btn-sm btn-admin">
                                                <i class="fas fa-edit"></i> Edit
                                            </a>
                                            <a href="${pageContext.request.contextPath}/product/delete?id=${p.id}" class="btn btn-danger btn-sm btn-admin" 
                                               onclick="return confirm('Are you sure you want to delete this product?')">
                                                <i class="fas fa-trash"></i> Delete
                                            </a>
                                        </div>
                                    </c:if>
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
