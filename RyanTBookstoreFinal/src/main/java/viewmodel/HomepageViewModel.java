package viewmodel;

import business.ApplicationContext;
import business.book.Book;
import business.book.BookDao;
import business.category.Category;
import business.category.CategoryDao;

import javax.servlet.http.HttpServletRequest;
import java.util.Collections;
import java.util.List;
import java.util.Random;


public class HomepageViewModel extends BaseViewModel {

    /**
     Create a homepage viewmodel class called HomepageViewModel that extends BaseViewModel.
     Don't put any fields in it yet, just create a constructor for it that calls through
     to the BaseViewModel constructor (see the CategoryViewModel).
     Super sets up the request in the base view model.
     */

    //need the categoryDao to determine the number of categories we have
    CategoryDao categoryDao=ApplicationContext.INSTANCE.getCategoryDao();
    BookDao bookDao=ApplicationContext.INSTANCE.getBookDao();



    private Category randomlySelectedCategory;
    private List<Book> selectedRandomCategoryBooks;




    public HomepageViewModel(HttpServletRequest request) {
        super(request);

        //lists all categories
        List<Category> allCategories=categoryDao.findAll();
        int numCategories = allCategories.size();

        Random rand = new Random();

        //need to determine how many categories we have from 0 to numCategories-1
        //we only have 4 categories filled right now (now have 9)
        int n = rand.nextInt(9);

        //java indexing starts at 0 so we can access the specific category in the list
        randomlySelectedCategory=allCategories.get(n);

        //then get category name
        //String categoryName = randomlySelectedCategory.getName();

        //gets list of books
        List<Book> allCategoryBooks = bookDao.findByCategoryId(randomlySelectedCategory.getCategoryId());
        Collections.shuffle(allCategoryBooks);

        //some categories have 0 books so have no items, so in the future can use         if(!allCategoryBooks.isEmpty())

        selectedRandomCategoryBooks=allCategoryBooks.subList(0, 3); //from 0 to 2 (gets 3 items in the list)

    }

    //generated getters for our two fields by right clicking and only generating getters
    public Category getRandomlySelectedCategory() {
        return randomlySelectedCategory;
    }

    public List<Book> getSelectedRandomCategoryBooks() {
        return selectedRandomCategoryBooks;
    }






}
