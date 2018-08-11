<%--
  Created by IntelliJ IDEA.
  User: rwtam
  Date: 6/26/2018
  Time: 9:32 PM
  To change this template use File | Settings | File Templates.

  Create a JSP file directly inside your webapp directory called "index.jsp" and make sure the file contains *only* the following line:

  When you type your applicaiton context path into the address bar, Tomcat looks for an index.html or index.jsp file in the webapp directory.
  The code above will forward the request to the servlet that responds to the "/home" URL pattern. In our case, that is the home page servlet.
home page servlet has url pattern of home

--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:forward page="/home"/>
