package entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

@Entity
public class Categorie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String nom;
    private String description;
    
    @OneToMany(mappedBy = "categorie", cascade = CascadeType.ALL)
    private List<Produit> produits = new ArrayList<>();
    
    // Default constructor (needed by JPA)
    public Categorie() {}
    
    // Constructor without ID
    public Categorie(String nom, String description) {
        this.nom = nom;
        this.description = description;
    }
    
    // Constructor with ID
    public Categorie(int id, String nom, String description) {
        this.id = id;
        this.nom = nom;
        this.description = description;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getNom() {
        return nom;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public List<Produit> getProduits() {
        return produits;
    }
    
    public void setProduits(List<Produit> produits) {
        this.produits = produits;
    }
    
    // Helper method to add a product to this category
    public void addProduit(Produit produit) {
        produits.add(produit);
        produit.setCategorie(this);
    }
    
    // Helper method to remove a product from this category
    public void removeProduit(Produit produit) {
        produits.remove(produit);
        produit.setCategorie(null);
    }
    
    @Override
    public String toString() {
        return "Categorie [id=" + id + ", nom=" + nom + ", description=" + description + "]";
    }
}
