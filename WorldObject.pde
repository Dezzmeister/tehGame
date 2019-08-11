public class WorldObject {
  String filename;
  float scaleFactor;
  float mass;
  
  WorldObject(String file, float scale, float kilograms) {
    filename = file;
    scaleFactor = scale;
    mass = kilograms;
  }
  
  WorldObject(String file) {
    filename = file;
    scaleFactor = 1;
  }
  
  WorldObject(String file, float scale) {
    filename = file;
    scaleFactor = scale;
  }
  
  void placeInWorld(float xCoord, float yCoord, float zCoord) {
    
  }
}