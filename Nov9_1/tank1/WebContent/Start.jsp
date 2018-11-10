<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="Start.css" />
<title>Start</title>
</head>
<body>

	<div id="all">	
	  <div class="container">
	   
	    <div id ="colorSelect">
	    Tank Color
	    <br/>
	    <br/>
		    <input type="radio" name="color" value="red"> Red<br>
	  		<input type="radio" name="color" value="green"> Green<br>
	  	    <input type="radio" name="color" value="blue"> Blue<br>  
  	    </div>
  	    
  	    <br/>
  	    
	    <button onClick="findGame()">Find Game</button>
	    
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	    
	    <script>
	    
	    function findGame(){
	    	connectToServer();
	    }
	    
	    var socket;
	    
    	function connectToServer() {
    		socket = new WebSocket("ws://localhost:8080/tank1/ms");
    		socket.onopen = function(event) {
    			console.log("Connected");
    			//document.getElementById("mychat").innerHTML += "Connected!";
    			
    		}
    		socket.onmessage = function(event) {
    			console.log(event.data);
    			var str = event.data;
    			var spl = str.split("#");
    			
    			//request.getSession().setAttribute("room",spl[0]);
    			/*
    			$.ajax({
    				url: "startToTank",
    				data:{
    					room: spl[0],
    					position: spl[1]
    				},
    				success: function(result){
    					
    				}
    			});
    			*/
    			//request.getSession().setAttribute("position",spl[1]);
    			//console.log(spl[0]);
    			location.href = "startToTank?room="+ spl[0] +"&position="+spl[1];
    		}
    		socket.onclose = function(event) {
    			//document.getElementById("mychat").innerHTML += "Disconnected!";
    		}
    	}
    	function sendMessage() {
    		//socket.send("Miller: " + document.chatform.message.value);
    		
    	}
	    </script>
	    <button>Log Out / Quit</button>
	
	  </div>

	</div>
</body>
</html>