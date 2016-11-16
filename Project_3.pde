JSONObject data;
ArrayList<String> keys;
ArrayList<PImage> images = new ArrayList<PImage>();
ArrayList userArray;
ArrayList<MyUser> users = new ArrayList<MyUser>();
int time = 6;
int userCount = 0;
int pixelCount = 0;
int allPhotoCount= 0;
int mouseClickX;
boolean single = false;
float red = 0;
float green = 0;
float blue = 0;
int[] days;
int[] hours;
int[] minutes;

PImage showImage;

int placementX = 0;
int placementY = 0;
int moveImage = 0;
int displayImage = 0;

void setup() {
  size(2000, 1220);
  background(60);
  textFont(createFont("Helvetica", 20));
  textSize(20);
  fill(30);
  rect(0, 600, 2000, 600);
  
  data = loadJSONObject("output.json");
  keys = new ArrayList(data.keys());
  //time  
  hours = new int[keys.size()];
  minutes = new int[keys.size()];
  userArray = new ArrayList();
  for (int i = 0; i < keys.size(); i++) {
    PImage img = loadImage(keys.get(i) + ".jpg");
    images.add(img);
    JSONObject dateEntry = data.getJSONObject(keys.get(i));
    JSONArray timeArray = dateEntry.getJSONArray("time");
    int hour = timeArray.getInt(3);
    int minute = timeArray.getInt(4);
    hours[i] = hour;
    minutes[i] = minute;
    String user = dateEntry.getString("user");
    if (!userArray.contains(user)) {
      userArray.add(user);
      userCount++;
      users.add(0, new MyUser(user, new PhotoTime(img, hour, minute)));
    } else {
      for (MyUser u : users) {
        if (u.id.equals(user)) {
          u.addImage(new PhotoTime(img, hour, minute));
          allPhotoCount++;
          break;
        }
      }
    }
  }

  /*
  for (int i = 0; i < images.size(); i++) {
    JSONObject dateEntry = data.getJSONObject(keys.get(i));
    JSONArray timeArray = dateEntry.getJSONArray("time");
    int hour = timeArray.getInt(3);
    int minute = timeArray.getInt(4);
    hours[i] = hour;
    minutes[i] = minute;
    String user = dateEntry.getString("user");
    if (userArray.contains(user) == false) {
      userArray.add(user);
      userCount++;
      users.add(new MyUser(user));
    }
    for (MyUser u : users) {
      if (u.id == user) {
        u.addImage(new PhotoTime(images.get(i), hour, minute));
      }
    }
    */
}

void draw() {
 int tempX = 0;
 int tempY = 0;
 time = 6;
 int thisPhotoCount = allPhotoCount;
 boolean picDrawn = false;
 fill(30);
 stroke(30);
 rect(0, 600, 2000, 620);
 fill(60);
 stroke(60);
 rect(0, 0, 2000, 600);
 fill(102, 178, 255);
 stroke(0);
 fill(255);
 textSize(20);
 text("Day", 1950, 595);
 text("Night", 1950, 620);
 text("Users", 10, 595);
 textSize(14);
 text("(Incomplete data set)", 10, 1210);
 text("Press r to reset", 1900, 1210);
 int xaxis = 175;
 fill(255);
 rect(40, 50, 1920, 15);
 rect(40, 1140, 1920, 15);
 textSize(20);
 for (int x = 40; x < 2100; x = x + 170) {
    if (x < 1000) {
      fill(255);
      text(Integer.toString(time) + " AM", x, 40);
      text(Integer.toString(time) + " PM", x, 1175);
      time++;
    } else {
      fill(255);
      text(Integer.toString(time) + " PM", x, 40);
      text(Integer.toString(time) + " AM", x, 1175);
      time++;
    }
    if (time == 13) {
      time = 1;
    }
  }
  for (int x = 120; x < 2100; x = x + 170) {
    if (x < 1000) {
      fill(0);
      stroke(0);
      rect(x + 20, 50, 2, 15);
      rect(x + 20, 1140, 2, 15);
      time++;
    } else {
      fill(0);
      stroke(0);
      rect(x + 20, 50, 2, 15);
      rect(x + 20, 1140, 2, 15);
      time++;
    }
    if (time == 13) {
      time = 1;
    }
  }
 for (MyUser user : users) {
   if ((single && (mouseClickX >= xaxis - 15 && mouseClickX < xaxis + 15)) || !single) {
     if (single) {
       thisPhotoCount = user.size;
     }
     for (PhotoTime p : user.images) {
       PImage image = p.image;
       loadPixels();
       image.loadPixels();
       for (int i = 0; i < image.pixels.length; i++) { 
         pixelCount++;
         red = red(image.pixels[i]) + red;
         green = green(image.pixels[i]) + green;
         blue = blue(image.pixels[i]) + blue;
       }
  
        color averageColor = color(red / pixelCount, green / pixelCount, blue / pixelCount);
        int y2;
        int x2;
        if (p.hour > 5 && p.hour < 18) {
           y2 = 65;
           x2 = (1880/12) * (p.hour - 6);
         } else {
           y2 = 1140;
           if (p.hour <= 5) {
             x2 = (1880/12) * (p.hour + 6);
           } else {
             x2 = (1880/12) * (p.hour - 18);
           }
         }
         x2 = x2 + 199/60 * p.minute + 50;
         stroke(averageColor);
         fill(averageColor);
         strokeWeight(2);
         line(xaxis, 600, x2, y2);
         ellipse(x2, y2, 10, 10);
         pixelCount = 0;
         red = 0;
         green = 0;
         blue = 0;
         if ((mouseX > 40 && mouseX < 1920 + 40) && mouseY > 40 && mouseY < 85 && !picDrawn && y2 < 500) { 
           if (mouseX >= x2 - 10 && mouseX <= x2 + 10) {
             picDrawn = true;
             showImage = image;
             tempX = mouseX;
             tempY = mouseY;
             
           }
         } else if ((mouseX > 40 && mouseX < 1920 + 40) && mouseY > 1130 && mouseY < 1165 && !picDrawn && y2 > 500) { 
           if (mouseX >= x2 - 10 && mouseX <= x2 + 10) {
             picDrawn = true;
             showImage = image;
             tempX = mouseX;
             tempY = mouseY - 75;
           }
         }
       }
     }
  if (single && (mouseClickX >= xaxis - 15 && mouseClickX < xaxis + 15)) {     
     fill(102, 178, 255);
     stroke(0);
     ellipse(xaxis, 600, 20, 20);
     xaxis = xaxis + 30;
  } else {
     fill(255);
     ellipse(xaxis, 600, 20, 20);
     xaxis = xaxis + 30;
  }
 }
  fill(255);
  text("Photo Count: " + thisPhotoCount, 10, 630);
  if (picDrawn) {
    image(showImage, tempX, tempY, 150, 150);
  }
}

void mouseClicked() {
  if (mouseY >= 580 && mouseY <= 620){
    mouseClickX = mouseX;
    single = true;
  }
}
void keyPressed() {
  if (key == 'r') {
    single = false;
  }
}


public class MyUser {
  public int size;
  public ArrayList<PhotoTime> images;
  public String id;
  public MyUser(String id, PhotoTime image) {
    this.id = id;
    images = new ArrayList<PhotoTime>();
    images.add(image);
    this.size = 1;
  }
  public void addImage(PhotoTime image) {
    this.images.add(image);
    this.size++;
  }
}

public class PhotoTime {
  public PImage image;
  public int hour;
  public int minute;
  public PhotoTime(PImage image, int hour, int minute) {
    this.image = image;
    this.hour = hour;
    this.minute = minute;
  }
}