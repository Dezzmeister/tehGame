//The in-game console, and soon other fields

public class InteractiveTextField {
  FieldType textFieldType;
  
  PGraphics textField;
  PGraphics returnField;
  
  int fieldWidth;
  int fieldHeight;
  String inputText = "";
  String returnText = "";
  String tempInputText = "";
  PFont inputFont;
  boolean inTextField = false;
  char activateKey;
  float xCoord;
  float yCoord;
  boolean keyHasBeenPressed = false;
  boolean shiftPressed = false;
  char shiftKey = SHIFT;
  char backspaceKey = BACKSPACE;
  boolean[] keyArray = new boolean[2];
  StringBuilder fieldBuilder = new StringBuilder(inputText);
  boolean playerNameCanBeDezzy = false;
  
  InteractiveTextField(FieldType type) {
    textFieldType = type;
    
    if (type == FieldType.CONSOLE) {
      activateKey = TAB;
    }
    
    textField = createGraphics(fieldWidth,fieldHeight,JAVA2D);
    textField.beginDraw();
    textField.background(150);
    textField.endDraw();
    
    returnField = createGraphics(fieldWidth,fieldHeight,JAVA2D);
    returnField.beginDraw();
    returnField.background(0,0);
    returnField.endDraw();
  }
  
  InteractiveTextField(int textFieldWidth, int textFieldHeight, FieldType type) {
    fieldWidth = textFieldWidth;
    fieldHeight = textFieldHeight;
    textFieldType = type;
    
    if (type == FieldType.CONSOLE) {
      activateKey = TAB;
    }
    
    textField = createGraphics(fieldWidth,fieldHeight,JAVA2D);
    textField.beginDraw();
    textField.background(150);
    textField.endDraw();
    
    returnField = createGraphics(fieldWidth,fieldHeight,JAVA2D);
    returnField.beginDraw();
    returnField.background(0,0);
    returnField.endDraw();
  }
  
  void initializeTextField(int textFieldWidth, int textFieldHeight) {
    fieldWidth = textFieldWidth;
    fieldHeight = textFieldHeight;
    
    textField = createGraphics(fieldWidth,fieldHeight,JAVA2D);
    textField.beginDraw();
    textField.background(150);
    textField.endDraw();
    
    returnField = createGraphics(fieldWidth,fieldHeight,JAVA2D);
    returnField.beginDraw();
    returnField.background(0,0);
    returnField.endDraw();
  }
  
  void setActivateKey(char tempKey) {
    activateKey = tempKey;
  }
  
  void setTextFieldLocation(int xPos, int yPos) {
    xCoord = xPos;
    yCoord = yPos;
  }
  
  void updateTextField() {
    
    //A StringBuilder is used to modify inputText as you type, for some reason
    fieldBuilder.setLength(800);
    if (keyPressed && !keyHasBeenPressed && (key == activateKey || keyCode == activateKey)) {
      inTextField = !inTextField;
      keyHasBeenPressed = true;
      inConsole = false;
    }
    
    //Checks if you are in the text field and adds keys to inputText as you type
    if (inTextField) {
      inConsole = true;
      textField.beginDraw();
      textField.background(150);
      textField.strokeWeight(3);
      textField.fill(150);
      textField.rect(0,0,textField.width,textField.height);
      textField.strokeWeight(1);
      textField.fill(0);
      textField.textAlign(LEFT,CENTER);
      textField.text(inputText,5,(textField.height)/2);
      textField.endDraw();
      
      returnField.beginDraw();
      returnField.background(0,0);
      returnField.strokeWeight(1);
      returnField.fill(180);
      returnField.textAlign(LEFT,CENTER);
      returnField.text(returnText,5,(returnField.height)/2);
      returnField.endDraw();
      
      fieldBuilder.insert(0,inputText);
      
      image(textField,xCoord,yCoord);
      image(returnField,xCoord,yCoord-fieldHeight);
      
      if (keyPressed && !keyHasBeenPressed) {
        if (key != ENTER) {
          if (keys[11]) {
            inputText = inputText + Character.toUpperCase(key);
            shiftPressed = true;
          } else {
              if (keys[12]) {
                fieldBuilder.deleteCharAt(fieldBuilder.length()-1);
                inputText = fieldBuilder.toString();
              } else {
                if (!keys[11] && !keys[12]) {
                  inputText = inputText + key;
              }
            }
          }
          if (keyCode == 8 && inputText.length() >= 2) {
            inputText = inputText.substring(0,inputText.length()-2);
          }
        }
        if (keyCode == ENTER) {
          submitText();
          //inTextField = false;
        }
        keyHasBeenPressed = true;
      }
      
      //removes non-ASCII keys from the field so you can't press backspace or something and get a box
      inputText = inputText.replaceAll("[^\\x00-\\x7F]", "");
      inputText = inputText.replaceAll(Character.toString(backspaceKey), "");
    }
    
    if (!keyPressed && !keys[11]) {
      keyHasBeenPressed = false;
    }
  }
  
  //Other types of fields will be added and used soon
  void submitText() {
    if (textFieldType == FieldType.CONSOLE) {
      commandChecker();
    }
  }
  
  //if a command made sense and was responded to, commandParsed is true - but if not, you get an error message
  
  boolean commandParsed = false;
  
  void commandChecker() {
    
    //A hidden donald
    if (inputText.length() >= 5 && inputText.substring(0,5).equalsIgnoreCase("trump")) {
      returnText = "You have found a hidden Donald";
      donalds++;
      commandParsed = true;
    }
    
    //Changes your name
    if (inputText.length() >= 16 && inputText.substring(0,15).equals("player.setname ")) {
      
      //The password must first be entered before your name can be Dezzy
      if (playerNameCanBeDezzy) {
        if (inputText.substring(15).replaceAll(" ","").equalsIgnoreCase("Dezzy")) {
          returnText = "Only you can be the Dezzy";
          
          //There are no lowercase Dezzys allowed
          playerName = "Dezzy";
        }
      }
      
      if (!playerNameCanBeDezzy) {
        if (inputText.substring(15).replaceAll(" ","").equalsIgnoreCase("Dezzy")) {
          returnText = "You are not the Dezzy";
        } else {
          playerName = inputText.substring(15);
          returnText = "Player name is now "+playerName;
        }
      }
      commandParsed = true;
    }
    
    //This command allows you to change your name to "Dezzy"
    if (inputText.length() >= 22 && inputText.substring(0,22).equals("Boorah Fushee for 3359")) {
      playerNameCanBeDezzy = true;
      
      //Command is not parsed here, so as to confuse people who get this correct
    }
    
    if (inputText.length() >= 4 && inputText.substring(0,4).equalsIgnoreCase("exit")) {
      println("Game terminated through in-game console");
      exit();
    }
    
    //Saves some data about the players position and whatnot
    if (inputText.length() >= 15 && inputText.substring(0,15).equals("player.savedata")) {
      savePlayerData();
      returnText = "Data for "+playerName+" saved to /data/player/"+playerName+"_data.txt along with config file";
      commandParsed = true;
    }
    
    //A hidden donald
    if (inputText.length() >= 6 && inputText.substring(0,6).equalsIgnoreCase("donald")) {
      returnText = "You have found a hidden Donald";
      donalds++;
      commandParsed = true;
    }
    
    //Changes the player's base speed
    if (inputText.length() >= 16 && inputText.substring(0,16).equals("player.setspeed ")) {
      baseMoveDistance = Float.parseFloat(inputText.substring(16));
      returnText = "Base speed set to "+baseMoveDistance+" units per frame";
      commandParsed = true;
    }
    
    //Changes the sprint modifier
    if (inputText.length() >= 22 && inputText.substring(0,22).equals("player.setsprintspeed ")) {
      sprintModifier = Float.parseFloat(inputText.substring(22));
      returnText = "Base sprint speed set to "+sprintModifier+" units per frame";
      commandParsed = true;
    }
    
    //Turns flying on. Beware: AABBs have no upper or lower limit (yet), so you will have walls no matter how high you go
    if (inputText.length() >= 10 && inputText.substring(0,10).equals("player.fly")) {
      flyOn = !flyOn;
      if (flyOn) {
        returnText = "Enabled flying for "+playerName;
      } else {
        returnText = "Disabled flying for "+playerName;
      }
      commandParsed = true;
    }
    
    //Changes the player's flying speed
    if (inputText.length() >= 19 && inputText.substring(0,19).equals("player.setflyspeed ")) {
      baseFlyDistance = Float.parseFloat(inputText.substring(19));
      returnText = "Base fly speed set to "+baseFlyDistance+" units per frame";
      commandParsed = true;
    }
    
    //Multiplayer commands, WIP
    /*
    if (inputText.length() >= 5 && inputText.substring(0,5).equals("host ")) {
      if (!online && !hosting) {
        servPort = int(inputText.substring(5));
        hosting = true;
        tcpHandled = false;
        returnText = "Attempting to host a local server on port "+servPort;
      } else {
        if (hosting) {
          returnText = "You are already hosting a server";
        }
        if (online) {
          returnText = "You cannot host while connected";
        }
      }
      commandParsed = true;
    }
    
    
    if (inputText.length() >= 8 && inputText.substring(0,8).equals("connect ")) {
      if (!online && !hosting) {
        servIP = inputText.substring(8,inputText.lastIndexOf(" "));
        servPort = int(inputText.substring(inputText.lastIndexOf(" ")+1));
        online = true;
        tcpHandled = false;
        returnText = "Attempting to connect to "+servIP+" through port "+servPort;
      } else {
        if (hosting) {
          returnText = "You cannot connect while hosting a server";
        }
        if (online) {
          returnText = "You must first disconnect from this server";
        }
      }
      commandParsed = true;
    }
    
    if (inputText.length() >= 10 && inputText.substring(0,10).equals("disconnect")) {
      if (hosting) {
        hosting = false;
        online = false;
        returnText = "Server has been shut down, client disconnected";
      }
      if (online) {
        online = false;
        hosting = false;
        returnText = "Disconnected from server";
      }
      commandParsed = true;
    }
    */
    
    if (!commandParsed) {
      returnText = "Invalid input";
    }
    commandParsed = false;
    inputText = "";
  }
  
  void savePlayerData() {
    playerData[0] = playerName+" Data File";
    playerData[1] = "yRotate="+yRotate;
    playerData[2] = "xRotate="+xRotate;
    playerData[3] = "yRotateX="+yRotateX;
    playerData[4] = "yRX2="+yRX2;
    playerData[5] = "yRotateZ="+yRotateZ;
    playerData[6] = "yRZ2="+yRZ2;
    
    saveStrings("/data/player/"+playerName+"_data.txt",playerData);
    saveStrings("/data/player/"+playerName+"_config.txt",loadStrings("config.txt"));
  }
}