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
<!--Image hosted on a image hosting website. May not be the best but it worked easier than trying to get it from file -->
<table>
  <tr>
    <th>Article Title</th>
    <th>Target</th>
    <th>Genre</th>
    <th>Date</th>
    <th>Price</th>
    <th>Purchase</th>
  
<% 
	try{ 
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
 // int UserID = Integer.parseInt((session.getAttribute("UserId").toString()));
 // String sql = "Select ArticleTitle, Theme, UserID, Articles.CID, OwnerID,Candidate.FirstName, Candidate.LastName,ArticleID,IsSold ReleaseDate From Articles where IsSold=0 ORDERBY ReleaseDate DESC";
  if (request.getParameter("title")==null){
  String sql = "Select TOP 10 ArticleTitle, Theme, UserID, Articles.CID, OwnerID,Candidate.FirstName, Candidate.LastName,ArticleID,IsSold, ReleaseDate, Price From Articles JOIN Candidate ON Articles.CID = Candidate.CID where IsSold = 0 ORDER BY ReleaseDate DESC";
  PreparedStatement pstmt = con.prepareStatement(sql);
  ResultSet rst = pstmt.executeQuery();
  while(rst.next()){
	  int AID = rst.getInt(8);
	  out.print("</tr><td><a href=\"Article.jsp?ArticleID="+rst.getInt(8)+"\">"+rst.getString(1)+"</a></td><td>"+rst.getString(6)+" "+rst.getString(7)+"</td><td>"+rst.getString(2)+"</td><td>"+rst.getDate(10)+"</td><td>"+currFormat.format(rst.getDouble(11))+"</td><td><a href=addcart.jsp?AID="+rst.getInt(8)+">BuyNow</td></tr>");
  }
  }
 else {

	 String sql = "Select ArticleTitle, Theme, UserID, Articles.CID, OwnerID, Candidate.FirstName, Candidate.LastName, ArticleID,IsSold, ReleaseDate, Price From Articles JOIN Candidate ON Articles.CID = Candidate.CID where ArticleTitle  LIKE '%"+request.getParameter("title")+"%' AND IsSold=0 ORDER BY ReleaseDate DESC";
	 PreparedStatement pstmt = con.prepareStatement(sql);
	  ResultSet rst = pstmt.executeQuery();
	  while(rst.next()){
		  int AID = rst.getInt(8);
		  out.print("</tr><td><a href=\"Article.jsp?ArticleID="+rst.getInt(8)+"\">"+rst.getString(1)+"</a></td><td>"+rst.getString(6)+" "+rst.getString(7)+"</td><td>"+rst.getString(2)+"</td><td>"+rst.getDate(10)+"</td><td>"+currFormat.format(rst.getDouble(11))+"</td><td><a href=addcart.jsp?AID="+AID+">Buy Now</td></tr>");
	  }
 }

	}
  catch(Exception e){
	  out.println("error Computing purchased articles");
  }
%>
  </tr>
</table>
<script>
window.onscroll = function() {myFunction()};

var navbar = document.getElementById("navbar");
var sticky = navbar.offsetTop;

function myFunction() {
  if (window.pageYOffset >= sticky) {
    navbar.classList.add("sticky")
  } else {
    navbar.classList.remove("sticky");
  }
}
</script>
</body>
</head>


