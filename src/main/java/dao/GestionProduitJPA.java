package dao;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.Query;

import entity.Produit;

public class GestionProduitJPA implements IGestionProduit {

	private EntityManagerFactory emf;
	
	public GestionProduitJPA() {
		try {
			emf = Persistence.createEntityManagerFactory("ProduitPU");
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Error initializing database connection: " + e.getMessage());
		}
	}
	
	@Override
	public int countProductsByCategory(int categoryId) {
		EntityManager em = emf.createEntityManager();
		try {
			Query q = em.createQuery("select count(p) from Produit p where p.categorie.id = :categoryId");
			q.setParameter("categoryId", categoryId);
			Long count = (Long) q.getSingleResult();
			return count.intValue();
		} finally {
			em.close();
		}
	}
	
	@Override
	public Produit addProduct(Produit p) {
		EntityManager em = emf.createEntityManager();
		EntityTransaction et = em.getTransaction();
		try {
			et.begin();
			em.persist(p);
			et.commit();
			return p;
		} catch (Exception e) {
			if (et.isActive()) {
				et.rollback();
			}
			e.printStackTrace();
			return null;
		} finally {
			em.close();
		}
	}

	@Override
	public List<Produit> getAllProducts() {
		EntityManager em = emf.createEntityManager();
		try {
			Query q = em.createQuery("select p from Produit p");
			return q.getResultList();
		} finally {
			em.close();
		}
	}

	@Override
	public List<Produit> getProductsByMc(String mc) {
		EntityManager em = emf.createEntityManager();
		try {
			Query q = em.createQuery("select p from Produit p where p.nom like :x");
			q.setParameter("x", "%"+mc+"%");
			return q.getResultList();
		} finally {
			em.close();
		}
	}
	
	@Override
	public List<Produit> getProductsByCategory(int categoryId) {
		EntityManager em = emf.createEntityManager();
		try {
			Query q = em.createQuery("select p from Produit p where p.categorie.id = :categoryId");
			q.setParameter("categoryId", categoryId);
			return q.getResultList();
		} finally {
			em.close();
		}
	}

	@Override
	public Produit getProduct(int id) {
		EntityManager em = emf.createEntityManager();
		try {
			return em.find(Produit.class, id);
		} finally {
			em.close();
		}
	}

	@Override
	public void deleteProduct(int id) {
		EntityManager em = emf.createEntityManager();
		EntityTransaction et = em.getTransaction();
		try {
			et.begin();
			Produit product = em.find(Produit.class, id);
			if (product != null) {
				em.remove(product);
			}
			et.commit();
		} catch (Exception e) {
			if (et.isActive()) {
				et.rollback();
			}
			e.printStackTrace();
		} finally {
			em.close();
		}
	}

	@Override
	public Produit updateProduct(Produit p) {
		EntityManager em = emf.createEntityManager();
		EntityTransaction et = em.getTransaction();
		try {
			et.begin();
			Produit updatedProduct = em.merge(p);
			et.commit();
			return updatedProduct;
		} catch (Exception e) {
			if (et.isActive()) {
				et.rollback();
			}
			e.printStackTrace();
			return null;
		} finally {
			em.close();
		}
	}
}