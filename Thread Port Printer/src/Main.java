import java.net.InetAddress;
import java.net.UnknownHostException;

import Thread.Threadoverseer;

/**
 * 
 * @author PRANAY KATHARD
 *
 */
public class Main {

	public static void main(String[] args) throws Exception {
		
		//Display local host ip address
		try {
			InetAddress iNet = InetAddress.getLocalHost();
			System.out.println("Computer IP address: " + iNet.getHostAddress());
		} catch (UnknownHostException e) {
			System.err.println("Host connection error.");
		}
		
		//Show all open port numbers using threadpool
		System.out.println("Open port numbers:");
		Threadoverseer overseer = new Threadoverseer(65535);
		Thread thread = new Thread(overseer);		
		thread.start();

	}

}
