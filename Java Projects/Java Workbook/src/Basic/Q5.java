package Basic;

import java.util.Scanner;

public class Q5 {
    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("Input a number:");
        int x = sc.nextInt();

        for(int i = 1;i<11;i++){
            System.out.print(x + " x " + i + " = " + x*i + "\n");
        }


    }
}
