part of game_of_life;

class Engine {
  Cell min;
  Cell max;

  Engine([this.min, this.max]);

  Generation nextGeneration(Generation current) {
    Generation next = new Generation();
    current.aliveCellsAndNeighbours().forEach((cell) => processCell(current, next, cell));
    return next;
  }

  processCell(Generation current, Generation next, Cell cell) {
    int aliveNeighbours = current.aliveNeighbours(cell);
    next[cell] = aliveNeighbours == 3 || (aliveNeighbours == 2 && current[cell]);
  }
}
