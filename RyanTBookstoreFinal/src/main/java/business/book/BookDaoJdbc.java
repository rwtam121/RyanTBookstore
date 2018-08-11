package business.book;

import business.JdbcUtils;
import business.category.Category;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import business.BookstoreDbException.BookstoreQueryDbException;

public class BookDaoJdbc implements BookDao {

    private static final String FIND_BY_BOOK_ID_SQL =
            "SELECT book_id, title, author, price, is_public, category_id " +
                    "FROM book " +
                    "WHERE book_id = ?";

    private static final String FIND_BY_CATEGORY_ID_SQL =
            "SELECT book_id, title, author, price, is_public, category_id " +
                    "FROM book " +
                    "WHERE category_id = ?";

	// DONE ABOVE: Create a constant SQL statement for the findByCategory method
	
    @Override
    public Book findByBookId(long bookId) {
        Book book = null;
        try (Connection connection = JdbcUtils.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_BOOK_ID_SQL)) {
            statement.setLong(1, bookId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    book = readBook(resultSet);
                }
            }
        } catch (SQLException e) {
            throw new BookstoreQueryDbException("Encountered a problem finding book " + bookId, e);
        }
        return book;
    }


    //with Dr. K's help we set the category ID
    @Override
    public List<Book> findByCategoryId(long categoryId) {

        List<Book> books= new ArrayList<>();

        try (Connection connection = JdbcUtils.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_CATEGORY_ID_SQL)) {
            statement.setLong(1, categoryId);
            try (ResultSet resultSet = statement.executeQuery()) {
                //since we are using a foreign key (category ID) can be many books so change if conditional to while below
                //then we call the readBook defined below which returns a book, and we put it into our array of books
                while (resultSet.next()) {
                    books.add(readBook(resultSet));
                }
            }
        } catch (SQLException e) { //it is important to create good error msgs
            throw new BookstoreQueryDbException("Encountered a problem finding books with category " + categoryId, e);
        }

    	// TODO: Implement this method.
    
    	return books;
	}    

    private Book readBook(ResultSet resultSet) throws SQLException {
        Long bookId = resultSet.getLong("book_id");
        String title = resultSet.getString("title");
        String author = resultSet.getString("author");
        Integer price = resultSet.getInt("price");
        Boolean isPublic = resultSet.getBoolean("is_public");
        Long categoryId = resultSet.getLong("category_id");
        return new Book(bookId, title, author, price, isPublic, categoryId);
    }

}
