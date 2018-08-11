package controller;

import business.ApplicationContext;
import business.book.Book;
import business.cart.ShoppingCart;
import viewmodel.CartViewModel;
import viewmodel.HomepageViewModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.HttpConstraint;
import javax.servlet.annotation.ServletSecurity;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
@ServletSecurity(@HttpConstraint(transportGuarantee = ServletSecurity.TransportGuarantee.CONFIDENTIAL))
public class CartServlet extends BookstoreServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("change".equals(action)) {

            //the goal is to access the shopping cart, get the bookID, and eventually get the book out of it

            ShoppingCart cart=(ShoppingCart) request.getSession().getAttribute("cart");

            String bookIdString=request.getParameter("bookId"); //request parameters all returned as strings
            long bookId= Long.parseLong(bookIdString); //change to long to use it

            //we get the instance of the bookDao such as what we did as seen in the CategoryViewModel, then we use find by book id which takes in the long id,
            //returns book
            Book book=ApplicationContext.INSTANCE.getBookDao().findByBookId(bookId);

            //from Dr A's piazza: https://piazza.com/class/jhby2wqxp122?cid=292
            String quantityString=request.getParameter("quantity");
            int quantity=Integer.parseInt(quantityString);

            //use ShoppingCart Item update to update the book count to quantity (the number of items should always update in the header and in the cart page since the cart has updated)
            cart.update(book,quantity);
        }

        if ("clear".equals(action)){

            ShoppingCart cart=(ShoppingCart) request.getSession().getAttribute("cart");
            cart.clear();
        }

        response.sendRedirect(request.getContextPath() + "/cart"); //redirects to the cart page after updating

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setAttribute("p", new CartViewModel(request));

        //go back to BookstoreServlet which has forwardToJSP take in the userPath argument, which should be the urlPattern for /homepage instead of /category
        //this will get a redirection to the homepage.jsp which is what we want (thx Ezequiel) https://canvas.vt.edu/courses/70400/external_tools/2284
        forwardToJsp(request, response, "/cart");

    }
}
