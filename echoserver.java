/* A number of items */
import java.net.Socket;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.io.PrintWriter;

public class EchoServer
{
    private static String string;

    public static void main(String args[])
    {
        string = args[0];
        String hostName = string;
        int portNumber = Integer.parseInt(args[1]);

        try {
            Socket echoSocket = new Socket(hostName, portNumber);
            PrintWriter out = new PrintWriter(echoSocket.getOutputStream(), true);
            BufferedReader in = new BufferedReader(new InputStreamReader(echoSocket.getInputStream()));
            BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
        }
        finally {
            System.out.println("Error failed socket");
        }

        /*
        String userInput;
        while ((userInput = System.in.read()) != null) {
            out.println(userInput);
            System.out.println("echo: " + System.in.readLine());
        }
        */
    }
}
