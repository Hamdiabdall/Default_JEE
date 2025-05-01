<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${nomB} Product</title>
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
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background-color: #007bff;
            color: white;
            border-radius: 10px 10px 0 0 !important;
            padding: 15px;
        }
        .form-label {
            font-weight: 500;
        }
        .form-control {
            padding: 10px;
            border-radius: 5px;
        }
        .btn-primary {
            background-color: #007bff;
            border: none;
            padding: 10px 20px;
        }
        .btn-secondary {
            background-color: #6c757d;
            border: none;
            padding: 10px 20px;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h3 class="mb-0"><i class="fas fa-box-open"></i> ${nomB} Product</h3>
                    </div>
                    <div class="card-body">
                        <form action="${produit.id == 0 ? 'add' : 'update'}" method="post">
                            <input type="hidden" name="id" value="${produit.id != 0 ? produit.id : ''}">

                            <div class="mb-3">
                                <label for="nom" class="form-label">Product Name</label>
                                <input type="text" class="form-control" id="nom" name="nom" value="${produit.nom}" required>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Description</label>
                                <textarea class="form-control" id="description" name="description" rows="3">${produit.description}</textarea>
                            </div>

                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label for="prix" class="form-label">Price</label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" step="0.01" class="form-control" id="prix" name="prix" value="${produit.prix}" required>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="quantite" class="form-label">Quantity</label>
                                    <input type="number" class="form-control" id="quantite" name="quantite" value="${produit.quantite}" required>
                                </div>

                                <div class="col-md-4">
                                    <label for="categorieId" class="form-label">Category</label>
                                    <select class="form-select" id="categorieId" name="categorieId" required>
                                        <option value="" disabled ${empty produit.categorie ? 'selected' : ''}>Select a category</option>
                                        <c:forEach items="${categories}" var="category">
                                            <option value="${category.id}" ${produit.categorie.id == category.id ? 'selected' : ''}>
                                                ${category.nom}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="image" class="form-label">Image URL (optional)</label>
                                <input type="url" class="form-control" id="image" name="image" value="${produit.image}" placeholder="https://example.com/image.jpg">
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/acceuil" class="btn btn-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary">${nomB}</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
