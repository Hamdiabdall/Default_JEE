-- Database creation
CREATE DATABASE IF NOT EXISTS gestionproduits;
USE gestionproduits;

-- Table creation
CREATE TABLE IF NOT EXISTS Produit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    quantite INT NOT NULL,
    prix DOUBLE NOT NULL
);

-- Sample data (optional)
INSERT INTO Produit (nom, quantite, prix) VALUES 
('Laptop ASUS', 10, 899.99),
('Smartphone Samsung', 15, 499.99),
('Headphones Sony', 20, 79.99),
('Monitor Dell', 8, 249.99),
('Keyboard Logitech', 12, 59.99);

-- Display created data
SELECT * FROM Produit; 