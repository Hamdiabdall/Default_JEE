<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart</title>
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
        .cart-item {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px;
            padding: 15px;
            transition: transform 0.2s ease;
        }
        .cart-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .product-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }
        .product-details {
            flex-grow: 1;
        }
        .product-title {
            font-weight: 600;
            margin-bottom: 5px;
        }
        .product-category {
            display: inline-block;
            background-color: #e9ecef;
            color: #495057;
            padding: 0.2rem 0.4rem;
            border-radius: 15px;
            font-size: 0.8rem;
            margin-bottom: 5px;
        }
        .product-price {
            font-weight: 700;
            color: #007bff;
        }
        .quantity-control {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .quantity-btn {
            background-color: #e9ecef;
            border: none;
            color: #495057;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
        }
        .quantity-input {
            width: 40px;
            text-align: center;
            margin: 0 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
        }
        .btn-remove {
            color: #dc3545;
            background: transparent;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
        }
        .empty-cart {
            text-align: center;
            padding: 50px 0;
        }
        .empty-cart i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 1rem;
        }
        .empty-cart h3 {
            color: #6c757d;
            margin-bottom: 1rem;
        }
        .cart-summary {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
            position: sticky;
            top: 20px;
        }
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .summary-total {
            font-size: 1.2rem;
            font-weight: 700;
            border-top: 1px solid #dee2e6;
            padding-top: 10px;
            margin-top: 10px;
        }
        .btn-checkout {
            background-color: #28a745;
            color: white;
            border: none;
            width: 100%;
            padding: 10px;
            font-weight: 600;
            margin-top: 15px;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/cart/view">
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
        <h1 class="mb-4"><i class="fas fa-shopping-cart"></i> Shopping Cart</h1>
        
        <c:choose>
            <c:when test="${empty cartItems}">
                <div class="empty-cart">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Your cart is empty</h3>
                    <p>Products you add to cart will appear here</p>
                    <a href="${pageContext.request.contextPath}/acceuil" class="btn btn-primary mt-3">Browse Products</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <div class="col-md-8">
                        <c:forEach items="${cartItems}" var="item">
                            <div class="cart-item d-flex align-items-center">
                                <c:choose>
                                    <c:when test="${not empty item.image}">
                                        <img src="${item.image}" class="product-img me-3" alt="${item.nom}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="product-img me-3 d-flex align-items-center justify-content-center bg-light">
                                            <i class="fas fa-box fa-2x text-secondary"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="product-details me-3">
                                    <h5 class="product-title">${item.nom}</h5>
                                    <c:if test="${not empty item.categorie}">
                                        <span class="product-category">
                                            <i class="fas fa-tag"></i> ${item.categorie.nom}
                                        </span>
                                    </c:if>
                                    <p class="mb-1 text-muted small">${item.description != null ? item.description : 'No description available'}</p>
                                    <div class="product-price">$${item.prix}</div>
                                </div>
                                
                                <div class="quantity-wrapper me-3">
                                    <form action="${pageContext.request.contextPath}/cart/update" method="get" class="quantity-control">
                                        <input type="hidden" name="productId" value="${item.id}">
                                        <button type="button" class="quantity-btn" onclick="decrementQuantity(this)">-</button>
                                        <input type="number" name="quantity" value="1" min="1" max="${item.quantite}" class="quantity-input">
                                        <button type="button" class="quantity-btn" onclick="incrementQuantity(this, parseInt('${item.quantite}'))">+</button>
                                    </form>
                                    <small class="text-muted">Available: ${item.quantite}</small>
                                </div>
                                
                                <div class="ms-auto">
                                    <a href="${pageContext.request.contextPath}/cart/remove?productId=${item.id}" class="btn-remove">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="cart-summary">
                            <h4 class="mb-3">Order Summary</h4>
                            
                            <c:set var="subtotal" value="0" />
                            <c:forEach items="${cartItems}" var="item">
                                <c:set var="subtotal" value="${subtotal + item.prix}" />
                            </c:forEach>
                            
                            <div class="summary-item">
                                <span>Subtotal (${cartItems.size()} items)</span>
                                <span>$${subtotal}</span>
                            </div>
                            <div class="summary-item">
                                <span>Shipping</span>
                                <span>$0.00</span>
                            </div>
                            <div class="summary-item">
                                <span>Tax</span>
                                <span>$${subtotal * 0.1}</span>
                            </div>
                            <div class="summary-item summary-total">
                                <span>Total</span>
                                <span>$${subtotal + (subtotal * 0.1)}</span>
                            </div>
                            
                            <button class="btn btn-checkout">
                                <i class="fas fa-credit-card"></i> Proceed to Checkout
                            </button>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function decrementQuantity(button) {
            const input = button.nextElementSibling;
            const value = parseInt(input.value);
            if (value > 1) {
                input.value = value - 1;
            }
        }
        
        function incrementQuantity(button, max) {
            const input = button.previousElementSibling;
            const value = parseInt(input.value);
            if (value < max) {
                input.value = value + 1;
            }
        }
    </script>
</body>
</html> 