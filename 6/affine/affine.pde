// videolib
import processing.video.*;
Capture cam;
 
PImage input;         //input
PImage output;        //output
 
//mouse
boolean dragged = false;
int selector = 0;
 
//control points
PVector[] points = new PVector[4];
float Start_points[3][3];

float test_pos[][] =  {
                          {300.0,70.0},
                          {470.0,240.0},
                          {320.0,410.0},
                          {140.0,240.0}
                        };


void setup() {
  size(1280, 480);
  cam = new Capture(this, 640, 480);
  cam.start();
 
  //initialize control point
  for(int i=0;i<4;i++) points[i] = new PVector(); 
  /*
  points[0].set(100, 100, 0);
  points[1].set(320, 100, 0);
  points[2].set(320, 240, 0);
  points[3].set(100, 240, 0);
  */
  points[0].set(300, 70, 0);
  points[1].set(470, 240, 0);
  points[2].set(320, 410, 0);
  points[3].set(140, 240, 0);
  
  Start_points = {
                   {points[0].x, points[0].y,0},
                   {points[1].x, points[1].y,0},
                   {points[2].x, points[2].y,0},
                   {points[3].x, points[3].y,0}
                 };
  
  println("=========================");
  for(int i=0;i<4;i++){
    println("POINT " + i + " = " + "(" + points[i].x + ", " + points[i].y + ")");
  }
  println("");
}
 
void draw() {
  //show capture image
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
 
  //show control point (line and carcle)
  ellipseMode(CENTER);
  noFill();
  strokeWeight(1);
  for(int i=0; i < 4; i++){
    stroke(255*(i%2),64*(i%4),0);
    ellipse(points[i].x,points[i].y,10,10);
    line(points[i%4].x,points[i%4].y,points[(i+1)%4].x,points[(i+1)%4].y);
  }
 
  // image(output,640,0);      // trasforme image 
}
 
// affine 
PImage AffineTransforms(){
 

 
  return output;
}
 
void mousePressed(){
  if(dragged == false){
    for(int i=0; i < 4; i++){
      if(points[i].x -10 < mouseX && points[i].x + 10>mouseX){
        if(points[i].y -10 < mouseY && points[i].y + 10>mouseY){
          dragged = true;
          selector = i;
          
        }
      }
    }
  }
}
void mouseDragged(){
  if(dragged){
    if(mouseX > 0 && mouseX < 640){
      points[selector].set(mouseX,points[selector].y, 0);
    }
    if(mouseY > 0 && mouseY < 480){
      points[selector].set(points[selector].x,mouseY, 0);
    }
  }
}
void mouseReleased(){
  dragged = false;
 
  println("=========================");
  for(int i=0;i<4;i++){
    println("POINT " + i + " = " + "(" + points[i].x + ", " + points[i].y + ")");
  }
  println("");
}

void change_affine(){
  
}

void show_affine(float data[][]){
  main
}

float inverse_3(float data[][]){
  float deta = 0;
  
  deta = data[0][0]*data[1][1]*data[2][2]+
          data[0][1]*data[1][2]*data[2][0]+
            data[0][2]*data[1][0]*data[2][1]-
              data[0][0]*data[1][2]*data[2][1]-
                data[0][2]*data[1][1]*data[2][0]-
                  data[0][1]*data[1][0]*data[2][2];
  
  float result[][] = {
                       {data[1][1]*data[2][2] - data[2][1]*data[1][2],data[0][2]*data[1][2] - data[1][0]*data[2][2],data[1][0]*data[2][1] - data[2][0]*data[1][1]},
                       {data[2][1]*data[0][2] - data[0][1]*data[2][2],data[0][0]*data[2][2] - data[2][0]*data[0][2],data[2][0]*data[0][1] - data[0][0]*data[2][1]},   
                       {data[0][1]*data[1][2] - data[1][1]*data[0][2],data[1][0]*data[0][2] - data[0][0]*data[1][2],data[0][0]*data[1][1] - data[1][0]*data[0][1]}
                     };
  
  for(int y=0;y<3;y++){
      for(int x=0;x<3;x++){
         result[x][y] = result[x][y] / deta;
      }
  }
  
  return result;
 }






