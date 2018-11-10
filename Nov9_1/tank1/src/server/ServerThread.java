package server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.PrintWriter;
import java.net.Socket;

import data.Action;

public class ServerThread extends Thread {
	//private BufferedReader br;
	//private PrintWriter pw;
	private ObjectInputStream ois;
	private ObjectOutputStream oos;
	private GameRoom cr;
	public ServerThread(Socket s,GameRoom cr) {//
		this.cr = cr;
		try {
			//br = new BufferedReader(new InputStreamReader(s.getInputStream()));
			//pw = new PrintWriter(s.getOutputStream());
			ois = new ObjectInputStream(s.getInputStream());
			oos = new ObjectOutputStream(s.getOutputStream());
			this.start();
		}catch(IOException ioe){
			System.out.println("ioe: "+ ioe.getMessage());
		}
		
	}
	
	//public void sendMessage(String line) {
	public void sendMessage(Action cm) {
		//pw.println(line);
		//pw.flush();
		try {
			oos.writeObject(cm);
			oos.flush();
		}catch(IOException ioe) {
			System.out.println("ioe: " + ioe.getMessage());
		}
		
	}
	
	public void run() {
		try {
			while(true) {
				//String line = br.readLine();
				//cr.broadcast(line, this);
				Action cm = (Action)ois.readObject();
				cr.broadcast(cm, this);
			}
		}catch(IOException ioe){
			System.out.println("ioe in run: "+ ioe.getMessage());
		}catch(ClassNotFoundException cnfe) {
			System.out.println("cnfe in run: "+ cnfe.getMessage());
		}
	}
}