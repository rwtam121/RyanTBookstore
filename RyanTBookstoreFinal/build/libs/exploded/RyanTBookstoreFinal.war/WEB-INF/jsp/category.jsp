<!--
Don't need this:
<li><a class="active" href="#home">Home</a></li>
<li><a href="#news">News</a></li>
<li><a href="#contact">Contact</a></li>
<li><a href="#about">About</a></li>

ul width: 200px

At left took out             <p>Left Menu</p>

No need for extra logos
<a href="#">
<img src="scilogo.png" alt="science logo" />
</a>

no need for right menu
<p>Right Menu</p>

I took out the class left and right (affecting some things)

.left {
background-color:#2196F3;
padding:20px 0px; /* No pad */
float:left;
width:30%; /* The width is 20%, by default */
display: flex;
flex-direction: column;
align-items: center;

}

.right {
background-color:white;
padding:20px 2px;
float:left;
width:65%; /* The width is 80%, by default */
}

ul width for dropdown is             width: 200px;

a hover not active
background-color: #555;
color: white;

To fix the category page and get the css bindings on category (not category.jsp),
Import the core JSTL library to the category JSP page (we added the taglib below after page contentType)
so we can use the c: url later below)

Also, learn to create tags to translate the image dashed names into actual names
https://canvas.vt.edu/courses/70400/external_tools/2284 shows a walkthrough

I will create a tags folder under WEB-INF to reference those tags (we add the taglib to reference this below)
I will use a prefix of "my" for the below:
-->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="my" tagdir="/WEB-INF/tags"%>


<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!doctype html>
<html>
<head>
    <title>Bookstore Category Page</title>
    <meta charset="utf-8">
    <meta name="description" content="The category page for a bookstore">

    <!--
        normalize-and-reset.css.css is a basic CSS reset; useful for starting from ground zero.
        always include this first.
    -->

    <link rel="stylesheet" href="<c:url value="/css/normalize-and-reset.css"/>">

    <!--
        cascading appropriately, we have:

        main.css    --  all things common
        header.css  --  header-specific rules
        footer.css  --  footer-specific rules
        <page>.css  --  page-specific rules
        extras.css  --  extras you may want

        padding for .left and .right is needed to inflate headers
    -->



    <!--



    We imported from the jstl core library so we can use the c: url which allows the application context to find your css files.
    A jsp page can use nested double quotes as seen below

    so previously:
        <link rel="stylesheet" href="../../css/normalize-and-reset.css">   [FROM ABOVE]
    <link rel="stylesheet" href="../../css/main.css">
        <link rel="stylesheet" href="../../css/header.css">
            <link rel="stylesheet" href="../../css/footer.css">
    <link rel="stylesheet" href="../../css/category.css">




    reference template for the category.css (do we need type=text/css?
        <link rel="stylesheet" type="text/css" href="">

       making all the changes above and below we get the css back!

       GOT IT:

               /* Responsive layout - makes the three columns stack on top of each other instead of next to each other */
        @media screen and (max-width:1385px) {
            .bookItems{
                display: flex;
                flex-direction: column;
            }

        }


        /* Responsive layout - makes the three columns stack on top of each other instead of next to each other
        At 850 pixels reduce the padding within entries*/
        @media screen and (max-width:850px) {
            .bookSet{
                padding-right: 5px;
                height: 400px;
            }

            .bookInfo{
                margin-right: 80px;
            }

        }

    -->


    <link rel="stylesheet" href="<c:url value="/css/main.css"/>">
    <link rel="stylesheet" href="<c:url value="/css/header.css"/>">
    <link rel="stylesheet" href="<c:url value="/css/footer.css"/>">
    <link rel="stylesheet" href="<c:url value="/css/category.css"/>">


    <style>

        /* width went from 200px to 225px to accomodate the length of scifi*/
        ul.a {
            list-style-type: none;
            margin: 0;
            padding: 0;
            width: 225px;
            background-color: #f1f1f1;
            border: 5px solid #555;
        }

        li.b a {
            display: block;
            color: blue;
            padding: 8px 16px;
            text-decoration: none;
        }

        /*in addition to the listproperties provided above, the suggested book items get more padding
        40 pixels up/down, 70 px left-right*/
        li.suggestedBookItem{
            padding: 40px 70px;
        }

        /* border bottom creates a line at the end of every menu item
        took out
                    border-bottom: 1px solid #555;*/
        li.b {
            text-align: center;
            border: 10px solid lightgoldenrodyellow;
        }

        /*Ohhhh so there is a last child to write in the border bottom as well*/
        li.b:last-child {
            border-bottom: 10px solid lightgoldenrodyellow;
        }

        li.b a.active {
            background-color: #4CAF50;
            color: white;
        }

        li.b a:hover:not(.active) {
            background-color: yellow;
            color: blue;
        }






    </style>

</head>

<body>

<!--
I added a useBean in category.jsp that enables us to print the category buttons instead of hardcoding them as we have done prior, ie with
                <li class="b"><a href="category?category=technology">Technology</a></li>

We took inspiration from test.jsp, which also used the bookList useBean
and used a     c:forEach var="book" items="selectedBookList to access each book and its properties.
In our case we use the categoryList and access the category name to print it out.
the categoryList is from categoryServlet's doGet method.

Category.jsp much like test.jsp has a usebean for the selectedCategoryName we defined in CategoryServlet.java (test.jsp had it defined in TestServlet.java)
So now have the selected category name and the list of categories.

Copied the selectedBookList from test.jsp and also put it to category.jsp (to get the books from a specific category). We can iterate through
the selectedBookList for the specific category (code copied from test.jsp)


To read from the category controller servlet,
place the following JSP statement (p) near the top of your category JSP page. (see below)

Don't use the following anymore since p encapsulates that functionality
Once you do this, IntelliJ will treat "p" as a category view-model object and smart auto-completion will work with it.

Now you are going to have to go through your category JSP file and tweak it so that it uses "p" instead of the
attributes you set in the controller servlet. For example, in my project, I had to change "{categoryName}" to "{p.selectedCategory.name}".
The nice thing about it was that as soon as I typed "p.", IntelliJ offered me suggestions for the rest.

Took away these three (everything now coming from the view model)
jsp:useBean id="selectedCategoryName" type="java.lang.String" scope="request"/>
jsp:useBean id="categoryList" type="java.util.List" scope="request"/>
jsp:useBean id="selectedBookList" type="java.util.List" scope="request"/>


-->

<jsp:useBean id="p" scope="request" type="viewmodel.CategoryViewModel"/>



<main>
    <jsp:include page="header.jsp"/>

    <section id="totalFrame">

        <section id="left">

            <ul class="a">
                <!--

                Took inspiration from test.jsp's forEach code where we iterate across the category names instead of the booklist.
                Loop through each category in the category list

                Put a choose statement (equivalent of if-else statement); choose to print the button depending
                on whether the category is selected or unselected

                We already have the selected category from the TestServlet, and the list of categories. Make condition on whether name of category
                is equal to the selected category name.

                Need to also get a usebean for the category, to access the category ID and name. So we put a usebean below (much like for test.jsp
                we have a usebean for the book to get the book properties outputted into a table)


                take away this old selectedCategory:
                <li class="b">
                    <div id="selectedCategory">
                        <a href="category?category=science" href="#home">Science</a>
                    </div>
                </li>

                                <li class="b"><a href="category?category=technology">Technology</a></li>
                <li class="b"><a href="category?category=scifi">Science Fiction</a></li>
                <li class="b"><a href="category?category=literature">Literature</a></li>
                <li class="b"><a href="category?category=history">History</a></li>
                <li class="b"><a href="category?category=imdb">IMDB Top 250</a></li>
                <li class="b"><a href="category?category=business">Business</a></li>
                <li class="b"><a href="category?category=health">Health</a></li>
                <li class="b"><a href="category?category=diy">Do-It-Yourself</a></li>

                then the selectedCategoryName is selected below

                when you are finished, there is an otherwise category (can have as many whens as you want)
                for otherwise we want the category to equal its name and create a url referencing this name

                and for the unselected classes we put a style that capitalizes the first letter of it (this belongs in the css)

                categoryList became p.categories below (to conform with the p CategoryViewModel). IntelliJ knows that p.categories
                is a list of category objects. So we no longer need that usebean for categoryList to tell you that the category is a category.

                took away
                                    jsp:useBean id="category" type="business.category.Category" scope="page"/>


                also selectedCategoryName became p.selectedCategory.name (from CategoryViewModel.java, and Category.java properties)
                chagned in 2 places within the when test
                -->

                <c:forEach var="category" items="${p.categories}">
                    <c:choose>
                        <c:when test="${p.selectedCategory.name==category.name}">

                            <li class="b" style="text-transform: capitalize">
                                <div id="selectedCategory">
                                    <a href="#home">${p.selectedCategory.name}</a>
                                </div>
                            </li>

                        </c:when>

                        <c:otherwise>
                            <li class="b" style="text-transform: capitalize"><a href="category?category=${category.name}">${category.name}</a></li>
                        </c:otherwise>

                    </c:choose>

                </c:forEach>

            </ul>

        </section>

        <section id="right">

            <!--
            Don't need all the rows since we are not doing tables anymore. Also copied a class bookSet item with a Read Now
            inside the forEach loop. Keep the book image fornow, but change the bookTitle since we can directly get that from the book

            figure out the pricing divisions (put double dollar signs, as first dollar sign indicates actual dollar, second gets the price.
            We will have to get 8.99 not 899. %100 (break down dollars and cents, decimal in between) (I used div 100, seems to work)

            Also below create a conditional; if the book is public, then a readNow button is available

            we don't really see the flex-wrap aspect for the books


            with the p category viewModel, selectedBookList becomes p.selectedCategoryBooks from CategoryViewModel.java for a specific category
            knows it is a list of books so knows book is a book object

            -->
            <c:forEach var="book" items="${p.selectedCategoryBooks}">
                <jsp:useBean id="book" type="business.book.Book" scope="page"/>

                <ul class="bookItems">

                    <div class="bookSet">


                        <c:set var="bookImageFilename">

                            <!-- Below uses the prefix of my referencing the WEB-INF/tags folder
                            needs to find an imageName.tag file within the tags folder
                            we created the .tag file, and it is similar to a JSP page (in fact, it has the JSP label at the left bar)
                            To use the imageName tag, you can now call it directly:

                            Assuming you have imported the tag directory using the prefix "my" as shown above,
                            you can now use the tag in your JSP page.

                            so for the suggestedBookItem, instead of hyperspace.gif, use {bookImageFileName} as derived from this variable


                            take away the .gif"

                            For now this doesn't work as intended; only below works as intended (there was a space between end of filename and gif)

                            toook away
                            <div class="rightSide">
                            for book info and buttons

                            took away dollar designs in front of { below

                            {bookImageFilename}
                            <p>Final string : {bookDash}</p>

                            https://stackoverflow.com/questions/16166378/search-and-replace-single-quote-and-backslash-using-jstl

                            tags don't work but Dr. K says we don't need tags (optional) so stick with the JSTL functions in the JSP page (see below)
                            via: https://canvas.vt.edu/courses/70400/external_tools/2284
                            -->
                            <my:imageName bookTitle="${book.title}"/>
                        </c:set>

                        <c:set var="search" value="'" />

                        <c:set var="bookTitle" value="${book.title}"/>
                        <c:set var = "bookLower" value = "${fn:toLowerCase(bookTitle)}" />
                        <c:set var = "bookDash" value = "${fn:replace(bookLower,' ','-')}" />
                        <c:set var = "bookColon" value = "${fn:replace(bookDash,':','')}" />
                        <c:set var = "bookComma" value = "${fn:replace(bookColon,',','')}" />
                        <c:set var = "bookFinal" value = "${fn:replace(bookComma,search,'')}" />


                        <!--previously: initParam.bookImages
                        now p.bookImagePath

                                                    {bookFinal}

                        -->

                        <li class="suggestedBookItem">
                            <a href="#">
                                <img src="${p.bookImagePath}${bookFinal}.gif" alt="Hyperspace"/>
                            </a>
                        </li>



                        <div class="bookInfo">
                            <p class="bookName"><strong>${book.title}</strong></p>
                            <br>
                            <p>${book.author}</p>
                            <p><strong><fmt:formatNumber value="${book.price div 100}" type="currency"/></strong></p>
                            <!-- previously used-->
                            <%--<p><strong>$${book.price div 100}</strong></p>--%>
                            <br>
                            <br>
                        </div>



                        <div class="buttons">

                            <!-- taken from Dr. K, category controller accounts for add to cart (can be cart controller)
                            easier to keep on same page otherwise will need another hidden input to acct for previous page

                            prev input class addToCartButton, changed to cartButton

                            need to fix the submit border--which is inflated with cartButton css

                            so when clicking submit for Add to Cart, should handle post request; handle this in your
                            category servlet's doPost request


                            TO TEMPORARILY FIX THE SAVED CATEGORY PROBLEM:
                            save the category name as a hidden variable in the form to pass over to the CategoryServlet's DoPost

                            -->

                            <!-- On your category page, insert this code (with necessary changes for your styling) before the add-to-cart form. Proj 9 PtII AJAX
                            Step 1 - Create a new add-to-cart button

                            so we have 2 buttons to compare and see what they look like

                            The "data-" fields refer to custom fields that you create. They syntax is important here. It will be recognised by
                            special Javascript functions. Notice that we have "book-id" instead of "bookId" in the data name. This is deliberate.
                            Book-dash-id is going to become book camel case ID (they correspond to each other); this is how javascript reads those attributes
                            javascript has access to all data attrib's you set up

                            less input tags than what we had with the cartButton, so have to be comfortable with the syntax change

                            I then comment out the form submit to add to cart (since we don't need that anymore)--goal is to have ajax replace that functionality
                            Change Ajax Add

                            Fixed the button post issue with some css changes; added addToCartButton css to be  same as readNow css and also added the <a> tag to
                            it to make it hoverable it will display a certain color; change the width of add to cart a little as well
                            -->


                            <%--<div class="cartButton">--%>



                            <button class="addToCartButton"
                                    data-book-id="${book.bookId}"
                                    data-action="add">
                                    Add To Cart
                            </button>

                                <%--<form action="category" method="post">--%>
                                    <%--<input type="hidden" name="bookId" value="${book.bookId}"/>--%>
                                    <%--<input type="hidden" name="action" value="add"/>--%>
                                    <%--<input type="hidden" name="category" value="${p.selectedCategory.name}"/>--%>
                                    <%--<input type="submit" name="submit" value="Add to Cart"/>--%>

                                <%--</form>--%>

                            <%--</div>--%>


                            <c:if test="${book.isPublic}">

                                <div class="readNow">
                                    <a href="#">
                                        <p><strong>Read Now</strong></p>
                                    </a>
                                </div>

                            </c:if>
                        </div>

                    </div>

                </ul>

            </c:forEach>


        </section>


    </section>

    <jsp:include page="footer.jsp"/>
</main>

<!-- Step 2 - Create listeners for your new buttons
At the bottom of your category.jsp (but inside the body) add the following code.

Below is javascript code. We created multiple addToCartButtons above for each  (we have a forEach loop creating the buttons b4 page is laoded), and so each button gets an event
listener where they get the event-target data from the button that triggered the event. This would get
 the data  such as the bookId and  the action for that particular book (these are the data fields) and put it into a data object
 Eventually the book id will be posted to the server, but the ajaxPost for the category data and the cart count
 are currently commented out.
  The function "addToCartCallback" processes the JSON text string (for the cart count) we get back from the server (handles response from server)
  This function won't execute until we call "ajaxPost" from the "addToCartEvent" function.

  For now, we just want to invoke the alert of insideCartEvent when we press the button.

  Dr A says that this script is at btm bc browser will have all content (html tags) available; such as "addToCartButton", "cartCount", etc.
  ie the add to cart buttons would exist in browser memory when we run the event listener code at the end.

Also might need to comment out the old addToCartButton  or the listeners would apply to all buttons not just the AJAX ones. Be careful about this.
Luckily my old code used cartButton not addToCartButton so I don't get the listener attached to that. Dr. K had this problem, but when clicking his add to
cart, even after getting the AJAX alert, it goes back to the server/form actions where it adds the book to the cart after you press OK on the alert the
for-m is still in place (but don't double the request to the server if you send the request to the server using AJAX as well). Dr. K fixed the double issue by changing
the names of the server/form button so the AJAX won't affect it.

css class name addToCartButton ensures ensures listener is added to the anything with that addToCartButton tag, so you can then get that same alert for those

ALSO: add the text/javascript below, just before your various listeners.
To your category page, add the following line just before the script you already included.

This will enable the category page to see the added functions. Note that these functions will work for buttons other
than add-to-cart as long as you implement them properly. For example, you may want to implement Ajax buttons for
the increment, decrement, and update buttons on your cart page as well.

Finally, comment in the call to "ajaxPost" from the "addToCartEvent" function and run your project. Now clicking
the Ajax add-to-cart button should cause your cart to be updated just as if you clicked on the original add-to-cart
button, because both buttons are passing the same information to the servlet and are being handled in the exact same way.


(At the moment we just expect an alert from addToCartCallback, we haven't established the text for the cartCount yet;
(that's the next step). I run the code. The addToCartCallback aleart essentially takes ALL the text from your category.jsp page, as we
are invoking the ajaxPost fn on the category page. It is cutting the category page. with ...
-->

<script src="<c:url value="/js/ajax-functions.js"/>" type="text/javascript"></script>

<script>
    var addToCartButtons = document.getElementsByClassName("addToCartButton");
    for (var i = 0; i < addToCartButtons.length; i++) {
        addToCartButtons[i].addEventListener("click", function(event) {
            addToCartEvent(event.target) });
    }

    <!-- categoryId should be bookid and the action should be add-->
    function addToCartEvent(button) {
        //JUST COMMENT OUT THE ALERTS SINCE WE DON'T WANT THEM TO SHOW IN THE REAL DEPLOYMENT
         //alert("Inside AddToCartEvent");
        var data = {"bookId":button.dataset.bookId,
            "action":button.dataset.action
        };
        ajaxPost('category', data, function(text, xhr) {
        addToCartCallback(text, xhr)
        });
    }

    function addToCartCallback(responseText, xhr) {
        //JUST COMMENT OUT THE ALERTS SINCE WE DON'T WANT THEM TO SHOW IN THE REAL DEPLOYMENT
        // alert('Response text: ' + responseText + '; Ready state is ' + xhr.readyState);

        //so as part of Proj9PtII: Modify the servlet the handle add-to-cart posts
        //we went into the callback for category servlet and set a json String for cartCount so
        //after writing it as part of the response text we can access the cartCount and reset it immediately
        //rather than having to refresh the page manually with reload
        //remember in my header.jsp I have
        <%--<div id="cartCount">${p.cart.numberOfItems}</div>--%>
        //which has the id cartCount which we want to modify its contents (so my header is set up the right way)-->appends cartCount (a #) as a string
        //so p.cart.NumItems will be replaced
        //try to use JSON as a response as much as possible and can use the information from there to update the document model.
        //for instance, adding JSON to increment/decrement the cart page (we might have more JSON fields to account for) to update document model

        var cartCount = JSON.parse(responseText).cartCount;
        document.getElementById('cartCount').textContent = '' + cartCount;

    }
</script>

</body>
</html>

<!--
PREVIOUS FORMAT FOR THE BOOKS:


<ul class="bookItems">

    <div class="bookSet">

        <li class="suggestedBookItem">
        <a href="#">
        <img src="initParam.bookImages}hyperspace.gif" alt="Hyperspace"/>
        </a>
        </li>


        <div class="rightSide">

            <div class="bookInfo">
            <p class="bookName"><strong>Hyperspace</strong></p>
            <p>Michio Kaku</p>
            <p><strong>$8.98</strong></p>
            </div>

            <div class="buttons">

            <div class="cartButton">
            <a href="#">
            <p><strong>Add To Cart</strong></p>
            </a>
            </div>


            <div class="readNow">
            <a href="#">
            <p><strong>Read Now</strong></p>
            </a>
            </div>

            </div>

        </div>
    </div>


<div class="bookSet">
<li class="suggestedBookItem">
<a href="#">
<img src="initParam.bookImages}the-elegant-universe.gif" alt="The Elegant Universe"/>
</a>
</li>

<div class="rightSide">

<div class="bookInfo">
<p class="bookName"><strong>The Elegant Universe</strong></p>
<p><strong>Brian Greene</strong></p>
<p><strong>$4.49</strong></p>
</div>

<div class="buttons">
<div class="cartButton">
<a href="#">
<p><strong>Add To Cart</strong></p>
</a>
</div>


<div class="readNow">
<a href="#">
<p><strong>Read Now</strong></p>
</a>
</div>
</div>

</div>
</div>
</ul>

<ul class="bookItems">
<div class="bookSet">
<li class="suggestedBookItem">
<a href="#">
<img src="initParam.bookImages}marie-curies-search-for-radium.gif" alt="Marie Curie's Search For Radium"/>
</a>
</li>

<div class="rightSide">

<div class="bookInfo">
<p class="bookName"><strong>Marie Curie's Search For Radium</strong></p>
<p><strong>Beverly Birch, Christian Birmingham</strong></p>
<p><strong>$5.44</strong></p>
</div>

<div class="buttons">
<div class="cartButton">
<a href="#">
<p><strong>Add To Cart</strong></p>
</a>
</div>


</div>

</div>
</div>

<div class="bookSet">
<li class="suggestedBookItem">
<a href="#">
<img src="initParam.bookImages}cool-it-skept-enviro.gif" alt="Cool It: The Skeptical Environmentalist’s Guide To Global Warming"/>
</a>
</li>

<div class="rightSide">

<div class="bookInfo">
<p class="bookName"><strong>Cool It: The Skeptical Environmentalist’s Guide To Global Warming</strong></p>
<p><strong>Bjorn Lomborg</strong></p>
<p><strong>$4.77</strong></p>
</div>

<div class="buttons">
<div class="cartButton">
<a href="#">
<p><strong>Add To Cart</strong></p>
</a>
</div>


<div class="readNow">
<a href="#">
<p><strong>Read Now</strong></p>
</a>
</div>
</div>

</div>
</div>

</ul>


<ul class="bookItems">
<div class="bookSet">
<li class="suggestedBookItem">
<a href="#">
<img src="initParam.bookImages}botany-for-dummies.gif" alt="Botany For Dummies"/>
</a>
</li>

<div class="rightSide">

<div class="bookInfo">
<p class="bookName"><strong>Botany For Dummies</strong></p>
<p><strong>Rene Fester Kratz</strong></p>
<p><strong>$11.88</strong></p>
</div>

<div class="buttons">
<div class="cartButton">
<a href="#">
<p><strong>Add To Cart</strong></p>
</a>
</div>
</div>

</div>
</div>

<div class="bookSet">
<li class="suggestedBookItem">
<a href="#">
<img src="initParam.bookImages}geology.gif" alt="Geology"/>
</a>
</li>

<div class="rightSide">

<div class="bookInfo">
<p class="bookName"><strong>Geology</strong></p>
<p><strong>Frank Harold, Trevor Rhodes</strong></p>
<p><strong>$3.49</strong></p>
</div>

<div class="buttons">
<div class="cartButton">
<a href="#">
<p><strong>Add To Cart</strong></p>
</a>
</div>
</div>

</div>
</div>

</ul>
-->
