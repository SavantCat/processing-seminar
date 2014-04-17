PImage a,b,c,d;//image class
 
float[][] matrix = {{-1, 0, 1},
                    {-2, 0, 2},
                    {-1, 0, 1} };
 
 float[][] matrix2 = {{-1, -2, -1},
                      {-2,  0,  2},
                      {1,   2,  1} };
 
 int offest = 100;
 
void setup() {
  a = loadImage("lenna.png");
  b = a.get(0,0,a.width,a.height);//pixels 
  
  size(2*a.width,a.height);
  background(255);
  
  MovingAverageFilter(a,b,2);
  
  c = b.get(0,0,b.width,b.height);//pixels 
  
  sobel(b,c,2);
  
  d = c.get(0,0,c.width,c.height);//pixels 
  
  sobel2(c,d,2);
  
  image(a, 0, 0);
  image(d, a.width, 0);
}
 
void draw() {
 
}
 
int grey(color c){
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  return((int)(0.299*r + 0.587*g + 0.114*b));
}
 
int limit(int n){
  if(n > 255){
    return 255;
  }
  if(0 > n){
    return 0;
  }
  return (int)n;
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
         // sum += grey(F.get(x+i,y+j));
          //print(F.get(x+i,y+j));
          r += (  red(F.get(x+j,y+i)) * matrix[j+1][i+1]);
          g += (green(F.get(x+j,y+i)) * matrix[j+1][i+1]);
          b += ( blue(F.get(x+j,y+i)) * matrix[j+1][i+1]);
                    
          //r *= -1;
          //g *= -1;
          //b *= -1;
          
          //r = limit(r);
          //g = limit(g);
          //b = limit(b);
        }
      }
      //print("r="+r+"\n");
          r_ave = (r - r/9)+offest;
          g_ave = (g - g/9)+offest;
          b_ave = (b - b/9)+offest;
      println(r_ave);
      G.set(x,y,color(r_ave,g_ave,b_ave));
    }
  }
}

void sobel2(PImage F, PImage G, int m)
{
  for(int y=m; y<F.height-m; y++) {
    for(int x=m; x<F.width-m; x++) { 
      int r=0,g=0,b=0;
      int r_ave=0,g_ave=0,b_ave=0;
      int c=0;
      for(int i=-1; i<=1; i++){
        for(int j=-1; j<=1; j++){
         // sum += grey(F.get(x+i,y+j));
          //print(F.get(x+i,y+j));
          r += (  red(F.get(x+j,y+i)) * matrix2[j+1][i+1]);
          g += (green(F.get(x+j,y+i)) * matrix2[j+1][i+1]);
          b += ( blue(F.get(x+j,y+i)) * matrix2[j+1][i+1]);
                    
          //r *= -1;
          //g *= -1;
          //b *= -1;
          
          //r = limit(r);
          //g = limit(g);
          //b = limit(b);
        }
      }
      //print("r="+r+"\n");
          r_ave = r - r/9;
          g_ave = g - g/9;
          b_ave = b - b/9;
      
      G.set(x,y,color(r_ave,g_ave,b_ave));
    }
  }
}
