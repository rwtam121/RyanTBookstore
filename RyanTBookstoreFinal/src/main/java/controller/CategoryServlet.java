package controller;

import business.ApplicationContext;
import business.book.Book;
import business.book.BookDao;
import business.cart.ShoppingCart;
import business.category.Category;
import business.category.CategoryDao;
import viewmodel.CategoryViewModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/*

Now create CategoryServlet that extends BookstoreServlet (change from default HttpServlet).
We extend BookstoreServlet bc we want to use the redirect method.

don't forget to add urlPatterns={"/category"} to
the @WebServlet annotation in CategoryServlet; remember testServlet url pattern is  {"/test"}.


When you type in "/category" after the path in your address bar,
 your application will look for a controller servlets with the URL pattern "/category", find this one, and call
 its doGet method (because addresses are GET requests). In the doGet method, use forwardToJsp to forward to
 category.jsp. In forwardToJsp, make sure the userPath is "/category". Run the application. You can type
 ".../category" in the address bat to take you to the category page, but all the formatting will be lost.
 The dropdown menu in the header will *not* take you to the category page.

 Now cannot find /category.jsp but typing category works (even if it is missing the css-->all formatting is lost; dropdown menu
 still references jsp so won't take to category page; because category.jsp is now under WEB-INF but if we omit the jsp
 and type http://localhost:8080/RyanTBookstoreMvvm/category?category=imdb it still brings to category page with lost CSS format)


NEXT STEP:
Make the category buttons use data from your database
Copy the relevant TestServlet code to the CategoryServlet.
--This includes accessing the categoryDAO (to get the category list)--we want business.Category (thats the folder that has
our categories) and java.util.List
--remember the categoryDaoJdbc extending categoryDao has a findAll() which gets the list of all the categories.

In addition, get a list of categories and save
it as a request attribute (do this in the CategoryServlet).
(much like in TestServlet.java we get a list of books by category id and then we set a request.setAttrib to it

To print the category buttons, loop through the
categories with a JSTL forEach loop, and use a JSTL choose statement to print each button, depending on whether it
is the selected category or not. Make sure your category names are capitalized. Note that in the category button links,
you will have to change "category.jsp" to "category". Run the application. Your books won't change, but when you click
on a different category button the selected category should change and the parameter in your address bar should change.

Copy getting the selected category name from the TestServlet.java

 */

@WebServlet(name = "CategoryServlet", urlPatterns = {"/category"} )
public class CategoryServlet extends BookstoreServlet {

    /* post method from add to cart in category page gets redirected to the below doPost request
    * addToCart was taking us tot he /category page because that was the url pattern for the CategoryServlet;
    * doing nothing because we added nothing to doPost at that moment
    *
    * we also have hidden variables like the bookID which we passed to the post method
    * and we passed a hidden variable action=add, so that's what we are tracing back in this post method as well with if
    * add equals action then we know add to cart was pressed
    *
    * in a post operation, just getting the state on the server, and just going back to some page (in this case going back to the category page)
    * not constructing a view model and getting a new page (such as our sub-categories for science, tech, etc)--instead we are changing system state, redirect
    * away. Once we have updated the cart, we are going to redirect the request to the category page. This effectively redirects the request to the doGet method
    * of the category servlet. There are two benefits to this. First, redirecting to a "GET" request ensures that the view model object is created correctly,
    * and second, if you hit the back button on your browser now you won't get any annoying messages asking if you want to submit the form again.
     * */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("add".equals(action)) {
            /*
            Need to get cart. The cart is an attribute in the session scope, so you get the cart (the ShoppingCart object)
            by calling getAttribute from the session object. We just get a reference to the shopping cart in the session (the Shoppingcart was created
            in the BaseViewModel.java, assume that it has already been created bc viewmodel assumes it is not null, so we just get a reference to that cart).

            For the bookID, this was passed as a hidden variable in the post method, so now we can get that bookID as a string
             */

            ShoppingCart cart=(ShoppingCart) request.getSession().getAttribute("cart");
            String bookIdString=request.getParameter("bookId"); //request parameters all returned as strings
            long bookId= Long.parseLong(bookIdString); //change to long to use it

            //we get the instance of the bookDao such as what we did as seen in the CategoryViewModel, then we use find by book id which takes in the long id,
            //returns book
            Book book=ApplicationContext.INSTANCE.getBookDao().findByBookId(bookId);

            //add book to cart
            cart.addItem(book);

            //determines if this is an AJAX request by checking the headers;
            //remember in ajaxPost under ajax-fns.js we added the key-value 'X-Requested-With', 'XMLHttpRequest', so we can check if the request is XMLHttpRequest
            //if true we get a json string with the number of cart items (have those formatting things for json to write to the response)
            //flush buffer so the string doesn't remain in memory ; important to return so we don't refresh the page by going back to category. We can just return
            //Run the project now and you should see an alert that tells you the JSON string that is returned and the value of the ready state (should be 4) when it was returned
            //WITH THIS FIX ALSO, we are overwriting the response text to not get the whole category xml text; we are setting that response to get this json string
            //so we won't get the category text anymore, after the first alert insideAddToCart we then get the cartCount here
            //so we aren't incrementing directly, once we add the book to the cart, we get that updatedd total
            //ANOTHER TRICK IS TO reduce browser size and then use AJAX to add to cart. You can tell the page isn't refreshing because it doesn't go back to the top of the screen,
            //yet if you scroll up you can see the cart has incremented. Previously adding to cart in a reduced screen acted as a scroll up bc we were refreshing the page.
            boolean isAjaxRequest =
                    "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
            if (isAjaxRequest) {
                String jsonString = "{\"cartCount\": " + cart.getNumberOfItems() + "}";
                response.setContentType("application/json");
                response.getWriter().write(jsonString);
                response.flushBuffer();
                return;
            }

        }
        response.sendRedirect(request.getContextPath() + "/category?category=" + request.getParameter("category")); //redirects to the category page, which causes the do get method of the category page to be executed (to get back to the category page you were on)
        //just a msg sent to the browser to reload the page after changing the system (different than forwardtoJSP we see at doGet which builds the page; again POST sendredirect just reloads it)
        //also if we click the back button,  it stops us from trying to change the system again by just reloading the page (rather than enabling the page to add the book again)
        //THIS IS THE POST-REDIRECT-GET SCHEMA .
        //however, when moving away from the default category page and adding items (ie in literature) it moves back toward the default science page. There's nothing in the category page telling the get request
        //that hey, I'm in literautre for example.

        //Change the + "/category" redirect to + "/category?category=" + request.getParameter("category") from the hidden variable input to go back to the category you were last on
        //TEMPORARILY FIX UNSOLVED CAT PROBLEM--FIXES THE PROBLEM!!!! :)
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        /*
        Cleanig up the category servlet is easy. Remove all the code in the doGet method except for the "forwardToJsp" call,
        and right before that call, create a new category view-model and save it as a request attribute named "p".
        p refers to that category view model object.

        Our selected category view model object will have the selected category, the selected books from that category
        (from the getters of CategoryViewModel.java)
        also get the getters from the BaseViewModel.java which it inherits from, where it gets the site image path, book image path, and
        also all the available categories

        p stands for page, so anything that needs to come from the page (in this case the category) will show

        simplifies category servlet significantly
         */
        request.setAttribute("p", new CategoryViewModel(request));

        //go back to BookstoreServlet which has forwardToJSP take in the userPath argument, which should be the urlPattern for /category
        forwardToJsp(request, response, "/category");

    }
}


/*
        INSTRUCTIONS WERE:
        Clean up the category servlet and modify the category JSP
Cleanig up the category servlet is easy. Remove all the code in the doGet method except for the
 "forwardToJsp" call, and right before that call, create a new category view-model and save it as a request
 attribute named "p". All the stuff below from the category servlet is now incorporated into the viewmodel.

 ALL CHANGES MADE BELOW (removed from doGet method above)

        BookDao bookDao=ApplicationContext.INSTANCE.getBookDao();
        CategoryDao categoryDao=ApplicationContext.INSTANCE.getCategoryDao();

        //GET THE SELECTED CATEGORY NAME AND SET IT AS AN ATTRIBUTE
        //The servlet container passes several objects to the servlets
        //it is running. In JSP you can retrieve those objects by using
        //implicit objects. (Slide 7, Java Server Pages)
        String categoryName=request.getParameter("category");

        //if no category name was specified then I make science my default category, otherwise keep as categoryName
        String selectedCategoryName=(categoryName==null)?"science":categoryName;

        //To print the selected category name inside a JSP page, you need to store it in a request attribute in the controller servlet as done below
        //this enables getting the object on the test.jsp to use it
        request.setAttribute("selectedCategoryName", selectedCategoryName);




        //GET THE SELECTED CATEGORY BOOK LIST AND SET IT AS AN ATTRIBUTE (will need to work with the DAO classes)
        //we took this from TestServlet.java (this is how we get the books for the selected category)
        Category selectedCategory=categoryDao.findByName(selectedCategoryName);

        //above returns the category from the dao which we can access its id and match it with the bookDao
        //need to make sure findByCategoryId works (we can fill this up right now) (implement in BookDaoJdbc)-->findByCatID gets list of books
        //had several choices, alt+enter to make the Book part of the BookDaoJDBC
        List<Book> selectedBookList= bookDao.findByCategoryId((selectedCategory).getCategoryId());

        //set an attribute associated with the list object, so now this selectedBookList should be available in the jsp page
        request.setAttribute("selectedBookList", selectedBookList);






        //GET ENTIRE LIST OF CATEGORIES AS AN ATTRIBUTE AS WELL
        List<Category> categoryList= categoryDao.findAll();
        request.setAttribute("categoryList", categoryList);

 */