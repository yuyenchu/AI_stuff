int col = 12, row = 6, imgSize = 25, blockSize = 30, textSize = 10, 
    specials = 1, normals = 6, wraps = 6, stripes = 12, seed = 2,
    h = 300, w = 600;
int xOffSet, yOffSet, score, x1, y1, x2, y2, maxCode, blankBlock;
int[][] board, ignition;
//board values:
//0 = empty, 1~6 = normal, 7~12 = wrap, 13~24 = stripe, 25 = bomb
//ignition values:
//0 = none, 1 = ver-stripe ignite, 2 = hor-stripe ignite,
//3 = wrap ignite 1, 4 = wrap ignite 2, 5 = bomb ignite
String normalPath = "images/normal/normal";
String stripePath = "images/striped/striped";
String wrapPath = "images/wrapped/wrapped";
String specialPath = "images/special/special";
String backPath = "images/environment/background.jpg";
String selectPath = "images/environment/selected.png";
String boardPath = "data/boards/";
PImage back, select;
PImage[] normal, stripe, wrap, special;

boolean debug = true, settingMode = false;

void settings() {
  if (debug) {
    size(w, h*2);
  } else {
    size(w, h);
  }
}

void setup(){
  maxCode = normals + wraps + stripes + specials;
  blankBlock = maxCode+1;
  
  back = loadImage(backPath);
  select = loadImage(selectPath);
  
  normal = new PImage[normals];
  for(int i = 0; i < normals; i++) {
    normal[i] = loadImage(normalPath + (i+1) +".png");
  }
  
  wrap = new PImage[wraps];
  for(int i = 0; i < wraps; i++) {
    wrap[i] = loadImage(wrapPath + (i+1) +".png");
  }
  
  stripe = new PImage[stripes];
  for(int i = 0; i < stripes; i++) {
    stripe[i] = loadImage(stripePath + (i+1) +".png");
  }

  special = new PImage[specials];
  for(int i = 0; i < specials; i++) {
    special[i] = loadImage(specialPath + (i+1) +".png");
  }

   initialize();
   fillBoard(seed);
  //readBoard("board1");

  // board[4][2]=6;
  // board[1][0]=6;
  // board[3][0]=5;
  
  imageMode(CENTER);
  drawBack();
  drawCandy();
  drawDebug();
  println("setup finished");
}

void initialize() {
  score = 0;
  x1 = y1 = x2 = y2 = -1;
  board = new int[col][row];
  ignition = new int[col][row];
  xOffSet = (w-blockSize*col)/2;
  yOffSet = (h-blockSize*row)/2;
}

void fillBoard(int seed){
  if (seed > 0) {
    randomSeed(seed);
  }
  for(int i = 0; i < col; i++) {
    for(int j = 0; j < row; j++) {
      if (board[i][j] != blankBlock) {
        board[i][j] = (int)random(normals)+1;
      }
    }
  }
}

void readBoard(String fileName) {
  fileName = boardPath + fileName + ".txt";
  if (debug) {
    println(fileName);
  }
  try {
    BufferedReader reader = createReader(fileName);
    String line = reader.readLine();
    String item[] = line.split(",");
    if (item.length == 2) {
      col = Integer.parseInt(item[0]);
      row = Integer.parseInt(item[1]);
      initialize();
    }
    line = reader.readLine();
    item = line.split(",");
    if (item.length == col * row) {
      for (int i = 0; i < item.length; i++) {
        board[i%col][i/col] = Integer.parseInt(item[i]);
      }
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
}

void draw(){
  if (settingMode) {
    drawDebug();
  }
}

void drawBack(){
  image(back, 300, 150, 640, 300);
  strokeWeight(2);
  fill(70, 100);
  stroke(80, 150);
  rect(xOffSet, yOffSet, blockSize*col, blockSize*row, 5);
  strokeWeight(1);
  stroke(150, 80);
  for(int i = 1; i < col; i++) {
    line(blockSize*i+xOffSet, yOffSet, blockSize*i+xOffSet, blockSize*row+yOffSet);
  }
  stroke(200, 60);
  for(int i = 1; i < row; i++) {
    line(xOffSet, blockSize*i+yOffSet, blockSize*col+xOffSet, blockSize*i+yOffSet);
  }
}

void drawCandy(){
  for(int i = 0; i < col; i++) {
    for(int j = 0; j < row; j++) {
      if (board[i][j] == blankBlock) {
        rectMode(CENTER);
        fill(255, 35);
        rect((i+0.5)*blockSize+xOffSet, (j+0.5)*blockSize+yOffSet, blockSize, blockSize);
        rectMode(CORNER);
      } else if (board[i][j] > 24) {
        image(special[board[i][j]-25], (i+0.5)*blockSize+xOffSet, 
              (j+0.5)*blockSize+yOffSet, imgSize, imgSize);
      } else if (board[i][j] > 12) {
        image(stripe[board[i][j]-13], (i+0.5)*blockSize+xOffSet, 
              (j+0.5)*blockSize+yOffSet, imgSize, imgSize);
      } else if (board[i][j] > 6) {
        image(wrap[board[i][j]-7], (i+0.5)*blockSize+xOffSet, 
              (j+0.5)*blockSize+yOffSet, imgSize, imgSize);
      } else if (board[i][j] > 0) {
        image(normal[board[i][j]-1], (i+0.5)*blockSize+xOffSet, 
              (j+0.5)*blockSize+yOffSet, imgSize, imgSize);
      }
    }
  }
}

void drawDebug(){
  if (debug) {
    fill(255);
    strokeWeight(0);
    rect(0,300,600,600);
    textSize(textSize);
    fill(0);
    text("board values", 10, 310);
    for(int i = 0; i < col; i++) {
      for(int j = 0; j < row; j++) {
        text(""+board[i][j], 10+1.5*i*textSize, 310+1.5*(j+1)*textSize);
      }
    }
    text("ignition values", 310, 310);
    for(int i = 0; i < col; i++) {
      for(int j = 0; j < row; j++) {
        text(""+ignition[i][j], 310+1.5*i*textSize, 310+1.5*(j+1)*textSize);
      }
    }
    text("score = "+score, 10, 310+1.5*(row+1)*textSize);
    text("x1 = "+x1+" y1 = "+y1, 10, 310+1.5*(row+2)*textSize);
    text("x2 = "+x2+" y2 = "+y2, 10, 310+1.5*(row+3)*textSize);
    text("setting mode = "+settingMode, 10, 310+1.5*(row+4)*textSize);
    text("blank code = "+blankBlock, 10, 310+1.5*(row+5)*textSize);
  }
}

void drawSelect(int x, int y) {
  image(select, (x+0.5)*blockSize+xOffSet, (y+0.5)*blockSize+yOffSet, blockSize, blockSize);
}

void keyPressed() {
  switch (key) {
    case 's':
      settingMode = !settingMode;
      if (settingMode) {
        initialize();
      } else {
        fillBoard(seed);
      }
      drawBack();
      drawCandy();
      drawDebug();
      break;
    default:
  }
}

void mouseClicked() {
  if (debug) {
    println("mouseX = "+mouseX+", mouseY = "+mouseY);
  }
  if (!settingMode) {
    if (mouseX >= xOffSet && mouseX <= 600-xOffSet 
    && mouseY >= yOffSet && mouseY <= 300-yOffSet) {
      int x = (mouseX-xOffSet)/blockSize, y = (mouseY-yOffSet)/blockSize;
      if (board[x][y] != blankBlock){
        if (x1 < 0 && y1 < 0){
          x1 = x;
          y1 = y;
          drawSelect(x1, y1);
          drawDebug();
        } else {
          x2 = x;
          y2 = y;
          if ((abs(x1-x2) == abs(y1-y2)) || abs(x1-x2) > 1 || abs(y1-y2) > 1) {
            x2 = y2 = -1;
          } else {
            swap();
          }
        }
      }
    } else {
      x1 = y1 = x2 = y2 = -1;
      drawBack();
      drawCandy();
      drawDebug();
    }
  } else {
    if (mouseX >= xOffSet && mouseX <= 600-xOffSet 
    && mouseY >= yOffSet && mouseY <= 300-yOffSet) {
      int x = (mouseX-xOffSet)/blockSize;
      int y = (mouseY-yOffSet)/blockSize;
      board[x][y] = board[x][y] == 0 ? blankBlock : 0;
    }
  }
}

void swap(){
  int temp = board[x1][y1];
  board[x1][y1] = board[x2][y2];
  board[x2][y2] = temp;
  check();
  x1 = y1 = x2 = y2 = -1;
  if (settingMode) {
    initialize();
    drawBack();
    drawCandy();
  }
}

void check() {
  boolean needFall = false;
  for(int i = 0; i < col; i++) {
    for(int j = 0; j < row; j++) {
      if (board[i][j] > 0) {
        int hor = checkHor(i, j), ver = checkVer(i, j), temp = board[i][j];
        boolean wrapFlag = false;
        if (debug) {
          println("x = "+i+" ,y = "+j+" ,hor = "+hor+" ,ver = "+ver);
        }
        if (hor >= 3) {
          for (int k = 0; k < hor; k++) {
            int[] num = checkUpDw(i+k, j);
            if (num[2] >= 3 && !wrapFlag){
              wrapFlag = true;
              for (int h = -num[1]+1; h < num[0]; h++){
                //check candy type & delete
                setIgnite(i+k, j+h);
              }
              //set forming wrap
              board[i+k][j] = -(temp + 6);
              drawDebug();
            } else {
              //check candy type & delete
              setIgnite(i+k, j);
              drawDebug();
            }
          }
          if (!wrapFlag){
            if (hor >= 5) {
              //set forming bomb
              board[i][j] = -25;
            } else if (hor ==4) {
              //set forming horizontal stripe
              board[i][j] = -(11 + temp*2);
            }
            drawDebug();
          }
          needFall = true;
        } else if (ver >= 3) {
          for (int k = 0; k < ver; k++) {
            int[] num = checkLtRt(i, j+k);
            if (num[2] >= 3 && !wrapFlag){
              wrapFlag = true;
              for (int h = -num[1]+1; h < num[0]; h++){
                //check candy type & delete
                setIgnite(i+h, j+k);
              }
              //set forming wrap
              board[i][j+k] = -(temp + 6);
              drawDebug();
            } else {
              //check candy type & delete
              setIgnite(i, j+k);
              drawDebug();
            }
          }
          if (!wrapFlag){
            if (ver >= 5) {
              //set forming bomb
              board[i][j] = -25;
            } else if (ver ==4) {
              //set forming vertical stripe
              board[i][j] = -(12 + temp*2);
            }
            drawDebug();
          }
          needFall = true;
        }
      }
    }
  }
  drawBack();
  drawCandy();
  drawDebug();
  ignite();
  if (needFall) {
    fall();
  }
}

void setIgnite(int x, int y) {
  if (board[x][y] != blankBlock 
      && x > 0 && x < col && y > 0 && y < row) {
    if (board[x][y] == 25) { //bomb
      ignition[x][y] = 5;
      board[x][y] = 0;
    } else if (board[x][y] > 12) { //stripe
      if (board[x][y] % 2 == 0) {
        ignition[x][y] = 1;
      } else {
        ignition[x][y] = 2;
      }
      board[x][y] = 0;
    } else if (board[x][y] > 6) { //wrap
      if (ignition[x][y] == 4) {
        board[x][y] = 0;
      } else {
        ignition[x][y] = 3;
      }
    } else if (board[x][y] != blankBlock){ //normal
      ignition[x][y] = 0;
      board[x][y] = 0;
    }
  }
}

void ignite() {
  //special effects
  for (int i = 0; i < col; i++) {
    for (int j = 0; j < row; j++) {
      switch (ignition[i][j]) {
        case 1:
          for (int k = 0; k < row; k++) {
            setIgnite(i, k);
          }
          break;
        case 2:
          for (int k = 0; k < col; k++) {
            setIgnite(k, j);
          }
          break;
        case 3:
          for (int k = -1; k <= 1; k++) {
            for (int h = -1; h <= 1; h++) {
              setIgnite(i+k, j+h);
            }
          }
          ignition[i][j] = 4;
          break;
        case 4:
          for (int k = -1; k <= 1; k++) {
            for (int h = -1; h <= 1; h++) {
              setIgnite(i+k, j+h);
            }
          }
          break;
        case 5:
          //unfinished
          for (int k = 0; k < col; k++) {
            for (int h = 0; h < row; h++) {
              setIgnite(k, h);
            }
          }
          break;
        default:
      }
      drawDebug();
    }
  }
  //update newly formed special candies
  for (int i = 0; i < col; i++) {
    for (int j = 0; j < row; j++) {
      if (board[i][j] < 0) {
        board[i][j] = -board[i][j];
        drawDebug();
      }
    }
  }
}

int getColor(int x, int y) {
  int c = board[x][y];
  if (c > 12) {
    c = (c-11)/2;
  } else if (c > 6) {
    c -= 6;
  } else if (c < -12) {
    c = (c+11)/2;
  } else if (c < -6) {
    c += 6;
  }
  return c;
}

boolean sameColor(int x1, int y1, int x2, int y2) {
  int color1 = getColor(x1, y1), color2 = getColor(x2, y2);
  
  if (color1 < 0 || color2 < 0) {
    return false;
  } else {
    return color1 == color2;
  }
}

int checkHor(int x, int y) {
  int num = 1;
  while (x+num < col && sameColor(x+num, y, x, y)) {
    num++;
  }
  return num;
}

int checkVer(int x, int y) {
  int num = 1;
  while (y+num < row && sameColor(x, y+num, x, y)) {
    num++;
  }
  return num;
}

int[] checkLtRt(int x, int y) {
  int[] num = {1, 1, 0};
  while (x+num[0] < col && sameColor(x+num[0], y, x, y)) {
    num[0]++;
  }
  while (x-num[1] >= 0 && sameColor(x-num[1], y, x, y)) {
    num[1]++;
  }
  num[2] = num[0]+num[1]-1;
  return num;
}

int[] checkUpDw(int x, int y) {
  int[] num = {1, 1, 0};
  while (y+num[0] < row && sameColor(x, y+num[0], x, y)) {
    num[0]++;
  }
  while (y-num[1] >= 0 && sameColor(x, y-num[1], x, y)) {
    num[1]++;
  }
  num[2] = num[0]+num[1]-1;
  return num;
}

void fall() {
  for(int j = row -1; j >= 0 ; j--) {
    for(int i = 0; i < col; i++) {
      if (debug) {
        println("checking x = "+i+", y = "+j+", value = "+board[i][j]+", up value = "+(j==0?"empty":board[i][j-1]));
      }
      if (board[i][j] == 0) {
        int h = 1;
        while (j-h >= 0 && (board[i][j-h] == 0 || board[i][j-h] == blankBlock)) {
          h++;
        }
        for (int k = j; k >= 0; k--) {
          if (board[i][k] != blankBlock) {
            if (k-h < 0) {
              board[i][k] = (int)random(normals)+1;
            } else {
              board[i][k] = board[i][k-h];
              board[i][k-h] = 0;
            }
          }
        }
        if (debug) {
          println("---need fall, gap = "+h+", new value = "+board[i][j]);
        }
      }
    }
  }
  drawBack();
  drawCandy();
  drawDebug();
  delay(300);
  check();
}
