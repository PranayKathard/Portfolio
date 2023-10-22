import javafx.application.Application;
import javafx.scene.Scene;
import javafx.stage.Stage;
import gui.Pane;

/**
 * 
 * @author PRANAY KATHARD
 *
 */
public class Main extends Application{
	//Scene for stage
	private Pane pane = null;

	public static void main(String[] args) {		
		//Launch the JavaFX Application
		launch(args);
	}
	
	@Override
	public void start(Stage primaryStage) throws Exception {
		primaryStage.setTitle("SMTP Messanger");
		pane = new Pane();
		//Set the Scene
		Scene scene = new Scene(pane);
		primaryStage.setWidth(400);
		primaryStage.setHeight(600);
		primaryStage.setScene(scene);
		//Open the Curtains
		primaryStage.show();		
	}
}