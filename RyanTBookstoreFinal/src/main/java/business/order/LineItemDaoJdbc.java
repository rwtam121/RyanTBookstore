package business.order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static business.JdbcUtils.getConnection;

import business.BookstoreDbException.BookstoreQueryDbException;
import business.BookstoreDbException.BookstoreUpdateDbException;

//the line item table is a "join" table since it has a many to many relationship between the customer
//there is no auto-incremented keys or primary keys (unlike customer_order which maps to auto-gen'd customer id, and also
//autogens a customer order id; the customer table autogens customer id). The keys are just foreign (customerOrderId
//to custOrder table, bookId to the book table.

//So this is the error; compare this LineItemDaoJdbc to OrderDaoJdbc; connection.prepareStatement for orderDao
//has Statement.ReturnGeneratedKeys; this one does not, yet due to copying and pasting still has a
//statement.getGeneratedKeys() even though no keys existed (since we didn't generate them here). So it should
//fail to retrieve the auto-generated key; this isn't a database error, but this means we still get an error
public class LineItemDaoJdbc implements LineItemDao {

    //Dr K just refactored to start with customer_order_id and then book_id so we need to change order
    //of CREATE_LINE_ITEM_SQL
    private static final String CREATE_LINE_ITEM_SQL =
            "INSERT INTO customer_order_line_item (customer_order_id,book_id, quantity) " +
                    "VALUES (?, ?, ?)";

    private static final String FIND_BY_CUSTOMER_ORDER_ID_SQL =
            "SELECT book_id, customer_order_id, quantity " +
                    "FROM customer_order_line_item WHERE customer_order_id = ?";

    //since there is no key returned for lineItemDaoJdbc now, let's make it a void statement
    @Override
    public void create(Connection connection, long customerOrderId, long bookId, int quantity) {
        try (PreparedStatement statement = connection.prepareStatement(CREATE_LINE_ITEM_SQL)) {
            //and change customerOrderId to be first, bookId to be second
            statement.setLong(1, customerOrderId);
            statement.setLong(2, bookId);
            statement.setInt(3, quantity);
            int affected = statement.executeUpdate();
            if (affected != 1) {
                throw new BookstoreUpdateDbException("Failed to insert an order line item, affected row count = " + affected);
            }
        } catch (SQLException e) {
            throw new BookstoreQueryDbException("Encountered problem creating a new line item ", e);
        }
    }

    @Override
    public List<LineItem> findByCustomerOrderId(long customerOrderId) {
        List<LineItem> result = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_CUSTOMER_ORDER_ID_SQL)) {
            statement.setLong(1, customerOrderId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    result.add(readLineItem(resultSet));
                }
            }
        } catch (SQLException e) {
            throw new BookstoreQueryDbException("Encountered problem finding ordered books for customer order "
                    + customerOrderId, e);
        }
        return result;
    }

    private LineItem readLineItem(ResultSet resultSet) throws SQLException {
        long bookId = resultSet.getLong("book_id");
        long customerOrderId = resultSet.getLong("customer_order_id");
        int quantity = resultSet.getInt("quantity");
        return new LineItem(bookId, customerOrderId, quantity);
    }
}
