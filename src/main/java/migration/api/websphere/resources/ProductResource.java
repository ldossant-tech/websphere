package migration.api.websphere.resources;

import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import migration.api.websphere.models.Product;

import java.util.List;


@Path("/products")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class ProductResource {


    @PersistenceContext(unitName = "appPU")
    EntityManager em;


    @GET
    public List<Product> list() {
        return em.createQuery("select p from Product p", Product.class).getResultList();
    }


    @POST
    @Transactional
    public Product add(Product p) {
        em.persist(p);
        return p;
    }
}