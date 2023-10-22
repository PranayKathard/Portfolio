import java.util.Scanner;
	
public class Main
{
public static void main(String[] args)
{
	
	Converter C = new Converter(); // instance of Converter
	Scanner sIn = new Scanner(System.in);
	
	String sInput,sOut;//decleration of input and output variables 
	int iCode = 0; //decleration of integer code variable initialised to 0 
	
	System.out.println("Would you like to Encode a message (1) or Decode a message (2)?");
	iCode = Integer.parseInt(sIn.nextLine()); 
	switch (iCode)
	{
		//encode
		case 1:
		{
			System.out.print("Please enter the message\t");
			sInput= sIn.nextLine();
			sOut = C.Encode(sInput);
			System.out.println("Encoded message:\n"+
			"___________________\n"+sOut+"\n"
			+"___________________");
		}
		break;
		//decode
		case 2: 
		{
			System.out.print("Please enter the encoded message\t");
			sInput= sIn.nextLine();
			sOut = C.Decode(sInput);
			System.out.println("Decoded message:\n"+
			"___________________\n"+sOut+"\n"
			+"___________________");
		}
		break;
	}
}	
}