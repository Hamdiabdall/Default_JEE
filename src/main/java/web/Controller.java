package web;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.GestionProduitImplJDBC;
import dao.GestionProduitJPA;
import dao.IGestionProduit;
import entity.Produit;

/**
 * Servlet implementation class Controller
 */
@WebServlet(name = "controllerServlet", urlPatterns = {"", "/", "/acceuil", "/search", "/add", "/delete", "/update"})
public class Controller extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IGestionProduit gestion;

    @Override
    public void init() throws ServletException {
        // Initialize the GestionProduit instance
        gestion = new GestionProduitJPA();
    }

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Controller() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        System.out.println("Servlet path: " + path);

        // Handle the home page or acceuil page
        if (path.equals("") || path.equals("/") || path.equals("/acceuil")) {
            List<Produit> liste = gestion.getAllProducts();
            request.setAttribute("products", liste);
            request.getRequestDispatcher("acceuil2.jsp").forward(request, response);
        }

        // Handle the search functionality
        else if (path.equals("/search")) {
            String mc = request.getParameter("mc");
            List<Produit> produitsByMc = gestion.getProductsByMc(mc);
            request.setAttribute("products", produitsByMc);
            request.getRequestDispatcher("acceuil2.jsp").forward(request, response);
        }

        // Handle the "add product" page (form for adding a new product)
        else if (path.equals("/add")) {
            request.setAttribute("nomB", "Ajouter");
            request.getRequestDispatcher("ajout2.jsp").forward(request, response);
        }

        // Handle the delete product functionality
        else if (path.equals("/delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            gestion.deleteProduct(id);
            response.sendRedirect("acceuil");  // Redirect to the home page after deletion
        }

        // Handle the "update product" page (form for editing an existing product)
        else if (path.equals("/update")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Produit produit = gestion.getProduct(id);
            request.setAttribute("produit", produit);
            request.setAttribute("nomB", "Modifier");
            request.getRequestDispatcher("ajout2.jsp").forward(request, response);
        } else {
            // Handle unknown paths
            response.sendRedirect("acceuil");
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        
        // Handle add and update product forms
        if (path.equals("/add") || path.equals("/update")) {
            String nom = request.getParameter("nom");
            String prixParam = request.getParameter("prix");
            String quantiteParam = request.getParameter("quantite");
            String idParam = request.getParameter("id"); // Get product ID

            // Parse price and quantity
            double prix = Double.parseDouble(prixParam);
            int quantite = Integer.parseInt(quantiteParam);
            int id = idParam.isEmpty() ? 0 : Integer.parseInt(idParam); // Set id to 0 for new products

            // Create the product object
            Produit produit = new Produit(nom, quantite, prix);
            produit.setId(id); // Set the ID to the product object

            // Check if it's an update or add
            if (path.equals("/update")) {
                gestion.updateProduct(produit); // Update product in DB
            } else {
                gestion.addProduct(produit); // Add product to DB
            }

            // Redirect to the home page (acceuil) after updating or adding the product
            response.sendRedirect("acceuil");
        }
    }
}
