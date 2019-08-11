//Teh Game by Dezzy

import java.awt.*;
import java.io.*;
import java.net.*;

import processing.net.*;

//import processing.core.*;
//import processing.sound.*;
import camera3D.Camera3D;
import camera3D.generators.*;
import ddf.minim.*;

String version = "dev";

//Default config values

int defaultRenderType = 0;
int defaultBaseMoveDistance = 20;
int defaultSprintModifier = 2;
int defaultCrouchModifier = 2;
int defaultSaveNum = 0;
float defaultRenderDistanceMultiplier = 1000;
boolean defaultFastScreenshots = false;
float defaultMouseSensitivity = 8;
float defaultBaseFlyDistance = 100;

float scaler = 1;
boolean wheelvar = false;
float wheelcount = 1;
float yrotate = 0;
float xRotate = 0;
float zrotate = 0;
float xfield = 0;
float yfield = -80;
float zfield = -80;
float cubesize = 25;
int imax = 80;
int jmax = 80;
int kmax = 80;
int r1 = 0;
int g1 = 0;
int b1 = 0;
float ptStroke = 1;
boolean[] keys = new boolean[14];
float r = 650;
float yRotate = 0;
float swMovement = 0;
float daMovement = 0;
float moveDistance = 10;
float yRotateX = 0;
float yRotateZ = 0;
float xChecker = 0;
float zChecker = 0;
float adAngular = 0;
float mDModifier = 0;
int colCounter = 0;
float yRotateZ2 = 0;
float yRotateX2 = 0;
float upZBound, lowZBound, upXBound, lowXBound;
int millis;
int customFrameRate = 0;
float fr = 0;
float yDetectX, yDetectZ, yDX, yDZ;

int var107Chance = 10000;

int playerNumber = (int)random(0,1000);

String playerName = "player"+playerNumber;

int var107;
boolean player107InWorld = false;

float customXCoord = 0;
float customYCoord = 0;
float customZCoord = 0;

float yJump = 0;

float allX = 0;
float allY = 0;
float allZ = 0;

PGraphics hudCircle;
PGraphics hud;
PGraphics hudCrosshair;
PGraphics menu;
PGraphics saveNumError;
PGraphics settingsSubMenu;
PGraphics menuCrosshair;
PGraphics menuSelectionCrosshair;
PGraphics intro;

boolean inIntro = true;
boolean inMenu = true;
boolean inSettingsSubMenu = false;
boolean inConsole = false;

float numSettingsSubMenuButtons = 3;
int defaultButtonStrokeWeight = 2;
int playButtonStrokeWeight = defaultButtonStrokeWeight;
int settingsButtonStrokeWeight = defaultButtonStrokeWeight;

//SoundFile kygo;

//SoundFile player107Bell;
//SoundFile player107Speech;
boolean speechPlayed = false;

//Footstep Sounds
//SoundFile footstep1;
//SoundFile footstep2;
//SoundFile footstep3;
//SoundFile footstep4;

PFont lucidaConsole;

color redBG = color(255,50,25);
color blackBG = color(0);
color menuBG = color(120);

Camera3D render;
int renderType = 0; //0 for normal rendering, 1 for stereoscopic side-by-side, 2 for red and cyan anaglyph, 3 for Oculus Rift barrel distortion
String renderTypeText = "Default";

BarrelDistortionGenerator oculusGenerator;

float sprintModifier = 2;
float crouchModifier = 2;
float baseMoveDistance = 20;
float baseFlyDistance = 200;
float flyDistance = baseFlyDistance;

float mouseSensitivity = 300.0;

int saveNum = 0;

String[] configFile;
String[] controlsFile;
String[] saveNumData;

float fov = PI/3.0;
float cameraZ;
float renderDistanceMultiplier = 10;

long usedMemory, freeMemory, totalMemory;

float playerSpeed;
float speedMult = 1;

float hudCircleX, hudCircleY;

char forwardMoveKey, backMoveKey, leftMoveKey, rightMoveKey, saveKey;
String sprint, crouch;

boolean fastScreenshotsEnabled = false;

boolean flyOn;

//Models
PShape testRoundObject;
PShape testGenericHouse;
PShape testColoredHouse;
PShape obelisk;
PShape playermodel;

Robot mouseRobot;

Minim minim;

InteractiveTextField console;

WorldActor Stein;

String[] playerData = new String[7];

int donalds = 0;
int totalDonalds = 2;

boolean hosting = false;
boolean online = false;
boolean tcpHandled = false;
String servIP = "192.168.1.11";
int servPort = 10221;
InetAddress localIP;

TCPClient gameClient;
TCPServer gameServer;

Runtime runtime;

Process process;

String vbs = "C:\\windows\\...\\vbs.exe";

void setup() {
  fullScreen(P3D,1); //Replaces size()
  surface.setTitle("Teh Game");
  background(255,50,25);
  fill(200);
  sphereDetail(100);
  strokeWeight(1);
  rectMode(CENTER);
  
  //Sound
  minim = new Minim(this);
  
  keys[0] = false; //LEFT
  keys[1] = false; //RIGHT
  keys[2] = false; //DOWN
  keys[3] = false; //UP
  keys[4] = false; //s
  keys[5] = false; //w
  keys[6] = false; //d
  keys[7] = false; //a
  keys[8] = false; //q
  keys[9] = false; //e
  keys[10] = false; //CTRL
  keys[11] = false; //SHIFT
  keys[12] = false; //BACKSPACE
  keys[13] = false; //SPACE
  frameRate(60);
  noCursor();
  
  if (playerNumber == 107) {
    playerNumber = 314;
    var107Chance = 10;
  }
  
  playerName = "player"+playerNumber;
  
  var107 = (int)random(var107Chance);
  
  lucidaConsole = createFont("/fonts/LucidaConsole-48.vlw",24);
  
  hud = createGraphics(width,height,P2D);
  hud.beginDraw();
  hud.background(120,0);
  hud.noStroke();
  hud.noFill();
  hud.endDraw();
  
  hudCrosshair = createGraphics(width,height,P2D);
  hudCrosshair.beginDraw();
  hudCrosshair.background(120,0);
  hudCrosshair.noStroke();
  hudCrosshair.noFill();
  hudCrosshair.endDraw();
  
  intro = createGraphics(width,height,JAVA2D);
  intro.beginDraw();
  intro.background(menuBG);
  intro.endDraw();
  
  menu = createGraphics(width,height,JAVA2D);
  menu.beginDraw();
  menu.background(menuBG);
  menu.strokeWeight(1);
  menu.fill(0);
  menu.textAlign(CENTER,CENTER);
  menu.textSize(200);
  menu.text("TEH GAME",width/2,2*height/10);
  menu.textSize(150);
  menu.rectMode(CENTER);
  menu.fill(75);
  menu.rect(width/2,height/2,width/4,height/8);
  menu.fill(0);
  menu.text("PLAY",width/2,(height/2)-(height/64));
  menu.text("Settings",width/2,(5*height/8));
  menu.endDraw();
  
  settingsSubMenu = createGraphics(width,height,JAVA2D);
  settingsSubMenu.beginDraw();
  settingsSubMenu.rectMode(CENTER);
  settingsSubMenu.background(menuBG);
  settingsSubMenu.strokeWeight(1);
  settingsSubMenu.fill(75);
  settingsSubMenu.rect(width/2,height/numSettingsSubMenuButtons,width/4,height/10);
  settingsSubMenu.fill(0);
  settingsSubMenu.textAlign(CENTER,CENTER);
  settingsSubMenu.text("Render Type",width/2,(height/numSettingsSubMenuButtons)-(height/64));
  settingsSubMenu.endDraw();
  
  menuCrosshair = createGraphics((int)(height/50.4),(int)(height/50.4),JAVA2D);
  menuCrosshair.beginDraw();
  menuCrosshair.background(0,0);
  menuCrosshair.endDraw();
  
  menuSelectionCrosshair = createGraphics((int)(height/50.4),(int)(height/50.4),JAVA2D);
  menuSelectionCrosshair.beginDraw();
  menuSelectionCrosshair.background(0,0);
  menuSelectionCrosshair.endDraw();
  
  hudCircle = createGraphics(100,100);
  hudCircle.beginDraw();
  hudCircle.background(187);
  hudCircle.noFill();
  hudCircle.strokeWeight(2);
  hudCircle.stroke(0);
  hudCircle.ellipse(50,50,100,100);
  hudCircle.line(50,50,0,50);
  hudCircle.endDraw();
  
  saveNumError = createGraphics(400,150,JAVA2D);
  saveNumError.beginDraw();
  saveNumError.background(255);
  saveNumError.endDraw();
  
  //Texture Loading
  sloth = loadImage("/textures/sloth.jpg");
  gravel_diffuse = loadImage("/textures/gravel_diffuse.jpg");
  bricks1_diffuse = loadImage("/textures/bricks1_diffuse.jpg");
  door_diffuse = loadImage("/textures/door_diffuse.jpg");
  crate_diffuse = loadImage("/textures/crate_diffuse.jpg");
  grass_diffuse = loadImage("/textures/grass_diffuse.jpg");
  hardwood_diffuse = loadImage("/textures/hardwoodfloor_diffuse.jpg");
  beet_the_god = loadImage("/textures/beet_the_god.jpg");
  Bosco = loadImage("/textures/DonBosco.jpg");
  player107 = loadImage("/textures/player107.jpg");
  hotMemes = loadImage("/textures/hotmemes.jpg");
  gordonR = loadImage("/textures/gordonR.jpg");
  
  //Model Loading
  shapeMode(CENTER);
  
  testRoundObject = loadShape("/models/testRoundObject.obj");
  testRoundObject.translate(-testRoundObject.width/2,-testRoundObject.height/2,-testRoundObject.width/2);
  testRoundObject.rotateX(PI);
  testRoundObject.scale(75);
  
  testGenericHouse = loadShape("/models/testGenericHouse.obj");
  testGenericHouse.translate(-testGenericHouse.width/2,-testGenericHouse.height/2,-testGenericHouse.width/2);
  testGenericHouse.rotateX(PI);
  testGenericHouse.scale(125);
  
  testColoredHouse = loadShape("/models/testColoredHouse.obj");
  testColoredHouse.translate(-testColoredHouse.width/2,-testColoredHouse.height/2,-testColoredHouse.width/2);
  testColoredHouse.rotateX(PI);
  testColoredHouse.scale(125);
  
  obelisk = loadShape("/models/bigObelisk.obj");
  obelisk.translate(-obelisk.width/2,0,-obelisk.width/2);
  obelisk.rotateX(PI);
  obelisk.scale(400);
  
  playermodel = loadShape("/data/models/playermodel.obj");
  playermodel.translate(-testRoundObject.width/2,-testRoundObject.height/2,-testRoundObject.width/2);
  playermodel.rotateX(PI);
  playermodel.scale(125);
  
  //Texturing settings
  textureMode(NORMAL); //Normalizes u and v coordinates and allows for image to be resized or easily moved
  textureWrap(REPEAT); //For stuff like the ground and the brick wall
  
  if (var107 == 1) {
    player107InWorld = true;
  }
  
  configFile = loadStrings("/config/config.txt");
  controlsFile = loadStrings("/config/controls.txt");
  try {
    
    //Reads files and sets variables accordingly
    configReader();
    controlReader();
  }
  catch (ArrayIndexOutOfBoundsException e) {
    e.printStackTrace();
    //throw new CorruptFileException("Invalid config.txt file.");
  }
  
  //Upcoming feature
  catch (CorruptFileException ex) {
    ex.printStackTrace();
    exit();
  }
  
  mouseSensitivity = map(mouseSensitivity,1,10,1000,100);
  
  //Why did I make this an array
  saveNumData = new String[1];
  
  //A robot is used to control mouse movement
  try { 
    mouseRobot = new Robot();
    mouseRobot.setAutoDelay(0);
  } 

  catch (Exception e) {
    e.printStackTrace();
  }
  yRotate = 0;
  
  Stein = new WorldActor();
  Stein.defineBasicActorReferences("Stein",2,15,Gender.MALE);
  Stein.setDisposition(Disposition.FRIENDLY);
  
  console = new InteractiveTextField(500,30,FieldType.CONSOLE);
  console.setActivateKey(TAB);
  console.setTextFieldLocation((width/2)-250,height-30);
  
  kygo = new SoundObject(yRotateX+yRX2,-1105,-yRotateZ-yRZ2,"/data/audio/arcade_bass.mp3",SoundTrigger.LOOP,SoundType.LOCATED);
  
  //Multiplayer code, WIP
  if (hosting) {
    gameServer = new TCPServer(servPort);
  }
  if (online) {
    gameClient = new TCPClient(servIP,servPort);
  }
}

boolean fixSaveNum = false;

//Reads the controls file
void controlReader() throws CorruptFileException {
  if (!controlsFile[0].equals("Dezzy")) {
    println("Game terminated.");
    exit();
  }
  forwardMoveKey = controlsFile[1].charAt(8);
  backMoveKey = controlsFile[2].charAt(5);
  leftMoveKey = controlsFile[3].charAt(5);
  rightMoveKey = controlsFile[4].charAt(6);
  saveKey = controlsFile[5].charAt(5);
}

//Reads the config file
void configReader() throws CorruptFileException {
  
  if (!configFile[0].equals("Dezzy")) {
    println("Game terminated.");
    try {
      String path = new File("data/scripts/dezzyConfig.vbs").getAbsolutePath();
      String tempPath = this.getClass().getClassLoader().getResource("").toExternalForm();
      println(tempPath);
      //println(new File(".").getPath());
      //C:\Users\Joe Junior\Documents\Processing\tehGame\data\scripts
      String cmdArg[] = {vbs,"/data/scripts/dezzyConfig.vbs"};
      //process = Runtime.getRuntime().exec(cmdArg);
      //Runtime.getRuntime().exec("wscript data/scripts/dezzyConfig.vbs");
      launch("wscript data/scripts/dezzyConfig.vbs");
      //process.waitFor();
    } catch (Exception e) {
      e.printStackTrace();
    }
    exit();
  }  
  
  renderType = Integer.parseInt(configFile[1].substring(11));
  if (renderType < 0 || renderType > 3) {
    renderType = 0;
    configFile[1] = "renderType="+defaultRenderType;
    saveStrings("config.txt",configFile);
  }
  
  baseMoveDistance = Float.parseFloat(configFile[2].substring(17));
  if (baseMoveDistance <= 0) {
    baseMoveDistance = 20;
    configFile[2] = "baseMoveDistance="+defaultBaseMoveDistance;
    saveStrings("config.txt",configFile);
  }

  sprintModifier = Float.parseFloat(configFile[3].substring(15));
  if (sprintModifier < 0) {
    sprintModifier = 2;
    configFile[3] = "sprintModifier="+defaultSprintModifier;
    saveStrings("config.txt",configFile);
  }
  
  crouchModifier = Float.parseFloat(configFile[4].substring(15));
  if (crouchModifier < 0) {
    crouchModifier = 2;
    configFile[4] = "crouchModifier="+defaultCrouchModifier;
    saveStrings("config.txt",configFile);
  }
  
  saveNum = Integer.parseInt(configFile[5].substring(8));
  if (saveNum < 0) {
    fixSaveNum = true;
  }
  
  renderDistanceMultiplier = Float.parseFloat(configFile[6].substring(25));
  if (renderDistanceMultiplier < 0) {
    renderDistanceMultiplier = 45;
    configFile[6] = "renderDistanceMultiplier="+defaultRenderDistanceMultiplier;
    saveStrings("config.txt",configFile);
  }
  
  fastScreenshotsEnabled = Boolean.parseBoolean(configFile[7].substring(16));
  
  mouseSensitivity = Float.parseFloat(configFile[8].substring(17));
  if (mouseSensitivity < 1) {
    mouseSensitivity = 7;
    configFile[8] = "mouseSensitivity="+defaultMouseSensitivity;
    saveStrings("config.txt",configFile);
  }
  
  baseFlyDistance = Float.parseFloat(configFile[9].substring(16));
  if (baseFlyDistance < 1) {
    baseFlyDistance = defaultBaseFlyDistance;
    configFile[9] = "baseFlyDistance="+defaultBaseFlyDistance;
    saveStrings("config.txt",configFile);
  }
  
  servIP = configFile[10].substring(3);
  
  servPort = int(configFile[11].substring(5));
}

//In case the config file is messed up
void resetConfigFile() {
  configFile[0] = "Dezzy";
  configFile[1] = "renderType="+defaultRenderType;
  configFile[2] = "baseMoveDistance="+defaultBaseMoveDistance;
  configFile[3] = "sprintModifier="+defaultSprintModifier;
  configFile[4] = "crouchModifier="+defaultCrouchModifier;
  configFile[6] = "renderDistanceMultiplier="+defaultRenderDistanceMultiplier;
  configFile[7] = "fastScreenshots="+defaultFastScreenshots;
  configFile[8] = "mouseSensitivity="+defaultMouseSensitivity;
  saveStrings("config.txt",configFile);
}

float xpan = width/2;
float ypan = height/2;

//Some of the oldest code in this game
void cube() {
  box(50);
}

//My friend made this comment when he came to my house
//slurmpus.jpg

//Defining vertexes for physical objects in the game
//This will be fixed soon enough

void taper() {
  fill(0);
  //Floor
  beginShape();
  vertex(0,0,0);
  vertex(0,0,50);
  vertex(-25,0,50);
  vertex(-25,0,0);
  endShape(CLOSE);
  fill(45,14,200);
  beginShape();
  vertex(0,0,0);
  vertex(0,-100,5);
  vertex(-25,-100,5);
  vertex(-25,0,0);
  endShape(CLOSE);
  //Straight Wall
  beginShape();
  vertex(0,0,0);
  vertex(0,0,50);
  vertex(0,-100,45);
  vertex(0,-100,5);
  endShape(CLOSE);
  translate(0,0,50);
  beginShape();
  vertex(0,0,0);
  vertex(-25,0,0);
  vertex(-25,-100,-5);
  vertex(0,-100,-5);
  endShape(CLOSE);
  translate(-25,0,0);
  //Straight Wall
  beginShape();
  vertex(0,0,0);
  vertex(0,-100,-5);
  vertex(0,-100,-45);
  vertex(0,0,-50);
  endShape(CLOSE);
  translate(0,-100,-5);
  //Roof
  fill(0);
  beginShape();
  vertex(0,0,0);
  vertex(25,0,0);
  vertex(25,0,-40);
  vertex(0,0,-40);
  endShape(CLOSE);
  translate(12.5,0,-20);
  //Spire (WIP)
}

void plate() {
  //Outline
  fill(252,106,8);
  beginShape();
  vertex(0,0,0);
  vertex(50,0,0);
  vertex(50,-41,0);
  vertex(0,-41,0);
  endShape(CLOSE);
  //Wall
  beginShape();
  vertex(0,0,0);
  vertex(0,0,3);
  vertex(0,-41,3);
  vertex(0,-41,0);
  endShape(CLOSE);
  //Floor
  beginShape();
  vertex(0,0,0);
  vertex(0,0,3);
  vertex(50,0,3);
  vertex(50,0,0);
  endShape(CLOSE);
  //Roof
  translate(0,-41,0);
  beginShape();
  vertex(0,0,0);
  vertex(0,0,3);
  vertex(50,0,3);
  vertex(50,0,0);
  endShape(CLOSE);
  //Other Wall
  translate(50,0,0);
  beginShape();
  vertex(0,0,0);
  vertex(0,0,3);
  vertex(0,41,3);
  vertex(0,41,0);
  endShape(CLOSE);
  //Front
  translate(0,0,3);
  beginShape();
  vertex(0,0,0);
  vertex(-50,0,0);
  vertex(-50,41,0);
  vertex(0,41,0);
  endShape(CLOSE);
}

void plate2() {
  //Top
  beginShape();
  vertex(0,0,0);
  vertex(-45,0,0);
  vertex(-45,0,5);
  vertex(0,0,5);
  endShape(CLOSE);
  //Wall 1
  beginShape();
  vertex(0,0,0);
  vertex(0,0,5);
  vertex(0,38,5);
  vertex(0,38,0);
  endShape(CLOSE);
  //Wall 2 (Staggered)
  translate(-45,0,0);
  beginShape();
  vertex(0,0,0);
  vertex(0,0,5);
  vertex(0,21,5);
  vertex(0,21,0);
  endShape(CLOSE);
  translate(0,21,0);
  beginShape();
  vertex(0,0,0);
  vertex(14,0,0);
  vertex(14,0,5);
  vertex(0,0,5);
  endShape(CLOSE);
  translate(14,0,0);
  beginShape();
  vertex(0,0,0);
  vertex(0,0,5);
  vertex(0,17,5);
  vertex(0,17,0);
  endShape(CLOSE);
  //Bottom
  translate(0,17,0);
  beginShape();
  vertex(0,0,0);
  vertex(0,0,5);
  vertex(31,0,5);
  vertex(31,0,0);
  endShape(CLOSE);
  //Front
  translate(31,0,5);
  beginShape();
  vertex(0,0,0);
  vertex(0,-38,0);
  vertex(-45,-38,0);
  vertex(-45,-17,0);
  vertex(-31,-17,0);
  vertex(-31,0,0);
  endShape(CLOSE);
}

//A pointless field of colorful points
void field() {
  strokeWeight(ptStroke);
  for (int i = 30; i < imax; i = i+5) {
    r1++;
    if (r1 > 255) {
      r1 = 0;
    }
    for (int j = 0; j < jmax; j = j+5) {
      g1++;
      if (g1 > 255) {
        g1 = 0;
      }
      for (int k = 0; k < kmax; k = k+5) {
        b1++;
        if (b1 > 255) {
          b1 = 0;
        }
        stroke(r1,g1,b1);
        point(i,j,k);
      }
    }
  }
}

void brickWall() {
   //Larger sides of brick wall
   beginShape();
   texture(bricks1_diffuse);
   vertex(0,-500,-1000,0,0);
   vertex(0,500,-1000,0,4);
   vertex(0,500,1000,8,4);
   vertex(0,-500,1000,8,0);
   endShape();
   beginShape();
   texture(bricks1_diffuse);
   vertex(200,-500,-1000,0,0);
   vertex(200,500,-1000,0,4);
   vertex(200,500,1000,8,4);
   vertex(200,-500,1000,8,0);
   endShape();
   
   //Smaller sides of brick wall
   beginShape();
   texture(bricks1_diffuse);
   vertex(0,-500,1000,0,0);
   vertex(200,-500,1000,0.8,0);
   vertex(200,500,1000,0.8,4);
   vertex(0,500,1000,0,4);
   endShape();
   beginShape();
   texture(bricks1_diffuse);
   vertex(0,-500,-1000,0,0);
   vertex(200,-500,-1000,0.8,0);
   vertex(200,500,-1000,0.8,4);
   vertex(0,500,-1000,0,4);
   endShape();
   
   //Top of brick wall
   beginShape();
   texture(bricks1_diffuse);
   vertex(0,-500,-1000,0,0);
   vertex(200,-500,-1000,0.8,0);
   vertex(200,-500,1000,0.8,8);
   vertex(0,-500,1000,0,8);
   endShape(); 
}

void brickWall2() {
   //Larger sides of brick wall
   beginShape();
   texture(bricks1_diffuse);
   vertex(-1000,-500,0,0,0);
   vertex(-1000,500,0,0,4);
   vertex(1000,500,0,8,4);
   vertex(1000,-500,0,8,0);
   endShape();
   beginShape();
   texture(bricks1_diffuse);
   vertex(-1000,-500,200,0,0);
   vertex(-1000,500,200,0,4);
   vertex(1000,500,200,8,4);
   vertex(1000,-500,200,8,0);
   endShape();
   
   //Smaller sides of brick wall
   beginShape();
   texture(bricks1_diffuse);
   vertex(1000,-500,0,0,0);
   vertex(1000,-500,200,0.8,0);
   vertex(1000,500,200,0.8,4);
   vertex(1000,500,0,0,4);
   endShape();
   beginShape();
   texture(bricks1_diffuse);
   vertex(-1000,-500,0,0,0);
   vertex(-1000,-500,200,0.8,0);
   vertex(-1000,500,200,0.8,4);
   vertex(-1000,500,0,0,4);
   endShape();
   
   //Top of brick wall
   beginShape();
   texture(bricks1_diffuse);
   vertex(-1000,-500,0,0,0);
   vertex(-1000,-500,200,0.8,0);
   vertex(1000,-500,200,0.8,8);
   vertex(1000,-500,0,0,8);
   endShape(); 
}

void frontDoor() {
  //Large door panels
  beginShape();
  texture(door_diffuse);
  vertex(0,-500,-250,0,0);
  vertex(0,500,-250,0,1);
  vertex(0,500,250,1,1);
  vertex(0,-500,250,1,0);
  endShape();
  translate(-25,0,200);
  fill(#FFD900);
  sphere(25);
  translate(25,0,-200);
  fill(50,100,200);  
  beginShape();
  texture(door_diffuse);
  vertex(50,-500,-250,0,0);
  vertex(50,500,-250,0,1);
  vertex(50,500,250,1,1);
  vertex(50,-500,250,1,0);
  endShape();
  translate(75,0,200);
  fill(#FFD900);
  sphere(25);
  translate(-75,0,-200);
  fill(50,100,200);
  
  //Top of door
  beginShape();
  texture(door_diffuse);
  vertex(0,-500,-250,0,0.05);
  vertex(50,-500,-250,0,0);
  vertex(50,-500,250,1,0.05);
  vertex(0,-500,250,1,0);
  endShape();
  
  //Sides of door
  beginShape();
  texture(door_diffuse);
  vertex(50,-500,-250,0,1);
  vertex(0,-500,-250,0,0.95);
  vertex(0,500,-250,1,0.95);
  vertex(50,500,-250,1,1);
  endShape();
  beginShape();
  texture(door_diffuse);
  vertex(50,-500,250,0,1);
  vertex(0,-500,250,0,0.95);
  vertex(0,500,250,1,0.95);
  vertex(50,500,250,1,1);
  endShape(); 
  noFill();
}

void crate() {
  //Sides
  beginShape();
  texture(crate_diffuse);
  vertex(150,-150,-150,0,0);
  vertex(150,-150,150,1,0);
  vertex(150,150,150,1,1);
  vertex(150,150,-150,0,1);
  endShape();
  beginShape();
  texture(crate_diffuse);
  vertex(-150,-150,-150,0,0);
  vertex(-150,-150,150,1,0);
  vertex(-150,150,150,1,1);
  vertex(-150,150,-150,0,1);
  endShape();
  
  beginShape();
  texture(crate_diffuse);
  vertex(150,-150,-150,0,0);
  vertex(-150,-150,-150,1,0);
  vertex(-150,150,-150,1,1);
  vertex(150,150,-150,0,1);
  endShape();
  beginShape();
  texture(crate_diffuse);
  vertex(150,-150,150,0,0);
  vertex(-150,-150,150,1,0);
  vertex(-150,150,150,1,1);
  vertex(150,150,150,0,1);
  endShape();
  
  beginShape();
  texture(crate_diffuse);
  vertex(150,-150,-150,0,0);
  vertex(150,-150,150,1,0);
  vertex(-150,-150,150,1,1);
  vertex(-150,-150,-150,0,1);
  endShape();
  beginShape();
  texture(crate_diffuse);
  vertex(150,150,-150,0,0);
  vertex(150,150,150,1,0);
  vertex(-150,150,150,1,1);
  vertex(-150,150,-150,0,1);
  endShape();
}

//Grass floor piece
void grassStrip() {
  beginShape();
  texture(grass_diffuse);
  vertex(-300,0,-2250,0,0);
  vertex(-300,0,2250,7.5,0);
  vertex(300,0,2250,7.5,1);
  vertex(300,0,-2250,0,1);
  endShape();
}

//638 x 413

//1276 x 826

//Gordon Ramsay
void gordonR() {
  beginShape();
  texture(gordonR);
  vertex(-638,-413,0,0,0);
  vertex(-638,413,0,0,1);
  vertex(638,413,0,1,1);
  vertex(638,-413,1,0);
  endShape();
}

//Hardwood floor
void hardwoodFloor() {
  beginShape();
  texture(hardwood_diffuse);
  vertex(1200,0,2250,0,0);
  vertex(-1200,0,2250,2,0);
  vertex(-1200,0,-2250,2,3.25);
  vertex(1200,0,-2250,0,3.25);
  endShape();
}

//Picture of Don Bosco
void saintBosco() {
  beginShape();
  texture(Bosco);
  vertex(0,-500,-375,0,0);
  vertex(0,-500,375,1,0);
  vertex(0,500,375,1,1);
  vertex(0,500,-375,0,1);
  endShape();
}

//Mirrored picture of Don Bosco
//(Isn't actually mirrored)
void saintBoscoM() {
  beginShape();
  texture(Bosco);
  vertex(0,-500,-375,1,0);
  vertex(0,-500,375,0,0);
  vertex(0,500,375,0,1);
  vertex(0,500,-375,1,1);
  endShape();
}

//Nothing to say about this
void player107() {
  beginShape();
  texture(player107);
  vertex(0,-500,-375,0,0);
  vertex(0,-500,375,1,0);
  vertex(0,500,375,1,1);
  vertex(0,500,-375,0,1);
  endShape();
}

//Or this
void player107M() {
  beginShape();
  texture(player107);
  vertex(0,-500,-375,1,0);
  vertex(0,-500,375,0,0);
  vertex(0,500,375,0,1);
  vertex(0,500,-375,1,1);
  endShape();
}

//Some memes
void hotMemes() {
  beginShape();
  texture(hotMemes);
  vertex(0,-500,-1000,0,0);
  vertex(0,500,-1000,0,1);
  vertex(0,500,1000,1,1);
  vertex(0,-500,1000,1,0);
  endShape();
}

//All of the circle methods that make this program happen - used for movement and collision detection
//(A.K.A. tons of boilerplate code that shouldn't be here - but they work for now, so they are here)

float circleCounter = 0;
float tempX1 = 0, tempZ1 = 0, tempX2 = 0, tempZ2 = 0;
float circleCycle = 0;

void circle() {
  
  //Creates a circle with a radius of moveDistance so that WS will work correctly
  circleCounter++;
  double theta = yRotate;
  float tempX, tempZ;
  tempX = moveDistance * cos((float)theta);
  tempZ = moveDistance * sin((float)theta);
  if (circleCounter % 2 == 0) {
    tempX1 = tempX2+tempX;
    tempZ1 = tempZ2+tempZ;
    circleCycle = 0;
  } else {
    tempX2 = tempX1+tempX;
    tempZ2 = tempZ1+tempZ;
    circleCycle = 1;
  }
  if (circleCycle == 0) {
    yRotateZ = tempX1;
    yRotateX = tempZ1;
  } else {
    yRotateZ = tempX2;
    yRotateX = tempZ2;
  }
  //println(theta);
}

void circleS() {
  
  //Creates a circle with a radius of moveDistance so that WS will work correctly
  circleCounter++;
  double theta = yRotate;
  float tempX, tempZ;
  tempX = abs(moveDistance) * cos((float)theta);
  tempZ = abs(moveDistance) * sin((float)theta);
  if (circleCounter % 2 == 0) {
    tempX1 = tempX2+tempX;
    tempZ1 = tempZ2+tempZ;
    circleCycle = 0;
  } else {
    tempX2 = tempX1+tempX;
    tempZ2 = tempZ1+tempZ;
    circleCycle = 1;
  }
  if (circleCycle == 0) {
    yRotateZ = tempX1;
    yRotateX = tempZ1;
  } else {
    yRotateZ = tempX2;
    yRotateX = tempZ2;
  }
  //println(theta);
}

//These colCircle methods are old methods from old collision handling, but they are still here because I cannot bring myself to delete them

void colCircle() {
  
  //Just like circle(), except theta = -yRotate to move in the opposite direction when a collision occurs
  circleCounter++;
  double theta = -yRotate;
  if (moveDistance >= 0) {
    theta = yRotate;
  }
  float tempX, tempZ;
  tempX = (1.1*moveDistance) * cos((float)theta);
  tempZ = (1.1*moveDistance) * sin((float)theta);
  if (circleCounter % 2 == 0) {
    tempX1 = tempX2+tempX;
    tempZ1 = tempZ2+tempZ;
    circleCycle = 0;
  } else {
    tempX2 = tempX1+tempX;
    tempZ2 = tempZ1+tempZ;
    circleCycle = 1;
  }
  if (circleCycle == 0) {
    yRotateZ = tempX1;
    yRotateX = tempZ1;
  } else {
    yRotateZ = tempX2;
    yRotateX = tempZ2;
  }
  //println(theta);
}

void colCircle2() {
  
  //Just like circle(), except theta = -yRotate to move in the opposite direction when a collision occurs
  circleCounter++;
  double theta = -yRotate;
  float tempX, tempZ;
  tempX = (2*moveDistance) * cos((float)theta);
  tempZ = (2*moveDistance) * sin((float)theta);
  if (circleCounter % 2 == 0) {
    tempX1 = tempX2+tempX;
    tempZ1 = tempZ2+tempZ;
    circleCycle = 0;
  } else {
    tempX2 = tempX1+tempX;
    tempZ2 = tempZ1+tempZ;
    circleCycle = 1;
  }
  if (circleCycle == 0) {
    yRotateZ = tempX1;
    yRotateX = tempZ1;
  } else {
    yRotateZ = tempX2;
    yRotateX = tempZ2;
  }
  //println(theta);
}

void colCircle3() {
  
  //Just like circle(), except theta = -yRotate to move in the opposite direction when a collision occurs, and some different theta stuff
  circleCounter++;
  double theta = -yRotate;
  theta = -(map(yRotate,0,(2*PI),0,PI));
  float tempX, tempZ;
  tempX = (2*moveDistance) * cos((float)theta);
  tempZ = (2*moveDistance) * sin((float)theta);
  if (circleCounter % 2 == 0) {
    tempX1 = tempX2+tempX;
    tempZ1 = tempZ2+tempZ;
    circleCycle = 0;
  } else {
    tempX2 = tempX1+tempX;
    tempZ2 = tempZ1+tempZ;
    circleCycle = 1;
  }
  if (circleCycle == 0) {
    yRotateZ = tempX1;
    yRotateX = tempZ1;
  } else {
    yRotateZ = tempX2;
    yRotateX = tempZ2;
  }
  //println(theta);
}

void colCircleS() {
  
  //Fix for reverse theta noclip glitch with a new method for going backwards and colliding
  circleCounter++;
  double theta = yRotate;
  if (theta >= PI) {
    theta += PI;
  }
  
  float tempX, tempZ;
  tempX = (2*moveDistance) * cos((float)theta);
  tempZ = (2*moveDistance) * sin((float)theta);
  if (circleCounter % 2 == 0) {
    tempX1 = tempX2+tempX;
    tempZ1 = tempZ2+tempZ;
    circleCycle = 0;
  } else {
    tempX2 = tempX1+tempX;
    tempZ2 = tempZ1+tempZ;
    circleCycle = 1;
  }
  if (circleCycle == 0) {
    yRotateZ = tempX1;
    yRotateX = tempZ1;
  } else {
    yRotateZ = tempX2;
    yRotateX = tempZ2;
  }
  //println(theta);
}

float circleCounter2 = 0;
float circleCycle2 = 0;
float tempX3 = 0, tempZ3 = 0, tempX4 = 0, tempZ4 = 0, tempX5 = 0, tempZ5 = 0;
float yRX2 = 0, yRZ2 = 0;

void adCircle() {
  
  //Creates a circle with a radius of moveDistance so that AD will work correctly
  circleCounter2++;
  double theta = adAngular;
  float tempX3, tempZ3;
  tempX3 = abs(moveDistance) * cos((float)theta);
  tempZ3 = abs(moveDistance) * sin((float)theta);
  if (circleCounter2 % 2 == 0) {
    tempX4 = tempX5+tempX3;
    tempZ4 = tempZ5+tempZ3;
    circleCycle2 = 0;
  } else {
    tempX5 = tempX4+tempX3;
    tempZ5 = tempZ4+tempZ3;
    circleCycle2 = 1;
  }
  if (circleCycle2 == 0) {
    yRZ2 = tempX4;
    yRX2 = tempZ4;
  } else {
    yRZ2 = tempX5;
    yRX2 = tempZ5;
  }
  //println(theta);
}

void colAdCircle() {
  
  //Just like adCircle(), except theta = -adAngular to move in the opposite direction when a collision occurs
  circleCounter2++;
  double theta = -adAngular;
  float tempX3, tempZ3;
  tempX3 = abs(moveDistance) * cos((float)theta);
  tempZ3 = abs(moveDistance) * sin((float)theta);
  if (circleCounter2 % 2 == 0) {
    tempX4 = tempX5+tempX3;
    tempZ4 = tempZ5+tempZ3;
    circleCycle2 = 0;
  } else {
    tempX5 = tempX4+tempX3;
    tempZ5 = tempZ4+tempZ3;
    circleCycle2 = 1;
  }
  if (circleCycle2 == 0) {
    yRZ2 = tempX4;
    yRX2 = tempZ4;
  } else {
    yRZ2 = tempX5;
    yRX2 = tempZ5;
  }
  //println(theta);
} 

double yRadX, yRadZ;
float auxLineDist = 2;

void triangleSound() {
  
  //Creates a circle with a radius of moveDistance to see if a movement forwards would put you in an AABB
  double theta = yRotate % TWO_PI;
  double tempX, tempZ;
  tempX = auxLineDist * cos((float)theta);
  tempZ = auxLineDist * sin((float)theta);
  yRadX = tempZ;
  yRadZ = tempX;
  //println(theta);
}

float colDistance = 100;

boolean sprinting = false;

void circleDetect() {
  
  //Creates a circle with a radius of moveDistance to see if a movement forwards would put you in an AABB
  circleCounter++;
  double theta = yRotate;
  float tempX, tempZ;
  tempX = moveDistance * cos((float)theta);
  tempZ = moveDistance * sin((float)theta);
  yDetectX = tempZ;
  yDetectZ = tempX;
  //println(theta);
}

void circleSDetect() {
  
  //Creates a circle with a radius of moveDistance to see if a movement backwards would put you in an AABB
  circleCounter++;
  double theta = yRotate;
  float tempX, tempZ;
  tempX = abs(moveDistance) * cos((float)theta);
  tempZ = abs(moveDistance) * sin((float)theta);
  yDetectX = tempZ;
  yDetectZ = tempX;
  //println(theta);
}

void adCircleDetect() {
  
  //Creates a circle with a radius of moveDistance to see if a movement sideways would put you in an AABB
  circleCounter2++;
  double theta = adAngular;
  float tempX3, tempZ3;
  tempX3 = abs(moveDistance) * cos((float)theta);
  tempZ3 = abs(moveDistance) * sin((float)theta);
  yDX = tempZ3;
  yDZ = tempX3;
  //println(theta);
}

//Collision Handler method, called after boundSetter() whenever a collision is detected
//--OUTDATED-- This method was never finished, and the parts that worked were annoying

void colHandler() {
  if (((yRotateZ+yRZ2 >= lowZBound) && (yRotateZ+yRZ2 <= upZBound)) && (yRotateX+yRX2 >= lowXBound && yRotateX+yRX2 <= upXBound) ) {
    if (keys[6] || keys[7]) {
      colAdCircle();
    }
    if ((yRotateX+yRX2 <= upXBound && 0 < yRotate && yRotate < PI) || (yRotateX+yRX2 >= lowXBound && PI < yRotate && yRotate < (2*PI))) {
      colCircle2();
    } else {
      moveDistance = -moveDistance;
      colCircle();
    }
  }
}

//Optimized collision handling
//(that isn't finished)
int facing;
// 0 for -x
// 1 for +x
// 2 for -z
// 3 for +z
// 4 for ad special case

//Collision detection that ties in with circleDetect() methods as a better form of collision detection
//but only "better"
void colHandlerV2Detect() {
  if (wCol && ((0 <= yRotate && yRotate <= PI/2) || (((3*PI/2) <= yRotate && yRotate <= 2*PI)))) {
    facing = 2;
  }
  if (adCol && ((0 <= yRotate && yRotate <= PI/2) || (((3*PI/2) <= yRotate && yRotate <= 2*PI)))) {
    facing = 4;
  }
  if (sCol && ((0 <= yRotate && yRotate <= PI/2) || (((3*PI/2) <= yRotate && yRotate <= 2*PI)))) {
    facing = 3;
  }
  //if (wCol && (0 <= yRotate
}


//More parts of the "better" collision detection that actually check for collisions (AABB)
boolean wCol, sCol, adCol;

void colHandlerV2() {
  if (((yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord >= lowZBound) && (yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord <= upZBound)) && (yRotateX+yRX2+yDetectX+yDX+customXCoord >= lowXBound && yRotateX+yRX2+yDetectX+yDX+customXCoord <= upXBound) ) {
    wCol = true;
  } else {
    wCol = false;
  }
}

void colHandlerSV2() {
  if (((yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord >= lowZBound) && (yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord <= upZBound)) && (yRotateX+yRX2+yDetectX+yDX+customXCoord >= lowXBound && yRotateX+yRX2+yDetectX+yDX+customXCoord <= upXBound) ) {
    sCol = true;
  } else {
    sCol = false;
  }
}

void colHandlerADV2() {
  if (((yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord >= lowZBound) && (yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord <= upZBound)) && (yRotateX+yRX2+yDetectX+yDX+customXCoord >= lowXBound && yRotateX+yRX2+yDetectX+yDX+customXCoord <= upXBound) ) {
    adCol = true;
  } else {
    adCol = false;
  }
}

void colHandlerV21() {
  if (((yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord >= lowZBound) && (yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord <= upZBound)) && (yRotateX+yRX2+yDetectX+yDX+customXCoord >= lowXBound && yRotateX+yRX2+yDetectX+yDX+customXCoord <= upXBound) ) {
    wCol = true;
  }
}

void colHandlerSV21() {
  if (((yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord >= lowZBound) && (yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord <= upZBound)) && (yRotateX+yRX2+yDetectX+yDX+customXCoord >= lowXBound && yRotateX+yRX2+yDetectX+yDX+customXCoord <= upXBound) ) {
    sCol = true;
  }
}

void colHandlerADV21() {
  if (((yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord >= lowZBound) && (yRotateZ+yRZ2+yDetectZ+yDZ+customZCoord <= upZBound)) && (yRotateX+yRX2+yDetectX+yDX+customXCoord >= lowXBound && yRotateX+yRX2+yDetectX+yDX+customXCoord <= upXBound) ) {
    adCol = true;
  }
}

//Sets axis aligned bounding boxes by specifying min/max x and z values, y values coming soon with gravity
void boundSetter(float upX, float lowX, float upZ, float lowZ) {
  upXBound = upX;
  lowXBound = lowX;
  upZBound = upZ;
  lowZBound = lowZ;
}

//Collision Detection by checking inequalities that define axis-aligned bounding boxes - smoothest, yet player gets "glued" to walls (seriously, I need to fix this)

void collisionDetectionV2(int i) {
  //(yRotateX+yRX2,-105,6250-(2000+yRotateZ+yRZ2))
  
  //AABB's were found by entering the game and using coordinates from the HUD
  
  boundSetter(-(width/2)+160,(-width/2)-200,4500,4000);
  
  switch (i) {
    case 0:
      colHandlerV21();
      break;
    case 1:
      colHandlerSV21();
      break;
    case 2:
      colHandlerADV21();
      break;
  }
  
  //translate(yRotateX+yRX2,-105,5000-(2000+yRotateZ+yRZ2));
  
  //160 is the magic number to avoid noclips for brick walls
  boundSetter(-(width/2)+160,(-width/2)-360,4000,2000);
  
  switch (i) {
    case 0:
      colHandlerV21();
      break;
    case 1:
      colHandlerSV21();
      break;
    case 2:
      colHandlerADV21();
      break;
  }
  
  boundSetter(-(width/2)+160,(-width/2)-360,6500,4500);
  
  switch (i) {
    case 0:
      colHandlerV21();
      break;
    case 1:
      colHandlerSV21();
      break;
    case 2:
      colHandlerADV21();
      break;
  }
  
  //translate(1000+yRotateX+yRX2,-105,3800-(2000+yRotateZ+yRZ2));
  boundSetter(-(width/2)+160,(-width/2)-3160,2160,1656);
 
  switch (i) {
     case 0:
       colHandlerV21();
       break;
     case 1:
       colHandlerSV21();
       break;
     case 2:
       colHandlerADV21();
       break;
  }
  
  boundSetter(-(width/2)+160,(-width/2)-3160,6880,6325);
 
  switch (i) {
    case 0:
      colHandlerV21();
      break;
    case 1:
      colHandlerSV21();
      break;
    case 2:
      colHandlerADV21();
      break;
  }
  
  boundSetter(-(width/2)+964,(-width/2)+(width/4),5241,4696);
 
  switch (i) {
    case 0:
      colHandlerV21();
      break;
    case 1:
      colHandlerSV21();
      break;
    case 2:
      colHandlerADV21();
      break;
  }
  
  boundSetter(61110,54879,205592,199063);
  
  switch (i) {
    case 0:
      colHandlerV21();
      break;
    case 1:
      colHandlerSV21();
      break;
    case 2:
      colHandlerADV21();
      break;
  }
}

//Old, jumpy and clunky collision handling
void collisionDetection() {
  //(yRotateX+yRX2,-105,6250-(2000+yRotateZ+yRZ2))
  
  //Finding AABB's by interpreting world construction code is annoying and a waste of time
  
  boundSetter(-(width/2)+160,(-width/2)-200,4500,4000);
  
  colHandler();
  
  //translate(yRotateX+yRX2,-105,5000-(2000+yRotateZ+yRZ2));
  
  //160 is the magic number to avoid noclips for brick walls
  boundSetter(-(width/2)+160,(-width/2)-360,4000,2000);
  
  colHandler();
  
  boundSetter(-(width/2)+160,(-width/2)-360,6500,4500);
  
  colHandler();
}

/*
void circle() {
  
  //Creates a circle with a radius of moveDistance so that WS will work correctly
  circleCounter++;
  double theta = yRotate;
  float tempX, tempZ;
  tempX = moveDistance * cos((float)theta);
  tempZ = moveDistance * sin((float)theta);
  if (circleCounter % 2 == 0) {
    tempX1 = tempX2+tempX;
    tempZ1 = tempZ2+tempZ;
    circleCycle = 0;
  } else {
    tempX2 = tempX1+tempX;
    tempZ2 = tempZ1+tempZ;
    circleCycle = 1;
  }
  if (circleCycle == 0) {
    yRotateZ = tempX1;
    yRotateX = tempZ1;
  } else {
    yRotateZ = tempX2;
    yRotateX = tempZ2;
  }
  //println(theta);
}
*/

//First person shooting (WIP)

float zShotCoord,xShotCoord;
float shootCircleCounter = 0;
float shootCircleCycle = 0;

void shootCircle() {
  
  //Creates a circle
  shootCircleCycle++;
  double theta = yRotate;
  float tempX, tempZ;
  tempX = 10000 * cos((float)theta);
  tempZ = 10000 * sin((float)theta);
  zShotCoord = tempX;
  xShotCoord = tempZ;
  //println(theta);
}

void singleShot() {
  stroke(#FFEB08); //Gold
  strokeWeight(5);
  shootCircle();
  //line(width/2,0,width/2,0,0,-10000);
  noStroke();
}

//Menu button action
//There will soon be a Button class

boolean cursorOverPlay = false;
boolean cursorOverSettings = false;

void menuCursorAction() {
  if (inMenu && !inSettingsSubMenu && mouseX < (width/2) + (width/8) && mouseX > (width/2) - (width/8) && mouseY > (height/2) - (2*height/32) && mouseY < (height/2) + (2*height/32)) {
    cursorOverPlay = true;
    playButtonStrokeWeight = 0;
  } else {
    cursorOverPlay = false;
    playButtonStrokeWeight = defaultButtonStrokeWeight;
  }
  if (inMenu && !inSettingsSubMenu && mouseX < (width/2) + (width/8) && mouseX > (width/2) - (width/8) && mouseY > (11*height/16) - (2*height/32) && mouseY < (11*height/16) + (2*height/32)) {
    cursorOverSettings = true;
    settingsButtonStrokeWeight = 0;
  } else {
    cursorOverSettings = false;
    settingsButtonStrokeWeight = defaultButtonStrokeWeight;
  }
}

//Plays a random footstep sound for every 50 "steps," which are increased by moving
//But somehow, Minim manages to destroy the sound files, so this doesn't work

int stepCounter = 0;
int stepSelector = 0;
boolean stepPlayed = true;

void stepTracker() {
  
  //FIX THE SOUND FILES FIRST
  
  /*
  stepSelector = (int)random(1,5);
  if (stepCounter % 50 == 0 & !inMenu & !stepPlayed) {
    switch (stepSelector) {
      case 1:
        footstep1.play();
        break;
      case 2:
        footstep2.play();
        break;
      case 3:
        footstep3.play();
        break;
      case 4:
        footstep4.play();
        break;
    }
    stepPlayed = true;
  }
  if (stepCounter % 50 != 0 & !inMenu) {
    stepPlayed = false;
  }
  */
}

//OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD OLD sound methods, from before SoundObject
//These methods rely on the Processing Sound Library (which is complete trash, you can't pan sound correctly with it), so Minim is used now

boolean kygoPlayed = false;

//Creates sound entities in the world, pan() throws errors, probably because of corrupted sound library
void soundEntity(float xPos, float yPos, float zPos, float normVol, String file, int soundType, int iteration) {
  //soundType should be "LOOP" for a looping sound or it should have the name of an existing boolean that corresponds to an activation condition
  
  //Makes sure that normVol does not fall outside of 0-1
  if (normVol > 1) {
    normVol = 1;
  }
  if (normVol < 0) {
    normVol = 0;
  }
  float soundDist = abs(dist(xPos,yPos,zPos,0,0,0));
  float volModifier = norm(soundDist,0,10000);
  float soundAngle = atan2(xPos,zPos);
  float panAngle = 0;
  boolean soundPlayed = false;
  
  switch (iteration) {
    case 1:
      soundPlayed = kygoPlayed;
      break;
  }
  
  //file contains the name of the sound file to be played
  //SoundFile entityFile;
  //entityFile = new SoundFile(this, file);
  if (volModifier > 1) {
    volModifier = 1;
  }
  if (volModifier < 0) {
    volModifier = 0;
  }
  
  if (soundAngle >= 0) {
    panAngle = map(soundAngle,PI,0,-1,1);
  }
  if (soundAngle < 0) {
    panAngle = map(soundAngle,-PI,0,-1,1);
  }
  
  //Sets the volume by multiplying the normalized volume normVol by the normalized distance based volume
  //entityFile.amp(normVol*(1-volModifier));
  //entityFile.pan(panAngle);
  
  if (soundType == 1 && !soundPlayed) {
    //entityFile.loop();
    soundPlayed = true;
  }
  
  /*
  if (soundType.equals("LOOP") && !soundPlayed) {
    entityFile.loop();
    soundPlayed = true;
  }
  if (!soundType.equals("LOOP")) {
    
  }
  */
}


//soundEntity methods for large sound files
void soundEntityKygo(float xPos, float yPos, float zPos, float normVol) {
  //soundType should be "LOOP" for a looping sound or it should have the name of an existing boolean that corresponds to an activation condition
  
  //Makes sure that normVol does not fall outside of 0-1
  if (normVol > 1.0) {
    normVol = 1.0;
  }
  if (normVol < 0.0) {
    normVol = 0.0;
  }
  float soundDist = abs(dist(xPos,yPos,zPos,0.0,0.0,0.0));
  float volModifier = norm(soundDist,0.0,10000.0);
  float soundAngle = atan2(xPos,zPos);
  float panAngle;
  
  //file contains the name of the sound file to be played
  if (volModifier > 1.0) {
    volModifier = 1;
  }
  if (volModifier < 0.0) {
    volModifier = 0.0;
  }
  
  if (soundAngle >= 0) {
    //panAngle = map(soundAngle,PI,0.0,-1.0,1.0);
    panAngle = map(mouseX,0,width,-1.0,1.0);
    //kygo.pan(panAngle);
  }
  if (soundAngle < 0) {
    //panAngle = map(soundAngle,-PI,0.0,-1.0,1.0);
    panAngle = map(mouseX,0,width,-1.0,1.0);
    //kygo.pan(panAngle);
  }
  
  //Sets the volume by multiplying the normalized volume normVol by the normalized distance based volume
  //kygo.rate(1);
  //kygo.amp(normVol*(1.0-volModifier));
  
  /*
  if (soundType.equals("LOOP") && !soundPlayed) {
    entityFile.loop();
    soundPlayed = true;
  }
  if (!soundType.equals("LOOP")) {
    
  }
  */
}

float soundDist, volModifier, soundAngle, panAngle, normVol;

void soundHandler() {
  
  //(-750)+(yRotateX+yRX2),250,7000-(2000+yRotateZ+yRZ2)
  //soundEntityKygo(((-750)+(yRotateX+yRX2)),250,(7000-(2000+yRotateZ+yRZ2)),1);
  
  soundDist = abs(dist(((-750)+(yRotateX+yRX2)),250,7000-(2000+yRotateZ+yRZ2),0.0,0.0,0.0));
  volModifier = norm(soundDist,0.0,10000.0);
  soundAngle = atan2(((-750)+(yRotateX+yRX2)),(7000-(2000+yRotateZ+yRZ2)));
  normVol = 1.0;
  if (volModifier > 1.0) {
    volModifier = 1;
  }
  if (volModifier < 0.0) {
    volModifier = 0.0;
  }
  
  if (soundAngle >= 0) {
    //panAngle = map(soundAngle,PI,0.0,-1.0,1.0);
    //kygo.pan(map(mouseX,0,width,-1.0,3.0));
  }
  if (soundAngle < 0) {
    //panAngle = map(soundAngle,-PI,0.0,-1.0,1.0);
    //kygo.pan(map(mouseX,0,width,-1.0,3.0));
  }
  
  //Sets the volume by multiplying the normalized volume normVol by the normalized distance based volume
  //kygo.rate(1);
  //kygo.amp(normVol*(1.0-volModifier));
}

//This is no longer OLD OLD OLD OLD OLD OLD OLD!

//Initialization methods to be run when !inMenu to set rendering type to either default, stereoscopic, anaglyph, or oculus rift

boolean stereoscopicInitialized = false;
boolean redCyanAnaglyphInitialized = false;
boolean oculusRiftInitialized = false;

void stereoscopicInit() {
  render = new Camera3D(this);
  render.renderSplitFrameSideBySide().setDivergence(1);
  render.setBackgroundColor(redBG);
  renderTypeText = "Stereoscopic";
}

void redCyanAnaglyphInit() {
  render = new Camera3D(this);
  render.renderDefaultAnaglyph().setDivergence(1);
  render.setBackgroundColor(redBG);
  renderTypeText = "Anaglyph";
}

void oculusRiftInit() {
  render = new Camera3D(this);
  oculusGenerator = render.renderBarrelDistortion().setDivergence(1);
  render.setBackgroundColor(redBG);
  oculusGenerator.setBarrelDistortionCoefficients(0.22, 0.24);
  renderTypeText = "Oculus Rift";
}

//Ensures that renderInitialization occurs only once
boolean perspectiveInitialized = false;

void renderInitialization() {
  if (renderType == 0) {
    renderTypeText = "Default";
  }
  if (renderType == 1) {
    renderTypeText = "Stereoscopic";
  }
  if (renderType == 2) {
    renderTypeText = "Anaglyph";
  }
  if (renderType == 3) {
    renderTypeText = "Oculus Rift";
  }
  if (!inMenu) {
    if (renderType == 1 && !stereoscopicInitialized) {
      stereoscopicInit();
      stereoscopicInitialized = true;
    }
    if (renderType == 2 && !redCyanAnaglyphInitialized) {
      redCyanAnaglyphInit();
      redCyanAnaglyphInitialized = true;
    }
    if (renderType == 3 && !oculusRiftInitialized) {
      oculusRiftInit();
      oculusRiftInitialized = true;
    }
    if (renderType == 0) {
      renderTypeText = "Default";
    }
    if (!perspectiveInitialized) {
      cameraZ = (height/2.0) / tan(fov/2.0);
      //Sets render distance and FOV
      perspective(fov,float(width)/float(height),cameraZ/10.0,cameraZ*renderDistanceMultiplier);
      if (renderType != 0) {
        //Sets render distance and FOV
        render.perspective(fov,float(width)/float(height),cameraZ/10.0,cameraZ*renderDistanceMultiplier);
      }
      perspectiveInitialized = true;
    }
  }
}

//Little circle graphic in the upper right corner of the HUD
void updateHudCircle() {
  double theta = yRotate;
  hudCircleX = (47 * cos((float)theta));
  hudCircleY = (47 * sin((float)theta));
}

float renderTypeOptionCycler = renderType;
String renderTypeOptionText = renderTypeText;

//0 for normal rendering, 1 for stereoscopic side-by-side, 2 for red and cyan anaglyph, 3 for Oculus Rift barrel distortion

//Settings menu is unfinished
void updateSettingsSubMenu() {
  if (renderTypeOptionCycler == 0) {
    renderTypeOptionText = "Default";
  }
  if (renderTypeOptionCycler == 1) {
    renderTypeOptionText = "Stereoscopic";
  }
  if (renderTypeOptionCycler == 2) {
    renderTypeOptionText = "Anaglyph";
  }
  if (renderTypeOptionCycler == 3) {
    renderTypeOptionText = "Oculus Rift";
  }
}

//Before SoundObject
float sRadX = 0, sRadZ = 0;
float thirdLineDist = 10000;

void soundTriangle() {
  
  //Creates a line for the triangle that is solved to produce stereo sound
  
  double theta = yRotate % TWO_PI;
  sRadZ = -(thirdLineDist * cos((float)theta));
  sRadX = -(thirdLineDist * sin((float)theta));
  //println(theta);
}

/*
void circle() {
  
  //Creates a circle with a radius of moveDistance so that WS will work correctly
  circleCounter++;
  double theta = yRotate;
  float tempX, tempZ;
  tempX = moveDistance * cos((float)theta);
  tempZ = moveDistance * sin((float)theta);
  if (circleCounter % 2 == 0) {
    tempX1 = tempX2+tempX;
    tempZ1 = tempZ2+tempZ;
    circleCycle = 0;
  } else {
    tempX2 = tempX1+tempX;
    tempZ2 = tempZ1+tempZ;
    circleCycle = 1;
  }
  if (circleCycle == 0) {
    yRotateZ = tempX1;
    yRotateX = tempZ1;
  } else {
    yRotateZ = tempX2;
    yRotateX = tempZ2;
  }
  //println(theta);
}
*/

//Do stuff based on what keys are being pressed. NOTE! Shift has some issues.
void keyAction() {
  if (keys[11]) {
    moveDistance = 0;
    circle();
    adCircle();
    moveDistance = baseMoveDistance*sprintModifier;
    flyDistance = baseFlyDistance*sprintModifier;
    stepCounter+=2;
  } else {
    moveDistance = 0;
    circle();
    adCircle();
    moveDistance = baseMoveDistance;
    flyDistance = baseFlyDistance;
  }
  if (keys[0]) {
    yRotate -= 0.05;
  }
  if (keys[1]) {
    yRotate += 0.05;
  }
  if (keys[2]) {
    xRotate += 0.05;
  }
  if (keys[3]) {
    xRotate -= 0.05;
  }
  
  if (keys[4]) {
    //moveDistance = abs(moveDistance);
    swMovement += 10;
    circleSDetect();
    collisionDetectionV2(1);
    if (!sCol) {
      circleS();
      stepCounter++;
    } else {
      collisionDetected = true;
    }
    wCol = false;
    sCol = false;
    adCol = false;
  }
  if (keys[5]) {
    moveDistance = -abs(moveDistance);
    swMovement -= 10;
    circleDetect();
    collisionDetectionV2(0);
    if (!wCol) {
      circle();
      stepCounter++;
    } else {
      collisionDetected = true;
    }
    wCol = false;
    sCol = false;
    adCol = false;
  }
  if (keys[6]) {
    adAngular = yRotate-(PI/2);
    daMovement -= 10;
    adCircleDetect();
    collisionDetectionV2(2);
    if (!adCol) {
      adCircle();
      stepCounter++;
    } else {
      collisionDetected = true;
    }
    wCol = false;
    sCol = false;
    adCol = false;
  }
  if (keys[7]) {
    adAngular = yRotate+(PI/2);
    daMovement += 10;
    adCircleDetect();
    collisionDetectionV2(2);
    if (!adCol) {
      adCircle();
      stepCounter++;
    } else {
      collisionDetected = true;
    }
    wCol = false;
    sCol = false;
    adCol = false;
  }
  if (keys[10]) {
    if (!flyOn) {
      yTranslate -= height/5;
      crouching = true;
      moveDistance /= crouchModifier;
    } else {
      if (yTranslate > 0) {
        yTranslate -= flyDistance;
        if (yTranslate <= 0) {
          yTranslate = 0;
          flyOn = false;
        }
      }
    }
  } else {
    crouching = false;
  }
  if (!flyOn) {
    keys[13] = false;
  }
  if (keys[13]) {
    yTranslate += flyDistance;
  }
  
  if ((keys[4] && keys[6]) || (keys[4] && keys[7]) || (keys[5] && keys[6]) || (keys[5] && keys[7])) {
    speedMult = 1.4;
  } else {
    speedMult = 1;
  }
  if (!keys[11] && !keys[10]){
    playerSpeed = baseMoveDistance*frameRate*speedMult;
  }
  if (keys[11] && !keys[10]) {
    playerSpeed = baseMoveDistance*sprintModifier*frameRate*speedMult;
  }
  if (!keys[11] && keys[10]) {
    playerSpeed = baseMoveDistance*crouchModifier*frameRate*speedMult;
  }
  if (!(keys[4] || keys[5] || keys[6] || keys[7])) {
    playerSpeed = 0;
  }
}

//All of this code will be moved to a GameWorld object when that is finished
void buildWorld() {
  translate(width/2,0,0);
  fill(125);
  translate(yRotateX+yRX2,400,-yRotateZ-yRZ2);
  
  translate(customXCoord,yTranslate+yJump,customZCoord);
  
  //Floor
  beginShape();
  texture(gravel_diffuse);
  vertex(-10000000,-6,-10000000,0,0);
  vertex(-10000000,-6,10000000,0,20000);
  vertex(10000000,-6,10000000,20000,20000);
  vertex(10000000,-6,-10000000,20000,0);
  endShape();
  translate(0-yRotateX-yRX2,-400,0+yRotateZ+yRZ2);
  translate(0+yRotateX+yRX2,-2100,-2500-yRotateZ-yRZ2);
  box(5000,5000,10);
  beginShape();
  texture(sloth);
  vertex(-2500,-2500,6,0,0);
  vertex(-2500,2500,6,0,1);
  vertex(2500,2500,6,1,1);
  vertex(2500,-2500,6,1,0);
  endShape();
  translate(0-yRotateX-yRX2,2100,2500+yRotateZ+yRZ2);
  translate(0-yRotateX-yRX2,-6000,0+yRotateZ+yRZ2);
  fill(50,100,200);
  /*
  beginShape();
  vertex(-5000,0,0);
  vertex(-5000,0,-5000);
  vertex(5000,0,-5000);
  vertex(5000,0,5000);
  endShape(CLOSE);
  */
  translate(yRotateX+yRX2,6000,-yRotateZ-yRZ2);
  
  translate(yRotateX+yRX2,-105,5000-(2000+yRotateZ+yRZ2));
  brickWall();
  translate(-(yRotateX+yRX2),105,(-5000)+(2000+yRotateZ+yRZ2));
  translate(yRotateX+yRX2,-105,7500-(2000+yRotateZ+yRZ2));
  brickWall();
  translate(-(yRotateX+yRX2),105,(-7500)+(2000+yRotateZ+yRZ2));
  translate(yRotateX+yRX2,-105,6250-(2000+yRotateZ+yRZ2));
  frontDoor();
  translate(-(yRotateX+yRX2),105,(-6250)+(2000+yRotateZ+yRZ2));
  translate(yRotateX+yRX2,-5000,6250-(2000+yRotateZ+yRZ2));
  hotMemes();
  translate(-(yRotateX+yRX2),5000,(-6250)+(2000+yRotateZ+yRZ2));
  translate(1+yRotateX+yRX2,-1105,6250-(2000+yRotateZ+yRZ2));
  if (player107InWorld && horrorActivated) {
    player107();
  } else {
    saintBosco();
  }
  translate(1-(yRotateX+yRX2),1105,(-6250)+(2000+yRotateZ+yRZ2));
  translate(251+yRotateX+yRX2,-1105,6250-(2000+yRotateZ+yRZ2));
  if (player107InWorld && horrorActivated) {
    player107M();
  } else {
    saintBoscoM();
  }
  translate(-251-(yRotateX+yRX2),1105,(-6250)+(2000+yRotateZ+yRZ2));
  translate((-750)+(yRotateX+yRX2),250,7000-(2000+yRotateZ+yRZ2));
  crate();
  translate(750-(yRotateX+yRX2),-250,(-7000)+(2000+yRotateZ+yRZ2));
  translate(1000+yRotateX+yRX2,-105,3800-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-1000-(yRotateX+yRX2),105,(-3800)+(2000+yRotateZ+yRZ2));
  translate(2000+yRotateX+yRX2,-105,3800-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-2000-(yRotateX+yRX2),105,(-3800)+(2000+yRotateZ+yRZ2));
  translate(1000+yRotateX+yRX2,-105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-1000-(yRotateX+yRX2),105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(2000+yRotateX+yRX2,-105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-2000-(yRotateX+yRX2),105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(2200+yRotateX+yRX2,-105,5000-(2000+yRotateZ+yRZ2));
  brickWall();
  translate(-2200-(yRotateX+yRX2),105,(-5000)+(2000+yRotateZ+yRZ2));
  translate(2200+yRotateX+yRX2,-105,7500-(2000+yRotateZ+yRZ2));
  brickWall();
  translate(-2200-(yRotateX+yRX2),105,(-7500)+(2000+yRotateZ+yRZ2));
  translate(2700+yRotateX+yRX2,393,6250-(2000+yRotateZ+yRZ2));
  grassStrip();
  translate(-2700-(yRotateX+yRX2),-393,(-6250)+(2000+yRotateZ+yRZ2));
  translate(1200+yRotateX+yRX2,393,6250-(2000+yRotateZ+yRZ2));
  hardwoodFloor();
  translate(-1200-(yRotateX+yRX2),-393,(-6250)+(2000+yRotateZ+yRZ2));
  translate(2350+yRotateX+yRX2,-105,6250-(2000+yRotateZ+yRZ2));
  frontDoor();
  translate(-2350-(yRotateX+yRX2),105,(-6250)+(2000+yRotateZ+yRZ2));
  translate(2351+60+yRotateX+yRX2,-1105,6250-(2000+yRotateZ+yRZ2));
  if (player107InWorld && horrorActivated) {
    player107();
  } else {
    saintBosco();
  }
  translate(-2351-60-(yRotateX+yRX2),1105,(-6250)+(2000+yRotateZ+yRZ2));
  translate(2349-125+yRotateX+yRX2,-1105,6250-(2000+yRotateZ+yRZ2));
  if (player107InWorld && horrorActivated) {
    player107M();
  } else {
    saintBoscoM();
  }
  translate(-2349+125-(yRotateX+yRX2),1105,(-6250)+(2000+yRotateZ+yRZ2));
  
  //Floor 2
  translate(1000+yRotateX+yRX2,-1105,3800-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-1000-(yRotateX+yRX2),1105,(-3800)+(2000+yRotateZ+yRZ2));
  translate(2000+yRotateX+yRX2,-1105,3800-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-2000-(yRotateX+yRX2),1105,(-3800)+(2000+yRotateZ+yRZ2));
  translate(1000+yRotateX+yRX2,-1105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-1000-(yRotateX+yRX2),1105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(2000+yRotateX+yRX2,-1105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-2000-(yRotateX+yRX2),1105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(2200+yRotateX+yRX2,-1105,5000-(2000+yRotateZ+yRZ2));
  brickWall();
  translate(-2200-(yRotateX+yRX2),1105,(-5000)+(2000+yRotateZ+yRZ2));
  translate(2200+yRotateX+yRX2,-1105,7500-(2000+yRotateZ+yRZ2));
  brickWall();
  translate(-2200-(yRotateX+yRX2),1105,(-7500)+(2000+yRotateZ+yRZ2));
  translate(yRotateX+yRX2,-1105,5000-(2000+yRotateZ+yRZ2));
  brickWall();
  translate(-(yRotateX+yRX2),1105,(-5000)+(2000+yRotateZ+yRZ2));
  translate(yRotateX+yRX2,-1105,7500-(2000+yRotateZ+yRZ2));
  brickWall();
  translate(-(yRotateX+yRX2),1105,(-7500)+(2000+yRotateZ+yRZ2));
  
  //Outer Hallway
  translate(-1000+yRotateX+yRX2,-105,7500-(1000+yRotateZ+yRZ2));
  brickWall();
  translate(-1000-(yRotateX+yRX2),105,(-7500)+(1000+yRotateZ+yRZ2));
  translate(2000+yRotateX+yRX2,-105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-2000-(yRotateX+yRX2),105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(4000+yRotateX+yRX2,-105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-4000-(yRotateX+yRX2),105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(6000+yRotateX+yRX2,-105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-6000-(yRotateX+yRX2),105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(8000+yRotateX+yRX2,-105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-8000-(yRotateX+yRX2),105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(10000+yRotateX+yRX2,-105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-10000-(yRotateX+yRX2),105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(12000+yRotateX+yRX2,-105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-12000-(yRotateX+yRX2),105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(14000+yRotateX+yRX2,-105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-14000-(yRotateX+yRX2),105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(16000+yRotateX+yRX2,-105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-16000-(yRotateX+yRX2),105,(-8500)+(1000+yRotateZ+yRZ2));
  
  translate(6000+yRotateX+yRX2,-105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-6000-(yRotateX+yRX2),105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(8000+yRotateX+yRX2,-105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-8000-(yRotateX+yRX2),105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(10000+yRotateX+yRX2,-105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-10000-(yRotateX+yRX2),105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(12000+yRotateX+yRX2,-105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-12000-(yRotateX+yRX2),105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(14000+yRotateX+yRX2,-105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-14000-(yRotateX+yRX2),105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(16000+yRotateX+yRX2,-105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-16000-(yRotateX+yRX2),105,(-8500)+(2000+yRotateZ+yRZ2));
  
  //Outer Hallway Floor 2
  translate(2000,0,0);
  translate(-1000+yRotateX+yRX2,-1105,7500-(1000+yRotateZ+yRZ2));
  brickWall();
  translate(-1000-(yRotateX+yRX2),1105,(-7500)+(1000+yRotateZ+yRZ2));
  translate(2000+yRotateX+yRX2,-1105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-2000-(yRotateX+yRX2),1105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(4000+yRotateX+yRX2,-1105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-4000-(yRotateX+yRX2),1105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(6000+yRotateX+yRX2,-1105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-6000-(yRotateX+yRX2),1105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(8000+yRotateX+yRX2,-1105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-8000-(yRotateX+yRX2),1105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(10000+yRotateX+yRX2,-1105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-10000-(yRotateX+yRX2),1105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(12000+yRotateX+yRX2,-1105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-12000-(yRotateX+yRX2),1105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(14000+yRotateX+yRX2,-1105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-14000-(yRotateX+yRX2),1105,(-8500)+(1000+yRotateZ+yRZ2));
  translate(16000+yRotateX+yRX2,-1105,8500-(1000+yRotateZ+yRZ2));
  brickWall2();
  translate(-16000-(yRotateX+yRX2),1105,(-8500)+(1000+yRotateZ+yRZ2));
  
  translate(6000+yRotateX+yRX2,-1105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-6000-(yRotateX+yRX2),1105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(8000+yRotateX+yRX2,-1105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-8000-(yRotateX+yRX2),1105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(10000+yRotateX+yRX2,-1105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-10000-(yRotateX+yRX2),1105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(12000+yRotateX+yRX2,-1105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-12000-(yRotateX+yRX2),1105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(14000+yRotateX+yRX2,-1105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-14000-(yRotateX+yRX2),1105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(16000+yRotateX+yRX2,-1105,8500-(2000+yRotateZ+yRZ2));
  brickWall2();
  translate(-16000-(yRotateX+yRX2),1105,(-8500)+(2000+yRotateZ+yRZ2));
  translate(-2000,0,0);
  
  //Custom Model Placement
  translate((-2000)+(yRotateX+yRX2),450,10000-(2000+yRotateZ+yRZ2));
  shape(testRoundObject);
  translate(2000-(yRotateX+yRX2),-450,(-10000)+(2000+yRotateZ+yRZ2));
  translate((-7000)+(yRotateX+yRX2),1400,14000-(2000+yRotateZ+yRZ2));
  shape(testGenericHouse);
  translate(7000-(yRotateX+yRX2),-1400,(-14000)+(2000+yRotateZ+yRZ2));
  translate((-11000)+(yRotateX+yRX2),1400,14000-(2000+yRotateZ+yRZ2));
  shape(testColoredHouse);
  translate(11000-(yRotateX+yRX2),-1400,(-14000)+(2000+yRotateZ+yRZ2));
  
  translate((-100000)+(yRotateX+yRX2),-105,200000-(2000+yRotateZ+yRZ2));
  //custom pillar structures
  
  brickWall();
  
  
  translate((100000)-(yRotateX+yRX2),105,(-200000)+(2000+yRotateZ+yRZ2));
  
  translate(7000+yRotateX+yRX2,-105,200-(1000+yRotateZ+yRZ2));
  gordonR();
  translate(-7000-(yRotateX+yRX2),105,(-200)+(1000+yRotateZ+yRZ2));
  
  translate(-customXCoord,-yTranslate-yJump,-customZCoord);
}

//Menus and HUD
void draw2DStuff() {
  updateHudCircle();
  
  hudCircle.beginDraw();
  hudCircle.background(187);
  hudCircle.noFill();
  if (collisionDetected) {
    hudCircle.stroke(255,0,0);
    hudCircle.rect(0,0,100,100);
  }
  hudCircle.strokeWeight(1);
  hudCircle.stroke(0);
  hudCircle.ellipse(50,50,100,100);
  hudCircle.line(50,50,0,50);
  hudCircle.strokeWeight(3);
  hudCircle.stroke(255,100,100);
  hudCircle.translate(50,50);
  hudCircle.line(0,0,-hudCircleX,-hudCircleY);
  hudCircle.translate(-50,-50);
  hudCircle.endDraw();
  
  hud.beginDraw();
  hud.noStroke();
  hud.background(120,0);
  hud.fill(255);
  hud.textSize(map(50,0,1920,0,width));
  hud.textAlign(RIGHT,CENTER);
  hud.text(playerName,width-5,height-40);
  hud.fill(255);
  hud.textSize(map(10,0,1920,0,width));
  hud.textAlign(LEFT);
  hud.rect(width-125,0,25,100);
  hud.fill(255,0,0);
  hud.rect(width-125,map(mouseY,0,height,0,100),25,map(mouseY,0,height,100,0));
  hud.fill(255);
  hud.rect(0,0,175,300);
  hud.scale(0.2);
  hud.image(beet_the_god,0,(height*5)-(0.6*height));
  hud.scale(5);
  hud.fill(0);
  hud.text("FPS: "+customFrameRate,5,35);
  hud.strokeWeight(2);
  hud.stroke(0);
  /*
  hud.line(width/2,(height/2)-(height/100.8),width/2,(height/2)+(height/100.8));
  hud.line((width/2)-(height/100.8),height/2,(width/2)+(height/100.8),height/2);
  */
  hud.fill(255,0,255);
  hud.text("Teh Game by ",5,15);
  hud.fill(0,255,0);
  hud.textSize(map(14,0,1920,0,width));
  hud.text("Dezzy",75,15);
  hud.textSize(map(10,0,1920,0,width));
  hud.fill(0);
  hud.text("X: "+(int)(yRotateX+yRX2)+"   Z: "+(int)(yRotateZ+yRZ2),5,55);
  hud.text("XZ Angle: "+yRotate,5,75);
  hud.text("Z: "+(int)(yRotateZ+yRZ2+yDetectZ+yDZ)+" yDX: "+(int)(yDetectZ+yDZ),5,95);
  hud.text("Render: "+renderTypeText,5,115);
  hud.text("Render Multiplier: "+renderDistanceMultiplier,5,135);
  hud.text("Speed: "+(int)abs(playerSpeed)+" units per second",5,155);
  hud.text("Used Memory: "+(int)usedMemory+"MB/"+(int)totalMemory+"MB",5,175);
  hud.text("Version: "+version,5,195);
  hud.text("Mouse Sensitivity: "+mouseSensitivity,5,215);
  //hud.text("Angle: "+angle2,5,235);
  //hud.text("sRadX: "+sRadX,5,255);
  //hud.text("sRadZ: "+sRadZ,5,275);
  hud.text("Phi: "+xRotate,5,295);
  if (player107Joined) {
    hud.textSize(map(20,0,1920,0,width));
    hud.fill(255,255,0);
    hud.stroke(0);
    hud.strokeWeight(4);
    hud.text("player107 has connected",5,height-(height/7));
  }
  hud.image(hudCircle,width-100,0);
  hud.textSize(map(10,0,1920,0,width));
  hud.endDraw();  
  
  hudCrosshair.beginDraw();
  hudCrosshair.strokeWeight(2);
  hudCrosshair.stroke(0);
  hudCrosshair.line(width/2,(height/2)-(height/100.8),width/2,(height/2)+(height/100.8));
  hudCrosshair.line((width/2)-(height/100.8),height/2,(width/2)+(height/100.8),height/2);
  hudCrosshair.endDraw();
  
  //Makes the menu
  
  menu.beginDraw();
  menu.background(menuBG);
  menu.strokeWeight(1);
  menu.textAlign(CENTER,CENTER);
  menu.textSize(map(200,0,1920,0,width));
  menu.fill(0);
  menu.text("TEH GAME",width/2,2*height/10);
  menu.rectMode(CENTER);
  menu.fill(75);
  menu.strokeWeight(playButtonStrokeWeight);
  menu.rect(width/2,height/2,width/4,height/8);
  menu.strokeWeight(defaultButtonStrokeWeight);
  menu.rect((39*width)/40,(51*height)/52,(2*width)/40,(2*height)/52);
  menu.strokeWeight(settingsButtonStrokeWeight);
  menu.rect(width/2,(11*height)/16,width/4,height/8);
  menu.fill(0);
  menu.strokeWeight(1);
  menu.stroke(0);
  menu.textSize(map(150,0,1920,0,width));
  menu.text("PLAY",width/2,(height/2)-(height/64));
  menu.textSize(map(100,0,1920,0,width));
  menu.text("Settings",width/2,(11*height/16)-(height/64));
  menu.textSize(map(25,0,1920,0,width));
  menu.text("EXIT",((39*width)/40),(51*height)/52);
  menuCursorAction();
  menu.endDraw();
  
  menuCrosshair.beginDraw();
  menuCrosshair.strokeWeight(2);
  menuCrosshair.line(menuCrosshair.width/2,0,menuCrosshair.width/2,menuCrosshair.height);
  menuCrosshair.line(0,menuCrosshair.height/2,menuCrosshair.width,menuCrosshair.height/2);
  menuCrosshair.endDraw();
  
  menuSelectionCrosshair.beginDraw();
  menuSelectionCrosshair.noStroke();
  menuSelectionCrosshair.fill(#D1CBA9);
  menuSelectionCrosshair.ellipseMode(CENTER);
  menuSelectionCrosshair.ellipse(menuSelectionCrosshair.width/2,menuSelectionCrosshair.height/2,(menuSelectionCrosshair.width)-3,(menuSelectionCrosshair.height)-3);
  menuSelectionCrosshair.endDraw();
  
  updateSettingsSubMenu();
  
  settingsSubMenu.beginDraw();
  settingsSubMenu.rectMode(CENTER);
  settingsSubMenu.background(menuBG);
  settingsSubMenu.strokeWeight(1);
  settingsSubMenu.fill(75);
  settingsSubMenu.rect(width/2,height/numSettingsSubMenuButtons,width/4,height/10);
  settingsSubMenu.fill(0);
  settingsSubMenu.textSize(map(75,0,1920,0,width));
  settingsSubMenu.textAlign(CENTER,CENTER);
  settingsSubMenu.text("Render Type",width/2,(height/(numSettingsSubMenuButtons*2))-(height/64));
  settingsSubMenu.text(renderTypeOptionText,width/2,(height/(numSettingsSubMenuButtons))-(height/64));
  settingsSubMenu.endDraw();
  
  saveNumError.beginDraw();
  saveNumError.background(255);
  saveNumError.noFill();
  saveNumError.stroke(0);
  saveNumError.rect(0,0,400,150);
  saveNumError.textAlign(CENTER,CENTER);
  saveNumError.fill(255,0,0);
  saveNumError.textFont(lucidaConsole);
  saveNumError.text("ERROR",200,25);
  saveNumError.fill(0);
  saveNumError.text("Please fix saveNum",200,100);
  saveNumError.text("in config.txt.",200,125);
  saveNumError.endDraw();
  
  intro.beginDraw();
  intro.background(menuBG);
  intro.textAlign(CENTER,CENTER);
  intro.fill(0,255,0);
  intro.textSize(map(400,0,1920,0,width));
  intro.text("DEZZY",width/2,(height/2)-(height/64));
  intro.endDraw();
  
  //Draws the HUD as a P2D PGraphics object over the sketch by turning off Z depth testing, also draws the menu as a JAVA2D PGraphics object (better than P2D for text) if inMenu is true
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  hint(DISABLE_DEPTH_TEST);
  
  console.updateTextField();
  
  if (renderType == 0) {
    image(hud,0,0);
  }
  image(hudCrosshair,0,0);  
  
  if (inMenu) {
    image(menu,0,0);
  }
  
  if (inMenu && inSettingsSubMenu) {
    image(settingsSubMenu,0,0);
  }
  
  if (millis < 10000) {
    image(intro,0,0);
  } else {
    inIntro = false;
  }
  
  imageMode(CENTER);
  if (inMenu && !inIntro && !cursorOverPlay && !cursorOverSettings) {
    image(menuCrosshair,mouseX,mouseY);
  } else {
    if (inMenu && !inIntro ) {
      image(menuSelectionCrosshair,mouseX,mouseY);
    }
  }
  
  imageMode(CORNER);
  if (fixSaveNum && inMenu && !inIntro) {
    image(saveNumError,(width/2)-200,(height/2)-112);
  }
    
  hint(ENABLE_DEPTH_TEST);
}

//Updates the mouse position by adding a function of the difference from the center every frame to theta or phi, then uses Robot to put the mouse in the center
void updateMousePos() {
  float tempXPos = mouseX-(width/2);
  float tempYPos = mouseY-(height/2);
  yRotate += tempXPos/mouseSensitivity;
  mouseRobot.mouseMove(width/2,mouseY);
  xRotate = (map(mouseY,0,height,PI/2,-PI/2));
}

//Some variables

float horrorMillis;
boolean horrorActivated = false;
boolean player107Joined = false;
float soundMillis;
boolean collisionDetected = false;
float introMillis;
boolean introActivated = false;

double angle2;

float yTranslate = 0;

boolean crouching = false;

//No comment here
void handleHorror() {
  if (player107InWorld) {
    if (!horrorActivated) {
      background(redBG);
    }
    if (inMenu) {
      horrorMillis = millis();
    }
    if (millis >= horrorMillis+7000 && millis < horrorMillis+10000) {
      player107Joined = true;
    } else {
      player107Joined = false;
    }
    if (millis >= horrorMillis+10000) {
      horrorActivated = true;
      //player107Bell.rate(0.1); 
      //player107Bell.amp(1); 
      if (player107InWorld) {
        background(blackBG);
        if (!speechPlayed) {
          //player107Speech.play();
          //player107Bell.loop();
          speechPlayed = true;
        }
      }
    }
  } else {
      background(redBG);
  }
}

void draw() {
  if (!inMenu) {
    kygo.playSoundOnce();
    kygo.solveForStereo();
    
    //Change coordinates, sound moves
    kygo.setLocation(yRotateX+yRX2,-1105,-yRotateZ-yRZ2);
  }
  allX = yRotateX+yRX2+customXCoord+yDetectX+yDX;
  allY = customXCoord;
  allZ = yRotateZ+yRZ2+customZCoord+yDetectZ+yDZ;
  
  imageMode(CORNER);
  freeMemory = Runtime.getRuntime().freeMemory()/1000000;
  totalMemory = Runtime.getRuntime().totalMemory()/1000000;
  usedMemory = totalMemory-freeMemory;
  
  millis = millis();
  
  handleHorror();
  
  renderInitialization();
  renderTypeOptionCycler = renderType;
  renderTypeOptionText = renderTypeText;
  
  lights();
  //println(yRotate);
  //collisionDetection();
  
  //0 is W, 1 is S, 2 is AD
  
  //Keypress Action
  keyAction();
  
  if (!inMenu) {
    updateMousePos();
  }
  
  //Incredibly Important Code Here, allows for first person perspective
  translate((width/2),height/2,(width/2));
  
  //World moves around camera - having the player at the origin makes everything else easier
  //pushMatrix();
  
  noStroke();
  
  rotateX(xRotate); //phi
  rotateY(yRotate); //theta
  
  translate(0,height/2,0);
  
  //scale(scaler,scaler,scaler);
  
  //Placement
  buildWorld();
  
  if (crouching) {
    yTranslate += height/5;
  }
  //popMatrix();
  
  customFrameRate = (int)frameRate;
  
  if (collisionDetected) {
    playerSpeed = 0;
  }
  
  //Menus, HUD
  draw2DStuff();
  
  collisionDetected = false;
}

void postDraw() {
  if (!inMenu) {
    image(hud,0,0);
  }
}

void keyPressed() {
  if (key == CODED && !inMenu && !inConsole) {
    if (keyCode == LEFT) {
      keys[0] = true;
    }
    if (keyCode == RIGHT) {
      keys[1] = true;
    }
    if (keyCode == DOWN) {
      keys[2] = true;
    }
    if (keyCode == UP) {
      keys[3] = true;
    }
    if (keyCode == CONTROL) {
      keys[10] = true;
    }
  
    if (keyCode == SHIFT) {
      keys[11] = true;
      sprinting = true;
    }
    if (keyCode == BACKSPACE) {
      keys[12] = true;
    }
  }
  
  if (!inConsole && !inMenu) {
    if (key == backMoveKey) {
      keys[4] = true;
    }
    if (key == forwardMoveKey) {
      keys[5] = true;
    }
    if (key == rightMoveKey) {
      keys[6] = true;
    }
    if (key == leftMoveKey) {
      keys[7] = true;
    }
    if (key == 'q') {
      keys[8] = true;
    }
    if (key == 'e') {
      keys[9] = true;
    }
    if (flyOn && key == ' ') {
      keys[13] = true;
    }
  }
  if (keyCode == ESC) {
    configFile[5] = ("saveNum="+saveNum);
    saveStrings("/config/config.txt",configFile);
  }
}

void keyReleased() {
  if (key == CODED && !inMenu && !inConsole) {
    if (keyCode == LEFT) {
      keys[0] = false;
    }
    if (keyCode == RIGHT) {
      keys[1] = false;
    }
    if (keyCode == DOWN) {
      keys[2] = false;
    }
    if (keyCode == UP) {
      keys[3] = false;
    }
    if (keyCode == CONTROL) {
      keys[10] = false;
    }
  
    if (keyCode == SHIFT) {
      keys[11] = false;
      sprinting = false;
    }
    if (keyCode == BACKSPACE) {
      keys[12] = false;
    }
  }
  
  if (!inConsole && !inMenu) {
    if (key == backMoveKey) {
      keys[4] = false;
    }
    if (key == forwardMoveKey) {
      keys[5] = false;
    }
    if (key == rightMoveKey) {
      keys[6] = false;
    }
    if (key == leftMoveKey) {
      keys[7] = false;
    }
    if (key == 'q') {
      keys[8] = false;
    }
    if (key == 'e') {
      keys[9] = false;
    }
    if (flyOn && key == ' ') {
      keys[13] = false;
    }
  }
  
  if (key == saveKey) {
    save("/screenshots/screenshot-"+saveNum);
    saveNum++;
    if (!fastScreenshotsEnabled) {
      configFile[5] = ("saveNum="+saveNum);
      saveStrings("/config/config.txt",configFile);
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT && !inMenu) {
    println("X: "+(yRotateX+yRX2+yDetectX+yDX));
  }
  if (mouseButton == RIGHT && !inMenu) {
    println("Z: "+(yRotateZ+yRZ2+yDetectZ+yDZ));
  }
}

void mouseReleased() {
  //Some button action
  if (mouseButton == LEFT && inMenu && !inSettingsSubMenu && mouseX < (width/2) + (width/8) && mouseX > (width/2) - (width/8) && mouseY > (height/2) - (2*height/32) && mouseY < (height/2) + (2*height/32)) {
    inMenu = false;
  }
  
  if (mouseButton == LEFT && inMenu && !inSettingsSubMenu && mouseX < (width/2) + (width/8) && mouseX > (width/2) - (width/8) && mouseY > (11*height/16) - (2*height/32) && mouseY < (11*height/16) + (2*height/32)) {
    inSettingsSubMenu = true;
  }
  //menu.rect((39*width)/40,(51*height)/52,(2*width)/40,(2*height)/52);
  
  if (mouseButton == LEFT && inMenu && !inSettingsSubMenu && mouseX < ((39*width)/40) + (width/40) && mouseX > ((39*width)/40) - (width/40) && mouseY > ((51*height)/52) - (height/52) && mouseY < ((51*height)/52) + (height/52)) {
    exit();
  }
}