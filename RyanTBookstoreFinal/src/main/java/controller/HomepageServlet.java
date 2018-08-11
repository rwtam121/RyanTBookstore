package controller;

import viewmodel.HomepageViewModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.HttpConstraint;
import javax.servlet.annotation.ServletSecurity;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "Homepage", urlPatterns = {"/home"})
@ServletSecurity(@HttpConstraint(transportGuarantee = ServletSecurity.TransportGuarantee.CONFIDENTIAL))
public class HomepageServlet extends BookstoreServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        /*
        Cleanig up the homepage servlet is easy. Remove all the code in the doGet method except for the "forwardToJsp" call,
        and right before that call, create a new category view-model and save it as a request attribute named "p".
        p refers to that category view model object.

        Our selected category view model object will have the selected category, the selected books from that category
        (from the getters of CategoryViewModel.java)
        also get the getters from the BaseViewModel.java which it inherits from, where it gets the site image path, book image path, and
        also all the available categories

        p stands for page, so anything that needs to come from the page (in this case the category) will show

        simplifies category servlet significantly

        NEED TO KEEP AS BEAN P to keep within scope
         */
        request.setAttribute("p", new HomepageViewModel(request));

        //go back to BookstoreServlet which has forwardToJSP take in the userPath argument, which should be the urlPattern for /homepage instead of /category
        //this will get a redirection to the homepage.jsp which is what we want (thx Ezequiel) https://canvas.vt.edu/courses/70400/external_tools/2284
        forwardToJsp(request, response, "/homepage");

    }
}
