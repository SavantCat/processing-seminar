PImage img;
PImage img_2;
PImage result;

void setup() {
  img = loadImage("city.png");
  size(2*img.width, img.height);
  
  img_2 = loadImage("robo.png");
  //gre(img,img_2);
  //
  result = img_2.get(0,0,img.width,img.height);
  DoG(result,img,img_2);
  
  image(img, 0,0);
  image(result, img_2.width,0);
}
void gre(PImage a,PImage b){
  float R,G,B;
    for(int y=0;y<a.height;y++){
    for(int x=0;x<a.width;x++){
      R = red( a.get(x,y));
      G = green( a.get(x,y));
      B = blue( a.get(x,y));
      
      int n = (int)((R+G+B)/3);
      b.set(x,y,color(n,n,n));
    }
  }
}
void DoG(PImage r,PImage a,PImage b){
  color tmp;
    for(int y=0;y<a.height;y++){
    for(int x=0;x<a.width;x++){
      tmp = b.get(x,y) - a.get(x,y);
      r.set(x,y,tmp);
    }
  }
}
