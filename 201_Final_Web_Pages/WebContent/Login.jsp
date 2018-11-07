<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="Login.css" />
<title>Login</title>
</head>

<script>
	function LogIn() {
	  	var request = "Validate?";
		request += "username=" + document.login.uname;
		request += "&password=" + document.login.psw;
		
		var xhttp = new XMLHttpRequest();
		xhttp.open("GET", request, true);
		xhttp.send();
	}
</script>
<body>

	<div id="all">	
	<form name = "login">
	  <div class="container">
	    <label for="uname"><b>Username</b></label>
	    <input type="text" placeholder="Enter Username" name="uname">
	
	    <label for="psw"><b>Password</b></label>
	    <input type="password" placeholder="Enter Password" name="psw">
	        
	    <button type="submit">Log In</button>
	    <button>Create Account</button>
	    <button>Play As Guest</button>
	    
		</div>

	</form>

	</div>
</body>
</html>