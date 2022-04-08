import java.util.Arrays;

/*****/

public class HelloWorld {
    public static void main(String[] args) {
        // Prints "Hello, World" to the terminal window.
        System.out.println("Hello, World");

        char a = 'a';
        char b = 'b';
        char c = 'c';

        System.out.println("First" + a + b + c);

        char[] n = new char[4];

        n[0] = 'y';
        n[1] = 'z';

        System.out.println("First" + Arrays.toString(n));
    }

}
