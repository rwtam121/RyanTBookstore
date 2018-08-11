package viewmodel;

import business.ApplicationContext;
import business.book.Book;
import business.book.BookDao;
import business.category.Category;
import business.category.CategoryDao;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

public class CategoryViewModel extends BaseViewModel {


    BookDao bookDao=ApplicationContext.INSTANCE.getBookDao();
    CategoryDao categoryDao=ApplicationContext.INSTANCE.getCategoryDao();


    /**
     Create a class called "CategoryViewModel" in the viewmodel package that inherits from "BaseViewModel".
     The class should have two fields: one that represents the selected category and the other that represents that selected category book list.
     */

    private Category selectedCategory;
    private List<Book> selectedCategoryBooks;

    /**
     Initialize these fields in the constructor.

     Make sure valid names are something found in "category".
     For book and category Daos don't use local variables;  use fields! Place them above, took them from CategoryServlet.java

     Below, our category gets assigned no matter what; in Dr A's github https://github.com/nowucca/SimpleAffableBean/blob/master/src/main/java/viewmodel/CategoryViewModel.java
     he had if categoryId != null; we don't need to do that.

     Also set the session in the category view model.
     */

    public CategoryViewModel(HttpServletRequest request) {
        super(request);

        HttpSession session = request.getSession();

        String categoryName = request.getParameter("category");
        selectedCategory = (isValidName(categoryName)) ?
                categoryDao.findByName(categoryName) :
                categoryDao.findByCategoryId(1);
        selectedCategoryBooks = bookDao.findByCategoryId(selectedCategory.getCategoryId());

        rememberSelectedCategory(session,selectedCategory);
    }

    /** Make sure continue shopping takes you to most recently selected category
     *
     * https://piazza.com/class/jhby2wqxp122?cid=285
     * Dr A's Simple Affable Bean complete code is here: https://github.com/nowucca/SimpleAffableBean/blob/master/src/main/java/viewmodel/CategoryViewModel.java
     *
     * This was taken from Dr A's code
     *
     * BELOW is similar to BaseViewModel's initCart() session.setAttribute which sets cart to a new shopping cart, this sets
     * selectedCategory to our category which was selected in our CategoryViewModel
     * */

    private void rememberSelectedCategory(HttpSession session, Category selectedCategory) {
        session.setAttribute("selectedCategory", selectedCategory);
    }



    /**
     Loop thru categories and make sure the string you are passing in is the same as one of the categories
     Take some inspiration from category.jsp but here is a DISTINCT difference--cannot use category.jsp's useBean bc
     that is only for jsps--previously trying to use it to get the category list. so instead, we have our category dao and I use the find
     all for it. Then we iterate across all categories (in java form; forEach is only for jsps) and see if the category name inputted matches
     anything within the list, if so, return true; otherwise, return false

     change category to equals to get it to work (not ==) because we are dealing with strings
     */
    private boolean isValidName(String categoryName){

        List<Category> allCategories=categoryDao.findAll();

        for (Category cat:allCategories)
        {
            if (cat.getName().equals(categoryName))
            {
                return true;
            }
        }

        return false;
    }

    /**
     Finally, provide getters for the fields b/c this view model is a java bean
     */
    public Category getSelectedCategory() { return selectedCategory; }
    public List<Book> getSelectedCategoryBooks() { return selectedCategoryBooks; }
}
