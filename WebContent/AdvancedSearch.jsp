<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
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
      <form action="FrontPage.jsp">
      <input type="text" placeholder="Search Articles..." name="title" cols = "50">
      <button type="submit">Search</button>
    </form>
</div>
<!--Image hosted on a image hosting website. May not be the best but it worked easier than trying to get it from file -->
<form>
<ul class="form-style-1">
	<li><label>Search Option</label></li>
	<li><select name=SearchOption class="field-select">
	<option value=Author>Author</option>
	<option value=Candidate>Candidate</option></li>
	</select>
    <li><label>Last Name </label> <input type="text" name="LastName" class="field-divided" placeholder="Last Name" /></li>
        </select>
    </li>
    <li>
        <input type="submit" value="Search" />
    </li>
</ul>
</form>
<table>
  <tr>
  
  
<% 
//try{ 
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// int UserID = Integer.parseInt((session.getAttribute("UserId").toString()));
// String sql = "Select ArticleTitle, Theme, UserID, Articles.CID, OwnerID,Candidate.FirstName, Candidate.LastName,ArticleID,IsSold ReleaseDate From Articles where IsSold=0 ORDERBY ReleaseDate DESC";
if (request.getParameter("SearchOption")==null){
}

else {
if(request.getParameter("SearchOption").equalsIgnoreCase("author")){
	out.println("<th>Authors</th>");
	//write out multiple queries such that they join and pull the search options.
	String sql = "Select Account.FirstName, Account.LastName, Author.UserID from Author JOIN account ON Author.UserID = Account.UserID where Author.UserID IN (select UserID from Account) and Account.LastName LIKE ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, "%"+request.getParameter("LastName")+"%");
	
	ResultSet rst = pstmt.executeQuery();
	while(rst.next()){
		out.print("we get results");
		  out.print("</tr><tr><td><a href=\"Author.jsp?AuthorID="+rst.getInt(3)+"\">"+rst.getString(1)+" "+rst.getString(2)+"</a></td></tr>");
	}
}
if(request.getParameter("SearchOption").equalsIgnoreCase("Candidate")){
out.println("<th>Candidates</th><th>Position</th><th>Party</th>");

	String sql = "Select FirstName, LastName, CID, Position, PartyName from Candidate WHERE LastName LIKE ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, "%"+request.getParameter("LastName")+"%");
	ResultSet rst = pstmt.executeQuery();
	while(rst.next()){
		  out.print("</tr><tr><td><a href=\"Candidate.jsp?CID="+Integer.toString(rst.getInt(3))+"\">"+rst.getString(1)+" "+rst.getString(2)+"</a></td><td>"+rst.getString(4)+"</td><td>"+rst.getString(5)+"</td></tr>");
	}
}

	
}
/*
sql = "Select ArticleTitle, Theme, UserID, Articles.CID, OwnerID, Candidate.FirstName, Candidate.LastName, ArticleID,IsSold, ReleaseDate, Price From Articles JOIN Candidate ON Articles.CID = Candidate.CID where ArticleTitle  LIKE '%"+request.getParameter("title")+"%' ORDER BY ReleaseDate DESC";
pstmt = con.prepareStatement(sql);
rst = pstmt.executeQuery();
  while(rst.next()){
	  int AID = rst.getInt(8);
	  out.print("</tr><td><a href=\"Article.jsp?ArticleID="+rst.getInt(8)+"\">"+rst.getString(1)+"</a></td><td>"+rst.getString(6)+" "+rst.getString(7)+"</td><td>"+rst.getString(2)+"</td><td>"+rst.getDate(10)+"</td><td>"+currFormat.format(rst.getDouble(11))+"</td><td><a href=addcart.jsp?AID="+AID+">Buy Now</td></tr>");
  }*/


//}
//catch(Exception e){
 // out.println("error Computing purchased articles");
//}
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


