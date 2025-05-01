package dao;

import java.util.List;

import entity.Produit;

public interface IGestionProduit {
	Produit addProduct(Produit p);
	List<Produit> getAllProducts();
	List<Produit> getProductsByMc(String mc);
	List<Produit> getProductsByCategory(int categoryId);
	Produit getProduct(int id);
	Produit updateProduct(Produit p);
	void deleteProduct(int id);
	
	// New method to count products by category
	int countProductsByCategory(int categoryId);
}