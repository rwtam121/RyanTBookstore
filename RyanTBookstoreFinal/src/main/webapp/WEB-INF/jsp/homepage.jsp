<!--
Put two sections to choose three books randomly, but two or three projects from now.

Have a section called upper home and a section called lower home, in lower home have a suggested readings list.
hr signifies a thematic change in content between upper and lower homes (text and suggested readings)

use an ordered list to get the book names

I have a suggested book list referencing homepage.css

suggestedBookItem is now a class (can be used multipletimes for books. suggestedBookList is a flexbox which by default is horizontal

link can be to hashtag # so it can be filled in later

strongis more robust than bold for fonts

emphasis doesn't work yet

I referenced the bulleted list in the main.css

For the homepage.jsp (previously index.jsp), we also need to fix the css problems now, which we
do by adding the same taglib prefix="c" that had for category.jsp


Also, to fulfill the very last part of the project:
Finally, you should be able to replace the context parameters (for site images and book images)
from the web.xml deployment descriptor with the constants from the view-model.

To avoid using the web.xml deployment descriptor we can use the BaseViewModel as a bean and inherit
its site and book image paths, it is using p so can replace siteImages and bookImages with
dollarsign{p.siteImagePath} for instance. So the base view model defines the paths now

From Dr. A: https://canvas.vt.edu/courses/70400/external_tools/2284
-->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:useBean id="p" scope="request" type="viewmodel.BaseViewModel"/>



<!doctype html>
<html>
<head>
    <title>My Bookstore</title>
    <meta charset="utf-8">
    <meta name="description" content="The homepage for My Bookstore">

    <!--
        normalize-and-reset.css is a basic CSS reset; useful for starting from ground zero.
        always include this first.

        previously:     <link rel="stylesheet" href="../../css/normalize-and-reset.css">

    -->

    <link rel="stylesheet" href="<c:url value="/css/normalize-and-reset.css"/>">




    <!--
        cascading appropriately, we have:

        main.css    --  all things common
        header.css  --  header-specific rules
        footer.css  --  footer-specific rules
        <page>.css  --  page-specific rules
        extras.css  --  extras you may want

        These establish the colors through the external style sheet
        https://www.w3schools.com/css/tryit.asp?filename=trycss_howto_external

        previously:
            <link rel="stylesheet" href="../../css/main.css">
    <link rel="stylesheet" href="../../css/header.css">
    <link rel="stylesheet" href="../../css/footer.css">
    <link rel="stylesheet" href="../../css/homepage.css">

    should be homepage.css!!!! not category.css (that's why it didn't render!)
    -->



    <link rel="stylesheet" href="<c:url value="/css/main.css"/>">
    <link rel="stylesheet" href="<c:url value="/css/header.css"/>">
    <link rel="stylesheet" href="<c:url value="/css/footer.css"/>">
    <link rel="stylesheet" href="<c:url value="/css/homepage.css"/>">

    <style>
        ul.a {
            list-style-type: circle;
        }

    </style>


</head>



<body>
<main>
    <jsp:include page="header.jsp"/>

    <section id="homeTotal">
        <section id="leftFrame">

            <div id="topLeft">
                <p align="left"><strong>Want to indulge in books that are culturally significant or wide reaching?</strong></p>
                <p align="left">Books that will be read by <em>future generations?</em> You’ve come to the right place.</p>
            </div>

            <div id="bottomLeft">
                <p><u>Our advantages include:</u></p>
                <br>
                <ul class="a">
                    <li>We sell audiobooks and e-books for all our books</li>
                    <li>We email apps for select books, so readers can experience various book scenes through virtual reality headsets</li>
                </ul>
            </div>

            <div id="featuredBooks">

                <p><u>Featured books from: ${p.randomlySelectedCategory.name} </u></p>
                <br>

                <c:forEach var="book" items="${p.selectedRandomCategoryBooks}">
                    <jsp:useBean id="book" type="business.book.Book" scope="page"/>

                    <c:set var="search" value="'" />

                    <c:set var="bookTitle" value="${book.title}"/>
                    <c:set var = "bookLower" value = "${fn:toLowerCase(bookTitle)}" />
                    <c:set var = "bookDash" value = "${fn:replace(bookLower,' ','-')}" />
                    <c:set var = "bookColon" value = "${fn:replace(bookDash,':','')}" />
                    <c:set var = "bookComma" value = "${fn:replace(bookColon,',','')}" />
                    <c:set var = "bookFinal" value = "${fn:replace(bookComma,search,'')}" />


                    <ul class="randBooks">
                        <li class="bookie">
                            <img src="${p.bookImagePath}${bookFinal}.gif" alt="Hyperspace"/>
                        </li>
                    </ul>

                </c:forEach>

            </div>

        </section>

        <!--
        can just use the baseviewModel, still can resolve the category (no need for HomepageViewModel below, confuses the algo
                        jsp:useBean id="x" scope="request" type="viewmodel.HomepageViewModel"/>


         {p.randomlySelectedCategory.name}
        need to change all category.jsp to category

        now that I added the bean to the baseview model replace initParam.siteImages
        with p.siteImagePath
        -->
        <section id="rightFrame">

            <ul id="suggestedCatList">

                <li class="suggestedCatItem">
                    <a href="category?category=science">
                        <img src="${p.siteImagePath}scilogo.png" alt="science logo" />
                    </a>

                    <a href="category?category=science">
                        <img src="${p.siteImagePath}science.jpg" alt="science icon" width="250" height="250"/>
                    </a>
                </li>

                <li class="suggestedCatItem">

                    <a href="category?category=technology">
                        <img src="${p.siteImagePath}techlogo.png" alt="technology logo" />
                    </a>

                    <a href="category?category=technology">
                        <img src="${p.siteImagePath}technology.jpg" alt="technology icon" width="250" height="250"/>
                    </a>
                </li>

                <li class="suggestedCatItem">

                    <a href="category?category=sciencefiction">
                        <img src="${p.siteImagePath}scifilogo.png" alt="scifi logo" />
                    </a>

                    <a href="category?category=sciencefiction">
                        <img src="${p.siteImagePath}scifi.jpg" alt="scifi icon" width="250" height="250"/>
                    </a>
                </li>


                <li class="suggestedCatItem">
                    <a href="category?category=literature">
                        <img src="${p.siteImagePath}litLogo.png" alt="literature logo" />
                    </a>

                    <a href="category?category=literature">
                        <img src="${p.siteImagePath}literature.jpg" alt="literature icon" width="250" height="250"/>
                    </a>
                </li>

                <li class="suggestedCatItem">
                    <a href="category?category=history">
                        <img src="${p.siteImagePath}historyLogo.png" alt="history logo" />
                    </a>

                    <a href="category?category=history">
                        <img src="${p.siteImagePath}history.jpg" alt="history icon" width="250" height="250"/>
                    </a>
                </li>

                <li class="suggestedCatItem">
                    <a href="category?category=imdb">
                        <img src="${p.siteImagePath}imdblogo.png" alt="imdb logo" />
                    </a>

                    <a href="category?category=imdb">
                        <img src="${p.siteImagePath}imdb.png" alt="imdb icon" width="250" height="250"/>
                    </a>
                </li>

                <li class="suggestedCatItem">
                    <a href="category?category=business">
                        <img src="${p.siteImagePath}businessLogo.png" alt="business logo" />
                    </a>

                    <a href="category?category=business">
                        <img src="${p.siteImagePath}business.jpg" alt="business icon" width="250" height="250"/>
                    </a>
                </li>

                <li class="suggestedCatItem">
                    <a href="category?category=health">
                        <img src="${p.siteImagePath}healthLogo.png" alt="health logo" />
                    </a>

                    <a href="category?category=health">
                        <img src="${p.siteImagePath}health.jpg" alt="health icon" width="250" height="250"/>
                    </a>
                </li>

                <li class="suggestedCatItem">
                    <a href="category?category=diy">
                        <img src="${p.siteImagePath}diyLogo.png" alt="diy logo" />
                    </a>

                    <a href="category?category=diy">
                        <img src="${p.siteImagePath}diy.jpg" alt="diy icon" width="250" height="250"/>
                    </a>
                </li>

            </ul>
        </section>

    </section>

    <jsp:include page="footer.jsp"/>
</main>
</body>
</html>

<!--
changed all image sizes from 125X125 to 250X250 (might need to replace lower res images)
also made text up front

Don't need this anymore once we figure out flex: wrap
<ul id="suggestedCatListTwo">
</ul>

<ul id="suggestedCatListThree">

</ul>

Suspect we don't need responsive layout:
/* Responsive layout - makes the three columns stack on top of each other instead of next to each other */
@media screen and (max-width:1005px) {
#suggestedCatListOne, #suggestedCatListTwo, #suggestedCatListThree{
width: 90%;
display: flex;
flex-wrap: wrap;
justify-content: space-evenly;
margin: 20px auto 40px;
align-items: center;
}

.suggestedCatItem{
padding-bottom: 20px;
}



}
-->