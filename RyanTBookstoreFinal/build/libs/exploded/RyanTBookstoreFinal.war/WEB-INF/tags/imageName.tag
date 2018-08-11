<!--
Tag files allow you to create simple custom tags without a lot of code and without *any* Java code.
A tag file is similar to a JSP page. A tag file should reside in the WEB-INF/tags directory.
It has the name [tagFile].tag, where [tagFile] is the name of the tag you use to refer to it.


Suppose you want to create a tag file that gets the book title from the image name
(from which we use the JSTL function library).
For that, we created a file called imageName.tag and place it in the WEB-INF/tags directory.
In the JSP page where you want to use the tag, you first have to import your tags and give them a prefix.
this was done in category.jsp where we used my:imageName to access the bookTitle which we implement below

We have several directives:
FIRST: tag - declare this as a tag file
The body-content attribute indicates whether this tag will allow bodies or not.
The imageName tag will *not* allow bodies, so we give it a value of "empty".
Another possible value is "scriptless", which is the default. It means that standard bodies are allowed.
The last value is "tagdependent", which means that special bodies (determined by the tag) are allowed.


SECOND: taglib - use another tag library
Next, we import tag libraries into our file. We use both the core library and the function library in our code.

THIRD: attribute - declare an attribute in a tag file.
We have an required attribute of type string called bookTitle (now we can reference this in category.jsp)
Since our tag requires an input string, we need the tag to have an attribute that holds the string. We use the attribute directive.

finally it writes out the finished result

considered adding .gif to the end of replace since there is no space skips.

rtexprvalue="true"
-->

<%@ tag body-content="empty" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ attribute name="bookTitle"  required="true" type="java.lang.String" description="Book Title" %>


<c:set var = "bookLower" value = "${fn:toLowerCase(bookTitle)}" />
<c:set var = "bookDash" value = "${fn:replace(bookLower,' ','-')}" />
<c:set var = "bookColon" value = "${fn:replace(bookDash,':','')}" />
<c:set var = "bookComma" value = "${fn:replace(bookColon,',','')}" />
<c:set var = "bookFinal" value = "${fn:replace(bookComma,search,'')}" />


${bookDash}



<!--

c:set var="name1">
    <!-- transform name1 with a JSTL fn here
    previously value="{fn:substring(input, 0, 1)}"

    I noticed the elegant universe came out with an arrow like this
    the elegant universe.gif"

    "{fn:substring(bookTitle, 0, fn:length(bookTitle))}"


    {fn:toLowerCase(bookTitle)}




c:set>

c:set var="name2">
    <!-- transform name2 with a JSTL fn here
    previously c:set var="upperFirst" value="{fn:toUpperCase(firstChar)}" />

    {fn:substring(name1, 0, fn:length(bookTitle))}
    {fn:trim(name1)}


    {fn:trim(name1)}


/c:set>

c:set var="name3">
    <!-- transform name2 with a final JSTL fn here
    previously c:set var="allButFirst" value="{fn:substring(input,1,fn:length(input))}" />
    Used stackoverflow for inspiration: https://stackoverflow.com/questions/58054/how-can-i-replace-newline-characters-using-jsp-and-jstl/1690942#1690942

    Below looks to replace all the spaces with dashes
    goal is to get from “The Elegant Universe” to “the-elegant-universe”


    {fn:replace(name2,' ','-')}



/c:set>


{name2}

-->