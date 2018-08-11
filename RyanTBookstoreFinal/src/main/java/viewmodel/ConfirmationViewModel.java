package viewmodel;

import business.cart.ShoppingCart;
import business.order.OrderDetails;

import javax.servlet.http.HttpServletRequest;
import java.util.Calendar;
import java.util.Date;

public class ConfirmationViewModel extends BaseViewModel {

    private OrderDetails orderDetails;
    private int surcharge;
    private String finalEncrypted;
    private String expMonth;
    private String expYear;

    public ConfirmationViewModel(HttpServletRequest request){
        super(request);

        //the confirmation view model, loaded when we go to the confirmation page, can retrieve the orderDetails from
        //the session, so it makes sense that we can nullify/delete the session attribute that
        //that was set in the checkout servlet and sent to the confirmation page (because we have already recovered it in "orderDetails")
        //once the sessionAttribute stores those details into the view model, we don't need the attribute anymore
        //the downside of this is that losing the session attribute, if the user reloads the confirmation page, they have lost the order details
        //so this is just a hack for now
        orderDetails=(OrderDetails) session.getAttribute("orderDetails");
        session.setAttribute("orderDetails",null);

        ShoppingCart cart=(ShoppingCart) session.getAttribute("cart");
        surcharge=cart.getSurcharge();

        String custCredCard=orderDetails.getCustomer().getCcNumber();
        //after subsetting the credit card, get away all numeric characters with a period
        String encryptedCard=custCredCard.substring(0,custCredCard.length()-4).replaceAll("\\d", ".");
        String lastFourCard=custCredCard.substring(custCredCard.length()-4,custCredCard.length());
        finalEncrypted= encryptedCard + lastFourCard;

        //Dr K made note I need to include expiration date
        //https://stackoverflow.com/questions/7182996/java-get-month-integer-from-date
        Date expDate=orderDetails.getCustomer().getCcExpDate();
        Calendar cal = Calendar.getInstance();
        cal.setTime(expDate);
        int month = cal.get(Calendar.MONTH)+1; //offset of 1 so account for it
        int year = cal.get(Calendar.YEAR);

        expMonth=Integer.toString(month);
        expYear=Integer.toString(year);
    }

    public OrderDetails getOrderDetails() {
        return orderDetails;
    }

    //extending BaseViewModel, we can overwrite getSurcharge
    public int getSurcharge(){
        return surcharge;
    }

    //a getter to get the final encrypted string value
    public String getFinalEncrypted() {
        return finalEncrypted;
    }

    public String getExpMonth() {
        return expMonth;
    }

    public String getExpYear() {
        return expYear;
    }
}
