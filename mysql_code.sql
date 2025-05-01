-- Database creation
CREATE DATABASE IF NOT EXISTS gestionproduits;
USE gestionproduits;

-- Category table
CREATE TABLE IF NOT EXISTS Categorie (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    description VARCHAR(500)
);

-- Product table with category relationship
CREATE TABLE IF NOT EXISTS Produit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    quantite INT NOT NULL,
    prix DOUBLE NOT NULL,
    image VARCHAR(255),
    description VARCHAR(500),
    categorie_id INT,
    FOREIGN KEY (categorie_id) REFERENCES Categorie(id) ON DELETE SET NULL
);

-- User table with role
CREATE TABLE IF NOT EXISTS User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    role VARCHAR(10) NOT NULL DEFAULT 'USER', -- USER or ADMIN
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default admin user
INSERT INTO User (username, password, nom, prenom, email, role) VALUES
('admin', 'admin123', 'Admin', 'User', 'admin@example.com', 'ADMIN');

-- Favorites (many-to-many relationship between User and Produit)
CREATE TABLE IF NOT EXISTS Favorite (
    user_id INT NOT NULL,
    produit_id INT NOT NULL,
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, produit_id),
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (produit_id) REFERENCES Produit(id) ON DELETE CASCADE
);

-- Cart (many-to-many relationship between User and Produit with quantity)
CREATE TABLE IF NOT EXISTS Cart (
    user_id INT NOT NULL,
    produit_id INT NOT NULL,
    quantite INT NOT NULL DEFAULT 1,
    date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, produit_id),
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (produit_id) REFERENCES Produit(id) ON DELETE CASCADE
);

-- Sample category data
INSERT INTO Categorie (nom, description) VALUES 
('Electronics', 'Electronic devices and accessories'),
('Computers', 'Laptops, desktops and computer accessories'),
('Smartphones', 'Mobile phones and accessories'),
('Audio', 'Headphones, speakers and audio equipment');

-- Sample product data with category
INSERT INTO Produit (nom, quantite, prix, description, categorie_id) VALUES 
('Laptop ASUS', 10, 899.99, 'High-performance laptop for gaming and productivity', 2),
('Smartphone Samsung', 15, 499.99, 'Latest model with advanced camera features', 3),
('Headphones Sony', 20, 79.99, 'Noise-cancelling wireless headphones', 4),
('Monitor Dell', 8, 249.99, '27-inch 4K monitor with HDR support', 2),
('Keyboard Logitech', 12, 59.99, 'Mechanical gaming keyboard with RGB lighting', 2);

-- Sample user data (password: 'user123')
INSERT INTO User (username, password, nom, prenom, email, role) VALUES 
('user1', 'user123', 'John', 'Doe', 'john@example.com', 'USER');

-- Display table data
SELECT * FROM Categorie;
SELECT * FROM Produit;
SELECT * FROM User;