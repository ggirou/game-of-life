part of game_of_life;

class Cell {
  static const int _maxCache = 2048;
  static Map<int, Map<int, Cell>> _cache = new Map();
  
  final int x, y;
  
  factory Cell(int x, int y) {
    if(x.abs() > _maxCache || y.abs() > _maxCache) {
      return new Cell._internal(x, y);
    } else if(!_cache.containsKey(x)) {
      _cache[x] = new Map();
      return _cache[x][y] = new Cell._internal(x, y);
    } else if(!_cache[x].containsKey(y)) {
      return _cache[x][y] = new Cell._internal(x, y);
    } else {
      return _cache[x][y];
    }
  }
  const Cell._internal(this.x, this.y);
  
  int get hashCode => x ^ y;
  bool operator ==(other) => x == other.x && y == other.y;
  String toString() => "[$x, $y]";
  
  List<Cell> neighbours() => [
    new Cell(x-1, y-1), new Cell(x, y-1), new Cell(x+1, y-1),
    new Cell(x-1,  y ),                   new Cell(x+1,  y ),
    new Cell(x-1, y+1), new Cell(x, y+1), new Cell(x+1, y+1),
  ];
}
