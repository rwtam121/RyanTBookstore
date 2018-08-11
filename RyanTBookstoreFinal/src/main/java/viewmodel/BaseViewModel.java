package viewmodel;

import business.ApplicationContext;
import business.cart.ShoppingCart;
import business.category.Category;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

public class BaseViewModel {

    // We're moving the initialization parameters to the view model (these initialization parameters were previously in web.xml)
    //create static strings bc everything has access to the viewModel (all other ViewModels extend from this)
    private static final String SITE_IMAGE_PATH = "images/site/";
    private static final String BOOK_IMAGE_PATH = "images/books/";

    //I created a fixed surcharge value here in the BaseViewModel
    //used to be double 5.00
    //private static final int surcharge= 5;

    // Every view model knows the request and session
    protected HttpServletRequest request;
    protected HttpSession session;

    // The header (on all pages) needs to know the categories
    private List<Category> categories;

    //shopping cart is in base view model because it's needed to show the header properly (to update the list of items)
    private ShoppingCart cart;

    private int surcharge;

    // Now initialize the (non-static) fields in the constructor:
    //changed request get session false (creating a new session) to true
    //PROJECT 8 change (done): Set the surcharge when the cart is first created in the BaseViewModel.
    //still works, gets the surcharge from the cart (fix the surcharge there, we pick up that cart value into this model)
    //we didnd't use setter for surcharge since we didn't change that
    public BaseViewModel(HttpServletRequest request) {
        this.request = request;
        this.session = request.getSession(true);
        this.categories = initCategories();
        this.cart=initCart();
        this.surcharge=cart.getSurcharge();
    }

    //We have called an initialization routine for the categories field. Here is the routine:

    /**
     The first line sets the result to the "categories" attribute that is currently *set* in the application.
     Recall that if an attribute has *not* been set and it is accessed, a null value will be returned.
     That is what the if statement checks: if the result is null, the category DAO object is used to create the list of categories
     AND THEN that category list is stored as an attribute in the application. Note that the attribute is stored in the "servlet context",
     which means it is global to the application (has application scope--for the scope fo the web app; an attribute put to server has app scope), and will exist until the application stops running.
     Effectively, the categories object is created (and then stored) one time -- the first time the base view-model code is executed --
     and after that, the view-model simply accesses the globally scoped categories attribute.
     */
    private List<Category> initCategories() {
        List<Category> result = (List<Category>) request.getServletContext().getAttribute("categories");
        if (result == null) {
            result = ApplicationContext.INSTANCE.getCategoryDao().findAll();
            request.getServletContext().setAttribute("categories", result);
        }
        return result;
    }

    /**
     *Above, initCategories creates the list of categories and stores them in the application scope.
     * But we only need cart variable for life of session (stored in BaseViewModel here)
     *
     * So we also create an initCart
     * First, add a field named cart to the BaseViewModel. Then we create a method called "initCart" similar to
     * "initCategories", except that it will store the cart as a session attribute, and when we retrieve it we
     * have to cast it to a ShoppingCart object. As a convention, we will use "cart" to refer to the shopping cart.
     * Note that this is slightly different from what the AffableBean project does - it creates a new shopping cart
     * only when an "Add to Cart" button is clicked the first time. In contrast, we create an empty shopping cart immediately.
     *
     * Not a list of categories, we want to return a cart.
     *
     * We have a request get servletContext for categories, much like we have useBeans for different viewmodels such as for cart.jsp
     * we are looking for attribute named categories inside request.getServletContext there. Initially, we set this servlet context's attribute
     * to the list of categories the CategoryDAOJDBC points us to, so we can recover it through the life of the application.
     *
     * We have page as the narrowest scope, then
     * comes request, then comes session which we use for the cart, then comes application scope.
     *
     * We already had session predefined up top and a session was already created in base view model initialization. So instead of
     * request.getAtt, we use session.getAtt to find for a attribute we call cart
     *
     * we do not have a dao to create a new cart; so no need to go through the DAO. we simply just create a new shopping cart.
     *
     * replace all request.servletContext to session
     */

    private ShoppingCart initCart() {

        ShoppingCart result = (ShoppingCart) session.getAttribute("cart");
        if (result == null) {
            result = new ShoppingCart();
            session.setAttribute("cart", result);
        }
        return result;
    }



    /**
     *Providing getters enables us to treat the view-model as a Java Bean.
     * If the view-model object is stored as an attribute named "p", we can use the expression language within the JSP page to get the categories as: ${p.categories}.
     * Please note that you should not replace your context parameters with the view-model constants in your JSP pages until you have completed your homepage view-model.
     *
     * For BookstoreSession also provide the getter to return the cart (cart is equal to the result from initCart and we can return its value)
     */
    public String getSiteImagePath() { return SITE_IMAGE_PATH; }
    public String getBookImagePath() { return BOOK_IMAGE_PATH; }
    public List<Category> getCategories() { return categories; }
    public ShoppingCart getCart() { return cart; }

    //also a getter for the surcharge to access in anything that inherits from the BaseViewModel (in our case, the checkout.jsp)
    //this is used in checckout.jsp with p.surcharge to display what your credit card will be charged
    public int getSurcharge() { return surcharge; }

    /**
     *
     * we are using the BaseViewModel for our cart, not the CategoryViewModel; the BaseViewModel can get the attribute that was stored into the session by the CategoryViewModel;
     * this is the principle of using "remember" in the CategoryViewModel and "recall" within the BaseViewModel
     * no need to take in parameter of session, we are using the session in the BaseViewModel
     */
    public Category recallSelectedCategory() {
        return (Category) session.getAttribute("selectedCategory");
    }
}
