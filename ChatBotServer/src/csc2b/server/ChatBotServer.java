package csc2b.server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Random;
import java.util.StringTokenizer;

/**
 * 
 * @author PRANAY KATHARD
 *
 */
public class ChatBotServer {
	
	static Socket clientConnection;
	static ServerSocket serverSoc;
	static String[] answers1 = {"Yes","No","Maybe"};
	static String answer2 = "Because the boss says so";
	static String[] answers3 = {"Escusez-moi","Oh ok!","Meh"};
	static String answer4 = "Please see sacoronavirus.co.za";
	
	//Function to check the Question string for key words
	static String checkQuestion(String q) { 
		StringTokenizer st = new StringTokenizer(q);
		String question ="";
		while(st.hasMoreTokens()) {
			question = st.nextToken().toUpperCase();
			if(question.equals("ARE")) {
				return "ARE";
			}else if(question.equals("WHY")) {
				return "WHY";
			}else if(question.equals("VIRUS") || question.equals("COVID-19") ) {
				return "VIRUS";
			}
		}
		return "OTHER";
	}

	public static void main(String[] args) {
			try {
				serverSoc = new ServerSocket(8888);
				System.out.println("Ready for clients to connect...");
				clientConnection = serverSoc.accept();
				
				//set up streams
				BufferedReader br = new BufferedReader(new InputStreamReader(clientConnection.getInputStream()));
				PrintWriter pw = new PrintWriter(clientConnection.getOutputStream(), true);
				
				boolean running = true;
				String command = "";
				
				while(running) {
					pw.println("HELLO- You may ask 4 questions");
					pw.flush();
					command = br.readLine();
					//HELLO BOT greeting
					if(command.toUpperCase().equals("HELLO BOT")) {
						//for loop for 4 questions
						for(int i =0;i<4;i++) {
							pw.println("ASK me a question or DONE");
							pw.flush();
							command = br.readLine();
							StringTokenizer stAsk = new StringTokenizer(command);
							//answer question
							if(stAsk.nextToken().toUpperCase().equals("ASK")) {
								//randomiser for answers
								Random rand = new Random();
								if(checkQuestion(command).equals("ARE")) {
									pw.println(answers1[rand.nextInt(2)]);
									pw.flush();
								}else if(checkQuestion(command).equals("WHY")) {
									pw.println(answer2);
									pw.flush();
								}else if(checkQuestion(command).equals("VIRUS")) {
									pw.println(answer4);
									pw.flush();
								}else if(checkQuestion(command).equals("OTHER")) {
									pw.println(answers3[rand.nextInt(2)]);
									pw.flush();
								};
							//or if DONE stop running
							}else if(command.toUpperCase().equals("DONE")) {
								pw.printf("0%d OK BYE - %d questions answered", i, i);
								pw.flush();
								running = false;
							}
						}
					}else {
						pw.println("Try again!");
						pw.flush();
					}
					pw.println("HAPPY TO HAVE HELPED - 4 Questions answered");
					pw.flush();
				}
				
			} catch (IOException e) {
				System.err.println("Could not create server socket!");
			}finally {
				//close sockets
				try {
					if(clientConnection != null || serverSoc != null) {
						clientConnection.close();
						serverSoc.close();
					}
				} catch (IOException e) {
					System.out.println("Could not close socket connection.");
				}
			}

	}

}
