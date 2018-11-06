<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="Account.css" />
<title>Create Account</title>
</head>
<script>
	function makeAccount() {
	  	var request = "MakeAccount?";
		request += "username=" + document.login.uname;
		request += "&password=" + document.login.psw;
		request += "&email=" + document.login.eml;
		
		var xhttp = new XMLHttpRequest();
		xhttp.open("GET", request, true);
		xhttp.send();
	}
</script>
<body>

	<div id="all">	
	<form>
	  <div class="container">
	    <label for="uname"><b>New Username</b></label>
	    <input type="text" placeholder="Enter Username" name="uname">
	
	    <label for="psw"><b>New Password</b></label>
	    <input type="text" placeholder="Enter Password" name="psw">
	    
	     <label for="psw"><b>Email Address</b></label>
	    <input type="email" placeholder="Example@email.com" name="eml">
	        
	    <button type="submit">Create Account</button>
	    <button onclick = "location.href='http://google.com';"> Return to Login</button>
	    
	    
		</div>

	</form>

	</div>
</body>
</html>