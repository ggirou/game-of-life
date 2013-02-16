part of game_of_life_test;

var engineTests = {
                   "testNextGeneration": testNextGeneration, 
                   "testProcessCell_1": testProcessCell_1,
                   "testProcessCell_2": testProcessCell_2,
                   "testProcessCell_3": testProcessCell_3,
                   "testProcessCell_4": testProcessCell_4,
                   "testProcessCell_5": testProcessCell_5,
                   "testProcessCell_6": testProcessCell_6,
                   "testProcessCell_7": testProcessCell_7,
                   "testProcessCell_8": testProcessCell_8,
                   };

class GenerationMock extends Mock implements Generation {}

class EngineSpy extends Mock implements Engine {
  Engine _real;

  EngineSpy() : this.original(new Engine());
  
  EngineSpy.original(this._real) {
    when(callsTo('nextGeneration')).alwaysCall(_real.nextGeneration);
    when(callsTo('processCell')).alwaysCall(_real.processCell);
  }
}

testNextGeneration() {
  // GIVEN
  Engine engine = new Engine();
  
  GenerationMock currentGenerationMock = new GenerationMock();
  currentGenerationMock.when(callsTo('aliveCellsAndNeighbours')).alwaysReturn([new Cell(0, 0), new Cell(1, 0), new Cell(1, 1)]);
  
  // WHEN
  engine.nextGeneration(currentGenerationMock);

  // THEN
  currentGenerationMock.getLogs(callsTo('aliveCellsAndNeighbours'), null, true).verify(happenedOnce);
  currentGenerationMock.getLogs(callsTo('aliveNeighbours', new Cell(0, 0)), null, true).verify(happenedOnce);
  currentGenerationMock.getLogs(callsTo('aliveNeighbours', new Cell(1, 0)), null, true).verify(happenedOnce);
  currentGenerationMock.getLogs(callsTo('aliveNeighbours', new Cell(1, 1)), null, true).verify(happenedOnce);
  currentGenerationMock.getLogs().verify(neverHappened);
}

testProcessCell_1() {
  _testProcessCell(1, false);
}

testProcessCell_2() {
  _testProcessCell(2, true, true);
}

testProcessCell_3() {
  _testProcessCell(3, true);
}

testProcessCell_4() {
  _testProcessCell(4, false);
}

testProcessCell_5() {
  _testProcessCell(5, false);
}

testProcessCell_6() {
  _testProcessCell(6, false);
}

testProcessCell_7() {
  _testProcessCell(7, false);
}

testProcessCell_8() {
  _testProcessCell(8, false);
}

void _testProcessCell(int aliveNeighbours, bool isAlive, [bool checkIsAlive]) {
  // GIVEN
  Engine engine = new Engine();
  Cell cell = new Cell(0, 0);
  
  GenerationMock currentGenerationMock = new GenerationMock();
  GenerationMock nextGenerationMock = new GenerationMock();
  currentGenerationMock.when(callsTo('aliveNeighbours', cell)).thenReturn(aliveNeighbours);
  if(?checkIsAlive) {
    currentGenerationMock.when(callsTo('[]', cell)).thenReturn(checkIsAlive);
  }
 
  // WHEN
  engine.processCell(currentGenerationMock, nextGenerationMock, cell);
  
  // THEN
  currentGenerationMock.getLogs(callsTo('aliveNeighbours', cell), null, true).verify(happenedOnce);
  if(?checkIsAlive) {
    currentGenerationMock.getLogs(callsTo('[]', cell), null, true).verify(happenedOnce);
  }
  currentGenerationMock.getLogs().verify(neverHappened);
  
  nextGenerationMock.getLogs(callsTo('[]=', cell, isAlive), null, true).verify(happenedOnce);
  nextGenerationMock.getLogs().verify(neverHappened);
}
