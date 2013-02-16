part of game_of_life_ui;

class GridPresenter {
  Engine engine;
  Grid grid;

  Generation generation = new Generation();
  int generationCount = 0;

  bool _clickState = true;

  GridPresenter(this.engine, this.grid) {
    grid.cellClick = _gridCellClick;
  }

  nextGeneration() {
    generation = engine.nextGeneration(generation);
    if(generation.aliveCells.length > 0) {
      generationCount++;
    }
  }

  drawGeneration() {
    grid.drawGeneration(generation);
  }

  refresh() {
    grid.clear();
    grid.drawGeneration(generation);
  }

  clear() {
    generation = new Generation();
    generationCount = 0;
    grid.clear();
  }

  _gridCellClick(Cell current, {Cell startCell}) {
    if(startCell == null) {
      _clickState = generation[current] = !generation[current];
    } else {
      generation[current] = _clickState;
    }
    grid[current] = generation[current];
  }

  bool operator [](Cell cell) => generation[cell];
  void operator []=(Cell cell, bool value) {
   generation[cell] = true;
   if(value) {
      grid.drawCell(cell);
    } else {
      grid.clearCell(cell);
    }
  }

  zoom(int delta) {
    grid.scale = max(1 / 8, min(grid.scale * (delta < 0 ? -0.5 : 2) * delta, 8));
    grid.clear();
    grid.drawGeneration(generation);
  }
}
