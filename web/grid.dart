part of game_of_life_ui;

typedef CellClick(Cell currentCell, {Cell startCell});

class Grid {
  CanvasElement _canvas;
  CanvasRenderingContext2D _context;
  num cellSize = 10;
  num lineWidth = 1;
  String backgroundColor = "white";
  String lineColor = "white";
  num _scale = 1;
  
  Cell _startMouseDown;
  Cell _currentMouseMove;
  CellClick cellClick;

  Grid(CanvasElement canvas) {
    _canvas = canvas;
    _canvas.on.mouseDown.add(_onMouseDown);
    _canvas.on.mouseUp.add(_onMouseUp);
    _canvas.on.mouseMove.add(_onMouseMove);
    
    _context = canvas.getContext("2d");
    clear();
  }

  void operator []=(Cell cell, bool value) => value ? drawCell(cell, "red") : clearCell(cell);

  drawCell(Cell cell, [String color = "red"]) {
    num lineWidth = this.lineWidth * scale;
    _context..beginPath()
            ..rect(cell.x * cellSize, cell.y * cellSize, cellSize, cellSize)
            ..fillStyle = color
            ..fill()
            ..lineWidth = lineWidth
            ..strokeStyle = lineColor
            ..stroke()
            ..closePath();
  }
  
  clear() {
    _context..beginPath()
            ..rect(0, 0, width, height)
            ..fillStyle = backgroundColor
            ..closePath()
            ..fill();
    drawGrid();
  }
  
  clearCell(Cell cell) => drawCell(cell, "white");
  
  drawGrid() {
    if(lineColor != backgroundColor) {
      for(num x = 0; x < width; x+= cellSize) {
        drawLine(x, 0, x, height);
      }
  
      for(num y = 0; y < height; y+= cellSize) {
        drawLine(0, y, width, y);
      }
    }
  }

  drawLine(num x1, num y1, num x2, num y2) {
    _context..beginPath()
            ..strokeStyle = lineColor 
            ..moveTo(x1, y1)
            ..lineTo(x2, y2)
            ..lineWidth = lineWidth * scale ..stroke();
  }
  
  drawGeneration(Generation generation) {
    generation.deadCells.forEach((cell) => clearCell(cell));
    generation.aliveCells.forEach((cell) => drawCell(cell, "red"));
  }
  
  _onMouseDown(MouseEvent event) =>_startMouseDown = _mouseEventToCell(event);
  
  _onMouseUp(MouseEvent event) {
    _startMouseDown = null;
    _dispatchCellClick(_mouseEventToCell(event));
    _currentMouseMove = null;
  }

  _onMouseMove(MouseEvent event) {
    // FIX: vérifier que la souris est bien DOWN
    if(_startMouseDown != null) {
      var cell = _mouseEventToCell(event);
      if(_currentMouseMove != cell) {
        _dispatchCellClick(cell);
      }
    }
  }
  
  _dispatchCellClick(Cell cell) {
    if(cellClick != null && _currentMouseMove != cell) {
      _currentMouseMove = cell;
      if(_currentMouseMove == _startMouseDown) {
        cellClick(_currentMouseMove);
      } else {
        cellClick(_currentMouseMove, startCell: _startMouseDown);
      }
    }
  }
  
  _mouseEventToCell(MouseEvent event) {
    int x = (event.offsetX / cellSize / scale).toInt();
    int y = (event.offsetY / cellSize / scale).toInt();
    return new Cell(x, y);
  }

  num get width => _canvas.width / scale;
  num get height => _canvas.height / scale;
  int get cellWidth => (width / cellSize).ceil().toInt();
  int get cellHeight => (height / cellSize).ceil().toInt();
  
  num get scale => _scale;
  set scale(num scale) {
    print("Scale: $scale");
    _context.scale(scale / _scale, scale / _scale);
    _scale = scale;
  }
}
