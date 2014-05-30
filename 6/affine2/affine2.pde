// videolib
import processing.video.*;
Capture cam;

PImage input; //input
PImage output; //output

//mouse
boolean dragged = false;
int selector = 0;

//control points
PVector[] points = new PVector[4];
//double Start_points[3][3];

double start_pos[][]; 
double set_pos[][];
double get_pos[][];

double[] con = new double[6];//a b c d e f

void setup() {
size(1280, 480);
cam = new Capture(this, 640, 480);
cam.start();
input = new PImage(640,480);

output = new PImage(640,480);


//initialize control point
for(int i=0;i<4;i++) points[i] = new PVector(); 

points[0].set(100, 100, 0);
points[1].set(320, 100, 0);
points[2].set(320, 240, 0);
points[3].set(100, 240, 0);

start_pos = new double[2][4];
for(int i=0;i<points.length;i++){
start_pos[0][i]=points[i].x;
start_pos[1][i]=points[i].y;
}



points[0].set(100, 100, 0);
points[1].set(320, 100, 0);
points[2].set(320, 240, 0);
points[3].set(100, 240, 0);

set_pos = new double[][]{
{0,0},
{639,0},
{639,479},
{0,479}
};

get_pos = new double[2][4];

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
// println(get_pos[0][y]+" "+get_pos[1][y]);

ellipse((float)get_pos[0][y],(float)get_pos[1][y],10,10);
}

input.copy(cam,0,0,cam.width,cam.height,0,0,cam.width,cam.height);

//image(input,640,0,width,480); // trasforme image 

change_affine();

image(output, width/2, 0);


}

// affine 
PImage AffineTransforms(){
PImage tmp = new PImage(640,480);
PVector[] p = points;
PVector affin_pos;

for(int y=0;y<tmp.height;y++){
for(int x=0;x<tmp.width;x++){
pos_change(x,y);
tmp.set(x,y,color(0));
}
}

for(int y=0;y<cam.height;y++){
for(int x=0;x<cam.width;x++){

//if((point[0].x == x && point[0].y == y)||(point[1].x == x && point[1].y == y)||(point[2].x == x && point[2].y == y)||(point[3].x == x && point[3].y == y)){
// if(prop(point[0],point[1],x,y)){

affin_pos = pos_change(x,y);
if(0<=affin_pos.x && affin_pos.x <= (width/2) && 0<=affin_pos.y && affin_pos.y <= height){
tmp.set((int)affin_pos.x,(int)affin_pos.y,input.get(x,y));
}
}
}

input = tmp;


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

println("R========================");
for(int i=0;i<4;i++){
println("POINT " + i + " = " + "(" + points[i].x + ", " + points[i].y + ")");
}
println("");


}



void change_affine(){
PVector tmp_v;

  double[] x = {

    points[0].x,points[1].x,points[2].x,points[3].x

  };

  double[] y = {

    points[0].y,points[1].y,points[2].y,points[3].y

  };

  double[] x_s = {

set_pos[0][0],set_pos[1][0],set_pos[2][0],set_pos[3][0]

};

  double[] y_s = { 

set_pos[0][1],set_pos[1][1],set_pos[2][1],set_pos[3][1]

};

for(int i=0;i<con.length;i++){
  con[i] = 0;
}

  double n = 4;

   double[][] a = {

                 {sum(x,x),sum(x,y),sum(x)},

                 {sum(x,y),sum(y,y),sum(y)},

                 {sum(x),sum(y),n}

               };

  for(int i=0;i<3;i++){

    print("a:");

    for(int t=0;t<3;t++){

      print(a[t][i]+"\t");

    }

    println();

  } 

                 

   double[] b = {

                    sum(x,x_s),

                    sum(y,x_s),

                    sum(x_s),

                    sum(x,y_s),

                    sum(y,y_s),

                    sum(y_s)

                 };

                 

    println();

    for(int t=0;t<6;t++){

      println(t+":"+b[t]);

    }

   a = inverse_3(a);

  for(int i=0;i<3;i++){

    for(int t=0;t<3;t++){

      con[i] += a[t][i] * b[t];

    }

  }

  for(int i=3;i<6;i++){

    for(int t=0;t<3;t++){

      con[i] += a[t][i-3] * b[t+3];

    }

  }

  for(int i=0;i<con.length;i++){

    println(i+":"+con[i]);

  }



  println("");

//all affine
for(int i=0;i<input.width ;i++){
for(int j=0;j<input.height ;j++){

tmp_v = pos_change(j,i);

if((0<=tmp_v.x && tmp_v.x<640) && (0<=tmp_v.y && tmp_v.y<480)){
println(tmp_v);
output.set((int)tmp_v.x,(int)tmp_v.y,input.get(i,j));
}
}
}

}

double[][] inverse_3(double data[][]){
double deta = 0;

deta = data[0][0]*data[1][1]*data[2][2]+
data[0][1]*data[1][2]*data[2][0]+
data[0][2]*data[1][0]*data[2][1]-
data[0][0]*data[1][2]*data[2][1]-
data[0][2]*data[1][1]*data[2][0]-
data[0][1]*data[1][0]*data[2][2];
double[][] tmp_001 = {
{(data[1][1]*data[2][2] - data[2][1]*data[1][2]),(data[2][0]*data[1][2]) - (data[1][0]*data[2][2]),(data[1][0]*data[2][1]) - (data[2][1]*data[1][1])},
{(data[2][1]*data[0][2] - data[0][1]*data[2][2]),(data[0][0]*data[2][2]) - (data[2][0]*data[0][2]),(data[2][0]*data[0][1]) - (data[0][0]*data[2][1])}, 
{(data[0][1]*data[1][2] - data[1][1]*data[0][2]),(data[1][0]*data[0][2]) - (data[0][0]*data[1][2]),(data[0][0]*data[1][1]) - (data[1][0]*data[0][1])}
};
//println((data[0][1]*data[1][2] - data[1][1]*data[0][2])/deta);
double[][] result = new double[3][3]; 

for(int y=0;y<3;y++){
for(int x=0;x<3;x++){
result[x][y] = tmp_001[x][y] / deta ;
}
}

println();
for(int i=0;i<3;i++){
print("inverse:");
for(int t=0;t<3;t++){
print(result[t][i]+"\t");
}
println();
} 
println();
return result;
}

double sum(double[] x){
double tmp = 0;
for(int i=0;i<x.length;i++){
tmp += x[i];
}
return tmp;
}

double sum(double[] x1,double[] x2){
double tmp = 0;
for(int i=0;i<x1.length;i++){
tmp += x1[i]*x2[i];
}
return tmp;
}

boolean prop(PVector p1,PVector p2,double x,double y){
double a,b;

a = (p2.y - p1.y)/(p2.x - p1.x);
b = a*p1.x - p1.y;

if(y == a*x+b){
return true;
}else{
return false;
}

}

PVector pos_change(int p_x,int p_y){
PVector tmp;
double x,y;

x = con[0]*p_x+con[1]*p_y+con[4];
y = con[2]*p_x+con[3]*p_y+con[5];

tmp = new PVector((float)x,(float)y,0);
println(tmp);
return tmp;

}

 

 
