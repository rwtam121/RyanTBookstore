package controller;

import viewmodel.ConfirmationViewModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

//need to extend BookstoreServlet to get access to forwardToJsp
//nothing to post for confirmation servlet
@WebServlet(name = "ConfirmationServlet", urlPatterns = {"/confirmation"})
public class ConfirmationServlet extends BookstoreServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        //when we go to the confirmation page, we go to the confirmation view model and then to the confirmation page
        request.setAttribute("p", new ConfirmationViewModel(request));

        //go back to BookstoreServlet which has forwardToJSP take in the userPath argument, which should be the urlPattern for /confirmation
        //this will get a redirection to the confirmation.jsp which is what we want (thx Ezequiel) https://canvas.vt.edu/courses/70400/external_tools/2284
        forwardToJsp(request, response, "/confirmation");

    }
}
