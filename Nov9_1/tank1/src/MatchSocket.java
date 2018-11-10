import java.io.IOException;
import java.util.Vector;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/ms")
public class MatchSocket {

	private static Vector<Session> sessionVector = new Vector<Session>();
	//private static Vector<GameRoom> rooms;
	private static int gameId = 0;
	@OnOpen
	public void open(Session session) {
		System.out.println("Connection made!"); 
		sessionVector.add(session);
		if(sessionVector.size()>=2) {
			try {
				gameId++;
				//System.out.println(gameId);
				String str = Integer.toString(gameId);
				sessionVector.get(0).getBasicRemote().sendText(str+"#left");
				sessionVector.get(1).getBasicRemote().sendText(str+"#right");
				sessionVector.clear();
			} catch (IOException ioe) {
				System.out.println("ioe: " + ioe.getMessage());
				close(session);
			}
		}
		
	}
	
	@OnMessage
	public void onMessage(String message, Session session) {
		System.out.println(message);
		
		try {
			for(Session s : sessionVector) {
				s.getBasicRemote().sendText(message);
			}
		} catch (IOException ioe) {
			System.out.println("ioe: " + ioe.getMessage());
			close(session);
		}
	}
	
	@OnClose
	public void close(Session session) {
		System.out.println("Disconnecting!");
		sessionVector.remove(session);
	}
	
	@OnError
	public void error(Throwable error) {
		System.out.println("Error!");
	}
}
