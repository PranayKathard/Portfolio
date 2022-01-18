package gui;

import client.SMTPClient;
import javafx.geometry.Insets;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.StackPane;
import javafx.scene.layout.VBox;

/**
 * 
 * @author PRANAY KATHARD
 *
 */
public class Pane extends StackPane{
	/**
	 * Constructor
	 */
	public Pane() {
		
		TextField TFHost = new TextField();
		TextField TFPort = new TextField();
		TextField TFSender = new TextField();
		TextField TFReciever = new TextField();
		TextField TFText = new TextField();
		
		//grid for labels and text boxes
		GridPane grid = new GridPane();
		grid.setVgap(4);
		grid.setPadding(new Insets(5,5,5,5));
		grid.add(new Label("Host name: "), 0, 0);
		grid.add(TFHost, 1, 0);
		grid.add(new Label("Port Number: "), 0, 1);
		grid.add(TFPort, 1, 1);
		grid.add(new Label("Sender: "), 0, 2);
		grid.add(TFSender, 1, 2);
		grid.add(new Label("Reciever: "), 0, 3);
		grid.add(TFReciever, 1, 3);
		grid.add(new Label("Text: "), 0, 4);
		grid.add(TFText, 1, 4);
		
		Button button = new Button("Send");
		Alert alert = new Alert(AlertType.INFORMATION);
		button.setOnAction(e->{
			//Instantiate client
			SMTPClient smtpclient = new SMTPClient(TFHost.getText(), TFPort.getText(), TFSender.getText(), TFReciever.getText(), TFText.getText());
			//give feedback
			if(smtpclient.isSent()){
				alert.setContentText("Your email has been sent!");
				alert.showAndWait();
			}else if(!smtpclient.isSent()){
				alert.setContentText("Unable to send email.");
				alert.showAndWait();
			}
			if(smtpclient.isIOerror()) {
				alert.setContentText("Sorry, unable to connect to email server.");
				alert.showAndWait();
			}
		});
		
		VBox layout = new VBox();
		layout.getChildren().addAll(grid);
		layout.getChildren().addAll(button);
		getChildren().add(layout);
		setWidth(400);
		setWidth(500);

	}
}
