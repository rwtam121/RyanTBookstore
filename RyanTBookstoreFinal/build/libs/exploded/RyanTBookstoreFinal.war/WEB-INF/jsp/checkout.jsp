<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:useBean id="p" scope="request" type="viewmodel.CheckoutViewModel"/>

<!doctype html>
<html>
<head>
    <title>My Bookstore - Category</title>
    <meta charset="utf-8">
    <meta name="description" content="The category page for My Bookstore">

    <!--
        normalize-and-reset.css.css is a basic CSS reset; useful for starting from ground zero.
        always include this first.
    -->

    <link rel="stylesheet" type="text/css" href="<c:url value="/css/normalize-and-reset.css"/>">

    <!--
        cascading appropriately, we have:

        main.css    --  all things common
        header.css  --  header-specific rules
        footer.css  --  footer-specific rules
        <page>.css  --  page-specific rules
        extras.css  --  extras you may want
    -->

    <link rel="stylesheet" type="text/css" href="<c:url value="/css/main.css"/>">
    <link rel="stylesheet" type="text/css" href="<c:url value="/css/header.css"/>">
    <link rel="stylesheet" type="text/css" href="<c:url value="/css/footer.css"/>">
    <link rel="stylesheet" type="text/css" href="<c:url value="/css/checkout.css"/>">

    <!-- From jQuery validation plugin video: https://www.youtube.com/watch?time_continue=325&v=yaxUV3Ib4vM
    Import JQuery in the HTML header of your checkout page:
    -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="<c:url value="/js/jquery.validate.js"/>" type="text/javascript"></script>
    <script src="<c:url value="/js/additional-methods.js"/>" type="text/javascript"></script>


    <!-- Below we have our form of information with form id checkoutForm which is why we reference it here for validation in #checkoutForm
    compared w/ Dr A's SimpleAffableBean: https://github.com/nowucca/SimpleAffableBean/blob/56f4d5368c1180537bdef55cf4b713e64924eb52/src/main/webapp/WEB-INF/jsp/checkout.jsp
    and roughly 9min mark of https://www.youtube.com/watch?time_continue=325&v=yaxUV3Ib4vM

    Add a script in checkout.jsp that verifies the form in the following way:
all fields including name and address are required
phone: use phoneUS in additional-methods to check this
email: use email to check this
credit card number: use creditcard to check this
expiration date: do not check this on the client side
(we have name, phone, date, address, email, credit card #, cc exp date)

for us creditcard is ccNumber (the other names are the same for the checkoutForm

took out from phone:
                        number: true,
replaced with phoneUS: true,
-->

    <!--
went to addition methods to excise out this part of the code (maybe I don't need to since we invoked additional-methods up top
cdn.jsdelivr.net/npm/jquery-validation@1.17.0/dist/additional-methods.js

this is also explained in the 11 minute mark of the youtube video (create your own functions)
www.youtube.com/watch?time_continue=325&v=yaxUV3Ib4vM
we create a name phoneUS to illustrate this function--this was the name in additionalfunctions
instead of setting phone to true we set phoneUS to true

in taking inspiration from Dr A, he already used email and creditcard from additional-methods.js to make the checks below

changed creditcard name to ccNumber (which uses creditcard for validation)

don't need to check expiration date on the client side

I put phoneUS to true (can take away number: true so we don't get locked into numbers)
                        number: true,

-->


    <script type="text/javascript">
        $(document).ready(function(){
            $("#checkoutForm").validate({
                rules: {
                    name: "required",
                    email: {
                        required: true,
                        email: true
                    },
                    phone: {
                        required: true,
                        phoneUS: true,
                        minlength: 9
                    },
                    address: {
                        required: true
                    },
                    ccNumber: {
                        required: true,
                        creditcard: true
                    }
                }
            });
        });
    </script>



</head>

<body class="home">
<main>
    <jsp:include page="header.jsp"/>

    <section id="checkoutMain">

        <div id="checkoutName">
            <p style="font-weight:bold">Checkout</p>
        </div>


        <!--If you haven't inputted phone number, need to register that as an error, we implemented that phone error msg
         up top now; Dr K says don't use choose because it only reports one or the other; this reports all cases of problems
         with the if conditional; also put the date error message there-->

        <div id="checkoutFormErrors">
            <c:if test="${p.hasValidationError}">
                <c:if test="${p.customerForm.hasNameError}">
                    ${p.customerForm.nameErrorMessage}<br>
                </c:if>

                <c:if test="${p.customerForm.hasPhoneError}">
                    ${p.customerForm.phoneErrorMessage}<br>
                </c:if>

                <c:if test="${p.customerForm.hasDateError}">
                    ${p.customerForm.dateErrorMessage}<br>
                </c:if>

                <c:if test="${p.customerForm.hasAddressError}">
                    ${p.customerForm.addressErrorMessage}<br>
                </c:if>

                <c:if test="${p.customerForm.hasEmailError}">
                    ${p.customerForm.emailErrorMessage}<br>
                </c:if>

                <c:if test="${p.customerForm.hasCreditCardNumberError}">
                    ${p.customerForm.creditCardNumberErrorMessage}<br>
                </c:if>
            </c:if>

            <!-- placeholders for if there are no errors, then just say transaction placeholder-->
            <c:if test="${p.hasTransactionError}">
                Transactions have not been implemented yet.<br>
            </c:if>
        </div>
        <div id="checkoutFormAndInfo">
            <div id="checkoutFormBox">
                <!-- this form is part of the checkout page, which is why the parameters here can be passed into the checkout servlet
                if the name is correct, retains the name  since it stores the customer form's name (if the name is valid the checkout servlet's post method
                creates a customerForm of that name, which is referenced in p.customerForm.name below
                We also need to be able to remember the phone number regardless of correct or incorrect (so we put p.customerForm.phone); now my phone is remembered

                Default for date is January 1 2018--we need to implement the change so it can recognize the change

                to retain the values we make use of the getters for address and email here (don't store the credit card number)
                -->
                <form id="checkoutForm" action="<c:url value='checkout'/>" method="post">
                    Name
                    <input class="textField" type="text" size="20" maxlength="45" name="name"
                           value="${p.customerForm.name}"><br>
                    Address
                    <input class="textField" type="text" size="20" maxlength="45" name="address" value="${p.customerForm.address}"><br>
                    Phone
                    <input class="textField" type="text" size="20" maxlength="45" id="phone" name="phone" value="${p.customerForm.phone}"><br>
                    Email
                    <input class="textField" type="text" size="20" maxlength="45" name="email" value="${p.customerForm.email}"><br>
                    Credit card
                    <input class="textField" type="text" size="20" maxlength="45" name="ccNumber"><br>

                    Exp. date
                    <select class="selectMenu" name="ccMonth">
                        <c:set var="montharr"
                               value="${['January','February','March','April','May','June','July','August','September','October','November','December']}"/>
                        <c:forEach begin="1" end="12" var="month">
                            <option value="${month}"
                                    <c:if test="${p.customerForm.month eq month}">selected</c:if>>
                                    ${month}-${montharr[month - 1]}
                                <!-- for whichever month int 1 to 12 selected print out the month anum along with its actual month value
                                implement remembering the month and year the user typed (even if it is wrong)

                                I created a getter to access private variable month in CustomerForm.java so we can compare the month the user entered to any month in the list,
                                so we can make that selected with its corresponding month name

                                prev: c:if test="{1 eq month}">selected/c:if
                                -->
                            </option>
                        </c:forEach>
                    </select>
                    <select class="selectMenu" name="ccYear">
                        <!-- Dr. K says change from 2016 to 2018

                        prev if test is {2018 eq year}
                        -->
                        <c:forEach begin="2018" end="2027" var="year">
                            <option value="${year}"
                                    <c:if test="${p.customerForm.year eq year}">selected</c:if>>
                                    ${year}
                            </option>
                        </c:forEach>
                    </select><br><br>

                    <!-- The expiration date stores the name ccMonth and ccYear which takes in the month and the year in strings, we can pass
                    these names back to CheckoutServlet in request.getParameter and recreate the date from those values-->

                    <input id="boldSubmitButton" type="submit" value="Submit">

                </form>
            </div>


            <div id="checkoutInfo">


                <!-- The total is the sum of the subtotal and the surcharge; surcharge is defined in the BaseViewModel which is referenced as p here
                so we can access that value

                previously:                 <span id="checkoutInfoText">
                Your credit card will be charged <strong>total</strong><br>
                (<strong>subtotal</strong> + <strong>surcharge</strong> shipping)
            </span>

            we accessed the surcharge below from the BaseViewModel and put a dollar sign in front.

            by using jstl tag for format number for currency, there is no need to put a dollar sign in front

            I just summed up the numbers shown below to display totals
            -->

                <span id="checkoutInfoText">
            Your credit card will be charged <strong><fmt:formatNumber value="${p.cart.subtotal/100+p.surcharge}" type="currency"/></strong><br>
            (<strong><fmt:formatNumber value="${p.cart.subtotal/100}" type="currency"/></strong> + <strong><fmt:formatNumber value="${p.surcharge}" type="currency"/> </strong> shipping)
        </span>
            </div>
        </div>
    </section>
    <jsp:include page="footer.jsp"/>
</main>
</body>
</html>
