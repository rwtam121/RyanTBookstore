package controller;

import business.ApplicationContext;
import business.book.Book;
import business.book.BookDao;
import business.category.Category;
import business.category.CategoryDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

//To disclose the target  (test.jsp, hidden in WEB-INF) create a controller servlet

//WebServlet annotation set attribute name to "Test" (instead of "TestServlet").
//Create an attribute urlPatterns inside the annotation and set it to {"/test"}; look for a controller servlet
//that has the "/test" URL pattern
@WebServlet(name = "Test", urlPatterns = {"/test"})
public class TestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        //as soon as the AppContext request comes into the servlet, it is going to run
        //the DAO allows to access database, so get books from specific category here, get both book and category daos
        //In your controller servlet, you need to create variables to hold the DAO objects: a category-dao and a book-dao.
        //both daos are local variables initialized here (can be initialized at every request)
        BookDao bookDao=ApplicationContext.INSTANCE.getBookDao();

        CategoryDao categoryDao=ApplicationContext.INSTANCE.getCategoryDao();

        //with the category-dao and book-dao, you can use them to access objects from the database.
        // Ultimately, you want the list of books associated with the selected category. (see GET SELECTED CATEGORY BOOK LIST)



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
        Category selectedCategory=categoryDao.findByName(selectedCategoryName);

        //above returns the category from the dao which we can access its id and match it with the bookDao
        //need to make sure findByCategoryId works (we can fill this up right now) (implement in BookDaoJdbc)-->findByCatID gets list of books
        //had several choices, alt+enter to make the Book part of the BookDaoJDBC
        List<Book> selectedBookList= bookDao.findByCategoryId((selectedCategory).getCategoryId());

        //set an attribute associated with the list object, so now this selectedBookList should be available in the jsp page
        request.setAttribute("selectedBookList", selectedBookList);






        //Inside the doGet method, create a String variable named userPath with a value of "/test
        String userPath="/test";

        //Then create a String variable named url with a value "/WEB-INF/jsp" + userPath + ".jsp".
        String url="/WEB-INF/jsp" + userPath + ".jsp";

        //Use the url to get the request dispatcher from request, and then call the forward method,
        // passing in the request and response objects. This will dispatch the request to the test.jsp page.
        request.getRequestDispatcher(url).forward(request, response);

        //Now run the application. In the address bar, type in "test" after the application context. Your should be able to see your table again. (not test.jsp)
        //test looks for a controller servlet with this pattern (the "/test" pattern specified in urlPatterns)-->if it finds the pattern, executes the do get method
        //b/c when you type something in address bar like we did for http://localhost:8080/RyanTBookstoreDao/test it is a get request.
        //set up controller servlet for test.jsp, so can see it.

    }
}
