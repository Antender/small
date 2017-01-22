import java.util.Random;

public class Minesweeper {
  class Cell {
    public int minecount;
    Cell() {
      open = false;
    }
    void SetMine() {
      minecount = -1;
    }
    boolean IsMine() {
      return minecount == -1;
    }
  }

  class Point {
    public int x;
    public int y;
    Point (int _x, int _y) {
      x = _x;
      y = _y;
    }
  }

  final int XSIZE;
  final int YSIZE;
  final int MINECOUNT;
  final int CELLCOUNT;
  public Cell[][] cells;

  public static void main(String[] args) {
    new Minesweeper();
  }

  Minesweeper(int _xsize, int _ysize, int _minecount) {
    XSIZE = _xsize;
    YSIZE = _ysize;
    MINECOUNT = _minecount;
    CELLSIZE = XSIZE * YSIZE;
    cells = new Cell[XSIZE][YSIZE];
    Point[] points = new Point[XSIZE*YSIZE];
    for (int x = 0; x < XSIZE; x++) {
      for (int y = 0; y < YSIZE; y++) {
        cells[x][y] = new Cell();
        points[x+XSIZE*y] = new Point(x,y);
      }
    }
    Random rnd = new Random();
    for (int x = 0; x < MINECOUNT; x++) {
      int pos = x+rnd.nextInt(CELLCOUNT-x);
      Point temp = points[pos];
      points[pos] = points[x];
      points[x] = temp;
      cells[temp.x][temp.y].SetMine();
    }
    for (int x = 0; x < XSIZE; x++) {
      for (int y = 0; y < YSIZE; y++) {
        if (!cells[x][y].IsMine()) {
          int minecount = 0;
          boolean left = x > 0;
          boolean right = x < XSIZE - 1;
          boolean up = y > 0;
          boolean down = y < YSIZE - 1;
          if (up && left && 
              cells[x-1][y-1].IsMine()) {
            minecount++;
              }
          if (up && cells[x][y-1].IsMine()) {
            minecount++;
          }
          if (up && right &&
              cells[x+1][y-1].IsMine()) {
            minecount++;
              }
          if (left && cells[x-1][y].IsMine()){
            minecount++;
          }
          if (right &&
              cells[x+1][y].IsMine()) {
            minecount++;
              }
          if (down && left &&
              cells[x-1][y+1].IsMine()) {
            minecount++;
              }
          if (down &&
              cells[x][y+1].IsMine()) {
            minecount++;
              }
          if (down && right &&
              cells[x+1][y+1].IsMine()) {
            minecount++;
              }
          cells[x][y].minecount = minecount;
        }
      }
    }
    ShowField();
  }

  void ShowField() {
    for (int x = 0; x < XSIZE; x++) {
      for (int y = 0; y < YSIZE; y++) {
        if (cells[x][y].IsMine()) {
          System.out.print("X");
        } else {
          System.out.print(cells[x][y].minecount);
        }
      }
      System.out.println();
    }
  }
}
