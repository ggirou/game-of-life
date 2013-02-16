part of game_of_life_test;

var generationTests = {"testAliveNeighbours": testAliveNeighbours, "testAliveCellsAndNeighbours": testAliveCellsAndNeighbours};

testAliveNeighbours() {
  allNeighboursCombinations.forEach((Set<Cell> neighbours) {
    var gen = new Generation.from(neighbours);
    Cell zeroCell = new Cell(0, 0);
    expect(gen.aliveNeighbours(zeroCell), equals(neighbours.length), reason: "For $gen");

    gen[zeroCell] = true;
    expect(gen.aliveNeighbours(zeroCell), equals(neighbours.length), reason: "For $gen");

    gen[new Cell(2, 0)] = true;
    expect(gen.aliveNeighbours(zeroCell), equals(neighbours.length), reason: "For $gen");
  });
}

testAliveCellsAndNeighbours() {
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
}