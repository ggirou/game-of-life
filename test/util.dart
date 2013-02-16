part of game_of_life_test;

final Function neighboursToGeneration = (Set<Cell> neighbours) => new Generation.from(neighbours);

final List<Cell> indexedPoint = [
    new Cell(-1, -1), new Cell(0, -1), new Cell(1, -1),
    new Cell(-1,  0),                  new Cell(1,  0),
    new Cell(-1,  1), new Cell(0,  1), new Cell(1,  1),
  ];

final List<Set<Cell>> allNeighboursCombinations = _allNeighboursCombinations();
List<Set<Cell>> _allNeighboursCombinations() {
  List<Set<Cell>> neighbours = new List();
  for(int i = 0x0; i <= 0xff; i++) {
    neighbours.add(_intToNeighbours(i));
  }
  return neighbours;
}

Set<Cell> _intToNeighbours(int i) {
  Set<Cell> points = new Set();
  for(int bit = 0; bit <= 7; bit++) {
    //print("$i & ${1 << bit} = ${((1 << bit) & i)}");
    if(((1 << bit) & i) > 0) {
      points.add(indexedPoint[bit]);
    }
  }
  return points;
}
