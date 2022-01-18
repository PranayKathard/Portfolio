package Thread;

import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;

/**
 * 
 * @author PRANAY KATHARD
 *
 */
public class Task implements Runnable{
	/**
	 * Variable to display port(task) number
	 */
	private int id = 0;
	
	/**
	 * Constructor for Task
	 * @param id
	 */
	public Task(int id) {
		this.id = id;
	}
	
	/**
	 * run() method for Task
	 */
	@Override
	public void run() {
		Socket s = null;
		try {
			s = new Socket("localhost", id);
			System.out.println(id);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (IOException e) {
		}finally {
			try {
				if(s != null) {
					s.close();
				}
			} catch (IOException e) {
				System.out.println("Could not close socket connection.");
			}
		}
		
	}

}
