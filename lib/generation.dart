part of game_of_life;

class Generation {
  Set<Cell> _aliveCells = new Set();
  Set<Cell> _deadCells = new Set();

  Generation();
  Generation.from(Iterable<Cell> aliveCell) : this._aliveCells = new Set.from(aliveCell);

  int aliveNeighbours(Cell cell) {
    return cell.neighbours().where(_aliveCells.contains).length;
  }

  Set<Cell> aliveCellsAndNeighbours() {
    Set cells = new Set();
    _aliveCells.forEach((cell) {
      cells.add(cell);
      cells.addAll(cell.neighbours());
    });
    return cells;
  }

  bool operator [](Cell cell) => _aliveCells.contains(cell);
  void operator []=(Cell cell, bool value) {
    if(value) {
      _aliveCells.add(cell);
      _deadCells.remove(cell);
    } else {
      _aliveCells.remove(cell);
      _deadCells.add(cell);
    }
  }

  Collection<Cell> get aliveCells => _aliveCells;
  Collection<Cell> get deadCells => _deadCells;
  String toString() => "Generation{aliveCell: $_aliveCells, deadCells: $_deadCells}";
}
