package dao;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.Query;
import javax.persistence.NoResultException;

import entity.Produit;
import entity.User;

public class UserDaoJPA implements IUserDao {
    private EntityManagerFactory emf;
    private IGestionProduit produitDao;
    
    public UserDaoJPA() {
        emf = Persistence.createEntityManagerFactory("ProduitPU");
        produitDao = new GestionProduitJPA();
    }
    
    @Override
    public User addUser(User user) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(user);
            tx.commit();
            return user;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
    
    @Override
    public User getUser(int id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }
    
    @Override
    public User getUserByUsername(String username) {
        EntityManager em = emf.createEntityManager();
        try {
            Query query = em.createQuery("SELECT u FROM User u WHERE u.username = :username");
            query.setParameter("username", username);
            try {
                return (User) query.getSingleResult();
            } catch (NoResultException e) {
                return null;
            }
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<User> getAllUsers() {
        EntityManager em = emf.createEntityManager();
        try {
            Query query = em.createQuery("SELECT u FROM User u");
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public User updateUser(User user) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User mergedUser = em.merge(user);
            tx.commit();
            return mergedUser;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
    
    @Override
    public void deleteUser(int id) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            User user = em.find(User.class, id);
            if (user != null) {
                em.remove(user);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    
    @Override
    public User authenticate(String username, String password) {
        EntityManager em = emf.createEntityManager();
        try {
            // First try to authenticate by username
            try {
                Query query = em.createQuery("SELECT u FROM User u WHERE u.username = :username AND u.password = :password");
                query.setParameter("username", username);
                query.setParameter("password", password);
                return (User) query.getSingleResult();
            } catch (NoResultException e) {
                // If no result with username, try with email
                try {
                    Query query = em.createQuery("SELECT u FROM User u WHERE u.email = :email AND u.password = :password");
                    query.setParameter("email", username); // Username field might contain email
                    query.setParameter("password", password);
                    return (User) query.getSingleResult();
                } catch (NoResultException e2) {
                    return null;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }
    
    @Override
    public void addToFavorites(int userId, int productId) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            
            // Get managed entities
            User user = em.find(User.class, userId);
            Produit produit = em.find(Produit.class, productId);
            
            if (user != null && produit != null) {
                // Check if product is already in favorites
                boolean alreadyExists = false;
                for (Produit p : user.getFavoriteProducts()) {
                    if (p.getId() == productId) {
                        alreadyExists = true;
                        break;
                    }
                }
                
                if (!alreadyExists) {
                    // Add to favorites using the helper method that manages both sides
                    user.addToFavorites(produit);
                    
                    // Make sure changes are tracked
                    em.merge(user);
                    em.flush();
                }
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    
    @Override
    public void removeFromFavorites(int userId, int productId) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            
            // Get managed entities
            User user = em.find(User.class, userId);
            Produit produit = em.find(Produit.class, productId);
            
            if (user != null && produit != null) {
                // Remove from favorites using the helper method that manages both sides
                user.removeFromFavorites(produit);
                
                // Make sure changes are tracked
                em.merge(user);
                em.flush();
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Produit> getUserFavorites(int userId) {
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, userId);
            if (user != null) {
                // Use a query with fetch join to avoid LazyInitializationException
                Query query = em.createQuery(
                    "SELECT u FROM User u LEFT JOIN FETCH u.favoriteProducts WHERE u.id = :userId");
                query.setParameter("userId", userId);
                
                try {
                    User userWithFavorites = (User) query.getSingleResult();
                    return userWithFavorites.getFavoriteProducts();
                } catch (NoResultException e) {
                    return new ArrayList<>();
                }
            }
            return new ArrayList<>(); // Return empty list instead of null
        } finally {
            em.close();
        }
    }
    
    @Override
    public void addToCart(int userId, int productId, int quantity) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            
            // Get managed entities
            User user = em.find(User.class, userId);
            Produit produit = em.find(Produit.class, productId);
            
            if (user != null && produit != null) {
                // Check if product is already in cart
                boolean alreadyExists = false;
                for (Produit p : user.getCartProducts()) {
                    if (p.getId() == productId) {
                        alreadyExists = true;
                        break;
                    }
                }
                
                if (!alreadyExists) {
                    // Add to cart using the helper method that manages both sides
                    user.addToCart(produit);
                    // Note: In a real app, we'd need a way to store quantity for cart items
                    // Currently we're just storing the many-to-many relationship
                    
                    // Ensure changes are tracked by the persistence context
                    em.merge(user);
                    em.flush();
                }
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    
    @Override
    public void updateCartItemQuantity(int userId, int productId, int quantity) {
        // In a real implementation, we would update a quantity field in the Cart table
        // For this demo, we're just ensuring the relationship exists
        addToCart(userId, productId, quantity);
    }
    
    @Override
    public void removeFromCart(int userId, int productId) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            
            // Get managed entities
            User user = em.find(User.class, userId);
            Produit produit = em.find(Produit.class, productId);
            
            if (user != null && produit != null) {
                // Remove from cart using the helper method that manages both sides
                user.removeFromCart(produit);
                
                // Ensure changes are tracked by the persistence context
                em.merge(user);
                em.flush();
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Produit> getUserCart(int userId) {
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, userId);
            if (user != null) {
                // Use a query with fetch join to avoid LazyInitializationException
                Query query = em.createQuery(
                    "SELECT u FROM User u LEFT JOIN FETCH u.cartProducts WHERE u.id = :userId");
                query.setParameter("userId", userId);
                
                try {
                    User userWithCart = (User) query.getSingleResult();
                    return userWithCart.getCartProducts();
                } catch (NoResultException e) {
                    return new ArrayList<>();
                }
            }
            return new ArrayList<>(); // Return empty list instead of null
        } finally {
            em.close();
        }
    }
}
