<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<!-- SOURCE FOR BAREBONES STICKY NAVIGATOR BAR https://www.w3schools.com/howto/howto_js_navbar_sticky.asp (follows you as you scroll down).-->
<style>
table {
    font-family: arial, sans-serif;
    border-collapse: collapse;
    width: 100%;
}

td, th {
    border: 1px solid #dddddd;
    text-align: left;
    padding: 8px;
}

tr:nth-child(even) {
    background-color: #dddddd;
}
body {
  margin: 0;
  font-size: 28px;
  font-family: Arial, Helvetica, sans-serif;
}

.header {
  background-color: #7B241C;
  padding: 30px;
  text-align: center;
}

#navbar {
  overflow: hidden;
  background-color: #333;
}

#navbar a {
  float: left;
  display: block;
  color: #f2f2f2;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 17px;
}

#navbar a:hover {
  background-color: #ddd;
  color: black;
}

#navbar a.active {
  background-color: #cc6600;
  color: white;
}

.content {
  padding: 16px;
}

.sticky {
  position: fixed;
  top: 0;
  width: 100%;
}

.sticky + .content {
  padding-top: 60px;
}
</style>
        <title>Fake News</title>
</head>
<body>
<div class="header">
  <h1 align="center"><img src="https://i.ibb.co/JqxHZp4/Social-Bomb.png" alt="Social-Bomb" border="1"></h1>
  <p>Articles About Your Enemies</p>
</div>
  <%
String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_mlockhar";
String uid = "mlockhar"; 
String pw = "65511917"; 

System.out.println("Connecting to database.");



String fileName = "data/order_sql.ddl";

try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}
Connection con = DriverManager.getConnection(url, uid, pw); 
//Integer userid = Integer.parseInt(session.getAttribute("UserId"));
%>
<div id="navbar">
  <a class="active" href="FrontPage.jsp">Home</a>

<%   if(session.getAttribute("UserId")==null)out.print("<a href=\"login.jsp\">Login</a><a href =\"CreateAccount.jsp\">Create Account</a>");
else{
Integer UserId = Integer.parseInt(session.getAttribute("UserId").toString());
String SQL = "select FirstName, Lastname FROM Account where UserId = ?";
PreparedStatement pstmt = con.prepareStatement(SQL);
pstmt.setInt(1,UserId);
ResultSet rst = pstmt.executeQuery();
rst.next();
out.print("<a href=\"FrontPage.jsp\">"+rst.getString(1)+"</a>");
SQL = "Select UserID FROM Author where UserID ="+Integer.toString(UserId)+"";
pstmt=con.prepareStatement(SQL);
rst = pstmt.executeQuery();
if(rst.next()==true)out.print("<a href=\"WriteArticle.jsp\">Write An Article</a>");
out.print("<a href=\"PurchasedArticles.jsp\">Purchased Articles</a>");
out.print("<a href=\"checkout.jsp\">CheckOut</a>");
SQL = "select * From ArtOrder where CartID = ?";
pstmt=con.prepareStatement(SQL);
pstmt.setInt(1,Integer.parseInt(session.getAttribute("UserId").toString()));
rst =pstmt.executeQuery();
int totalincart=0;
while(rst.next()){
	totalincart++;
}
out.print("<a href =\"checkout.jsp\">Total Items In Cart: "+totalincart+"</a>");
out.print("<a href =\"Logout.jsp\">Logout</a>");
}

%>
  
  <a href="ListAllAuthors.jsp">Authors</a>
  <a href="ListCandidates.jsp">Candidates</a> 
   <a href="AdvancedSearch.jsp">Advanced Search</a>
      <form action="FrontPage.jsp">
      <input type="text" placeholder="Search Articles..." name="title" cols = "50">
      <button type="submit">Search</button>
    </form>
    <%
    if(session.getAttribute("UserId")!= null){
    String SQL = "Select IsAdmin from Account where UserID = ?";
    PreparedStatement pstmt = con.prepareStatement(SQL);
    
    pstmt.setInt(1,Integer.parseInt(session.getAttribute("UserId").toString()));
    ResultSet rst = pstmt.executeQuery();
    rst.next();
    if(rst.getInt(1)==1){
    	out.println("<a href=\"AdminPage.jsp\">Admin</a>");
    }
    }
    //<a href="AdminPage.jsp">Admin</a> 
    %>
   
</div>
<body>
<h1>Non Author Accounts</h1>
<table>
<tr><th>UserName</th><th>Password</th><th>IsAdmin</th></tr>
<%
String sql = "select UserName, Password, IsAdmin from Account WHERE UserID Not In (Select UserID from Author)";
PreparedStatement pstmt = con.prepareStatement(sql);
ResultSet rst = pstmt.executeQuery();
while(rst.next()){
	out.println("<tr>");
	out.println("<td>");
	out.println(rst.getString(1));
	out.println("</td>");
	out.println("<td>");
	out.println(rst.getString(2));
	out.println("</td>");
	out.println("<td>");
	if(rst.getInt(3)==1)
	out.println("Yes");
	else out.println("No");
	out.println("</td>");
	out.println("</tr>");
}%>
</table>
<h1>Author Accounts</h1>
<table>
<tr><th>UserName</th><th>Password</th><th>IsAdmin</th><th>Account#</th></tr>
<%
sql = "select UserName, Password, IsAdmin, UserID from Account WHERE UserID In (Select UserID from Author)";
pstmt = con.prepareStatement(sql);
rst = pstmt.executeQuery();
while(rst.next()){
	out.println("<tr>");
	out.println("<td>");
	out.println(rst.getString(1));
	out.println("</td>");
	out.println("<td>");
	out.println(rst.getString(2));
	out.println("</td>");
	out.println("<td>");
	if(rst.getInt(3)==1)
	out.println("Yes");
	else out.println("No");
	out.println("</td>");
	out.println("<td>");
	out.println(rst.getInt(4));
	out.println("</td>");
	out.println("</tr>");
}

%>
</table>
<h1>Purchased Articles</h1>
<table>
<tr><th>Article Title</th><th>Author Account#</th><th>Owner Account#</th></tr>
<%
sql = "SELECT ArticleTitle, UserID, OwnerID from Articles Where IsSold=1";
pstmt = con.prepareStatement(sql);
rst = pstmt.executeQuery();
while(rst.next()){
	out.println("<tr>");
	out.println("<td>");
	out.println(rst.getString(1));
	out.println("</td>");
	out.println("<td>");
	out.println(rst.getInt(2));
	out.println("</td>");
	out.println("<td>");
	if(rst.getInt(3)!=0)
	out.println(rst.getInt(3));
	else out.println("No Owner");
	out.println("</td>");
	out.println("</tr>");
}
%>
</table>
</table>
<h1>Available Articles To Purchase</h1>
<table>
<tr><th>Article Title</th><th>Author Account#</th><th>Owner Account#</th></tr>
<%
sql = "SELECT ArticleTitle, UserID, OwnerID from Articles Where IsSold=0";
pstmt = con.prepareStatement(sql);
rst = pstmt.executeQuery();
while(rst.next()){
	out.println("<tr>");
	out.println("<td>");
	out.println(rst.getString(1));
	out.println("</td>");
	out.println("<td>");
	out.println(rst.getInt(2));
	out.println("</td>");
	out.println("<td>");
	if(rst.getInt(3)!=0)
	out.println(rst.getInt(3));
	else out.println("No Owner");
	out.println("</td>");
	out.println("</tr>");
}
%>
</table>
</body>
</html>