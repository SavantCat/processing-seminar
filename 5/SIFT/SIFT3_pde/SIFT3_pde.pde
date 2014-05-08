PImage origin;
PImage[] b = new PImage[5];
PImage[] d = new PImage[4];
PImage r;

float[][] myMatrix;
int       large=9;
float     sigma=2.0;
 
int x_size,y_size;

String name = "hand.jpg";

/*----------------------------------------------------------------*/

void setup() {
  // Load image
  origin = loadImage("../../../img/"+name);
  x_size = origin.width;
  y_size = origin.height;
  
  // Set canvas
  //size(2*x_size,2*y_size);
  size(x_size,y_size);
  noFill();
  strokeWeight(1);
  
  // Initialize PImage
  for(int i=0;i<b.length;i++) b[i] = origin.get(0,0,x_size,y_size);
  for(int i=0;i<d.length;i++) d[i] = origin.get(0,0,x_size,y_size);
  r = origin.get(0,0,x_size,y_size);

  format(d,color(0));
  format(r,color(0));
  
  // Initialize Matrix
  myMatrix = new float[large][large];
 
  // Make Gaussian
  for(int i = 0;i<b.length;i++){
    myMatrix = CreateGaussianMatrix(myMatrix, large, sigma*pow(sqrt(2),i));
    SmoothWithGaussian(origin, b[i], large, myMatrix);
  }
  
  // Set DoG
  for(int i=0;i<d.length;i++){//d = b[0] - b[1]
     DoG(d[i],b[i],b[i+1]);
  }
 
   
 
  //Show Images
  /*
  image(origin, 0, 0);
  image(d[1], x_size, 0);
  image(d[0], 0, y_size);
  image(r[0], x_size, y_size);
  */
  
  image(origin, 0, 0);
  check_DoG(r,d);
  //Save Result image.
  save( name+"keypoints.png" );
  //image(d[1], x_size, 0);
  //image(d[2], 0, y_size);
  //image(r, x_size, y_size);
}
 
void draw() {
}

/*----------------------------------------------------------------*/

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
  
  for(int i=0;i<s.length;i++) s[i] = r.get(0,0,r.width,r.height);  
  color tmp;
  int max = 0;
  int f = 0;
    //Max value
    for(int y=0; y<b[0].height; y++) {
      for(int x=0; x<b[0].width; x++) {
        tmp = b[0].get(x,y);
        max = 0;
        for(int i=1;i<s.length;i++){
          if(tmp < b[i].get(x,y)){
             tmp = b[i].get(x,y);
             max = i;
          }
        }
        s[max].set(x,y,tmp);
      }
    }
    
    //extreme value
    for(int Num=0;Num<2;Num++){
      for(int y=m; y<y_size-m; y++) {
        for(int x=m; x<x_size-m; x++) {
          f = 0;
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
             stroke(255,0,0,70);
             ellipse(x,y,5,5);
             point(x,y);
           }else{
             r.set(x,y,color(0,255,0));
             stroke(0,255,0,70);
             ellipse(x,y,20,20);
             point(x,y);
           }
          } 
        }
      }
    }
}

void DoG(PImage r,PImage a,PImage b){
  color tmp;
  for(int y=0;y<a.height;y++){
    for(int x=0;x<a.width;x++){
      tmp = a.get(x,y) - b.get(x,y);
      r.set(x,y,tmp);
    }
  }
}

void format(PImage[] r,color c){
  for(int n=0;n<r.length;n++) {
    for(int i=0; i<r[n].height; i++){
      for(int j=0; j<r[n].width; j++){
        r[n].set(j,i,c);
      }
    }
  }
}
void format(PImage r,color c){
  for(int i=0; i<r.height; i++){
    for(int j=0; j<r.width; j++){
      r.set(j,i,c);
    }
  }
}
