package business.book;

//bookDAO is just the interface, can be accessed via bookDAOJDBC

public class Book {

	//these were all the attributes we used to define our Book in the database, transferring them to class object
	//to make sure it stays immutable, set to final
	private final long bookId;
	private final String title;
	private final String author;
	private final int price;
	private final boolean isPublic;
	private final long categoryId;


	//code-->Generate (alt+insert), select all, we have our constructor

	public Book(long bookId, String title, String author, int price, boolean isPublic, long categoryId) {
		this.bookId = bookId;
		this.title = title;
		this.author = author;
		this.price = price;
		this.isPublic = isPublic;
		this.categoryId = categoryId;
	}

	//do the same alt+insert for getters (no need for setters since these are immutable) Dr K concerned about the public class aspect

	public long getBookId() {
		return bookId;
	}

	public String getTitle() {
		return title;
	}

	public String getAuthor() {
		return author;
	}

	public int getPrice() {
		return price;
	}

	//For the boolean isPublic field, IntelliJ will generate a getter named isPublic. In order for this method to work with the Java expression language, change the name to getIsPublic
	//previously was isPublic from the getter and returning isPublic and that was tripping it up
	public boolean getIsPublic() {
		return isPublic;
	}

	public long getCategoryId() {
		return categoryId;
	}

	//have a toString method (alt+insert)

	@Override
	public String toString() {
		return "Book{" +
				"bookId=" + bookId +
				", title='" + title + '\'' +
				", author='" + author + '\'' +
				", price=" + price +
				", isPublic=" + isPublic +
				", categoryId=" + categoryId +
				'}';
	}


	/*
	 * TODO: Create private fields corresponding to the fields in the
	 * book table of your database. Generate a constructor that
	 * uses those fields. Generate getter methods for those fields,
	 * and generate a toString method that uses those fields.
	 *
	 * These classes are immutable and singletons so we don't have to worry about threading problems.
	 * Most of the operations are reading things out of the database (database changes, class objects out of the database cannot be changed)
	 */
}
