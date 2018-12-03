<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
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
</div>
<body>
  <%
Statement statement = con.createStatement(
		ResultSet.TYPE_SCROLL_INSENSITIVE,
        ResultSet.CONCUR_READ_ONLY);
//Integer userid = Integer.parseInt(session.getAttribute("UserId"));
//getting current user ID
int currentUser = Integer.parseInt(session.getAttribute("UserId").toString());
//getting article data of articles in users cart
String command = "SELECT ArtOrder.ArticleID, Articles.ArticleTitle, FirstName, LastName, Articles.Price FROM (((ArtOrder JOIN Articles ON ArtOrder.ArticleID=Articles.ArticleID) JOIN Candidate ON Articles.CID=Candidate.CID) JOIN Cart ON ArtOrder.CartID = Cart.CartID) where Cart.CartID = ?";
PreparedStatement pstmt = con.prepareStatement(command);
pstmt.setInt(1,currentUser);
ResultSet purchasedSet = pstmt.executeQuery();
try{
	String sql = "Select Password from Account where UserID = ?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1,session.getAttribute("UserId").toString());
	ResultSet rst = pstmt.executeQuery();
	rst.next();
	String password = rst.getString(1);
if(request.getParameter("password").equals(password)){
	while(purchasedSet.next()){
		
		int aId = purchasedSet.getInt("ArticleID");
		String sale = "UPDATE Articles SET OwnerID="+ currentUser +", IsSold = 1 WHERE ArticleID="+aId;
		con.prepareStatement(sale).executeUpdate();
		String updateCart = "DELETE FROM ArtOrder WHERE CartID="+ currentUser +" AND ArticleID="+aId;
		con.prepareStatement(updateCart).executeUpdate();
		
	}
}
else{
	out.println("<h1>Incorrect password</h1>");
}
}
catch (Exception e){
	
}
purchasedSet.close();
%>

<header>
<h1>SocialBomb</h1>
<h3>Checkout</h3>
</header>

<div id="checkoutTable">
	<form action="/FakeNews/checkout.jsp" method="post">
	<%
	
	//creating checkout table
	out.println("<table>");
	out.println("<tr><th>Article #</th><th>Title</th><th>Target</th><th>Price</th><th>Remove</th></tr>");
	//creating each row of the table, and creating sum of prices.
	double totalPrice = 0;
	pstmt = con.prepareStatement(command);
	pstmt.setInt(1,currentUser);
	ResultSet cartSet = pstmt.executeQuery();
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	while(cartSet.next()){
		
		int aId = cartSet.getInt("ArticleID");
		String aTitle = cartSet.getString("ArticleTitle");
		String tFName = cartSet.getString("FirstName");
		String tLName = cartSet.getString("LastName");
		double aPrice = (double) cartSet.getDouble("Price");
		String pPrice = currFormat.format(aPrice);
		totalPrice += aPrice;
		
		
		out.println("<tr><td>"+aId+"</td><td>"+aTitle+"</td><td>"+tFName+" "+tLName+"</td><td>"+pPrice+"</td><td><a href = \"RemoveFromCart.jsp?AID="+Integer.toString(aId)+"\">Remove</a> </td></tr>");

	}
	String fPrice = currFormat.format(totalPrice);
	out.println("<tr><th colspan='3'>Total: </th><th colspan='1'>"+fPrice+"</th></tr>");
	out.println("</table>");%>
	</form>
	<table></table>
	<form method="get" action="checkout.jsp">
	<% 
	out.println("<br>Enter password to confirm Password and Wallet Number: <br>");
	out.println("<input type='password' name='password' required>");
	out.println("<input type='number' name='bitcoinWallet' required>");
	out.println("<input type='submit' value='Submit'>");
	out.println("</form>");
	cartSet.close();
	statement.close();
	con.close();
	%>
	</form>
</div>

</body>
</head>