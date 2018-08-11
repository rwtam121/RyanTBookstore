<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="p" scope="request" type="viewmodel.ConfirmationViewModel"/>


<%--
  Created by IntelliJ IDEA.
  User: rwtam
  Date: 7/21/2018
  Time: 10:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>My Bookstore - Confirmation</title>
    <meta charset="utf-8">
    <meta name="description" content="The confirmation page for My Bookstore">

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

        I also need to reference the confirmation.css here
    -->

    <link rel="stylesheet" type="text/css" href="<c:url value="/css/main.css"/>">
    <link rel="stylesheet" type="text/css" href="<c:url value="/css/header.css"/>">
    <link rel="stylesheet" type="text/css" href="<c:url value="/css/footer.css"/>">
    <link rel="stylesheet" type="text/css" href="<c:url value="/css/confirmation.css"/>">



    <!-- for the tables, put the css in here-->
    <style>

        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;

            margin-left:auto;
            margin-right:auto;
            text-align:center;
            padding: 5px;
        }

        /*
        Inspiration from w3 schools html tables page:
        https://www.w3schools.com/html/tryit.asp?filename=tryhtml_table_id2
        */

        /* centers the table, center text, and add padding to its text*/

        /* make the header white text with black color*/
        table#t01 th {
            background-color: black;
            color: white;
        }

        /* Make even and odd rows diff colors*/
        table#t01 tr:nth-child(even) {
            background-color: #eee;
        }

        table#t01 tr:nth-child(odd) {
            background-color: #fff;
        }

        td{
            padding:10px;
        }

    </style>

</head>



<body class="home">

<main>
    <jsp:include page="header.jsp"/>

    <!-- create a confirmationMain section that will contain a flexbox to display all the items:
    1) Confirmation title
    2) conf statements
    3) Items tablee
     4)customer information

     all in a flexbox vertical format

            <%--<strong>${p.orderDetails.order.dateCreated}</strong><br>--%>
     -->
    <section id="confirmationMain">

        <div id="confStatements">
            <div id="confirmationName">
                <p>Confirmation</p>
            </div>

            <br>

            Your confirmation number is: <strong>${p.orderDetails.order.confirmationNumber}</strong><br>

            Submission Time is ${p.orderDetails.order.dateFormatted}
        </div>

        <br><br>

    <!-- Create the table outside of the for loop, and its headers are also outside
    Can I inflate the space around the table with cellpadding="10" doesnt seem to work
    Instead, provide padding to the td elements instead: https://stackoverflow.com/questions/3656615/padding-a-table-row
    -->

        <table id="t01">
            <tr>
                <th>Book</th>
                <th>Quantity</th>
                <th>Price</th>
            </tr>


    <!-- Then within the table, use a for loop to iterate across all the line items
    To do this we already have the Confirmation View Model which stores all the OrderDetails; which we can
    access with getorderDetails from the ViewModel. OrderDetails are attained in the CheckoutServlet and
    include order, customer, lineItems and books

    in adhering to Dr. K's structure, we had book, quantity, price. We can access the quantity from their line items; but cannot
    access book title and its price directly. I thought about getting the bookID and using the bookDao to trace it back to its respective
    book, but only can be done in servlet for delegation of tasks; might be cumbersome. Have to set up dao.

    Seek inspiration from Dr. A: https://github.com/nowucca/SimpleAffableBean/blob/master/src/main/webapp/WEB-INF/jsp/confirmation.jsp
    he iterated across LineItems but for the books and their price he made use of iter_index to iterate across them (I will try this)
    This is called LoopTag Status information:
    JSTL provides a mechanism for LoopTags to return information about the current index of the iteration and convenience methods to
     determine whether or not the current round is either the first or last in the iteration

     [So our idea is to use the varStatus and go back to the list of books and store the current index of the iteration to get that
     respective book value]
     Yes, this works! VarStatus is the best approach
     -->
            <c:forEach var="lineItem" items="${p.orderDetails.lineItems}" varStatus="iter">

                <tr>
                    <td>${p.orderDetails.books[iter.index].title}</td>
                    <td>${lineItem.quantity}</td>
                    <td><fmt:formatNumber value="${p.orderDetails.books[iter.index].price/100}" type="currency"/></td>
                        <%--<td>${book.price}</td>--%>
                </tr>

            </c:forEach>

            <!-- Format the surcharge in terms of dollars-->
            <tr>
                <td>--Delivery Surcharge--</td>
                <td></td>
                <td><fmt:formatNumber value="${p.surcharge}" type="currency"/></td>

            </tr>

            <!-- Cannot use the cart subtotal here anymore because it has emptied out; note that by the time you
            get to the confirmation page you have 0 items, so nothing in the cart, so all that is left is the surcharge
            the $5. So cannot use p.cart.subtotal; instead as seen below, we get the confirmation's order details,
            accessing the order amount (which is in cents) so we divide by 100 and recconstruct as currency-->
            <%--${p.cart.subtotal/100+p.surcharge}--%>
            <tr class="Total">
                <td>Total</td>
                <td></td>
                <td><fmt:formatNumber value="${p.orderDetails.order.amount/100}" type="currency"/></td>
            </tr>

        </table>

        <br><br>

        <div id="customerInfo">
            Customer Information<br>
            Name: ${p.orderDetails.customer.customerName} (${p.orderDetails.customer.email})<br>
            Address: ${p.orderDetails.customer.address}<br>

            <!-- Have to manipulate credit card number, substring up to the last four digits
            Found there were problems with this method below-->
            <%--<c:set var="credCardNumber" value="${p.orderDetails.customer.ccNumber}"/>--%>
            <%--<c:set var="credCardLen" value="${fn:length(credCardNumber)}"/>--%>

            <%--<c:set var = "credCardSub" value = "${fn:substring(credCardNumber, 0, credCardLen-4)}" />--%>
            <%--<c:set var = "credCardLastFour" value = "${fn:substring(credCardNumber, credCardLen-4, credCardLen)}" />--%>

            <%--<c:set var = "credCardEncrypt" value = "${fn:replace(credCardSub, '-', '.')}" />--%>

            <%--Credit Card: ${credCardEncrypt}${credCardLastFour}--%>

            Credit Card: ${p.finalEncrypted} (${p.expMonth}-${p.expYear})<br>
        </div>

        <br><br>

        <div id="thankYou">
            Thank you! We appreciate your business!

            <ul class="buttons horizontal">
                <li><a href="category?category=${p.recallSelectedCategory().name}">Continue Shopping</a></li>
            </ul>
        </div>

    </section>

    <br><br>





    <jsp:include page="footer.jsp"/>

</main>

</body>
</html>
