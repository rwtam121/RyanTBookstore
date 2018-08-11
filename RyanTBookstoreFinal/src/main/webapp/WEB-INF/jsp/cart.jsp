<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
  Created by IntelliJ IDEA.
  User: rwtam
  Date: 7/5/2018
  Time: 9:57 PM
  To change this template use File | Settings | File Templates.
--%>

<%--

At this point the books in the cart will be hard-coded


--%>




<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Bookstore Cart Page</title>
    <meta charset="utf-8">
    <meta name="description" content="The cart page for my bookstore">

    <link rel="stylesheet" href="<c:url value="/css/normalize-and-reset.css"/>">
    <link rel="stylesheet" href="<c:url value="/css/cart.css"/>">

    <link rel="stylesheet" href="<c:url value="/css/main.css"/>">

    <link rel="stylesheet" href="<c:url value="/css/header.css"/>">
    <link rel="stylesheet" href="<c:url value="/css/footer.css"/>">


    <!--
    cascading appropriately, we have:

    main.css    --  all things common
    header.css  --  header-specific rules
    footer.css  --  footer-specific rules
    <page>.css  --  page-specific rules
    extras.css  --  extras you may want

    padding for .left and .right is needed to inflate headers
    -->

</head>

<body>


<main>
    <!-- IMPORTANT! Set to BaseViewModel since it has access to all models (CategoryViewModel, etc) that inherit from it-->
    <jsp:useBean id="p" scope="request" type="viewmodel.BaseViewModel"/>

    <!-- Chris Blessing put a header under a header tag here, but we can just use jsp to include our own header-->
    <jsp:include page="header.jsp"/>

    <!-- adapted from Chris Blessing
    Text stating how many items are in your cart (see below) which is hardcoded currently
    Text stating the subtotal for the items in your cart hardcoded currently
    A table containing the items in your cart. Each row should have the book title, quantity, and unit price of the book.
    Each row should also have a way to update the quantity (for example, a field + an update button, or decrement and increment buttons)

    Change cart.jsp header link to just cart

    for css, uses cart-checkout-confirm, sizes and extras (validate all three, might need to change some of them)

    Now "Adding some Dynamic Elements to the Cart Page"
    Previously itemCount was fixed at 5
    replace with the number of items in the cart (accessed from cartViewModel)
    -->
    <section class="content">
        <article>
            <div>
                <h2>Your Cart</h2>
                <h3 class="itemCount">Items: <strong>${p.cart.numberOfItems}</strong></h3>

                <div>
                    <!-- A continue shopping button that takes you back to the category page, just category below should work
                    a proceed to checkout button link not active for now (prev w/ Blessing: checkout.html)

                    change href="category" to the recall selected category name for redirecting back to the previous category

                    THIS RECALL WORKS!!!

                    -->
                    <ul class="buttons horizontal">
                        <li><a href="category?category=${p.recallSelectedCategory().name}">Continue Shopping</a></li>

                        <!--Only shows checkout if the number of items is not equal to 0 (WORKS!!!)
                        instead of # added Checkout
                        -->
                        <c:if test="${p.cart.numberOfItems != 0}">
                            <li><a href="checkout">Checkout</a></li>

                            <li><a><form action="cart" method="post">
                                <input type="hidden" name="action" value="clear"/>
                                 <input type="submit" name="submit" value="Clear Cart"/>
                            </form></a></li>

                        </c:if>


                    </ul>

                    <div class="table">
                        <!-- enhancement opportunity: list items by category, add a "delete" button, link back to category page, striped even/odd rows... -->

                        <!-- Under the "Add a table to the cart page"--fix table to show the correct items;
                        from cart.getItems() we get the shopping cart items; which is every book

                        because we are getting book properties, usebean for book is needed like in category.jsp

                        We also get the book's title and use change its name to get the image path

                        to get the quantity of a single item, go to cart.finditem to get the book and .getQuantity
                        every book is a ShoppingCartItem so you have access to each of its methods (including getQuantity)
                        which returns the quantity

                        cannot typecast shoppingCartItem as a book which is what I did with the usebean

                        commented out book usebean because wrong typecasting; instead shoppingItem is a shopping cart item
                        with getBook method to get the book version

                        -->

                        <c:forEach var="shoppingItem" items="${p.cart.items}">
                            <%--<jsp:useBean id="book" type="business.book.Book" scope="page"/>--%>

                            <c:set var="search" value="'" />

                            <c:set var="bookTitle" value="${shoppingItem.book.title}"/>
                            <c:set var = "bookLower" value = "${fn:toLowerCase(bookTitle)}" />
                            <c:set var = "bookDash" value = "${fn:replace(bookLower,' ','-')}" />
                            <c:set var = "bookColon" value = "${fn:replace(bookDash,':','')}" />
                            <c:set var = "bookComma" value = "${fn:replace(bookColon,',','')}" />
                            <c:set var = "bookFinal" value = "${fn:replace(bookComma,search,'')}" />

                            <!-- I added a span within the form (not sure if it will work) but the goal is to reflect the quantity
                            we're not adding a book to the cart like Add to cart here, we're merely incrementing the count of a book.
                            The action is not to category, but to cart; we are modifying the cart in the cart page.
                            -->


                            <div>
                                <span class="boxart"><img src="${p.bookImagePath}${bookFinal}.gif" width="62" height="93"></span>
                                <span class="title">${shoppingItem.book.title}</span>

                                <span class="quantity">

                                    <form action="cart" method="post">
                                        <input type="hidden" name="bookId" value="${shoppingItem.book.bookId}"/>
                                        <input type="hidden" name="action" value="change"/>

                                        <!--submit type is recognized by CartServlet's doPost, but type=number is not
                                         note, if I have a submit button after quantity everything auto-updates

                                         As Dr K said, OR you have a field for an integer and an update button for a cart item.
                                         I have a field for an integer below and an update button for the item.
                                         -->

                                        <div class="scroll">
                                            <input type="number" name="quantity" value="${shoppingItem.quantity}" min="0" max="99">

                                        </div>
                                        <input type="submit" name="submit" value="Update"/>


                                    </form>
                                </span>


                                <span class="price"><fmt:formatNumber value="${shoppingItem.price/100}" type="currency"/></span>
                                <!-- previously used-->
                                <%--<span class="price">$${shoppingItem.price/100}</span>--%>


                            </div>


                        </c:forEach>


                        <!-- For subtotal, instead of fixed $65.95, shoppingCart object has getSubtotal()
                        don't want subtotal completely in cents, divide by 100 for dollars-->
                        <div class="subtotal">
                            <span class="boxart"><!-- empty --></span>
                            <span class="title"><!-- empty --></span>
                            <span class="quantity">Sub-total:</span>
                            <span class="price"><fmt:formatNumber value="${p.cart.subtotal/100}" type="currency"/></span>

                            <!-- previously used-->
                            <%--<span class="price">$${p.cart.subtotal/100}</span>--%>


                        <%--<fmt:formatNumber value=${p.cart.subtotal/100} pattern="#,#00.0#"/>--%>
                        </div>
                    </div>

                    <ul class="buttons horizontal">
                        <li><a href="category?category=${p.recallSelectedCategory().name}">Continue Shopping</a></li>

                        <!--Only shows checkout if the number of items is not equal to 0 (WORKS!!!) took out <a> in between the <li> for post-->
                        <c:if test="${p.cart.numberOfItems != 0}">
                            <li><a href="checkout">Checkout</a></li>

                            <li><a><form action="cart" method="post">
                                <input type="hidden" name="action" value="clear"/>
                                <input type="submit" name="submit" value="Clear Cart"/>
                            </form></a></li>

                        </c:if>


                    </ul>

                </div>
            </div>
        </article>
    </section>

    <!-- Chris Blessing put a footer under a footer tag here, but we can just use jsp to include our own footer-->
    <jsp:include page="footer.jsp"/>

</main>

</body>
</html>
