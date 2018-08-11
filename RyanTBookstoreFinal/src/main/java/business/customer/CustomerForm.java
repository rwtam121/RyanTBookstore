package business.customer;

import java.util.Calendar;
import java.util.Date;

public class CustomerForm {

    private String name;
    private String phone;

    private String address;
    private String email;
    private String creditCardNumber;

    //expiration date of credit card info
    private String expMonth;
    private String expYear;


    // TODO: Put the remainder of the fields from the from here.
    private Date ccExpDate;

    private boolean hasNameError;
    private boolean hasPhoneError;
    private boolean hasDateError;

    private boolean hasAddressError;
    private boolean hasEmailError;
    private boolean hasCreditCardNumberError;



    // TODO: Make has-error methods for all fields except ccMonth and ccYear
    // TODO: Instead, make a has-error method for ccExpDate

    // TODO: This will change as your parameterized constructor changes
    //added a second "" to take in phone, and a third to take in the date
    //also taking in the expiration month and year of the credit card
    //THIS WORKS NOW!!! THE FIRST TIME YOU LOAD THE CUSTOMER FORM we haven't created the form
    //so we need to create default values for expiration month and year (need to put entries)
    //otherwise we get cannot parse a non-int string there
    //we can set the default to the month and year of the current date
    //automate getting the month and year in the customer form

    public CustomerForm(String monthVal, String yearVal) {

        //this("","","7","2018"); is default
        //name, phone, address, email, and credit card number are empty when first presented in the session
        this("","",monthVal,yearVal,"","","");
    }

    // TODO: Add more parameters as you add more fields
    //We added a phone parameter, including its errors. We take in string/phone fields from the form and put it into the customer form class.
    //Then it is going to validate whether the name and phone etc properties are legitimate; we're also going to have to validate the expiration date (I will implement)
    //a customerForm will be with legitimate parameters so it can remember your last entries if they were correct
    //We will also need to remember the expiration date if it is legitimate (make sure if year is 2018,  month is at least july  so we set this.expDate=ccExpDate?
    //I also added a date parameter (do I need to pass in Date ccExpDate? Probably not, since ccExpDate is invoked inside of customerForm.




    //The default value at first is January 2018 so month=1, year=2018; but 1 gets reported as February (starts at 0th index); so if month=1 passed in make it 0 (i-1) to be recognized as date
    public CustomerForm(String name, String phone, String expMonth, String expYear, String address, String email, String creditCardNumber) {
        this.name = name;
        this.phone=phone;

        //we need variables for month and year for recall back in checkout to remember the user's last entries there
        this.expMonth=expMonth;
        this.expYear=expYear;

        //these are recall variables for the checkout.jsp
        this.address=address;
        this.email=email;

        //no need to remember the credit card number, does not matter (but that means don't print it out on the screen)
        //All fields should retain the values you typed except for the credit-card field. The credit card field should be blank when you navigate away and come back.
        //We still need to store it to elicit a response about it
        this.creditCardNumber=creditCardNumber;


        // TODO: Initialize the fields that you add
        //assigns the date (because this date is always hard-coded, this will get a result based on this ccExpDate).
        //we need to get rid of the hard coded aspect, by feeding it a month and a year string.
        //previously:         ccExpDate = getCcExpDate("1", "2020"); (default values)
        ccExpDate = getCcExpDate(expMonth, expYear);
        //ccExpDate = getCcExpDate("1", "2018");

        //cannot be this.date has to be the same name as the field we are taking in
        //this.ccExpDate=ccExpDate;

        validate();
    }

    // Get methods for fields

    public String getName() {
        return name;
    }

    // TODO: Add getters for the fields you add
    //also need to add one for the phone
    public String getPhone() { return phone;}

    //also add a getter for the date (NOT SURE IF I NEED THIS if I am returning month and year--check later)
    //wasn't ever used
    //public Date getDate() { return ccExpDate;}

    public String getMonth() { return expMonth;}
    public String getYear() { return expYear;}

    public String getAddress(){ return address;}
    public String getEmail(){ return email;}

    //I assigned a getter for getCcExpDate bc form.getCcExpDate() can th en be invokeed in DefaultOrderService
    public Date getCcExpDate() {
        return ccExpDate;
    }

    //also need a getter for the credit card number  so can be accessed in DefaultOrderService
    public String getCcNumber() {
        return creditCardNumber;
    }

    //no getter for credit card number bc shouldnt access it
    //public String getCreditCardNumber(){ return creditCardNumber;}

    // hasError methods for fields

    public boolean getHasNameError() {
        return hasNameError;
    }

    // TODO: Add getters for the has-error fields you add
    //for phone
    public boolean getHasPhoneError() { return hasPhoneError;}

    //for the date, we can get an error if the date is before July 2018
    public boolean getHasDateError() { return hasDateError;}

    public boolean getHasAddressError() { return hasAddressError;}
    public boolean getHasEmailError() { return hasEmailError;}
    public boolean getHasCreditCardNumberError() { return hasCreditCardNumberError;}

    public boolean getHasFieldError() {
        return hasNameError || hasPhoneError || hasDateError || hasAddressError || hasEmailError || hasCreditCardNumberError;
        // TODO: This method returns true if *any* field has an error
        //set up an OR between error types (true or false always yields true)
        // TODO: This will evolve as you add more fields
    }

    // error messages for fields

    public String getNameErrorMessage() {
        return "Valid name required (ex: Bilbo Baggins)";
    }
    // TODO: Create reasonable error messages for any field or date that can have an error
    //added phone
    public String getPhoneErrorMessage(){ return "Valid US phone number required (ex: 703-555-1212)";}

    //added Date (compare it to today's date, if less then false)
    public String getDateErrorMessage(){ return "Valid expiration date required";}

    //address should be non-null and present
    public String getAddressErrorMessage(){ return "Valid address required (ex: 1600 Pennsylvania Ave)";}

    //email: should not contain spaces; should contain a "@"; and the last character should not be "."
    //should be non-null and present
    public String getEmailErrorMessage(){ return "Valid email required (ex: bilbo346@gmail.com)";}

    //credit card number: after removing spaces and dashes, the number of characters should be between 14 and 16.
    //should be non-null and present
    public String getCreditCardNumberErrorMessage(){ return "Valid credit card number required (ex: 1111-1111-1111-1111)";}

    //validate called in the constructor makes sure name is proper
    //REFERENCE GUIDE FOR SERVER-SIDE VALIDATION
    //All fields (including name and address): should be present and non-null (that is the  null and "" checks below)

    private void validate() {
        if (name == null || name.equals("") || name.length() > 45) {
            hasNameError = true;
        }
        // TODO: Validate fields as you add them
        //validate the phone
        //PROJ DSECRIPTION: phone: after removing all spaces, dashes, and parens (all nondigits) from the string it should have exactly 10 digits
        //phone is a string
        //tested in Eclipse
        //https://www.javacodeexamples.com/java-string-keep-only-numbers-example/715
        //[^//d] is what I want (even gets rid of the period) because looks for "not a digit" characters to remove
        //a . is a numeric character but is NOT A DIGIT (so cannot use [^0-9] because that looks for non-numeric characters)--needs 10 digits
        //Dr K did this
        //String digitOnlyPhone=(phone==null)? "":phone.replaceAll("[^\\d]", "");
        //and later used digitOnlyPhone.length() (I think mine works too)

        if (phone==null || phone.equals("") || phone.replaceAll("[^\\d]", "").length()!=10){
            hasPhoneError=true;
        }

        //create a field to get the current date
        Date currentDate = new Date();

        //use this conditional to get a false error if the date provided is before the current date
        //https://www.mkyong.com/java/how-to-compare-dates-in-java/
        if (ccExpDate.before(currentDate)) {
            hasDateError=true;
        }

        //fill in conditionals for the other fields
        //address just needs to have something within it
        if (address==null || address.equals("")){
            hasAddressError=true;
        }

        //email: should not contain spaces; should contain a "@"; and the last character should not be "."
        //should be non-null and present
        //inspiration for containing:         //https://stackoverflow.com/questions/11488478/how-do-i-check-whether-input-string-contains-any-spaces
        //should not contain spaces
        //similar principle for making sure it has a @ (if doesn't contain @ then there is an error)
        //string has an endsWith method: https://stackoverflow.com/questions/12310978/check-if-string-ends-with-certain-pattern
        //we don't want it to end with a period
        if (email==null || email.equals("") || email.contains(" ") || !email.contains("@") || email.endsWith(".")){
            hasEmailError=true;
        }

        //a credit card number should ONLY have numbers (should not have letters)--so only maintain the numbers
        //credit card number: after removing spaces and dashes, the number of characters should be between 14 and 16.
        //should be non-null and present
        //when we POST, we move away and come back to the customer form so the credit card field will be empty after you hit submit
        if (creditCardNumber==null || creditCardNumber.equals("") || creditCardNumber.replaceAll("[^\\d]", "").length()<14 || creditCardNumber.replaceAll("[^\\d]", "").length()>16){
            hasCreditCardNumberError=true;
        }

    }

    // Returns a Java date object with the specified month and year
    //the date needs to start from 2018 not 2016
    private Date getCcExpDate(String monthString, String yearString) {
        // TODO: Implement this method
        // Assume monthString is an integer between 1 and 12
        // Assume yearString is a four-digit integer

        //Example here: https://www.tutorialspoint.com/java/util/calendar_setfield2.htm
        //setting month and year example here: http://javatutorialhq.com/java/util/calendar-class-tutorial/set-method-example/
        Calendar calend = Calendar.getInstance(); //initialized withi current date and time (default tiemzone/locale)

        //since it is a string, need to take the integer value and pass it to month
        //to avoid one-offs as discussed above, we account for the 1 offset to get the actual month value
        int monthIndex=Integer.parseInt(monthString)-1;

        calend.set(Calendar.MONTH, monthIndex);
        calend.set(Calendar.YEAR, Integer.parseInt(yearString));

        //from calendar properties, date returns something in this format: Wed Mar 14 00:04:06 PDT 2018
        //ONE OFF ERRORS! //the 2nd month is reported as March [0  is january]--these are the one-off errors mentioend
        //date is an easier way to print the calendar's timestamp
        //conversion from here: https://www3.ntu.edu.sg/home/ehchua/programming/java/DateTimeCalendar.html
        //return this date
        Date date = calend.getTime();

        // Note: Calendar.getInstance() returns a calendar object
        // Note: calendar.set(Calendar.MONTH, mm) sets the month
        // Note: calendar.set(Calendar.YEAR, yyyy) sets the year
        // Note: Be careful of one-off errors (make sure June isn't referencing May, make sure index is correct)
        return date;
    }
}
