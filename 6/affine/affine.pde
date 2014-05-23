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
  
  float[] x = {
    points[0].x,points[1].x,points[2].x,points[3].x
  };
  float[] y = {
    points[0].y,points[1].y,points[2].y,points[3].y
  };
  float[] x_s = {
    set_pos[0][0],set_pos[1][0],set_pos[2][0],set_pos[3][0]
  };
  float[] y_s = {
    set_pos[0][1],set_pos[1][1],set_pos[2][1],set_pos[3][1]
  };
  float n = 4;
  
     float[][] a = {
                   {sum(x,x),sum(x,y),sum(x)},
                   {sum(x,y),sum(y,y),sum(y)},
                   {sum(x),sum(y),n}
                 };
                 
    
                 
  for(int i=0;i<3;i++){
    print("a:");
    for(int t=0;t<3;t++){
      print(a[t][i]+" ");
    }
    println();
  } 
                 
   float[] b = {
                    sum(x,x_s),
                    sum(y,x_s),
                    sum(x_s),
                    sum(x,y_s),
                    sum(y,y_s),
                    sum(y_s)
                 };
                 
println();
    for(int t=0;t<6;t++){
      println(b[t]+" ");
    }
  println();
 a = inverse_3(a);
 println();
  for(int i=0;i<3;i++){
    print("inverse:");
    for(int t=0;t<3;t++){
      print(a[t][i]+" ");
    }
    println();
  } 
  
  float[] r = new float[6];
  for(int i=0;i<3;i++){
    for(int t=0;t<3;t++){
      r[i] += a[t][i] * b[t];
    }
  }
  for(int i=3;i<6;i++){
    for(int t=0;t<3;t++){
      r[i] += a[t][i-3] * b[t+3];
    }
  }
  
  for(int i=0;i<r.length;i++){
    println(i+":"+r[i]);
  }
  
  float X,Y;
  for(int N=0;N<4;N++){
  
  X = (r[0]*x[N]+r[1]*y[N])+r[4];
  Y = (r[2]*x[N]+r[3]*y[N])+r[5];
  
  get_pos[0][N] = X;get_pos[1][N] = Y;
 
   
  }
   
  for(int yy=0;yy<4;yy++){
    println(get_pos[0][yy]+" "+get_pos[1][yy]);
    ellipse(get_pos[0][yy],get_pos[0][yy],10,10);
  }
}

float[][] inverse_3(float data[][]){
  float deta = 0;

  deta = data[0][0]*data[1][1]*data[2][2]+
          data[0][1]*data[1][2]*data[2][0]+
            data[0][2]*data[1][0]*data[2][1]-
              data[0][0]*data[1][2]*data[2][1]-
                data[0][2]*data[1][1]*data[2][0]-
                  data[0][1]*data[1][0]*data[2][2];
  
  println("A:"+((data[2][0]*data[1][2]) - (data[1][0]*data[2][2])/deta));
  println("21:"+((data[2][0]*data[1][2]) - (data[1][0]*data[2][2])/deta));
 float[][] tmp_001 = {
                       {(data[1][1]*data[2][2]) - (data[2][1]*data[1][2]),(data[2][0]*data[1][2]) - (data[1][0]*data[2][2]),(data[1][0]*data[2][1]) - (data[2][1]*data[1][1])},
                       {(data[2][1]*data[0][2]) - (data[0][1]*data[2][2]),(data[0][0]*data[2][2]) - (data[2][0]*data[0][2]),(data[2][0]*data[0][1]) - (data[0][0]*data[2][1])},   
                       {(data[0][1]*data[1][2]) - (data[1][1]*data[0][2]),(data[1][0]*data[0][2]) - (data[0][0]*data[1][2]),(data[0][0]*data[1][1]) - (data[1][0]*data[0][1])}
                     };
      
/*
float[][] tmp_001 = new float[3][3];
      tmp_001 = {
        {(data[1][1]*data[2][2]) - (data[2][1]*data[1][2]),(data[2][0]*data[1][2]) - (data[1][0]*data[2][2]),(data[1][0]*data[2][1]) - (data[2][1]*data[1][1])},
        {(data[2][1]*data[0][2]) - (data[0][1]*data[2][2]),(data[0][0]*data[2][2]) - (data[2][0]*data[0][2]),(data[2][0]*data[0][1]) - (data[0][0]*data[2][1])},   
        {(data[0][1]*data[1][2]) - (data[1][1]*data[0][2]),(data[1][0]*data[0][2]) - (data[0][0]*data[1][2]),(data[0][0]*data[1][1]) - (data[1][0]*data[0][1])}
      };
        */             
  
  println(tmp_001[0][2]);
  println(((data[0][1]*data[1][2]) - (data[1][1]*data[0][2])));
                     
  float[][] result = new float[3][3]; 
  
  for(int y=0;y<3;y++){
      for(int x=0;x<3;x++){
         result[x][y] = tmp_001[x][y] / deta ;
      }
  }
result[0][2] = (data[0][1]*data[1][2] - data[1][1]*data[0][2])/deta;
 println();
  for(int i=0;i<3;i++){
    print("inverse_in:");
    for(int t=0;t<3;t++){
      print(result[t][i]+":");
    }
    println();
  } 
  
 return result;
 }

float sum(float[] x){
  float tmp = 0;
  for(int i=0;i<x.length;i++){
    tmp += x[i];
  }
  return tmp;
}

float sum(float[] x1,float[] x2){
  float tmp = 0;
  for(int i=0;i<x1.length;i++){
    tmp += x1[i]*x2[i];
  }
  return tmp;
}





