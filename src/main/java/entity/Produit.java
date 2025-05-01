package entity;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;

@Entity
public class Produit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String nom;
    private int quantite;
    private double prix;
    private String image;
    private String description;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "categorie_id")
    private Categorie categorie;
    
    @ManyToMany(mappedBy = "favoriteProducts")
    private List<User> usersWhoFavorited = new ArrayList<>();
    
    @ManyToMany(mappedBy = "cartProducts")
    private List<User> usersWhoAddedToCart = new ArrayList<>();

    // Default constructor (needed by JPA)
    public Produit() {}

    // Constructor for new products (without ID)
    public Produit(String nom, int quantite, double prix, String description) {
        this.nom = nom;
        this.quantite = quantite;
        this.prix = prix;
        this.description = description;
    }
    
    // Constructor with category
    public Produit(String nom, int quantite, double prix, String description, Categorie categorie) {
        this.nom = nom;
        this.quantite = quantite;
        this.prix = prix;
        this.description = description;
        this.categorie = categorie;
    }

    // Constructor with ID (for database retrieval)
    public Produit(int id, String nom, double prix, int quantite) {
        this.id = id;
        this.nom = nom;
        this.prix = prix;
        this.quantite = quantite;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public int getQuantite() { return quantite; }
    public void setQuantite(int quantite) { this.quantite = quantite; }

    public double getPrix() { return prix; }
    public void setPrix(double prix) { this.prix = prix; }
    
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Categorie getCategorie() { return categorie; }
    public void setCategorie(Categorie categorie) { this.categorie = categorie; }
    
    public List<User> getUsersWhoFavorited() { return usersWhoFavorited; }
    public void setUsersWhoFavorited(List<User> usersWhoFavorited) { this.usersWhoFavorited = usersWhoFavorited; }
    
    public List<User> getUsersWhoAddedToCart() { return usersWhoAddedToCart; }
    public void setUsersWhoAddedToCart(List<User> usersWhoAddedToCart) { this.usersWhoAddedToCart = usersWhoAddedToCart; }

    @Override
    public String toString() {
        return "Produit [id=" + id + ", nom=" + nom + ", quantite=" + quantite + ", prix=" + prix + 
               ", categorie=" + (categorie != null ? categorie.getNom() : "none") + "]";
    }
}
