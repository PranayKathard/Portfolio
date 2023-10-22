package Thread;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 
 * @author PRANAY KATHARD
 *
 */
public class Threadoverseer implements Runnable{
	
	/**
	 * Number of tasks to be done
	 */
	private int numTasks;
	
	/**
	 * Constructor for Threadoverseer
	 * @param num
	 */
	public Threadoverseer(int num) {
		this.numTasks = num;
	}

	/**
	 * run() method for Threadoverseer
	 */
	@Override
	public void run() {
		ExecutorService threadPool = Executors.newCachedThreadPool();
		
		for(int i = 0; i < numTasks; i++) {
			Runnable task = new Task(i);
			threadPool.execute(task);
		}
		threadPool.shutdown();
		
	}

}
