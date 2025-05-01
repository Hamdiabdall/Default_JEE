package dao;

import java.util.List;
import entity.Categorie;

public interface IGestionCategorie {
    // Create a new category
    Categorie addCategorie(Categorie categorie);
    
    // Get a category by ID
    Categorie getCategorie(int id);
    
    // Get all categories
    List<Categorie> getAllCategories();
    
    // Get categories by name match
    List<Categorie> getCategoriesByName(String name);
    
    // Update a category
    Categorie updateCategorie(Categorie categorie);
    
    // Delete a category
    void deleteCategorie(int id);
}
