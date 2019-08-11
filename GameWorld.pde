//A work in progress - the plan here is to have loadable game worlds, some of which are constructed and others generated with fractal terrain generation using the diamond-square algorithm
//loadGameWorld() will either read data from a file, or generate a new world
//buildGameWorld() will use the data from loadGameWorld() to build the world and allow the player to interact with it
//exportGameWorld() will be used to save data for a generated world so it can be loaded later - or to have player saves

public abstract interface GameWorld {
  
 abstract void buildGameWorld();
 
 abstract void loadGameWorld();
 
 abstract void exportGameWorld(String filename, String[] worldCode);
}