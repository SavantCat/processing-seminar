PImage a;//image class
PImage[] b = new PImage[5];

  // Gaussian matrix
  float[][] myMatrix;
  int       large=13;
  float     sigma=2;
void setup() {
  // Load image
  a = loadImage("../../img/lenna.png");
 
  // Set canvas
   size(2*a.width,a.height);
   
  // Initialize PImage
  for(int i=0;i<5;i++) b[i] = a.get(0,0,a.width,a.height);
 
  myMatrix = new float[large][large];
  myMatrix = CreateGaussianMatrix(myMatrix, large, sigma);
 
  // Print gaussian matrix
  ShowMatrix(myMatrix, large);
 
  // Smooth an image
  SmoothWithGaussian(a, b[0], large, myMatrix);
  image(a, 0, 0);
  image(b[0], a.width, 0);
 
}
 
void draw() {
  if( sigma > 50){
     sigma = 0;
  }else{
      sigma += 1;
  }
 
    myMatrix = new float[large][large];
    myMatrix = CreateGaussianMatrix(myMatrix, large, sigma);
    // Print gaussian matrix
   // ShowMatrix(myMatrix, large);
 
    // Smooth an image
    SmoothWithGaussian(a, b[0], large, myMatrix); 
    image(b[0], a.width, 0); 
    
    text(sigma,a.width+50,a.height-50);
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
