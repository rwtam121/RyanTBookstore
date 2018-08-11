package business.book;

import java.util.List;

public interface BookDao {

    public Book findByBookId(long bookId);

    public List<Book> findByCategoryId(long categoryId);

}
