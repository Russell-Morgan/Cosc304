<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<!-- SOURCE FOR BAREBONES STICKY NAVIGATOR BAR https://www.w3schools.com/howto/howto_js_navbar_sticky.asp (follows you as you scroll down).-->
<style>
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

Connection con = DriverManager.getConnection(url, uid, pw); 

String fileName = "data/order_sql.ddl";

try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

//Integer userid = Integer.parseInt(session.getAttribute("UserId"));
%>
<div id="navbar">
  <a class="active" href="FrontPage.jsp">Home</a>

<%   if(session.getAttribute("UserId")==null&&session.getAttribute("UserId") != "")out.print("<a href=\"login.jsp\">Login</a><a href =\"CreateAccount.jsp\">Create Account</a>");
else{
Integer UserId = Integer.parseInt(session.getAttribute("UserId").toString());
String SQL = "select FirstName, Lastname from Account where UserId = ?";
PreparedStatement pstmt = con.prepareStatement(SQL);
pstmt.setInt(1,UserId);
ResultSet rst = pstmt.executeQuery();
rst.next();
out.print("<a href=\"FrontPage.jsp\">"+rst.getString(1)+"</a>");
out.print("<a href=\"PurchasedArticles.jsp\">Purchased Articles</a>");
out.print("<a href=\"PurchasedArticles\">Shipments</a>");
out.print("<a href =\"Logout.jsp\">Logout</a>");
}

%>
  
  <a href="ListAllAuthors.jsp">Authors</a>
  <a href="ListCandidates.jsp">Candidates</a> 
   <a href="AdvancedSearch.jsp">Advanced Search</a>
      <form action="/action_page.php">
      <input type="text" placeholder="Search People..." name="search" cols = "50">
      <button type="Search">Search</button>
    </form>
</div>
<!--Image hosted on a image hosting website. May not be the best but it worked easier than trying to get it from file -->
<%
String sql = "Select ArticleTitle, Theme, UserID, Articles.CID, OwnerID,Candidate.FirstName, Candidate.LastName,ArticleID, text From Articles JOIN Candidate ON Articles.CID = Candidate.CID where ArticleID = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
String ID = request.getParameter("ArticleID");
pstmt.setString(1, ID);
ResultSet rst = pstmt.executeQuery();
rst.next();
int AuthorID = rst.getInt(3);
int OwnerID = rst.getInt(5);
try{
int UserID = Integer.parseInt((session.getAttribute("UserId").toString()));
if (UserID==OwnerID){
out.println("<h1 align=\"center\">"+rst.getString(1)+"</h1>");
out.println("<p>"+rst.getString(9)+"</p>");
out.println("<a href=\"PurchasedArticles.jsp\"=>Back To Purchased Articles</a>");
}

else{
	
	String Title = rst.getString(1);
	String ArticleReduced = rst.getString(9);
	if(ArticleReduced.length()>100)
	ArticleReduced = ArticleReduced.substring(0, 50);
	ArticleReduced = ArticleReduced + "...";
	out.println("<h1 align=\"center\">"+Title+"</h1>");
	out.println("<p>"+ArticleReduced+"</p>");
	out.println("Purchase This Article to See the Entire Thing!");
	out.println("<a href=\"FrontPage.jsp\"=>Back To Home Page</a>");
}
}
catch(Exception e){
	String Title = rst.getString(1);
	String ArticleReduced = rst.getString(9);
	if(ArticleReduced.length()>100)
	ArticleReduced = ArticleReduced.substring(0, 50);
	ArticleReduced = ArticleReduced + "...";
	out.println("<h1 align=\"center\">"+Title+"</h1>");
	out.println("<p>"+ArticleReduced+"</p>");
	out.println("Purchase This Article to See the Entire Thing!");
	out.println("<a href=\"FrontPage.jsp\"=>Back To Home Page</a>");
}
String sql2 = "select UserName From Account where UserID = ?";
pstmt = con.prepareStatement(sql2);
pstmt.setInt(1,AuthorID);
ResultSet rst2 = pstmt.executeQuery();
rst2.next();
out.println("<p>Article Written by: "+rst2.getString(1)+"</p>");

out.println("<p>Genre: "+rst.getString(2)+"</p>");

out.println("<p>target: "+rst.getString(6)+" "+rst.getString(7)+"</p>");
%>
<h1 align="center"></h1>
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


