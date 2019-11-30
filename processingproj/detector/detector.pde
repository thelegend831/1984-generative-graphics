import controlP5.*;
import java.awt.*;

boolean isHandMovementDetectorWindowCreated = false ; //checks if camera has been initiated
PShape graphic;
Graphic myGraphic; //graphic instance
Menu_bar mp; //menu bar instance
float xPos; // x position of Graphic
float yPos; // y position of Graphic
float shape_color_r;
float shape_color_b;
float shape_color_g;
boolean didUserChooseMovementDetectorType =false; //has the user chosen a thing to detect
boolean didUserStart = false; //has the user started the application yet
boolean want_shape; //does the user want to use a shape
static int SHAPE; //which shape does user want to use
String detect; //which body part does the user want to detect
boolean want_import_image; //does user want to import an image
String loadimg;
boolean want_custom_shape; //does user want to have a custom shape
int vertices;
ControlP5 controlP5;
void setup() {  
  //setting up the main app
  noStroke();
  myGraphic = new Graphic(50,530,255,255,255); //setting up graphics
  buildMenuBar(); //building the menu bar
  controlP5 = new ControlP5(this); //gui class
}

void settings() {
  size(1200,800); 
}

void buildMenuBar() {
  //building menu bar
  mp = new Menu_bar(this, "Media", 100, 100); //menu class
}
 
void draw() {  
  if(didUserChooseMovementDetectorType==false){
    textSize(25);
    text("Please press enter to start",20,50);
  }
  
  if ( didUserStart == true && didUserChooseMovementDetectorType == false) { 
    //initated the camera
    String[] args = {"TwoFrameTest"};
    HandMovementDetector sa = new HandMovementDetector();
    PApplet.runSketch(args, sa);
    didUserChooseMovementDetectorType=true;    
    controlP5.addSlider("slider_r").setPosition(20,100).setRange(0,255).setValue(100); //slider for red
    controlP5.addSlider("slider_g").setPosition(20,130).setRange(0,255).setValue(100);//slider for green
    controlP5.addSlider("slider_b").setPosition(20,160).setRange(0,255).setValue(100); //slider for blue
    
  }
  if(isHandMovementDetectorWindowCreated == false && didUserChooseMovementDetectorType ==true) {
    //initates the drawing pad
    background(0, 0, 0);
    textSize(32);
  }
   if (isHandMovementDetectorWindowCreated == true && didUserChooseMovementDetectorType == true) {
     //adds graphics to the drawing pad
  myGraphic.display(); 
  
      
  }
}

//KEYBOARD INPUT
void keyPressed() {
 //when uses presses a key
    didUserStart = true;
}

void controlEvent(ControlEvent theEvent) {
  /* events triggered by controllers are automatically forwarded to 
     the controlEvent method. by checking the name of a controller one can 
     distinguish which of the controllers has been changed.
  */ 
 
  /* check if the event is from a controller otherwise you'll get an error
     when clicking other interface elements like Radiobutton that don't support
     the controller() methods
  */
  
  if(theEvent.isController()) { //triggers events from slider
    
    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue());
    
    
    if(theEvent.getController().getName()=="slider_r") {
      shape_color_r = theEvent.getController().getValue();
    }
    
    if(theEvent.getController().getName()=="slider_g") {
      shape_color_g = theEvent.getController().getValue();
    }
    
    if(theEvent.getController().getName()=="slider_b") {
      shape_color_b = theEvent.getController().getValue();
    }
    
    
  }  
}


//GRAPHIC CLASS
class Graphic {
  float speed = 2;
  boolean moveLeft, moveRight, moveUp, moveDown = false;
 
  Graphic(float x_in, float y_in,float r_color_in, float g_color_in,float b_color_in) {
    //constructor for the graphic
    xPos = x_in;
    yPos = y_in; 
    shape_color_r = r_color_in;
    shape_color_g = g_color_in;
    shape_color_b = b_color_in;
  }
 
  void display() {
    noStroke();
    background(0);
    // uncomment these when ui is done
    //if (want_shape) //ecompasses both 2d and 3d shapes
    //{ 
    //graphic = createShape(SHAPE,80,80,80,80);
    //graphic.setFill(color(shape_color_r, shape_color_g,shape_color_b));
    //shape(graphic, 10, 10);
    //}
    //if(want_import_image)
    //{
    //  graphic = loadShape(loadimg);
    //  shape(graphic, 10, 10);
    //}
    //if(want_custom_shape)
    //{
    //  graphic = createShape();
    //  graphic.beginShape();
    //  graphic.noStroke();
    //  for (int i = 0; i < vertices;i++)
    //  {
    //    graphic.vertex(0,0); //adding vertices
    //  }
    //  graphic.endShape(CLOSE);
    //  shape(graphic, 10, 10);
    //}
    graphic = createShape(RECT,80,80,80,80);
    graphic.setFill(color(shape_color_r, shape_color_g,shape_color_b));
    shape(graphic, 10, 10);
  }
  
  
}
import gab.opencv.*;
import processing.video.*;

public class HandMovementDetector extends PApplet {

  Capture video;
  OpenCV opencv;

  public void settings() {
    size(640, 480);
  }

  void setup() {     
    video = new Capture(this, 640/2, 480/2); 
    opencv = new OpenCV(this, 640/2, 480/2);
    opencv.loadCascade(OpenCV.CASCADE_FULLBODY);//initally detecting face, will add more
    //opencv.loadCascade(detect); Lisa, when you are ready uncomment this. This holds the string for which body to part to detect
    video.start();
  }

  void draw() {
    isHandMovementDetectorWindowCreated = true;    
    surface.setLocation(0,50);
    scale(2);
    opencv.loadImage(video);
    image(video, 0, 0 );
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    Rectangle[] faces = opencv.detect(); //rectangle to detect faces
    for (int i = 0; i < faces.length; i++) {
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height); //laying rectangles on to faces
      xPos = faces[i].x; //changing x coordinates of ellipses
      yPos = faces[i].x; //changing y coordinates of ellipses
    }
  }
  void captureEvent(Capture c) {
    c.read();
  }
}

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JFrame;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;

//menubar
public class Menu_bar {
  JFrame frame;

  public Menu_bar(PApplet app, String name, int width, int height) {
    System.setProperty("apple.laf.useScreenMenuBar", "true");
    frame = (JFrame) ((processing.awt.PSurfaceAWT.SmoothCanvas)app.getSurface().getNative()).getFrame();
    frame.setTitle(name);

    // Creates a menubar for a JFrame
    JMenuBar menu_bar = new JMenuBar();
    // Add the menubar to the frame
    frame.setJMenuBar(menu_bar);
    // Define and add two drop down menu to the menubar
    JMenu import_menu = new JMenu("import");
    JMenu template_menu  = new JMenu("templates");
    JMenu detect_menu = new JMenu("detect");
    JMenu save_menu = new JMenu("save");
    JMenu exit_menu = new JMenu("Exit");
    

    menu_bar.add(import_menu);
    menu_bar.add(detect_menu);
    menu_bar.add(save_menu);
    menu_bar.add(template_menu);
    menu_bar.add(exit_menu);

    // Create and add simple menu item to one of the drop down menu
    JMenuItem new_file = new JMenuItem("Import file");
    JMenuItem new_folder = new JMenuItem("Import folder");
    
    JMenuItem save = new JMenuItem("Save");
    JMenuItem save_as = new JMenuItem("Save As");
    
    JMenuItem ellipse = new JMenuItem("ellipse");
    JMenuItem rectangle = new JMenuItem("rectange");
    
    JMenu move_one_object = new JMenu("move one object");
    JMenu move_background = new JMenu("move background");
    
    JMenuItem detect_face = new JMenuItem("face");
    JMenuItem detect_body = new JMenuItem("body");
    JMenuItem detect_hands = new JMenuItem("hands");

    import_menu.add(new_file);
    import_menu.add(new_folder);
    
    save_menu.add(save);
    save_menu.add(save_as);
    
    move_one_object.add(ellipse);
    move_one_object.add(rectangle);
    
    template_menu.add(move_one_object);
    template_menu.add(move_background);
    
    detect_menu.add(detect_face);
    detect_menu.add(detect_body);
    detect_menu.add(detect_hands);
   
   
    // Add a listener to the New menu item. actionPerformed() method will
    // invoked, if user triggred this menu item
    new_file.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent arg0) {
        System.out.println("You have clicked on the new action");
      }
    }
    );
    frame.setVisible(true);
  }
}
