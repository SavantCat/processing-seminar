PImage a;//image class
PImage[] b = new PImage[5];
PImage[] d = new PImage[4];
PImage[] r = new PImage[5];
  //float[][] tmp;

  // Gaussian matrix
  float[][] myMatrix;
  int       large=9;
  float     sigma=2.0;
  
void setup() {
  // Load image
  a = loadImage("../../../img/lena.png");
  
  // Set canvas
  size(2*a.width,2*a.height);
  
  // Initialize PImage

 

 
  // Print gaussian matrix
  //ShowMatrix(myMatrix, large);
 
  // Smooth an image
  
  
  for(int i=0;i<5;i++) b[i] = a.get(0,0,a.width,a.height);
  for(int i=0;i<4;i++) d[i] = a.get(0,0,a.width,a.height);
  for(int i=0;i<5;i++) r[i] = a.get(0,0,a.width,a.height);
  
  myMatrix = new float[large][large];
  
  
  for(int i = 0;i<5;i++){
    myMatrix = CreateGaussianMatrix(myMatrix, large, sigma*pow(sqrt(2),i));
    //println(myMatrix[i][10] + " " +sigma*pow(sqrt(2),i));
    SmoothWithGaussian(a, b[i], large, myMatrix);
  }
  
  
  for(int i=0;i<4;i++){
     DoG(d[i],b[i],b[i+1]);
  }
 
  for(int n=0;n<5;n++) {
      r[n] = b[0].get(0,0,b[0].width,b[0].height);
      for(int i=0; i<b[0].height; i++){
      for(int j=0; j<b[0].width; j++){
        r[n].set(j,i,color(0));
      }
    }
  }
    //smooth();
  noFill();
  strokeWeight(1);
  stroke(255);
  //check_DoG(r[0],d);
  image(a, 0, 0);
 
  image(d[1], a.width, 0);
 // make_circle(r[0],0, 0);
  image(d[0], 0, a.height);
   //
  check_DoG(r[0],d);
 // make_circle(r[0],a.width, a.height);
  image(r[0], a.width, a.height);
}
 
void draw() {
}

void ShowMatrix(float[][] Gauss, int m)
{
  String matrixValue ="";
  for(int i=0; i<m; i++){
    for(int j=0; j<m; j++){
      matrixValue = matrixValue + Gauss[i][j] + " ";
    }
    println(matrixValue);
    matrixValue = "";
  }
}
 
int grey(color c){
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  return((int)(0.299*r + 0.587*g + 0.114*b));
}
 
float[][] CreateGaussianMatrix(float[][] myMatrix, int m, float sigma)
{
  for(int y=0; y<m; y++){
    for(int x=0; x<m; x++){
      int  center = floor(m/2.0);
      float G;
      G = (1.0/(2*PI*pow(sigma,2)) ) * exp(-1 * ( (pow(x-center,2) + pow(y-center,2) ) / (2*pow(sigma,2)) ) );
      myMatrix[y][x] = G;
    }
  }
  return myMatrix;
}
 
float GetWeight(float[][] GaussMatrix, int m)
{
  float weight=0.0;
 
  for(int y=0; y<m; y++){
    for(int x=0; x<m; x++){
      weight += GaussMatrix[y][x];
    }
  }
 
  return weight;
}
 
void SmoothWithGaussian(PImage in, PImage out, int m, float[][] Gauss)
{
  float weight=0.0;
 
  // Calculate gaussian weight
  weight = GetWeight(Gauss, m);//??
 
  for(int y=m; y<in.height-m; y++) {
    for(int x=m; x<in.width-m; x++) {
      float sum=0;
      int  center = floor(m/2.0);
      for(int i=0; i<m; i++){
        for(int j=0; j<m; j++){
          sum += grey(in.get(x+i-center,y+j-center)) * Gauss[i][j];
        }
      }
      // Normalize gaussian
      sum = sum/weight;
 
      // Set output value
      int c = round(sum);
      out.set(x,y,color(c,c,c));
    }
  }
 
  for(int x=0;x<in.width;x++){
    for(int y=0;y<m;y++) out.set(x,y,color(0,0,0));
    for(int y=in.height-m;y<in.height;y++) out.set(x,y,color(0,0,0));
  }
  for(int y=0;y<in.height;y++){
    for(int x=0;x<m;x++) out.set(x,y,color(0,0,0));
    for(int x=in.width-m;x<in.width;x++) out.set(x,y,color(0,0,0));
  }
}

/*------------------------------------------------------------------*/

int max;

void check_DoG(PImage r,PImage[] b){
  int m = 1;
  PImage[] s = new PImage[4];
  
  for(int i=0;i<4;i++) s[i] = r.get(0,0,r.width,r.height);  
    
  color tmp;
  int max = 0;
    for(int y=0; y<b[0].height; y++) {
      for(int x=0; x<b[0].width; x++) {
        tmp = b[0].get(x,y);
        max = 0;
        for(int i=1;i<4;i++){
          if(tmp < b[i].get(x,y)){
             tmp = b[i].get(x,y);
             max = i;
          }
        }
        s[max].set(x,y,tmp);
      }
    }
    
    //image(s[0], a.width, a.height);

    for(int Num=0;Num<2;Num++){
      for(int y=m; y<a.height-m; y++) {
        for(int x=m; x<a.width-m; x++) {
          int f = 0;
          color p = s[Num+1].get(x,y);
          for(int i=-1; i<2  && f==0; i++){
            for(int j=-1; j<2 && f==0; j++){
              for(int n=0; n<3 && f==0; n++){
               if(p >= b[n+Num].get(x+j,y+i)){
                  f = 1;
               }
              }
            }
          }
          if(f == 0){    
             if(Num == 0){
               r.set(x,y,color(255,0,0));
               ellipse(x,y,5,5);
               point(x,y);
             }else{
               r.set(x,y,color(0,255,0));
               ellipse(x,y,20,20);
               point(x,y);
             }
          }
          
        }
      }
    }
    
}

void make_circle(PImage r,int x_offset,int y_offset){
  smooth();
  noFill();
  //stroke(255);
  for(int y=0; y<r.height; y++) {
    for(int x=0; x<r.width; x++) {
      if(red(r.get(x,y)) == 255){
        ellipse(x+x_offset,y+y_offset,0.1,0.1);
        point(x+x_offset,y+y_offset);
      }else{
        ellipse(x+x_offset,y+y_offset,0.5,0.5);
        point(x+x_offset,y+y_offset);
      }
    }
  }
}

void DoG(PImage r,PImage a,PImage b){
  color tmp;
    for(int y=0;y<a.height;y++){
      for(int x=0;x<a.width;x++){
        tmp = a.get(x,y) - b.get(x,y);
       // println(red(tmp) + " " + blue(tmp) + " " + green(tmp));
        r.set(x,y,tmp);
      }
  }
}
