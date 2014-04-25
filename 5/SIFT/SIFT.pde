PImage a;//image class
PImage[] b = new PImage[5];
PImage[] d = new PImage[4];

  //float[][] tmp;

  // Gaussian matrix
  float[][] myMatrix;
  int       large=13;
  float     sigma=2;
  
void setup() {
  // Load image
  a = loadImage("../../img/lenna.png");
  
  // Set canvas
  size(2*a.width,2*a.height);
  
  // Initialize PImage

 

 
  // Print gaussian matrix
  //ShowMatrix(myMatrix, large);
 
  // Smooth an image
  
  
  for(int i=0;i<5;i++) b[i] = a.get(0,0,a.width,a.height);
  for(int i=0;i<4;i++) d[i] = a.get(0,0,a.width,a.height);
  
  myMatrix = new float[large][large];
  
  
  for(int i = 0;i<5;i++){
    myMatrix = CreateGaussianMatrix(myMatrix, large, sigma*pow(sqrt(2),i));
    //println(myMatrix[i][10] + " " +sigma*pow(sqrt(2),i));
    SmoothWithGaussian(a, b[i], large, myMatrix);
  }
  
  
 DoG(d[0],b[0],b[1]);
  image(d[0], 0, 0);
 DoG(d[1],b[1],b[2]);
  image(d[1], a.width, 0);
 DoG(d[2],b[2],b[3]);
  image(d[2], 0, a.height);
 DoG(d[3],b[3],b[4]);
  image(d[3], a.width, a.height);
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


void DoG(PImage r,PImage a,PImage b){
  color tmp;
    for(int y=0;y<a.height;y++){
    for(int x=0;x<a.width;x++){
      tmp = b.get(x,y) - a.get(x,y);
      r.set(x,y,tmp);
    }
  }
}
