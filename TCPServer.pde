//Multiplayer class for a server (wip)

public class TCPServer extends PApplet{
  Server server;
  Client client;
  
  String input;
  float[] data;
  
  int port;
  
  TCPServer(int port_) {
    port = port_;
    server = new Server(this,port);
  }
  
  void getData() {
    client = server.available();
    if (client != null) {
    input = client.readString(); 
    input = input.substring(0, input.indexOf("\n"));  //Only up to the newline
    data = float(split(input, ' '));  //Split values into an array
    //Place playermodel using coordinates
    translate(yRotateX+yRX2+data[0]+data[1],-1000,yRotateZ+yRZ2+data[2]+data[3]);
    playermodel.rotateY(data[4]);
    shape(playermodel);
    translate(-yRotateX-yRX2-data[0]-data[1],1000,-yRotateZ-yRZ2-data[2]-data[3]);
    }
  }
  
  void sendData() {
    server.write(yRotateX + " " + yRX2 + " " + yRotateZ + " " + yRZ2 + " " + yRotate + " " + xRotate + "\n");
  }
  
}