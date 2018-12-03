<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<!-- SOURCE FOR BAREBONES STICKY NAVIGATOR BAR https://www.w3schools.com/howto/howto_js_navbar_sticky.asp (follows you as you scroll down).-->
<style>
.form-style-1 {
	margin:10px auto;
	max-width: 400px;
	padding: 20px 12px 10px 20px;
	font: 13px "Lucida Sans Unicode", "Lucida Grande", sans-serif;
}
.form-style-1 li {
	padding: 0;
	display: block;
	list-style: none;
	margin: 10px 0 0 0;
}
.form-style-1 label{
	margin:0 0 3px 0;
	padding:0px;
	display:block;
	font-weight: bold;
}
.form-style-1 input[type=text], 
.form-style-1 input[type=date],
.form-style-1 input[type=datetime],
.form-style-1 input[type=number],
.form-style-1 input[type=search],
.form-style-1 input[type=time],
.form-style-1 input[type=url],
.form-style-1 input[type=email],
textarea, 
select{
	box-sizing: border-box;
	-webkit-box-sizing: border-box;
	-moz-box-sizing: border-box;
	border:1px solid #BEBEBE;
	padding: 7px;
	margin:0px;
	-webkit-transition: all 0.30s ease-in-out;
	-moz-transition: all 0.30s ease-in-out;
	-ms-transition: all 0.30s ease-in-out;
	-o-transition: all 0.30s ease-in-out;
	outline: none;	
}
.form-style-1 input[type=text]:focus, 
.form-style-1 input[type=date]:focus,
.form-style-1 input[type=datetime]:focus,
.form-style-1 input[type=number]:focus,
.form-style-1 input[type=search]:focus,
.form-style-1 input[type=time]:focus,
.form-style-1 input[type=url]:focus,
.form-style-1 input[type=email]:focus,
.form-style-1 textarea:focus, 
.form-style-1 select:focus{
	-moz-box-shadow: 0 0 8px #88D5E9;
	-webkit-box-shadow: 0 0 8px #88D5E9;
	box-shadow: 0 0 8px #88D5E9;
	border: 1px solid #88D5E9;
}
.form-style-1 .field-divided{
	width: 49%;
}

.form-style-1 .field-long{
	width: 100%;
}
.form-style-1 .field-select{
	width: 100%;
}
.form-style-1 .field-textarea{
	height: 100px;
}
.form-style-1 input[type=submit], .form-style-1 input[type=button]{
	background: #4B99AD;
	padding: 8px 15px 8px 15px;
	border: none;
	color: #fff;
}
.form-style-1 input[type=submit]:hover, .form-style-1 input[type=button]:hover{
	background: #4691A4;
	box-shadow:none;
	-moz-box-shadow:none;
	-webkit-box-shadow:none;
}
.form-style-1 .required{
	color:red;
}
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
out.print("<a href=\"checkout.jsp\">Checkout</a>");
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
<!--Image hosted on a image hosting website. May not be the best but it worked easier than trying to get it from file -->
<form>
<ul class="form-style-1" id ="usrform">
	<li><label>Article Title</label></li>
	<li><input type="text" name=ArticleTitle class="field-Long"></li>
	<li><label>Genre</label></li>
	<li><input type="text" name=Genre class="field-Long"></li>
	<li><label>Price</label></li>
	<li><input type="text" name=Price class="field-Long"></li>
    <li>
        <label>Candidate</label>
        <% 
        String sql = "Select FirstName, LastName from Candidate";
        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rst = pstmt.executeQuery();

       out.println("<select name=\"CandidateName\" class=\"field-select\">");
   	  // out.println("<option value=optional>optional</option>");
        while(rst.next()){
        	out.println("<option value="+rst.getString(1)+">"+rst.getString(1)+" "+rst.getString(2)+"</option>");
        }
        
      //  <select name="field4" class="field-select">
        %>
        </select>
    </li>
    <li>
      <textarea rows="4" cols="50" name="comment" form="usrform">
Enter Article here...</textarea>
    </li>
    <li>
        <input type="submit" value="Submit" />
    </li>
</ul>
</form>
<%
String sql3 = "SELECT ArticleID FROM Articles ORDER BY ArticleID DESC";
pstmt = con.prepareStatement(sql3);
rst = pstmt.executeQuery();
rst.next();
int AID= rst.getInt(1)+1;
try{
	if(request.getParameter("ArticleTitle")!=null){
	String ArticleTitle = request.getParameter("ArticleTitle");
	String Genre = request.getParameter("Genre");
	Double Price = Double.parseDouble(request.getParameter("Price"));
	String CandidateFirstName = request.getParameter("CandidateName");
	String tempsql = "select CID from Candidate where FirstName = ?";
	pstmt = con.prepareStatement(tempsql);
	pstmt.setString(1,request.getParameter("CandidateName"));
	rst = pstmt.executeQuery();
	rst.next();
	int CID = rst.getInt(1);
	String Article = request.getParameter("comment");
	SimpleDateFormat simpleDateFormat= new SimpleDateFormat("yyyy-MM-dd");
	String Date = simpleDateFormat.format(new Date());
	sql = "INSERT INTO Articles VALUES ("+Integer.toString(AID)+", "+Integer.toString(CID)+", 0,? , ?, ?, ?, "+Price+", 0, 0, "+session.getAttribute("UserId")+",  null)";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1,ArticleTitle);
	pstmt.setString(2,Article);
	pstmt.setString(3, Genre);
	  java.util.Date utilDate = new java.util.Date();
	java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
	pstmt.setDate(4, sqlDate);
	pstmt.executeUpdate();
	}
}
catch(Exception e){
	
	SimpleDateFormat simpleDateFormat= new SimpleDateFormat("yyyy-MM-dd");
	String Date = simpleDateFormat.format(new Date());
	out.println("Check Inputs for Title, Genre, Price and Article");
			out.println(Date);
}

%>
  

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


