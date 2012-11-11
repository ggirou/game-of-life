library game_of_life_ui;

import 'dart:html';
import 'dart:isolate';
import 'dart:math';
import '../lib/game_of_life.dart';

part 'grid.dart';

int lifeTime = 1000;
CanvasElement canvas = query("#canvas");
Grid grid = new Grid(canvas);
Engine engine = new Engine();
Generation generation = new Generation();

InputElement speed = query("#speed");
SpanElement speedValue = query("#speedValue");
int generationCount = 0;
SpanElement generationValue = query("#generationValue");
SpanElement cellsValue = query("#cellsValue");

Timer timer = new Timer(0, (t) => null);

void main() {
  speed.on.change.add(onSpeedChange);
  
  grid.resize(50, 50);
  grid.cellClick = (Cell current, {Cell startCell}) {
    if(startCell == null) {
      generation[current] = !generation[current];
    } else {
      generation[current] = generation[startCell];
    }
    grid[current] = generation[current];
  };
  
  for(int i = 0; i < 500; i++) {
    generation[randomCell()] = true;
  }
  drawGeneration();

  animate();
}

animate() {
  window.requestAnimationFrame(_animate);
}

_animate(num time) {
  timer.cancel();
  if(lifeTime > 0) {
    timer = new Timer(max(0, lifeTime - (time.toInt() % lifeTime)), (t) {
      nextGeneration();
      animate();
    });
  }
}

nextGeneration() {
  generation = engine.nextGeneration(generation);
  generationCount++;
  drawGeneration();
}

drawGeneration() {
  generationValue.text = generationCount.toString();
  cellsValue.text = generation.aliveCells.length.toString(); 
  generation.deadCells.forEach((cell) => grid.clearCell(cell));
  generation.aliveCells.forEach((cell) => grid.drawCell(cell, "red"));
}

Cell randomCell() => new Cell(new Random().nextInt(50), new Random().nextInt(50));

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