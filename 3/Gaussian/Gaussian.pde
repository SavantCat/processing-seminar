PImage a,b,c;//image class
 
float[][] matrix = {{-1, 0, 1},
                    {-2, 0, 2},
                    {-1, 0, 1} };
 
int offest = 20;
 
void setup() {
  a = loadImage("../../img/lenna.png");
  b = a.get(0,0,a.width,a.height);
  
  size(2*a.width,a.height);
  background(255);
  
  MovingAverageFilter(a,b,1);
  
  c = b.get(0,0,b.width,b.height);//pixels 
  
  sobel(b,c,1);
  
  image(a, 0, 0);
  image(c, b.width, 0);
}
 
void draw() {
 
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
