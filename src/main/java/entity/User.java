package entity;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "User")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    
    @Column(unique = true, nullable = false)
    private String username;
    
    @Column(nullable = false)
    private String password;
    
    private String nom;
    private String prenom;
    
    @Column(unique = true)
    private String email;
    
    @Column(nullable = false)
    private String role = "USER"; // USER or ADMIN
    
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_creation")
    private Date dateCreation = new Date();
    
    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
        name = "Favorite",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "produit_id")
    )
    private List<Produit> favoriteProducts = new ArrayList<>();
    
    @ManyToMany(fetch = FetchType.LAZY, cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
        name = "Cart",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "produit_id")
    )
    private List<Produit> cartProducts = new ArrayList<>();
    
    // Default constructor (needed by JPA)
    public User() {}
    
    // Constructor with required fields
    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role = role;
    }
    
    // Constructor with all fields
    public User(String username, String password, String nom, String prenom, String email, String role) {
        this.username = username;
        this.password = password;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.role = role;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getNom() {
        return nom;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public String getPrenom() {
        return prenom;
    }
    
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public Date getDateCreation() {
        return dateCreation;
    }
    
    public void setDateCreation(Date dateCreation) {
        this.dateCreation = dateCreation;
    }
    
    public List<Produit> getFavoriteProducts() {
        return favoriteProducts;
    }
    
    public void setFavoriteProducts(List<Produit> favoriteProducts) {
        this.favoriteProducts = favoriteProducts;
    }
    
    public List<Produit> getCartProducts() {
        return cartProducts;
    }
    
    public void setCartProducts(List<Produit> cartProducts) {
        this.cartProducts = cartProducts;
    }
    
    // Helper methods for managing favorites
    public void addToFavorites(Produit produit) {
        // Check if already in favorites to avoid duplicates
        if (!favoriteProducts.contains(produit)) {
            favoriteProducts.add(produit);
            produit.getUsersWhoFavorited().add(this);
        }
    }
    
    public void removeFromFavorites(Produit produit) {
        favoriteProducts.remove(produit);
        produit.getUsersWhoFavorited().remove(this);
    }
    
    // Helper methods for managing cart
    public void addToCart(Produit produit) {
        if (!cartProducts.contains(produit)) {
            cartProducts.add(produit);
            produit.getUsersWhoAddedToCart().add(this);
        }
    }
    
    public void removeFromCart(Produit produit) {
        cartProducts.remove(produit);
        produit.getUsersWhoAddedToCart().remove(this);
    }
    
    // Check if user is admin
    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }
    
    @Override
    public String toString() {
        return "User [id=" + id + ", username=" + username + ", nom=" + nom + ", prenom=" + prenom + ", email=" + email
                + ", role=" + role + "]";
    }
}
