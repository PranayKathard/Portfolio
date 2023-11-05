package Basic;
import java.util.Scanner;

//Calculate Perimeter and Area of a circle given a radius
public class Q7 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        double radius = sc.nextDouble();

        double p = 2*Math.PI*radius;
        double a = Math.PI*(radius*radius);

        System.out.println("Perimeter: " + p);
        System.out.println("Area: " + a);
    }
}
