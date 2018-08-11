package business.order;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

public class Order {

    private long customerOrderId;
    private int amount;
    private Date dateCreated;
    private long confirmationNumber;
    private long customerId;

    public Order(long customerOrderId, int amount, Date dateCreated, long confirmationNumber, long customerId) {
        this.customerOrderId = customerOrderId;
        this.amount = amount;
        this.dateCreated = dateCreated;
        this.confirmationNumber = confirmationNumber;
        this.customerId = customerId;
    }

    public long getCustomerOrderId() {
        return customerOrderId;
    }

    public int getAmount() {
        return amount;
    }

    public Date getDateCreated() {
        return dateCreated;
    }

    public long getConfirmationNumber() {
        return confirmationNumber;
    }

    public long getCustomerId() {
        return customerId;
    }


    //I created a new method that aims to convert the date to a specific format
    //return dateCreated.toString(); (String format doesn't seem to work
    //simple DateFormat format codes here: https://www.tutorialspoint.com/java/java_date_time.htm
    //try SimpleDateFormat

    //I used this format:         SimpleDateFormat ft = new SimpleDateFormat("E yyyy.MM.dd 'at' hh:mm:ss a zzz");
    //got Sun 2018.07.22 at 01:41:30 PM PDT; from this format: E yyyy.MM.dd 'at' hh:mm:ss a zzz
    //Sunday July 22, 2018 at 13:56:51 PM PDT from this format: EEEEE MMMMM dd, yyyy 'at' HH:mm:ss a zzz
    //we want this format: April 19, 2017 01:41:30 PM PDT
    //z doesn't get us EST (help to set timezones: https://coderanch.com/t/377982/java/Date-printed-IST-format-EDT)
    //but when I set timezones below, it doesn't seem to work (it just translates the time more)
    //https://coderanch.com/t/377982/java/Date-printed-IST-format-EDT
    //HARDCODING BEST OPTION AT THIS POINT

    public String getDateFormatted(){
        //SimpleDateFormat ft = new SimpleDateFormat("E yyyy.MM.dd 'at' hh:mm:ss a zzz");
        //SimpleDateFormat ft = new SimpleDateFormat("EEEEE MMMMM dd, yyyy 'at' HH:mm:ss a zzz");

        //THE TIMEZONES JUST SEEM TO SCALE, so I hardcoded EDT below (America/New York gets EDT)
        //SimpleDateFormat ft = new SimpleDateFormat("EEEEE MMMMM dd, yyyy 'at' HH:mm:ss a z");
        //TimeZone edt = TimeZone.getTimeZone("America/New_York");
        //ft.setTimeZone(edt);

        SimpleDateFormat ft = new SimpleDateFormat("EEEEE MMMMM dd, yyyy 'at' HH:mm:ss a 'EDT'");

        String dateFormat=ft.format(dateCreated);

        return dateFormat;
    }


    @Override
    public String toString() {
        return "Order{" +
                "customerOrderId=" + customerOrderId +
                ", amount=" + amount +
                ", dateCreated=" + dateCreated +
                ", confirmationNumber=" + confirmationNumber +
                ", customerId=" + customerId +
                '}';
    }
}
