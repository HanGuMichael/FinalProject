package server;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Vector;

import data.Action;

public class GameRoom {
	private Vector<ServerThread> serverThreads;
	public GameRoom(int port) {
		ServerSocket ss = null;
		
		try {
			System.out.println("Trying to bind to port "+ port);
			ss = new ServerSocket(port);
			System.out.println("Bound to port "+ port);
			serverThreads = new Vector<ServerThread>();
			while(true) {
				Socket s = ss.accept();
				System.out.println("Connection from " + s.getInetAddress() );
				ServerThread st = new ServerThread(s,this);
				serverThreads.add(st);
			}
		}catch(IOException ioe) {
			System.out.println("ioe: "+ ioe.getMessage());
		}finally {
			try {
				if(ss != null) {
					ss.close();
				}
			}catch(IOException ioe) {
				System.out.println("ioe closing stuff: "+ ioe.getMessage());
			}
		}
	}
	
	//Frank is alskdfjalsdkfj
	
	//public void broadcast(String line, ServerThread currentST) {
	public void broadcast(Action cm, ServerThread currentST) {
		//if(line != null) {
			//System.out.println(line);
		if(cm!=null) {
			//System.out.println(cm.getUsername()+": "+cm.getMessage());
			System.out.println(cm.getUser() +" "+cm.getField()+" " +cm.getValue());
			for(ServerThread st: serverThreads) {
				if(st != currentST) {
					//st.sendMessage(line);
					st.sendMessage(cm);
				}
			}
		}
	}
	
	public static void main(String [] args) {
		new GameRoom(6789);
	}
}