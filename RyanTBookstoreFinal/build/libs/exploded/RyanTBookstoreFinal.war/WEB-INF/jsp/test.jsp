<%--
  Created by IntelliJ IDEA.
  User: rwtam
  Date: 6/9/2018
  Time: 2:51 PM
  To change this template use File | Settings | File Templates.

  Note also that the datasource does not end in "DB". The datasource name is defined in your context.xml file.
  here:  <Resource name="jdbc/RyanTBookstore" auth="Container" type="javax.sql.DataSource" in context.xml

  since we aren't getting the results get rid of the import
  <%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

  we were previously making the sql queries here in this jsp file but for separation of tasks we want to delegate all
  those SQL queries to the daojbdc.java files; so no longer need the prefix tag for the below command we were making:

  Just don't need to be accessing the database here from our presentation layer. The controllers cooperate with the DAOs
  to deal with the database (the testServlet controller calls the DAO methods in DAOJdbc.java and returns the items back to this jsp file)
  with the useBean. Don't want to build up pages with SQL dependencies directly.

  Dr Atkinson will do a code review and he'll be looking at things that are irrelevant to what you are using

  <sql:query var="result" dataSource="jdbc/RyanTBookstore">

  Once you put something in the WEB-INF directory you cannot get to it by typing in the address directly.


--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
</head>
<body>


<%--
Create a \n HTML unordered list of clickable categories before Hello World
my request parameter is there

parameter is named category, value of that parameter is science, technology, etc.

the controller servlet named TestServlet.java handles the /test in http://localhost:8080/RyanTBookstoreDao/test?category=health
for example

For below, when accessing the category name to replace HelloWorld,
Notice that when you try to use ${selectedCategoryName} in your JSP page,
IntelliJ does not know if that is a valid attribute. You can fix this by essentially telling IntelliJ that it is using JSP's "useBean" action:

Put this near the top of the file before you use the attribute. It says that variable "selectedCategoryName" of type "String" is a request
attribute (part of the request scope). The request scope refers to the current ServletRequest
 IntelliJ will now assume that this is the case and will no longer give you the compiler warning.
When you run the application, IntelliJ will check if this is true. If it can't find such an attribute, it will give you a runtime error.

Using the bean now allows us to pass everything through the controller servlets. We want to take as much java code out of the jsp pages like this one,
so it just has HTML, CSS and basic things to loop over (we pass in things from the controller servlet--TestServlet.java) so there is a separation of
concerns (eventually this sep of concerns occurs in MVC)

Note that the "useBean" action is so-called because it is typically used with JavaBeans (not to be confused with Enterprise Java Beans, which are something different).
useBean works perfectly fine for non-JavaBeans, it just may not be as flexible. So the below are javabeans since they have a no-argument constructor, getters and setters, and are serialized
We do not have any enterprise java beans (EJB) since Tomcat does not have a EJB container. We use an application context instead for DAOs rather than using ejbs/session beans.
But we step away from the EJB/other frameworks that do a lot of things for you b/c we want to understand these at a more detailed level.


Another thing, intelliJ doesn't believe you have a selectedBookList until you put the useBean implementation below:; get the list for the selectedBookList
Unlike parameters, attributes are not limited to string types, so there is no problem setting list of book objects as an attribute; attribute of type java.util.List
take below out for now (until you replenish the book list for these):

    <li><a href="test?category=history">history</a></li>
    <li><a href="test?category=imdb">imdb</a></li>
    <li><a href="test?category=business">business</a></li>
    <li><a href="test?category=health">health</a></li>
    <li><a href="test?category=diy">diy</a></li>
--%>

<jsp:useBean id="selectedCategoryName" type="java.lang.String" scope="request"/>
<jsp:useBean id="selectedBookList" type="java.util.List" scope="request"/>



<ul>
    <li><a href="test?category=science">science</a></li>
    <li><a href="test?category=technology">technology</a></li>
    <li><a href="test?category=sciencefiction">sciencefiction</a></li>
    <li><a href="test?category=literature">literature</a></li>
</ul>


<%--
Instead of <h1>Hello World!</h1>
we have the selected category name

Once the name is in the attribute in TestServlet.java, you can simply use the Java expression language to access it in the JSP page:
Below selectedCategoryName no longer has an error once we use the bean and specify the request scope above

need to put selectedCategoryName here otherwise the jsp useBean above would give an error at runtime

 ${obj.property} will call obj.getProperty(); if you have getter methods

 You have to capitalize the category name even though the category names in your request parameters are all lower case.
 there is a css string-manipulation fn we used below text-transform (normally wouldn't put style in jsp pages, but makes it go quicker)
 since all of our category names are lowercase
--%>
<h1 style="text-transform: capitalize">${selectedCategoryName}</h1>


<%--
We don't want JSP page to know we're using an SQL (just know what kind of database we're using)
the sql query tags below should be put into a controller servlet, so we can delete the SQL from here.

since we are no longer reporting the results anymore--notice this result was connected to jdbc/RyanTBookstore
but once we started to get every book from our book list we needed to hook up our datasource via JdbcUtils.java
to jdbc/RyanTBookstore for it to recognize. (since we can't define the jdbc locally).

get rid of the sql query

<sql:query var="result" dataSource="jdbc/RyanTBookstore">
    SELECT * FROM category, book
    WHERE category.category_id = book.category_id
</sql:query>

--%>


<table border="1">
    <!-- column headers -->

    <%--
    The variable result is defined the sql query above, but we want to name columns explicitly.
            <c:forEach var="columnName" items="${result.columnNames}">
            <th><c:out value="${columnName}"/></th>
        </c:forEach>

    No longer do we want to iterate over a result set

    Per Proj4 instructions, Change the table header so that you are list the column names explicitly.
    So we just put the column names explicitly
    --%>
    <tr>
        <th>book_id</th>
        <th>title</th>
        <th>author</th>
        <th>price</th>
        <th>is_public</th>
        <th>category_id</th>

    </tr>



    <!-- column data
     don't iterate over the result set, but instead iterate over every BOOK in the selected book list
     which we did below: Keep the forEach JSTL tag to iterate over the list of books in the JSP page (for example: var="book" items=")
     that's why we made the changes to get every book within the list (the list already used the bean up top for access from control servlet)

     For the data, you are working with a book object. Once again, IntelliJ does not know that the "book" variable is a book object, so we can use useBean:
     we need to create a usebean for the book below (of the type Book that we created).

    previously rowsByIndex, we use to get each row and then iterate across the column of each row and spat out the results of each column
        c:forEach var="row" items="{result.rowsByIndex}"

        do not use forEach
                    c:forEach var="column" items="row}"
                <td>c:out value="column"/></td>
            /c:forEach

        now we access each book's contents within the list and report its contents (no each to iterate within columns.
        We access each of the book's contents and put it out within the row.

        note for below, scope is a page; "book" is a *page* attribute. It is not a request attribute that is set in the controller.
        The page scope is the narrowest scope and attributes stored here are only available in the same JSP page

        You will have to put the useBean action *inside* the loop here for it to work. Once you do this, IntelliJ will not only
        allow you to use the EL expression {book}, but since book has getter methods, it will also allow you to access,
        for example, {book.title} to get the book's title.

        The <td> tag defines a standard cell in an HTML table, within a row <tr>
        https://www.w3schools.com/tags/tag_td.asp

        change to book.isPublic; had to change the book's getter to getIsPublic to make this work (otherwise redundancies confuse compiler)

    -->

    <c:forEach var="book" items="${selectedBookList}">
        <jsp:useBean id="book" type="business.book.Book" scope="page"/>

        <tr>
            <td>${book.bookId}</td>
            <td>${book.title}</td>
            <td>${book.author}</td>
            <td>${book.price}</td>
            <td>${book.isPublic}</td>
            <td>${book.categoryId}</td>

        </tr>
    </c:forEach>
</table>
</body>
</html>
