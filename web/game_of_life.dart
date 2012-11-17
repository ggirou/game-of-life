library game_of_life_ui;

import 'dart:html';
import 'dart:isolate';
import 'dart:math';
import '../lib/game_of_life.dart';

part 'grid.dart';

int lifeTime = 1000;
DivElement canvasPanel = query("#canvasPanel");
CanvasElement canvas = query("#canvas");
Grid grid = new Grid(canvas);
Engine engine = new Engine();
Generation generation = new Generation();

InputElement clearButton = query("#clearButton");
InputElement randomButton = query("#randomButton");
InputElement speed = query("#speed");
SpanElement speedValue = query("#speedValue");
int generationCount = 0;
SpanElement generationValue = query("#generationValue");
SpanElement cellsValue = query("#cellsValue");

Timer generationTimer = new Timer(0, (t) => null);
Timer randomTimer = new Timer(0, (t) => null);

void main() {
  // TODO: localstorage, fileapi, webcomponent

  window.on.load.add(_autoResizeCanvas);
  window.on.resize.add(_autoResizeCanvas);
  clearButton.on.click.add(_clear);
  randomButton.on.mouseDown.add(_randomStart);
  randomButton.on.mouseUp.add(_randomStop);
  randomButton.on.mouseOut.add(_randomStop);
  speed.on.change.add(onSpeedChange);
  
  grid.cellClick = gridCellClick;
  
  animate();
}

animate() => window.requestAnimationFrame(_animate);

_animate(num time) {
  generationTimer.cancel();
  if(lifeTime > 0) {
    generationTimer = new Timer(max(0, lifeTime - (time.toInt() % lifeTime)), (t) {
      nextGeneration();
      animate();
    });
  }
}

nextGeneration() {
  generation = engine.nextGeneration(generation);
  if(generation.aliveCells.length > 0) {
    generationCount++;
  }
  drawGeneration();
}

drawGeneration() {
  refreshInfo(); 
  grid.drawGeneration(generation);
}

void refreshInfo() {
  generationValue.text = generationCount.toString();
  cellsValue.text = generation.aliveCells.length.toString();
}

gridCellClick(Cell current, {Cell startCell}) {
  if(startCell == null) {
    generation[current] = !generation[current];
  } else {
    generation[current] = generation[startCell];
  }
  grid[current] = generation[current];
}

onSpeedChange(e) {
  int value = speed.valueAsNumber.toInt();
  num x = 1;
  if(value < 0) {
    x = -1;
    speedValue.text = "Stop";
  } else if(value >= 10) {
    x = 1000;
    speedValue.text = "Max";
  } else {
    x = 0.25 * pow(2, value);
    speedValue.text = "${x}x";
  }
  
  lifeTime = (1000 / x).toInt();
  animate(); 
}

_clear(e) {
  generation = new Generation();
  generationCount = 0;
  grid.clear();
  drawGeneration();
}

_randomStart(e) => randomTimer = new Timer.repeating(100, (t) {
  num number = grid.cellWidth * grid.cellHeight * 0.01;
  for(int i = 0; i < number; i++) {
    Cell cell = _randomCell();
    generation[cell] = true;
    grid.drawCell(cell);
    refreshInfo();
  }
});
_randomStop(e) => randomTimer.cancel();
Cell _randomCell() => new Cell(new Random().nextInt(grid.cellWidth), new Random().nextInt(grid.cellHeight));

_autoResizeCanvas(e) {
  canvas.style.display = "none";
  canvas..width = canvasPanel.offsetWidth - 30 ..height = canvasPanel.offsetHeight - 30;
  canvas.style.display = "block";
  
  grid.clear();
  grid.drawGeneration(generation);
}