PImage a,b,c;//image class
 
float[][] matrix = {{-1, 0, 1},
                    {-2, 0, 2},
                    {-1, 0, 1} };
 
float[][] myMatrix;
int       large=7;
float     sigma = 1.0; 
 
int offest = 20;
 
int max,min,tmp; 
 
void setup() {
  a = loadImage("../../img/lenna.png");
  b = a.get(0,0,a.width,a.height);
  
  size(3*a.width,a.height);
  background(255);
  
  MovingAverageFilter(a,b,1);
  
  c = a.get(0,0,a.width,a.height);//pixels 
  gaussian_filter(a,c,1);
   
  image(a, 0, 0);
  image(b, a.width, 0);
  image(c, a.width + b.width, 0);
}
 
void draw() {

  if(sigma > 10){
    sigma = 1.0;
  }else{
    sigma += 0.1;
  }
 
 c = a.get(0,0,a.width,a.height);//pixels 
 gaussian_filter(b,c,1);
 image(c, a.width + b.width, 0);
// test(sigma,10,10);
}
 
int grey(color c){
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  return((int)(0.299*r + 0.587*g + 0.114*b));
}
 
void MovingAverageFilter(PImage F, PImage G, int m)
{
  for(int y=m; y<F.height-m; y++) {
    for(int x=m; x<F.width-m; x++) { 
      int sum=0;
      int cc=0;
      for(int i=-m; i<m+1; i++){
        for(int j=-m; j<m+1; j++){
          sum += grey(F.get(x+i,y+j));
          cc++;
        }
      }
      int c = sum/cc;
      G.set(x,y,color(c,c,c));
    }
  }
}


void sobel(PImage F, PImage G, int m)
{
  for(int y=m; y<F.height-m; y++) {
    for(int x=m; x<F.width-m; x++) { 
      int r=0,g=0,b=0;
      int r_ave=0,g_ave=0,b_ave=0;
      int c=0;
      for(int i=-1; i<=1; i++){
        for(int j=-1; j<=1; j++){
          r += (  red(F.get(x+j,y+i)) * matrix[j+1][i+1]);
          g += (green(F.get(x+j,y+i)) * matrix[j+1][i+1]);
          b += ( blue(F.get(x+j,y+i)) * matrix[j+1][i+1]);
        }
      }
      r_ave = (r - r/9)+offest;
      g_ave = (g - g/9)+offest;
      b_ave = (b - b/9)+offest;
      G.set(x,y,color(r_ave,g_ave,b_ave));
    }
  }
}

void gaussian_filter(PImage F, PImage G, int m)
{
  make_gaussian();
  for(int y=m; y<F.height-m; y++) {
    for(int x=m; x<F.width-m; x++) { 
      int r=0,g=0,b=0;
      int r_ave=0,g_ave=0,b_ave=0;
      int c=0;
      for(int i=-2; i<=2; i++){
        for(int j=-2; j<=2; j++){
          r += (  red(F.get(x+j,y+i)) * myMatrix[j+2][i+2]);
          g += (green(F.get(x+j,y+i)) * myMatrix[j+2][i+2]);
          b += ( blue(F.get(x+j,y+i)) * myMatrix[j+2][i+2]);
        }
      }
     // r_ave = (r - r/9)+offest;
     // g_ave = (g - g/9)+offest;
     // b_ave = (b - b/9)+offest;
      G.set(x,y,color(r,g,b));
    }
  }
}

void make_gaussian(){
  myMatrix = new float[large][large];
  for(int y=0; y<large; y++){
    for(int x=0; x<large; x++){
      int  center = floor(large/2.0);
      float G;
      G = 1.0/(2*PI*pow(sigma,2)) * exp(-1 * ( (pow(x-center,2) + pow(y-center,2) ) / (2*pow(sigma,2)) ) );
      myMatrix[y][x] = G;
    }
  }
  for(int y=0; y<large; y++){
      println("[" + myMatrix[y][0] + "] [" + myMatrix[y][1] + "] [" +myMatrix[y][2] + "] [" + myMatrix[y][3] + "] [" + myMatrix[y][4] + "]");
  }
}

void node(int n){
  tmp = n;
  
  if(max < tmp){
    max = tmp;
  }
  if(min > tmp){
    min = tmp;
  }  
}
