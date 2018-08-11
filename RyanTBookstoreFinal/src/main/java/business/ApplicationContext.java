
package business;

import business.book.BookDao;
import business.book.BookDaoJdbc;
import business.category.CategoryDao;
import business.category.CategoryDaoJdbc;
import business.customer.CustomerDao;
import business.customer.CustomerDaoJdbc;
import business.order.*;

// TODO: Add the appropriate code for the book DAO.
// (TODO: Add field and getter for BookDao)-->Done (bookDao was needed to use the category ID to find the book list for that category in TestServlet.java)
//application context is a singleton class (only have one of it)-->one database for book, category in this case
//this is what is used instead of dependency injection

public class ApplicationContext {

    private BookDao bookDao;
    private CategoryDao categoryDao;

    //Add all the DAO classes AND OrderService to your application context. The three DAO classes: CustomerDao, OrderDao, and LineItemDao are added in the standard way.
    private CustomerDao customerDao;
    private OrderDao orderDao;
    private LineItemDao lineItemDao;



    private DefaultOrderService orderService;

    //as soon as the AppContext request comes into the servlet, it is going to run (we make an instance of this context in TextServlet to get the databases).
    public static ApplicationContext INSTANCE = new ApplicationContext();

    private ApplicationContext() {

        bookDao=new BookDaoJdbc();
        categoryDao = new CategoryDaoJdbc();

        //these daos are added the standard way
        customerDao=new CustomerDaoJdbc();
        orderDao= new OrderDaoJdbc();
        lineItemDao=new LineItemDaoJdbc();

        //for orderService, provided in step 3 of the instructions:
        //can place an order or get order details; the order details that we create are going to go in our confirmation page
        orderService = new DefaultOrderService();
        DefaultOrderService service = (DefaultOrderService) orderService;
        service.setBookDao(bookDao);
        service.setCustomerDao(customerDao);
        service.setOrderDao(orderDao);
        service.setLineItemDao(lineItemDao);
    }

    public BookDao getBookDao() {
        return bookDao;
    }

    public CategoryDao getCategoryDao() {
        return categoryDao;
    }


    public CustomerDao getCustomerDao() {
        return customerDao;
    }

    public OrderDao getOrderDao() {
        return orderDao;
    }

    public LineItemDao getLineItemDao() {
        return lineItemDao;
    }

    public DefaultOrderService getOrderService() {
        return orderService;
    }
}