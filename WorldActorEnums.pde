//enums are actually useful here

public enum Gender {
  MALE,
  FEMALE;
  
  @Override
  public String toString() {
    switch (this) {
       case MALE:
         return "MALE";
       case FEMALE:
         return "FEMALE";
    }
    return "null";
  }
}

public enum Disposition {
  ANGRY(-2),
  MEAN(-1),
  INDIFFERENT(0),
  NICE(1),
  FRIENDLY(2);
  
  private int level;
  
  private Disposition(int level) {
    this.level = level;
  }
  
  int getLevel() {
    return level;
  }
  
  @Override
  public String toString() {
    switch (this) {
      case ANGRY:
        return "ANGRY";
      case MEAN:
        return "MEAN";
      case INDIFFERENT:
        return "INDIFFERENT";
      case NICE:
        return "NICE";
      case FRIENDLY:
        return "FRIENDLY";
    }
   return "null";
  }
}