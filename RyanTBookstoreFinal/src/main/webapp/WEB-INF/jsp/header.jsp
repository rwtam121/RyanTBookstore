<%--

This is the bracket for comments.

Each id is unique, so needs a different name. We need a section  ID
for left, mid and right header

        /*Cut reference to logo and paste inside left header ; just want the logo inside the left header
        This image also acts as a link back to the index.jsp page
        this works: facebook.png, try wormhole.jpg*/

 /*Will have text logo inside the mid  (also will need the search bar and the search icon)*/

        /*Also need a search bar and a search icon after the logo text. Search is going to be a form.
        Takes to the category page. Remember siteImages defined in web.xml*/

        cartCount is inside the cartIcon div

        note that the search.png is very dark and has bad contrast, so I cropped the magnifying glass I had in my ppt
        and made the searchMag.jpg. Likewise cart.png too dark, used cartUsed.jpg

        The cartLogin (housing the cartIcon, cartCount and Login) should definitely be a flexbox

        categoryLabel is placeholder for dropdown

        Previously for logo I did this:
                        <img src="${initParam.siteImages}wormhole.jpg" alt="Bookstore logo" width="100" height="100"/>

                        previous hover bkgrd color: background-color: #f1f1f1

                        Search button for the search bar; might eventually need a button rather than search icon
                                    <button type="submit"><i class="fa fa-search"></i></button>

                                    For CART
                                    TEMPLATE FOR PREVIOUS:

                                            <div id="cartAndLogin">
            <div id="cartIcon">
                <a href="cart.jsp">
                    <img src="${initParam.siteImages}cartUsed.jpg" alt="shopping cart icon"/>
                </a>
                <div id="cartCount">0</div>
            </div>
            <div id="loginButton">G</div>
        </div>
        <div id="categoryDropdown">
            <p id="categoryLabel">Categories</p>
        </div>


            .column.one, .column.two, .column.three {
                width: 10%;
            }
                    /* Create three equal columns that floats next to each other */
        .column {
                        float: left;
            width: 33.33%;
            padding: 15px;
        }

        probably don't need to set parameters via                         <jsp:setProperty name="" property=""/>

        normally we can append category values via a form, but here we take in predefined values (this is via a GET method)



changed the dropdown padding left from 75px to 10px
--%>

<head>
    <style>
        .dropdown {
            position: relative;
            display: inline-block;
            padding-left: 10px;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
        }

        .dropdown-content a {
            color: darkblue;
            padding: 12px 16px;
            text-decoration: none;
            font-family: "Copperplate Gothic Light";
            font-weight: bold;
            display: block;
        }

        .dropdown-content a:hover {background-color: yellow}

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .dropdown:hover {
            background-color: #f1f1f1;
        }

        .desc {
            padding: 15px;
            text-align: center;
        }

        .column {
            float: left;
            width: 33.33%;
            padding: 15px;
        }



        /* Responsive layout - makes the three columns stack on top of each other instead of next to each other
        take this out for now; want it to flex properly

                @media screen and (max-width:1375px) {
            header{
                height: 500px;
                display: flex;
                flex-direction: column;
            }

        }

        */

    </style>
</head>

<!--
need to modify your header. Since all page-specific view-models inherit from the base view-model,
our header can use any view-model that is created *as* a BaseViewModel.
Put the following at the top of the header JSP page fragment:
(this means our usebean p can use anything from categoryServlet or HomepageServlet
We only need HomePageServlet if we are looking to add specific features to our homepage, like getting
three random books to show up as discussed in P5 instructions

But this means we don't have to hardcode our categories--we can get specific category names much like
what we did for our menu in category.jsp (but this time for our dropdown menu in our header)

I changed the logo and logoText to reference index.jsp instead of homepage.jsp

instead of category.jsp put category (NOT /category)
saw in category.jsp we referenced href="category?category=

I also added the jstl taglib for the foreach to iterate across category names in the header

since we have the baseViewModel here, replace all initParam.siteImages with p.getSitePath


Removing the division headers for columns
<div class="column one">
</div>


<div class="column two">
</div>


<div class="column three">
</div>

Already added the viewModel to the header and footer
-->
<jsp:useBean id="p" scope="request" type="viewmodel.BaseViewModel"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<header>

    <section id="leftHeader">

        <div id="logo">
            <a href="index.jsp">
                <img src="${p.siteImagePath}wormhole.jpg" alt="Bookstore logo" width="100" height="100"/>
            </a>
        </div>

        <div id="logoText">
            <a href="index.jsp">
                <img src="${p.siteImagePath}logoTitle.jpg" alt="Bookstore logo text"/>
            </a>
        </div>

    </section>



    <section id="midHeader">
        <div class="dropdown">
            <img src="${p.siteImagePath}categories.png" alt="Categories text"  width="220" height="48" />

            <div class="dropdown-content">
                <c:forEach var="category" items="${p.categories}">

                    <div class="desc" style="text-transform: capitalize"><a href="category?category=${category.name}">${category.name}</a></div>

                </c:forEach>
            </div>

            <!--
            category text size:  width="146.5" height="32" does not work well

            We don't need a selectedCategory (that is only in the domain of the CategoryViewModel which we don't have exposure to)
            all we need is just every item in category (no need for conditional on if item is selected--in category that highlighted the item)

            in category.jsp it was a list <li class b> for us we need to keep thej same class and div so div class=desc
            and capitalize the name in the list so science- is Science

            previously:
                               <div class="desc">
                    <a href="category?category=science">Science</a>
                    <a href="category?category=technology">Technology</a>
                    <a href="category?category=scifi">Science Fiction</a>
                    <a href="category?category=literature">Literature</a>
                    <a href="category?category=history">History</a>
                    <a href="category?category=imdb">IMDB Top 250</a>
                    <a href="category?category=business">Business</a>
                    <a href="category?category=health">Health</a>
                    <a href="category?category=diy">Do-It-Yourself</a>
                </div>

                get rid of choose statement as well (choose is for switching no need for that)
            -->
        </div>


        <!-- Changed hardcoded 2 in cartCount to the number of items accessed from the cart; header.jsp has p inheriting from baseViewModel and we have a getter for the cart and access its itemcount for session-->
        <div id="cartAndLogin">
            <div id="cartIcon">
                <a href="cart">
                    <img src="${p.siteImagePath}cartUsed.jpg" alt="shopping cart icon"/>
                </a>
                <div id="itemsArray">
                    <div id="cartCount">${p.cart.numberOfItems}</div>
                    <div id="itemsTag">
                        <img src="${p.siteImagePath}items.png" alt="items"/>
                    </div>
                </div>
            </div>
        </div>
    </section>



    <section id="rightHeader">

        <form id="searchForm" action="category">
            <input id="searchBox" type="text" placeholder="Search.." name="category">
            <input id="searchIcon" type="image" src="${p.siteImagePath}searchMag.jpg" alt="search icon">
        </form>

        <!-- previously login standard is 249 by 82--from inspect image; scale same ratio to 180 by 60-->
        <a href="#">
            <img src="${p.siteImagePath}login.png" alt="Login" width="180" height="60"  />
        </a>

    </section>

</header>


<img src="${p.siteImagePath}lineThru.png" alt="Line Through"/>

