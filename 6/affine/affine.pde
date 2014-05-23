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
//float Start_points[3][3];

float test_pos[][] =  {
                          {300.0,70.0},
                          {470.0,240.0},
                          {320.0,410.0},
                          {140.0,240.0}
                        };
float set_pos[][];
float get_pos[][];

void setup() {
  size(1280, 480);
  cam = new Capture(this, 640, 480);
  cam.start();
 
  //initialize control point
  for(int i=0;i<4;i++) points[i] = new PVector(); 
  
  points[0].set(100, 100, 0);
  points[1].set(320, 100, 0);
  points[2].set(320, 240, 0);
  points[3].set(100, 240, 0);
  /*
  points[0].set(300, 70, 0);
  points[1].set(470, 240, 0);
  points[2].set(320, 410, 0);
  points[3].set(140, 240, 0);
  */
  set_pos = new float[][]{
    {0,0},
    {639,0},
    {639,479},
    {0,479}
  };
  
  get_pos = new float[2][4];

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
  fill(255);
  for(int y=0;y<2;y++){
 //   println(get_pos[0][y]+" "+get_pos[1][y]);

    ellipse(get_pos[0][y],get_pos[1][y],10,10);
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
  change_affine(set_pos);
}


void change_affine(float s_data[][]){
  
  for(int N=0;N<4;){
  
   float x = points[N].x;
   float x_s = set_pos[N][0];
   float y = points[N].y;
   float y_s = set_pos[N][1];
   float n = 4;
   
   float[] r = new float[6];
   
   float[][] a = {
                   {sum(x,2.0),sum(x*y),sum(x)},
                   {sum(x*y),sum(y,2.0),sum(y)},
                   {sum(x),sum(y),n}
                 };
   float[] b = {
                    sum(x*x_s),
                    sum(y*x_s),
                    sum(y),
                    sum(x*y_s),
                    sum(y*y_s),
                    sum(y_s)
                 };
                 
   inverse_3(a);
 
      for(int i=0;i<3;i++){
  for(int t=0;t<3;t++){
    print(a[t][i]+" ");
  }
  println();
} 
       
for(int i=0;i<3;i++){
  for(int t=0;t<3;t++){
     r[i] += b[i] * a[t][i];
     println(r[i]);
  }
}
       
for(int i=0;i<3;i++){
  for(int t=0;t<3;t++){
     r[i+3] += b[i+3] * a[t][i];
  }
}
/*
for(int k=0;k<2;k++){       
   for(int t=0;t<3;t++){
     for(int j=0;j<3;j++){
      r[i] += b[0][i] * a[j][t];
      println(i+" "+j+" "+t+ " "+k);
     }
     println(i);
     i++;
   }
}
  */
  
  float X,Y;
  
  X = r[0]*x+r[1]*y+r[3];
  Y = r[4]*x+r[5]*y+r[5];
  
  get_pos[0][N] = X;
  get_pos[1][N++] = Y;
   
   
  }
   
  for(int y=0;y<4;y++){
    println(get_pos[0][y]+" "+get_pos[1][y]);
    ellipse(get_pos[0][y],get_pos[0][y],10,10);
  }
}

void inverse_3(float data[][]){
  float deta = 0;
  
  deta = data[0][0]*data[1][1]*data[2][2]+
          data[0][1]*data[2][1]*data[0][2]+
            data[0][2]*data[0][1]*data[1][2]-
              data[0][0]*data[2][1]*data[1][2]-
                data[0][1]*data[0][1]*data[2][2]-
                  data[2][0]*data[1][1]*data[0][2];
  
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

  data = result;
 }

float sum(float x){
  return x*(x+1)/2;
}

float sum(float x1,float n){
  if(n == 2){
    return x1*(n+1)*(2*n+1)/6;
  }else{
    println("Error: "+n);
    return -1;
  }
}





