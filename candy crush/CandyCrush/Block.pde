public class Block {
  PImage image;
  PImage[] effect;
  int effectCount, frame, type, tint, state, size, x, y;
  public Block(int type, int tint, int size, int x, int y) {
    this.type = type;
    this.tint = tint;
    this.size = size;
    this.x = x;
    this.y = y;
    if (type < 0) {
      effect = null;
      effectCount = frame = state = -1;
    } else {
      switch (type) {
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
        case 4:
          break;
        default:
      }
    }
  }
}
