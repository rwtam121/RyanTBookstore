package business.order;

import business.BookstoreDbException;
import business.JdbcUtils;
import business.book.Book;
import business.book.BookDao;
import business.cart.ShoppingCart;
import business.cart.ShoppingCartItem;
import business.customer.Customer;
import business.customer.CustomerDao;
import business.customer.CustomerForm;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

public class DefaultOrderService implements OrderService {

    private OrderDao orderDao;
    private LineItemDao lineItemDao;
    private CustomerDao customerDao;
    private BookDao bookDao;
    private Random random = new Random();

    //placeOrder is invoked by the CheckoutServlet's doPost method after you submit the form in checkout
    //every time you hit the post button it goes to performPlaceOrderTransaction, which creates the customer information
    //using customerDaoJdbc. We created it the first time where customerDao auto-generates a key of 1, even if it is
    //not successful, and it will keep iterating each time you run this
    @Override
    public long placeOrder(CustomerForm form, ShoppingCart cart) {

        try (Connection connection = JdbcUtils.getConnection()) {
            return performPlaceOrderTransaction(form.getName(), form.getAddress(), form.getPhone(), form.getEmail(),
                    form.getCcNumber(), form.getCcExpDate(), cart, connection);
        } catch (SQLException e) { //an exception Dr. K saw was that java.util.Date cannot be cast into a Java.sql.Date
            throw new BookstoreDbException("Error during close connection for customer order", e);
        }
    }

    @Override
    public OrderDetails getOrderDetails(long customerOrderId) {
        Order order = orderDao.findByCustomerOrderId(customerOrderId);
        Customer customer = customerDao.findByCustomerId(order.getCustomerId());
        List<LineItem> lineItems = lineItemDao.findByCustomerOrderId(customerOrderId);
        List<Book> books = lineItems
                .stream()
                .map(lineItem -> bookDao.findByBookId(lineItem.getBookId()))
                .collect(Collectors.toList());

        return new OrderDetails(order, customer, lineItems, books);
    }

    //invoked above within placeOrder; order service places an order with the form contents when posting info from checkout
    private long performPlaceOrderTransaction(String name, String address, String phone, String email,
                                              String ccNumber, Date ccExpDate, ShoppingCart cart,
                                              Connection connection) {
        try {
            //set to false bc not going to commit anything to database unless everything correct
            //this makes the table empty (transaction can also be uncommitted bc of an error)
            connection.setAutoCommit(false);

            //customerDao.create gets a nonzero customer ID if it works, creating customer information
            //we get the customerId first so we can just it for the customerOrder since it is a foreign key for customerOrder
            long customerId = customerDao.create(connection, name, address, phone, email, ccNumber, ccExpDate);

            // orderDao takes in an integer amount (the combination of the cart subtotal and the cart surcharge).
            //associates customer with how much they have to pay (their order)
            //multiply surcharge in 100 because the order total is stored in cents
            long customerOrderId = orderDao.create(connection, cart.getSubtotal() + cart.getSurcharge()*100, generateConfirmationNumber(), customerId);

            //after we create a customer and make that customer place an order, we get into the bones of the order:
            // we create a line item for each
            //book that we bought. The lineItem associates each book with its customer ID (the customer who bought it)
            //as well as the number of those books that were bought
            //then do the customerOrderId and flip with the bookId (fixed that mistake)
            //other issue is that since we aren't generating keys with the lineItem, we're not returning anything.
            //the previous order and customer tables returned those keys, but here for lineItemDao we are not creating any
            //keys so there are no keys to return
            for (ShoppingCartItem item : cart.getItems()) {
                lineItemDao.create(connection, customerOrderId,  item.getBookId(), item.getQuantity());
            }

            //the connection will only commit if the customer, order and line item IDs are all successfully created
            connection.commit();

            return customerOrderId;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (SQLException e1) {
                throw new BookstoreDbException("Failed to roll back transaction", e1);
            }
            return 0;
        }
    }

    private int generateConfirmationNumber() {
        return random.nextInt(999999999);
    }

    public void setOrderDao(OrderDao orderDao) {
        this.orderDao = orderDao;
    }

    public void setLineItemDao(LineItemDao lineItemDao) {
        this.lineItemDao = lineItemDao;
    }

    public void setCustomerDao(CustomerDao customerDao) {
        this.customerDao = customerDao;
    }

    public void setBookDao(BookDao bookDao) {
        this.bookDao = bookDao;
    }

}
