//Polar and cartesian conversion functions, as well as some other functions for handling doubles (built-in versions only handle floats)

public static class GameMath {
  
  //Takes (x,y) and computes r from origin
  static double findR(double x, double y) {
    return Math.sqrt(((x * x) + (y * y)));
  }
  
  //Takes (x,y) and computes theta from origin
  static double findTheta(double x, double y) {
    //wip
    return atan2((float)y,(float)x);
  }
  
  //Polar to cartesian conversion
  static float findX(float theta, float r) {
    return (r * (cos(theta)));
  }
  
  static float findZ(float theta, float r) {
    return (r * (sin(theta)));
  }
  
  //Distance formula
  static double distance(double x1, double y1, double x2, double y2) {
    return Math.sqrt((((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1))));
  }
  
  //Maps a value from one range to another
  static double doubleMap(double val, double min, double max, double min1, double max1) {
    double firstRange = max - min;
    double secondRange = max1 - min1;
    double firstRatio = val/firstRange;
    
    return ((firstRatio*secondRange)+min1);
  }
  
  //Distance formula for 3D
  static double distance(double x1, double y1, double z1, double x2, double y2, double z2) {
    return Math.sqrt(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)) + ((z2 - z1) * (z2 - z1)));
  }
  
  static float distance(float x1, float y1, float z1, float x2, float y2, float z2) {
    return (float)Math.sqrt(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)) + ((z2 - z1) * (z2 - z1)));
  }
}