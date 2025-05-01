package dao;

import java.util.List;
import entity.Produit;
import entity.User;

public interface IUserDao {
    // User CRUD operations
    User addUser(User user);
    User getUser(int id);
    User getUserByUsername(String username);
    List<User> getAllUsers();
    User updateUser(User user);
    void deleteUser(int id);
    
    // Authentication
    User authenticate(String username, String password);
    
    // Favorites management
    void addToFavorites(int userId, int productId);
    void removeFromFavorites(int userId, int productId);
    List<Produit> getUserFavorites(int userId);
    
    // Cart management
    void addToCart(int userId, int productId, int quantity);
    void updateCartItemQuantity(int userId, int productId, int quantity);
    void removeFromCart(int userId, int productId);
    List<Produit> getUserCart(int userId);
}
