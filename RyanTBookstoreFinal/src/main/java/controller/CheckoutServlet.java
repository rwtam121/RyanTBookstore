package controller;

import business.ApplicationContext;
import business.cart.ShoppingCart;
import business.customer.CustomerForm;
import business.order.OrderDetails;
import business.order.OrderService;
import viewmodel.CheckoutViewModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.HttpConstraint;
import javax.servlet.annotation.ServletSecurity;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;

//Specifying that the connection requires encryption for all HTTP methods: with ServletSecurity (Proj9)

@WebServlet(name = "Checkout",
        urlPatterns = {"/checkout"})
@ServletSecurity(@HttpConstraint(transportGuarantee = ServletSecurity.TransportGuarantee.CONFIDENTIAL))
public class CheckoutServlet extends BookstoreServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws ServletException, IOException {

        request.setAttribute("p", new CheckoutViewModel(request));
        forwardToJsp(request, response, "/checkout");
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        ShoppingCart cart = (ShoppingCart) session.getAttribute("cart");

        String name = request.getParameter("name");
        //name is attained from checkout.jsp checkoutForm, where you can post the name and take in the value from the text field

        String phone = request.getParameter("phone");
        //we also added phone in the form list, so we can pass in the phone parameter (also in checkout jsp POST method) which is needed to create the customer form

        //recreate the date from ccMonth and ccYear so we can remember it if it is legitimate
        String month=request.getParameter("ccMonth");
        String year=request.getParameter("ccYear");

        //all these parameters are part of the checkout.jsp names as mentioned; no need to store the credit card number
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String ccNumber = request.getParameter("ccNumber");


        /**
         * I thought about setting a date object based on month and year and passing it in, but no need; just pass in string month and year
         *
         *
         *         //similar to CustomerForm getCcExpDate, get the passed month and year values from the user and recreate date in customerForm
         *         Calendar calend = Calendar.getInstance(); //initialized with current date and time (default tiemzone/locale)
         *         //since it is a string, need to take the integer value and pass it to month
         *         calend.set(Calendar.MONTH, Integer.parseInt(month));
         *         calend.set(Calendar.YEAR, Integer.parseInt(year));
         *         Date date = calend.getTime();
         *
         */

        //recreating the customer form when posting remembers all the data the user supplied
        CustomerForm customerForm = new CustomerForm(name, phone, month, year, address, email, ccNumber);
        session.setAttribute("customerForm", customerForm);

        // this should never happen...
        //from cart to checkout page the checkout only shows if a cart item exists, so this shouldn't occur
        if (cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        //why if a field error exists (in our case a name or phone error), we get a validation error which is reported back to the checkout.jsp top header (p.hasValidationError)
        //and we get redirected back to the checkout page to display such an error
        if (customerForm.getHasFieldError()) {
            session.setAttribute("validationError", Boolean.TRUE);
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // if everything goes through...(at this moment we will default to a transaction error in the checkout page if no mistakes; will change eventually)
        //so next week when we do transactions we won't make this a transaction error anymore
        //we wanted to break up validation and transactions for this week b/c a little too much to do both in one go (transactions--put data in multiple database tables)
        //session.setAttribute("transactionError", Boolean.TRUE);
        //response.sendRedirect(request.getContextPath() + "/checkout");

        //from Project 8 Part 4 (if everything goes through we then place that order) and go to a confirmation page showing all the order details
        //Notice that if orderId is zero after the call to "placeOrder", the transaction has failed, and the code you originally had is executed. If orderId is NOT zero, the transaction
        // was successful. If this happens, the shopping cart is cleared and the customer details are stored in a CustomerOrderDetails object, which is added to the session scope.
        //after we added a getter for teh order service in app context we can then get that service
        OrderService orderService = ApplicationContext.INSTANCE.getOrderService();

        //returns a customer order ID
        //Dr K was doing some debugging and got an error after generating the order here and placing the order. if you look into orderService, we use DefaultOrderService which extends
        //orderService; however, the form.getCcExpDate() doesn't return the date in the right format. It gets Fri Jul 31 20:32:13 ET 2020 for instance. Got close to statement object,
        //then threw exception; go bacck to try statement to finalize it.

        long orderId = orderService.placeOrder(customerForm, cart);


        if (orderId == 0) {
            //this is like the default code we had for Project 7 that we commented out above; if there was an error processing the order, go back to checkout page
            session.setAttribute("transactionError", Boolean.TRUE);
            response.sendRedirect(request.getContextPath() + "/checkout");
        } else {
            cart.clear();

            //Dr A proposes clear the cart in the checkout servlet then redirect to confirmation (get rid of setting the orderDetails here) and then sending a
            //query parameter to the order ID in the confirmation (this is how Dr A did it in the simplea ffable bean). Can leave it like this for now, but follow SAB
            //to implement Dr. A's change if necessary

            //orderDetails finds the customer, order and the line items based on customer ID and returns an order details class with these attributes
            //we had an error getting customer information (with customerDaoJDBC) within orderDetails, couldn't find the email information bc the
            //SQL query did not incorporate it

            OrderDetails orderDetails = orderService.getOrderDetails(orderId);
            //set orderDetails as session attribute so confirmation view model can have these details when we go to confirmation page (via get request)
            session.setAttribute("orderDetails", orderDetails);
            response.sendRedirect(request.getContextPath() + "/confirmation");

            //saving the info from the customer form and the cart into three tables, one for customer info and the other for order and order line item tables
            //transaction bc need to write all three at same time
        }

    }
}
