//Multiplayer class for a client (wip)

public class TCPClient extends PApplet{
  Client client;
  String input;
  float[] data;
  
  String serverIP;
  int serverPort;
  
  TCPClient(String ip, int port) {
    serverIP = ip;
    serverPort = port;
    client = new Client(this,ip,port);
  }
  
  void sendData() {
    client.write(yRotateX + " " + yRX2 + " " + yRotateZ + " " + yRZ2 + " " + yRotate + " " + xRotate + "\n");
  }
  
  void getData() {
    if (client.available() > 0) { 
      input = client.readString(); 
      input = input.substring(0,input.indexOf("\n"));  //Only up to the newline
      data = float(split(input, ' '));  //Split values into an array
      //Place playermodel using coordinates
      translate(yRotateX+yRX2+data[0]+data[1],-1000,yRotateZ+yRZ2+data[2]+data[3]);
      playermodel.rotateY(data[4]);
      shape(playermodel);
      translate(-yRotateX-yRX2-data[0]-data[1],1000,-yRotateZ-yRZ2-data[2]-data[3]);
    } 
  }
}