package client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

/**
 * 
 * @author PRANAY KATHARD
 *
 */
public class SMTPClient {
	
	Socket socket = null;
	static PrintWriter pw = null;
	static BufferedReader is = null;
	private boolean sent = false;
	private boolean IOerror = false;
	
	/**
	 * Constructor
	 * @param host
	 * @param port
	 * @param sender
	 * @param reciever
	 * @param text
	 */
	public SMTPClient(String host, String port, String sender, String reciever, String text) {
		try {
			socket = new Socket(host, Integer.parseInt(port));
			System.out.println("Connected to server!");
			
			pw = new PrintWriter(socket.getOutputStream(), true);
			is = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			
			readResponse(is);
			writeMessage(pw, "HELO Papercut");
			readResponse(is);
			writeMessage(pw, "MAIL FROM:<" + sender + ">");
			readResponse(is);
			writeMessage(pw, "RCPT TO:<" + reciever + ">");
			readResponse(is);
			writeMessage(pw, "DATA");
			readResponse(is);
			writeMessage(pw, text);
			
			if(readResponse(is).equals("250 Ok")) {
				sent = true;
			}else {
				sent = false;
			}
			writeMessage(pw, "QUIT");
			
			
		} catch (IOException e) {
			e.printStackTrace();
			IOerror = true;
		}
	}
	
	/**
	 * Read responses from server
	 * @param in
	 * @return
	 * @throws IOException
	 */
	private static String readResponse(BufferedReader in) throws IOException{
		String response = in.readLine();
		System.out.println(response);
		return response;
	}
	
	/**
	 * Write to server
	 * @param out
	 * @param msg
	 */
	private static void writeMessage(PrintWriter out, String msg) {
		out.println(msg);
		out.flush();
	}

	public boolean isSent() {
		return sent;
	}

	public boolean isIOerror() {
		return IOerror;
	}
	
}
