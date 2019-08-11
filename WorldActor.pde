//When people get added to this game

public class WorldActor {
  
  String actorName;
  float actorHeight;
  float actorAge;
  Gender actorGender;
  Disposition actorDisposition;
  String modelFile;
  
  WorldActor() {

  }
  
  WorldActor(String name, float sizeHeight, float age, Gender gender) {
    actorName = name;
    actorHeight = sizeHeight;
    actorAge = age;
    actorGender = gender;
  }
  
  WorldActor(String filename) {
    modelFile = filename;
  }
  
  WorldActor(String name, float sizeHeight, float age, Gender gender, String filename) {
    actorName = name;
    actorHeight = sizeHeight;
    actorAge = age;
    actorGender = gender;
    modelFile = filename;
  }
  
  void defineBasicActorReferences(String name, float sizeHeight, float age, Gender gender) {
    actorName = name;
    actorHeight = sizeHeight;
    actorAge = age;
    actorGender = gender;
  }
  
  void loadModel(String filename) {
    modelFile = filename;
  }
  
  String getActorName() {
    return actorName;
  }
  
  float getActorHeight() {
    return actorHeight;
  }
  
  float getActorAge() {
    return actorAge;
  }
  
  Gender getActorGender() {
    return actorGender;
  }
  
  String getActorGenderToString() {
    return actorGender.toString();
  }
  
  Disposition getActorDisposition() {
    return actorDisposition;
  }
  
  int getActorDispositionLevel() {
    return actorDisposition.getLevel();
  }
  
  String getActorDispositionToString() {
    return actorDisposition.toString();
  }
  
  void setActorName(String name) {
    actorName = name;
  }
  
  void setActorHeight(float sizeHeight) {
    actorHeight = sizeHeight;
  }
  
  void setActorAge(float age) {
    actorAge = age;
  }
  
  void setActorGender(Gender gender) {
    actorGender = gender;
  }
  
  void setDisposition(Disposition disposition) {
    actorDisposition = disposition;
  }
}