//Sound Objects that can be placed in the world

public class SoundObject {
  float xCoor;
  float yCoor;
  float zCoor;
  double fadeDist;
  
  boolean onLeft;
  boolean fadeOn = true;
  
  SoundType soundType = SoundType.BACKGROUND;
  SoundTrigger soundTrigger;
  
  AudioPlayer soundPlayer;
  
  SoundObject(float x, float y, float z, String fileName) {
    xCoor = x;
    yCoor = y;
    zCoor = z;
    soundPlayer = minim.loadFile(fileName);
    soundType = SoundType.LOCATED;
    onLeft = true;
    fadeDist = 10000;
  }
  
  SoundObject(float x, float y, float z, String fileName, SoundTrigger trigger) {
    xCoor = x;
    yCoor = y;
    zCoor = z;
    soundPlayer = minim.loadFile(fileName);
    soundType = SoundType.LOCATED;
    soundTrigger = trigger;
    onLeft = true;
    fadeDist = 10000;
  }
  
  SoundObject(float x, float y, float z, String fileName, SoundTrigger trigger, SoundType type) {
    xCoor = x;
    yCoor = y;
    zCoor = z;
    soundPlayer = minim.loadFile(fileName);
    soundTrigger = trigger;
    soundType = type;
    onLeft = true;
    fadeDist = 10000;
  }
  
  SoundObject(SoundType type, SoundTrigger trigger) {
    soundType = type;
    soundTrigger = trigger;
    onLeft = true;
    fadeDist = 10000;
  }
  
  SoundObject() {
    onLeft = true;  
    fadeDist = 10000;
  }
  
  //Solves a triangle for an angle that controls the sound balance value. As of yet, this only works if you are looking in a certain range of values (left of the line from the sound to you). I plan to fix this by using polar coordinates to compare the sound source to where you are looking, and determine if the sound needs to be flipped.
  void solveForStereo() {
    float localDist = 5;
    float maxDiff = (2 * localDist);
    
    float leftX = GameMath.findX(yRotate-(PI/2),localDist);
    float leftZ = GameMath.findZ(yRotate-(PI/2),localDist);
    
    float rightX = GameMath.findX(yRotate+(PI/2),localDist);
    float rightZ = GameMath.findZ(yRotate+(PI/2),localDist);
    
    float leftDist = dist(leftX,leftZ,xCoor,zCoor);
    float rightDist = dist(rightX,rightZ,xCoor,zCoor);
    
    float stereoDiff = leftDist-rightDist;
    
    float trueDist = dist(0,yTranslate+yJump,0,xCoor,yCoor,zCoor);
    
    if (fadeOn) {
      float vol = map(trueDist,0,(float)fadeDist,1,-20);
      soundPlayer.setGain(vol);
    }
    
    soundPlayer.setPan(map(stereoDiff,-maxDiff,maxDiff,-1,1));
    println("stereoDdiff"+stereoDiff);
    println("leftDist"+leftDist);
    println("rightDist"+rightDist);
  
  }
  
  void solveForStereoOld() {    
    double normal = GameMath.distance(0,0,xCoor,zCoor); //c
    double lastDist = GameMath.distance(yRadX,yRadZ,xCoor,zCoor); //b
    
    double b = normal; //Distance from player to sound object
    double a = lastDist; //Distance from sound object to where player is looking
    double c = auxLineDist; //Distance from player to where player is looking
    
    //Law of cosines is used to solve an SSS triangle for the angle between c and b, in radians
    double d = ((b * b) + (c * c) - (a * a));
    double e = (2 * b * c);
    double angle = Math.acos((d/e));
    
    /*
    println("a: "+a);
    println("b: "+b);
    println("c: "+c);
    println("d: "+d);
    println("e: "+e);
    println("angle: "+angle);
    */
    
    angle2 = angle;
    /*
    stroke(0);
    line(0,height/3,0,xCoor,height/3,zCoor);
    line(0,height/3,0,sRadX,height/3,sRadZ);
    line(sRadX,height/3,sRadZ,xCoor,height/3,zCoor);
    */
    
    //wip
    double trueDist = GameMath.distance(0,yTranslate+yJump,0,xCoor,yCoor,zCoor);
    
    //Changes the volume based on 3d distance from sound (can be disabled)
    if (fadeOn) {
      double vol = GameMath.doubleMap(trueDist,0,fadeDist,1,-20);
      soundPlayer.setGain((float)vol);
    }
    
    if (GameMath.findTheta(xCoor,zCoor) <= GameMath.findTheta(yRadX,yRadZ)) {
      onLeft = true;
    } else {
      //onLeft = false;
    }
    
    //If the angle is not a number, you are standing in the sound location
    if (angle != Double.NaN) {
      if (onLeft) {
        if (angle >= 0 && angle <= PI/2) {
          soundPlayer.setPan((float)GameMath.doubleMap(angle,0,PI/2,0,-1));
        }
        if (angle >= PI/2 && angle <= PI) {
          soundPlayer.setPan((float)GameMath.doubleMap(angle,PI/2,PI,-1,0));
        }
      } else {
        /*
        if (angle >= 0 && angle <= PI/2) {
          soundPlayer.setPan((float)GameMath.doubleMap(angle,0,PI/2,1,0));
        }
        if (angle >= PI/2 && angle <= PI) {
          soundPlayer.setPan((float)GameMath.doubleMap(angle,PI/2,PI,0,1));
        }
        */
      }
    } else {
        //angle == Double.NaN
        soundPlayer.setPan(0);
    }
  }    
  
  void setFadeDistance(float fade) {
    fadeDist = fade;
  }
  
  void fadeOn() {
    fadeOn = true;
  }
  
  void fadeOff() {
    fadeOn = false;
  }
  
  void setX(float x) {
    xCoor = x;
    soundType = SoundType.LOCATED;
  }
  
  void setY(float y) {
    yCoor = y;
    soundType = SoundType.LOCATED;
  }
  
  void setZ(float z) {
    zCoor = z;
    soundType = SoundType.LOCATED;
  }
  
  void setTrigger(SoundTrigger trigger) {
    soundTrigger = trigger;
  }
  
  void setSoundType(SoundType type) {
    soundType = type;
  }
  
  void playSound() {
    soundPlayer.play();
  }
  
  void playSoundOnce() {
    if (!soundPlayer.isPlaying()) {
      soundPlayer.play();
    }
  }
  
  void pauseSound() {
    soundPlayer.pause();
  }
  
  void setLocation(float x, float y, float z) {
    xCoor = x;
    yCoor = y;
    zCoor = z;
    soundType = SoundType.LOCATED;
  }
  
  void setSoundPan(float panVal) {
    soundPlayer.setPan(panVal);
  }
  
  //Old, unfinished work from before a SoundObject class
  /*
  void autoPanOld() {
    //soundType should be "LOOP" for a looping sound or it should have the name of an existing boolean that corresponds to an activation condition
  
    //Makes sure that normVol does not fall outside of 0-1
    if (normVol > 1) {
      normVol = 1;
    }
    if (normVol < 0) {
      normVol = 0;
    }
    float soundDist = abs(dist(xCoor,yCoor,zCoor,0,0,0));
    float volModifier = norm(soundDist,0,10000);
    float soundAngle = atan2(xCoor,zCoor);
    float panAngle = 0;
    boolean soundPlayed = false;
  
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
    soundPlayer.setVolume(normVol*(1-volModifier));
    soundPlayer.setPan(panAngle);
  }
  
  void setFile(AudioPlayer player, String fileName) {
    player = minim.loadFile(fileName);
    soundPlayer = player;
  }
  
  */
}