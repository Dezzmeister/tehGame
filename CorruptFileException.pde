//WIP, this exception will be thrown if the first line of the config is not "Dezzy", or the config is messed up

public class CorruptFileException extends Exception {
  public CorruptFileException(String message) {
    super(message);
  }
}