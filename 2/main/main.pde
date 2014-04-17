PImage in_img,out_img;



void setup(){
  in_img   = loadImage("lenna.png");
  out_img  = in_img.get(0,0,a.width,a.height);//pixels 
  
  size(2*a.width,a.height);
  background(255);
  
  image(a, 0, 0);
  image(b, in_img.width, 0);
}
