/* A number of items */
import java.io.IOException;
import java.net.Socket;
//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStreamReader;
//import java.io.PrintStream;
//import java.io.PrintWriter;

public class EchoServer
{
    //Socket echoSocket;
    Socket echoSocket = null;
    String hostName   = null;
    int portNumber    = 0;

    public EchoServer(String ar, String pn) {
        this.hostName   = ar;
        this.portNumber = Integer.parseInt(pn);
    }

    public static void main(String[] args)
    {
        EchoServer es = new EchoServer(args[0], args[1]);

        es.esInitialize();

        /*
        String userInput;
        while ((userInput = System.in.read()) != null) {
            out.println(userInput);
            System.out.println("echo: " + System.in.readLine());
        }
        */
    }

    private void esInitialize() {
        boolean gka;
        //this.echoSocket = new Socket(hostName, portNumber);

        try (
            this.echoSocket = new Socket(this.hostName, this.portNumber);
        ) {
            gka = this.echoSocket.getKeepAlive();
            //PrintWriter out = new PrintWriter(echoSocket.getOutputStream(), true);
            //BufferedReader in = new BufferedReader(new InputStreamReader(echoSocket.getInputStream()));
            //BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
        }
        catch (IOException i) {
                System.out.print(i.getMessage());
        }
        catch (Exception e) {
                System.out.print(e.getMessage());
        }
        finally {
            if (this.echoSocket != null) {
                this.echoSocket.close();
                System.out.print("Closed");
            } else {
                System.out.print("echoSocket not initialized");
            }
        }



    }
}
