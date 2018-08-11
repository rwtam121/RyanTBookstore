<%--

just like header footer needs to be separated into left, mid and right and style defined at footer.css
contains copyright, directions, privacy, social media icons at right

copyright is &copy (don't put in paragraph p wrapper b/c might put margin there)

Dr K put links like <a> </a> | <a> </a>

just context parameter for siteImages in the footer. (not from books)

change some formatting at 800px level for head/style

<head>
    <style>
        /* Responsive layout - makes the three columns stack on top of each other instead of next to each other */
        @media screen and (max-width:850px) {

            #motto{
                margin-bottom: 15px;
            }

        }


    </style>
</head>

            #leftFooter{
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: space-between;

            }
--%>

<head>
    <style>
        /* Responsive layout - makes the three columns stack on top of each other instead of next to each other */
        @media screen and (max-width:1100px) {

            footer{
                height:350px;
                display: flex;
                justify-content: space-around;
                flex-direction: column;
            }

        }


    </style>
</head>


<!--
use the bean for footer to replace initParam.siteImages with p.getSitePath
-->
<jsp:useBean id="p" scope="request" type="viewmodel.BaseViewModel"/>


<footer>
    <section id="leftFooter">

        <a href="#">
            <img src="${p.siteImagePath}wormhole.jpg" alt="Bookstore logo" width="75" height="75"/>
        </a>

        <div id="companyName">
            <div id="RyanBooks">
                <p>Ryan's Books Of The Future</p>
            </div>
            <br>
            <div id="motto">
                <p>"Enlightenment for Today's Generation"</p>
            </div>
        </div>

    </section>


    <section id="midFooter">

        <div id="topIcons">
            <a href="#">
                <img src="${p.siteImagePath}directions.png" alt="Directions icon" width="35" height="35"/>
            </a>

            <a href="#">Directions</a>

            <a href="#">
                <img src="${p.siteImagePath}contactus.png" alt="Contact Us icon" width="35" height="35"/>
            </a>

            <a href="#">Contact Us</a>
        </div>


        <div id="bottomText">
            <br>
            <p>&copy; 2018 Books Of The Future, Inc.</p>
        </div>


    </section>


    <section id="rightFooter">

        <p>Follow Us</p>

        <div id="contactIcons">
            <a href="#">
                <img src="${p.siteImagePath}linkedinOne.png" alt="Linkedin icon"/>
            </a>

            <a href="#">
                <img src="${p.siteImagePath}facebookOne.png" alt="Facebook icon"/>
            </a>

            <a href="#">
                <img src="${p.siteImagePath}twitterOne.png" alt="Twitter icon"/>
            </a>
        </div>

    </section>




</footer>
