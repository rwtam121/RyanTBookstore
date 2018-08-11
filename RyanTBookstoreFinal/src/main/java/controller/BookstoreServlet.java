package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/*

Netbeans ecommerce tutorial only has a single controller servlet; for us, we have a controller servlet for every page
 (even one for the cart page). We will have a bookstore servlet that is a controller for all other controllers
 (they inherit from bookstore servlet).

Below takes the path, forwards it to the JSP (testServlet is similar but fixes userPath to userPath="/test")
request and response are taken in from the doGet or doPost methods, and the userPath also specified, with the request forwarded
to the appropriate JSP page.
 */

@WebServlet(name = "Bookstore",
        loadOnStartup = 1)
public class BookstoreServlet extends HttpServlet {

    // Forwards the request to [userPath].jsp
    protected void forwardToJsp(HttpServletRequest request,
                                HttpServletResponse response, String userPath) {
        String url = "/WEB-INF/jsp" + userPath + ".jsp";
        try {
            request.getRequestDispatcher(url).forward(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
