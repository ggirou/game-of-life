import 'dart:html';
import 'dart:async';
import 'dart:math';
import '../lib/game_of_life.dart';
import 'game_of_life_ui.dart';

int lifeTime = 1000;
DivElement canvasPanel = query("#canvasPanel");
CanvasElement canvas = query("#canvas");
GridPresenter gridPresenter = new GridPresenter(new Engine(), new Grid(canvas));

InputElement clearButton = query("#clearButton");
InputElement randomButton = query("#randomButton");
InputElement speed = query("#speed");
SpanElement speedValue = query("#speedValue");
SpanElement generationValue = query("#generationValue");
SpanElement cellsValue = query("#cellsValue");

Timer generationTimer = new Timer(Duration.ZERO, () {});

void main() {
  // FIXME: input range
  // TODO: localstorage, fileapi, webcomponent

  window.onLoad.listen(_autoResizeCanvas);
  window.onResize.listen(_autoResizeCanvas);
  window.onMouseWheel.listen(_zoom);
  speed.onChange.listen(onSpeedChange);
  clearButton.onClick.listen(_clear);

  Timer _randomTimer = new Timer(Duration.ZERO, () {});
  randomButton.onMouseDown.listen((e) => _randomTimer = _randomStart());
  randomButton.onMouseUp.listen((e) => _randomTimer.cancel());
  randomButton.onMouseOut.listen((e) => _randomTimer.cancel());

  animate();
}

animate() => window.requestAnimationFrame(_animate);

_animate(num time) {
  generationTimer.cancel();
  if(lifeTime > 0) {
    Duration duration = new Duration(milliseconds: max(0, lifeTime - (time.toInt() % lifeTime)));
    generationTimer = new Timer(duration, () {
      nextGeneration();
      animate();
    });
  }
}

nextGeneration() {
  gridPresenter.nextGeneration();
  drawGeneration();
}

drawGeneration() {
  gridPresenter.drawGeneration();
  refreshInfo();
}

refreshInfo() {
  generationValue.text = gridPresenter.generationCount.toString();
  cellsValue.text = gridPresenter.generation.aliveCells.length.toString();
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
  gridPresenter.clear();
  refreshInfo();
}

_autoResizeCanvas(e) {
  canvas.style.display = "none";
  canvas..width = canvasPanel.offsetWidth - 30 ..height = canvasPanel.offsetHeight - 30;
  canvas.style.display = "block";

  gridPresenter.refresh();
}

_zoom(WheelEvent e) {
  int delta = (e.detail != 0 ? e.detail / 3 : e.deltaY / 120).toInt();
  gridPresenter.zoom(delta);
}

Timer _randomStart() => new Timer.repeating(const Duration(milliseconds: 100), (t) {
  Random rand = new Random(new DateTime.now().millisecondsSinceEpoch);
  int cellWidth = gridPresenter.grid.cellWidth;
  int cellHeight = gridPresenter.grid.cellHeight;
  num number = cellWidth * cellHeight * 0.01;
  for(int i = 0; i < number; i++) {
    Cell cell = new Cell(rand.nextInt(cellWidth), rand.nextInt(cellHeight));
    gridPresenter[cell] = true;
    refreshInfo();
  }
});
