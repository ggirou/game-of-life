library generation_test;

import "packages/unittest/unittest.dart";
import "packages/unittest/mock.dart";

import "../lib/game_of_life.dart";

main() {
  group("Generation tests", () {
    test("testAliveNeighbours", () {
      allNeighboursCombinations.forEach((Set<Cell> neighbours) {
        var gen = new Generation.from(neighbours);
        Cell zeroCell = new Cell(0, 0);
        expect(gen.aliveNeighbours(zeroCell), equals(neighbours.length), reason: "For $gen");
        
        gen[zeroCell] = true;
        expect(gen.aliveNeighbours(zeroCell), equals(neighbours.length), reason: "For $gen");
        
        gen[new Cell(2, 0)] = true;
        expect(gen.aliveNeighbours(zeroCell), equals(neighbours.length), reason: "For $gen");
      });
    });
    
    test("testAliveCellsAndNeighbours", () {
      List<Cell> aliveCells = [new Cell(0, 0), new Cell(0, 1), new Cell(1, 1)];
      var gen = new Generation.from(aliveCells);
      
      Set<Cell> expected = new Set();
      expected.addAll([
                       // 0,  0
                       new Cell(-1, -1), new Cell(0, -1), new Cell(1, -1),
                       new Cell(-1,  0), new Cell(0,  0), new Cell(1,  0),
                       new Cell(-1,  1), new Cell(0,  1), new Cell(1,  1),
                       // 0,  1
                       new Cell(-1,  0), new Cell(0,  0), new Cell(1,  0),
                       new Cell(-1,  1), new Cell(0,  1), new Cell(1,  1),
                       new Cell(-1,  2), new Cell(0,  2), new Cell(1,  2),
                       // 1,  1
                       new Cell( 0,  0), new Cell(1,  0), new Cell(2,  0),
                       new Cell( 0,  1), new Cell(1,  1), new Cell(2,  1),
                       new Cell( 0,  2), new Cell(1,  2), new Cell(2,  2),
                       ]);
      
      Set<Cell> output = gen.aliveCellsAndNeighbours();
      
      expect(output, unorderedEquals(expected), reason: "For $gen");
    });
  });
}

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
