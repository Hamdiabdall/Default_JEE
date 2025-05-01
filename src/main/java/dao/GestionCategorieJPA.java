package dao;

import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.Query;

import entity.Categorie;

public class GestionCategorieJPA implements IGestionCategorie {
    private EntityManagerFactory emf;
    
    public GestionCategorieJPA() {
        emf = Persistence.createEntityManagerFactory("ProduitPU");
    }
    
    @Override
    public Categorie addCategorie(Categorie categorie) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(categorie);
            tx.commit();
            return categorie;
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
    public Categorie getCategorie(int id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Categorie.class, id);
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Categorie> getAllCategories() {
        EntityManager em = emf.createEntityManager();
        try {
            Query query = em.createQuery("SELECT c FROM Categorie c");
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public List<Categorie> getCategoriesByName(String name) {
        EntityManager em = emf.createEntityManager();
        try {
            Query query = em.createQuery("SELECT c FROM Categorie c WHERE c.nom LIKE :x");
            query.setParameter("x", "%" + name + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    @Override
    public Categorie updateCategorie(Categorie categorie) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Categorie mergedCategorie = em.merge(categorie);
            tx.commit();
            return mergedCategorie;
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
    public void deleteCategorie(int id) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Categorie categorie = em.find(Categorie.class, id);
            if (categorie != null) {
                em.remove(categorie);
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
}
