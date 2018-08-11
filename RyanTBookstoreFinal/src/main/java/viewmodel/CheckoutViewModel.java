package viewmodel;

import business.customer.CustomerForm;

import javax.servlet.http.HttpServletRequest;
import java.util.Calendar;

public class CheckoutViewModel extends BaseViewModel {

    private CustomerForm customerForm;
    private Boolean hasTransactionError;
    private Boolean hasValidationError;

    //create a field to get the current date, easier to use with calendar since using objects of type Date
    //have their getMonth deprecated
    private Calendar calend;

    public CheckoutViewModel(HttpServletRequest request) {
        super(request);

        /**
         *I can put java statements in the CheckoutViewModel and pass them into the CustomerForm when it is first
         * created, so it can recognize the current date.
         *
         */
        calend = Calendar.getInstance(); //initialized with current date and time (default tiemzone/locale)
        String monthVal=Integer.toString(calend.get(Calendar.MONTH)+1); //need to add 1 to the month for the calendar
        String yearVal=Integer.toString(calend.get(Calendar.YEAR));

        //the customerForm is established in the CheckoutServlet's POST METHOD taking in all the properties that are saved into the form
        //so we can get those attributes here in the view model and reacquire those values for the form up top
        //when we do our validation error checks
        CustomerForm sessionForm = (CustomerForm) session.getAttribute("customerForm");

        //previously:         customerForm = (sessionForm == null) ? new CustomerForm() : sessionForm;
        customerForm = (sessionForm == null) ? new CustomerForm(monthVal,yearVal) : sessionForm;

        //this is determined after the CustomerForm is created, it undergoes the validate() function which toggles which sort
        //of errors have occurred; we can recover those attributes within that session
        hasValidationError = (Boolean) session.getAttribute("validationError");
        session.setAttribute("validationError", null);

        hasTransactionError = (Boolean) session.getAttribute("transactionError");
        request.getSession().setAttribute("transactionError", null);
    }

    public CustomerForm getCustomerForm() {
        return customerForm;
    }

    //within the checkout.jsp which uses this CheckoutViewModel we invoke the hasValida and hasTransact error methods here to report back what needs to be done
    public boolean getHasValidationError() {
        return hasValidationError != null && hasValidationError;
    }

    public boolean getHasTransactionError() {
        return hasTransactionError != null && hasTransactionError;
    }
}
