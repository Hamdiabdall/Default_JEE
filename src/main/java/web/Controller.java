package web;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.GestionCategorieJPA;
import dao.GestionProduitJPA;
import dao.IGestionCategorie;
import dao.IGestionProduit;
import dao.IUserDao;
import dao.UserDaoJPA;
import entity.Categorie;
import entity.Produit;
import entity.User;

/**
 * Servlet implementation class Controller
 */
@WebServlet(name = "controllerServlet", urlPatterns = {
    "", "/", "/acceuil", "/search", 
    "/product/add", "/product/delete", "/product/update", "/product/view",
    "/category/list", "/category/add", "/category/update", "/category/delete",
    "/login", "/logout", "/register", "/profile",
    "/favorites/add", "/favorites/remove", "/favorites/list",
    "/cart/add", "/cart/update", "/cart/remove", "/cart/view"
})
public class Controller extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IGestionProduit produitDao;
    private IGestionCategorie categorieDao;
    private IUserDao userDao;

    @Override
    public void init() throws ServletException {
        // Initialize the DAO instances
        produitDao = new GestionProduitJPA();
        categorieDao = new GestionCategorieJPA();
        userDao = new UserDaoJPA();
    }

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Controller() {
        super();
    }
    
    /**
     * Check if the user is authenticated
     */
    private boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession();
        return session.getAttribute("user") != null;
    }
    
    /**
     * Check if the user is an admin
     */
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        return user != null && user.isAdmin();
    }
    
    /**
     * Redirect to login page if not authenticated
     */
    private boolean checkAuthentication(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isAuthenticated(request)) {
            response.sendRedirect("login");
            return false;
        }
        return true;
    }
    
    /**
     * Redirect to home page if not admin
     */
    private boolean checkAdminRights(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("acceuil");
            return false;
        }
        return true;
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        System.out.println("Servlet path: " + path);

        // ===== PUBLIC PAGES =====
        
        // Login page
        if (path.equals("/login")) {
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        // Registration page
        else if (path.equals("/register")) {
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Logout
        else if (path.equals("/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login");
            return;
        }
        
        // ===== PROTECTED PAGES (Require login) =====
        
        // Handle the home page or acceuil page
        if (path.equals("") || path.equals("/") || path.equals("/acceuil")) {
            if (!checkAuthentication(request, response)) return;
            
            List<Produit> liste = null;
            List<Categorie> categories = null;
            
            try {
                // Get sort parameter
                String sort = request.getParameter("sort");
                // Get category filter parameter
                String categoryIdParam = request.getParameter("categoryId");
                
                // Filter by category if specified
                if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                    try {
                        int categoryId = Integer.parseInt(categoryIdParam);
                        liste = produitDao.getProductsByCategory(categoryId);
                        // Set the selected category for highlighting in UI
                        request.setAttribute("selectedCategoryId", categoryId);
                    } catch (NumberFormatException e) {
                        liste = produitDao.getAllProducts();
                    }
                } else {
                    liste = produitDao.getAllProducts();
                }
                
                // Sort the products if sort parameter is specified
                if (sort != null && !sort.isEmpty()) {
                    switch (sort) {
                        case "name_asc":
                            liste.sort((p1, p2) -> p1.getNom().compareToIgnoreCase(p2.getNom()));
                            break;
                        case "name_desc":
                            liste.sort((p1, p2) -> p2.getNom().compareToIgnoreCase(p1.getNom()));
                            break;
                        case "price_asc":
                            liste.sort((p1, p2) -> Double.compare(p1.getPrix(), p2.getPrix()));
                            break;
                        case "price_desc":
                            liste.sort((p1, p2) -> Double.compare(p2.getPrix(), p1.getPrix()));
                            break;
                    }
                    // Set the selected sort for highlighting in UI
                    request.setAttribute("selectedSort", sort);
                }
                
                categories = categorieDao.getAllCategories();
            } catch (Exception e) {
                e.printStackTrace();
                liste = new ArrayList<>();
                categories = new ArrayList<>();
            }
            
            request.setAttribute("products", liste);
            request.setAttribute("categories", categories);
            request.setAttribute("isAdmin", isAdmin(request));
            
            request.getRequestDispatcher("/acceuil2.jsp").forward(request, response);
        }

        // Handle the search functionality
        else if (path.equals("/search")) {
            if (!checkAuthentication(request, response)) return;
            
            List<Produit> produits = null;
            List<Categorie> categories = categorieDao.getAllCategories();
            
            // Search by keyword
            String mc = request.getParameter("mc");
            if (mc != null && !mc.isEmpty()) {
                produits = produitDao.getProductsByMc(mc);
                request.setAttribute("mc", mc);
            } 
            
            // Filter by category
            String categoryIdParam = request.getParameter("categoryId");
            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryIdParam);
                    produits = produitDao.getProductsByCategory(categoryId);
                    request.setAttribute("selectedCategoryId", categoryId);
                } catch (NumberFormatException e) {
                    if (produits == null) {
                        produits = produitDao.getAllProducts();
                    }
                }
            }
            
            // If no filters applied, get all products
            if (produits == null) {
                produits = produitDao.getAllProducts();
            }
            
            // Sort the products if sort parameter is specified
            String sort = request.getParameter("sort");
            if (sort != null && !sort.isEmpty()) {
                switch (sort) {
                    case "name_asc":
                        produits.sort((p1, p2) -> p1.getNom().compareToIgnoreCase(p2.getNom()));
                        break;
                    case "name_desc":
                        produits.sort((p1, p2) -> p2.getNom().compareToIgnoreCase(p1.getNom()));
                        break;
                    case "price_asc":
                        produits.sort((p1, p2) -> Double.compare(p1.getPrix(), p2.getPrix()));
                        break;
                    case "price_desc":
                        produits.sort((p1, p2) -> Double.compare(p2.getPrix(), p1.getPrix()));
                        break;
                }
                request.setAttribute("selectedSort", sort);
            }
            
            request.setAttribute("products", produits);
            request.setAttribute("categories", categories);
            request.setAttribute("isAdmin", isAdmin(request));
            
            request.getRequestDispatcher("/acceuil2.jsp").forward(request, response);
        }
        
        // View product details
        else if (path.equals("/product/view")) {
            if (!checkAuthentication(request, response)) return;
            
            int id = Integer.parseInt(request.getParameter("id"));
            Produit produit = produitDao.getProduct(id);
            
            request.setAttribute("produit", produit);
            request.setAttribute("isAdmin", isAdmin(request));
            
            // Forward to product/productDetails.jsp instead of view.jsp
            request.getRequestDispatcher("/product/productDetails.jsp").forward(request, response);
        }

        // ===== ADMIN PAGES (Require admin login) =====
        
        // Handle the "add product" page (form for adding a new product)
        else if (path.equals("/product/add")) {
            if (!checkAuthentication(request, response)) return;
            if (!checkAdminRights(request, response)) return;
            
            List<Categorie> categories = categorieDao.getAllCategories();
            request.setAttribute("categories", categories);
            request.setAttribute("nomB", "Ajouter");
            request.getRequestDispatcher("/ajout2.jsp").forward(request, response);
        }

        // Handle the delete product functionality
        else if (path.equals("/product/delete")) {
            if (!checkAuthentication(request, response)) return;
            if (!checkAdminRights(request, response)) return;
            
            int id = Integer.parseInt(request.getParameter("id"));
            produitDao.deleteProduct(id);
            response.sendRedirect(request.getContextPath() + "/acceuil");
        }

        // Handle the "update product" page (form for editing an existing product)
        else if (path.equals("/product/update")) {
            if (!checkAuthentication(request, response)) return;
            if (!checkAdminRights(request, response)) return;
            
            int id = Integer.parseInt(request.getParameter("id"));
            Produit produit = produitDao.getProduct(id);
            List<Categorie> categories = categorieDao.getAllCategories();
            
            request.setAttribute("produit", produit);
            request.setAttribute("categories", categories);
            request.setAttribute("nomB", "Modifier");
            request.getRequestDispatcher("/ajout2.jsp").forward(request, response);
        }
        
        // Category management
        else if (path.equals("/category/list")) {
            if (!checkAuthentication(request, response)) return;
            if (!checkAdminRights(request, response)) return;
            
            List<Categorie> categories = categorieDao.getAllCategories();
            
            // Create a map of category ID to product count
            java.util.Map<Integer, Integer> categoryProductCounts = new java.util.HashMap<>();
            for (Categorie category : categories) {
                int productCount = produitDao.countProductsByCategory(category.getId());
                categoryProductCounts.put(category.getId(), productCount);
            }
            
            request.setAttribute("categories", categories);
            request.setAttribute("categoryProductCounts", categoryProductCounts);
            // Forward to categories.jsp in the root webapp directory
            request.getRequestDispatcher("/categories.jsp").forward(request, response);
        }
        
        else if (path.equals("/category/add")) {
            if (!checkAuthentication(request, response)) return;
            if (!checkAdminRights(request, response)) return;
            
            request.setAttribute("nomB", "Ajouter");
            request.getRequestDispatcher("/ajoutCategorie.jsp").forward(request, response);
        }
        
        else if (path.equals("/category/update")) {
            if (!checkAuthentication(request, response)) return;
            if (!checkAdminRights(request, response)) return;
            
            int id = Integer.parseInt(request.getParameter("id"));
            Categorie categorie = categorieDao.getCategorie(id);
            
            request.setAttribute("categorie", categorie);
            request.setAttribute("nomB", "Modifier");
            request.getRequestDispatcher("/ajoutCategorie.jsp").forward(request, response);
        }
        
        // ===== USER FEATURES =====
        
        // User profile
        else if (path.equals("/profile")) {
            if (!checkAuthentication(request, response)) return;
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            request.setAttribute("user", user);
            // Forward directly to /profile.jsp without context path
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        }
        
        // Favorites management
        else if (path.equals("/favorites/list")) {
            if (!checkAuthentication(request, response)) return;
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            List<Produit> favorites = userDao.getUserFavorites(user.getId());
            request.setAttribute("favorites", favorites);
            // Forward directly to favorites/favorites.jsp instead of list.jsp
            request.getRequestDispatcher("/favorites/favorites.jsp").forward(request, response);
        }
        
        else if (path.equals("/favorites/add")) {
            if (!checkAuthentication(request, response)) return;
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            userDao.addToFavorites(user.getId(), productId);
            
            // Redirect back to the previous page or product list
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/acceuil");
        }
        
        else if (path.equals("/favorites/remove")) {
            if (!checkAuthentication(request, response)) return;
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            userDao.removeFromFavorites(user.getId(), productId);
            
            // Redirect back to the previous page or favorites list
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : request.getContextPath() + "/favorites/list");
        }
        
        // Cart management
        else if (path.equals("/cart/view")) {
            if (!checkAuthentication(request, response)) return;
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            List<Produit> cartItems = userDao.getUserCart(user.getId());
            request.setAttribute("cartItems", cartItems);
            // Forward directly to cart/cart.jsp instead of view.jsp
            request.getRequestDispatcher("/cart/cart.jsp").forward(request, response);
        }
        
        else if (path.equals("/cart/add")) {
            if (!checkAuthentication(request, response)) return;
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            userDao.addToCart(user.getId(), productId, quantity);
            
            // Get the referer to redirect back to the same page
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                response.sendRedirect(referer);
            } else {
                // Fallback to product list
                response.sendRedirect(request.getContextPath() + "/acceuil");
            }
        }
        
        else if (path.equals("/cart/update")) {
            if (!checkAuthentication(request, response)) return;
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            userDao.updateCartItemQuantity(user.getId(), productId, quantity);
            
            // Redirect back to cart
            response.sendRedirect(request.getContextPath() + "/cart/view");
        }
        
        else if (path.equals("/cart/remove")) {
            if (!checkAuthentication(request, response)) return;
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            userDao.removeFromCart(user.getId(), productId);
            
            // Always redirect back to cart view
            response.sendRedirect(request.getContextPath() + "/cart/view");
        }
        
        else {
            // Handle unknown paths
            response.sendRedirect(request.getContextPath() + "/acceuil");
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Handle login form
        if (path.equals("/login")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            User user = userDao.authenticate(username, password);
            
            if (user != null) {
                // Store user in session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                // Redirect to home page
                response.sendRedirect(request.getContextPath() + "/acceuil");
            } else {
                // Authentication failed
                request.setAttribute("errorMessage", "Invalid username or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        }
        
        // Handle registration form
        else if (path.equals("/register")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            
            // Check if username already exists
            User existingUser = userDao.getUserByUsername(username);
            if (existingUser != null) {
                request.setAttribute("errorMessage", "Username already exists");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            
            // Create new user
            User newUser = new User(username, password, nom, prenom, email, "USER");
            userDao.addUser(newUser);
            
            // Redirect to login page
            request.setAttribute("successMessage", "Registration successful. Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
        
        // Handle add and update product forms
        else if (path.equals("/product/add") || path.equals("/product/update")) {
            if (!checkAuthentication(request, response)) return;
            if (!checkAdminRights(request, response)) return;
            
            String nom = request.getParameter("nom");
            String prixParam = request.getParameter("prix");
            String quantiteParam = request.getParameter("quantite");
            String description = request.getParameter("description");
            String categorieIdParam = request.getParameter("categorieId");
            String image = request.getParameter("image"); // Read the image URL
            String idParam = request.getParameter("id"); // Get product ID

            // Parse numeric parameters
            double prix = Double.parseDouble(prixParam);
            int quantite = Integer.parseInt(quantiteParam);
            int categorieId = Integer.parseInt(categorieIdParam);
            int id = (idParam == null || idParam.isEmpty()) ? 0 : Integer.parseInt(idParam); // Set id to 0 for new products

            // Get the category
            Categorie categorie = categorieDao.getCategorie(categorieId);
            
            // Create the product object
            Produit produit = new Produit(nom, quantite, prix, description, categorie);
            produit.setImage(image); // Set the image URL
            produit.setId(id); // Set the ID for update case

            // Check if it's an update or add
            if (path.equals("/product/update")) {
                produitDao.updateProduct(produit); // Update product in DB
            } else {
                produitDao.addProduct(produit); // Add product to DB
            }

            // Redirect to the home page after updating or adding the product
            response.sendRedirect(request.getContextPath() + "/acceuil");
        }
        
        // Handle add and update category forms
        else if (path.equals("/category/add") || path.equals("/category/update")) {
            if (!checkAuthentication(request, response)) return;
            if (!checkAdminRights(request, response)) return;
            
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");
            String idParam = request.getParameter("id"); // Get category ID

            // Create the category object
            Categorie categorie = new Categorie(nom, description);
            
            // If updating, set the ID
            if (path.equals("/category/update") && idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                categorie.setId(id);
                categorieDao.updateCategorie(categorie);
            } else {
                categorieDao.addCategorie(categorie);
            }

            // Redirect to the category list
            response.sendRedirect(request.getContextPath() + "/category/list");
        }
        
        // Handle user profile update
        else if (path.equals("/profile")) {
            if (!checkAuthentication(request, response)) return;
            
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            
            // Get form parameters
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            
            // Update user object
            currentUser.setNom(nom);
            currentUser.setPrenom(prenom);
            currentUser.setEmail(email);
            
            // Update password if provided
            if (password != null && !password.isEmpty()) {
                currentUser.setPassword(password);
            }
            
            // Save changes
            User updatedUser = userDao.updateUser(currentUser);
            
            // Update session
            session.setAttribute("user", updatedUser);
            
            // Redirect back to profile with success message
            request.setAttribute("successMessage", "Profile updated successfully");
            request.setAttribute("user", updatedUser);
            // Forward directly to /profile.jsp without context path
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        }
    }
}
