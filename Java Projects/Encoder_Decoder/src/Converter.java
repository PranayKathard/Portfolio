public  class Converter
{
	private String clearMessage,secretMessage;
	
	//this is the array of characters for the normalised heros name.
	private String[] letters = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                       "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
						"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", " "};
	
	//this is the array of characters that scrambled the name corrisponding to the letters array.
	private String[] code = new String[]{"D", "U", "P", "1", "Q", "C", "I", "O", "5",
                        "7", "Z", "6", "V", "8", "W", "H", "T", "L",
                        "E", "0", "M", "J", "B", "4", "G", "9", "X",
                        "N", "3", " ", "2", "R", "Y", "K",
						"S", "F", "A"};
	
	//Construcor
	public Converter()
	{
	clearMessage = "";
	secretMessage = "";
	}
	
	//Accesor methods
	public String getClearMessage()
	{
		return clearMessage;
	}
	
	public String getSecretMessage()
	{
		return secretMessage;
	}
	
	public void setClearMessage(String message)
	{
		clearMessage = message;
	}
	
	public void setSecretMessage(String message)
	{
		secretMessage = message;
	}
	
	//Encoder message
	public String Encode(String message)
	{
		clearMessage = message.toUpperCase();
		for (int i=0;i<message.length();i++)
		{
			int index = -1;
			char temp = clearMessage.charAt(i);
			for (int k=0; k<37; k++)
			{
				if( letters[k].charAt(0)==(temp))
				{
				index = k;	
				}
			}
			// checks if letter is in range
			if(index==-1)
			{
				System.out.println("There are invalid characters in the message.");
				break;
			}
			else
			{
				secretMessage+=code[index];
			}
		}
	return secretMessage;
	}
	
	public String Decode(String secret)
	{
		secretMessage = secret.toUpperCase();
		for (int i=0;i<secret.length();i++)
		{
			int index2 = -1;
			char temp = secret.charAt(i);
			for (int k=0; k<37; k++)
			{
				if( code[k].charAt(0)==(temp))
				{
				index2 = k;	
				}
			}
			//checks range
			if(index2==-1)
			{
				System.out.println("There are invalid characters in the message.");
				break;
			}
			else
			{	
				clearMessage+=letters[index2];
			}
		}
	return clearMessage;	
	}
}