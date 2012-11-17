part of game_of_life_ui;

typedef CellClick(Cell currentCell, {Cell startCell});

class Grid {
  CanvasElement _canvas;
  CanvasRenderingContext2D _context;
  num cellSize = 10;
  num lineWidth = 1;
  String backgroundColor = "white";
  String lineColor = "white";
  
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
    _context..beginPath()
            ..rect(cell.x * cellSize + lineWidth, cell.y * cellSize + lineWidth, cellSize - lineWidth * 2, cellSize - lineWidth * 2)
            ..fillStyle = color
            ..closePath()
            ..fill();
  }
  
  clear() {
    _context..beginPath()
            ..rect(0, 0, _canvas.width, _canvas.height)
            ..fillStyle = backgroundColor
            ..closePath()
            ..fill();
    drawGrid();
  }
  
  clearCell(Cell cell) => drawCell(cell, "white");
  
  drawGrid() {
    for(num x = 0; x < _canvas.width; x+= cellSize) {
      drawLine(x, 0, x, _canvas.height);
    }

    for(num y = 0; y < _canvas.height; y+= cellSize) {
      drawLine(0, y, _canvas.width, y);
    }
  }

  drawLine(num x1, num y1, num x2, num y2) {
    _context..beginPath()
            ..strokeStyle = lineColor 
            ..moveTo(x1, y1)
            ..lineTo(x2, y2)
            ..lineWidth = lineWidth ..stroke();
  }
  
  drawGeneration(Generation generation) {
    generation.deadCells.forEach((cell) => grid.clearCell(cell));
    generation.aliveCells.forEach((cell) => grid.drawCell(cell, "red"));
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
    var x = ((event.pageX - _canvas.offsetLeft) / cellSize).toInt();
    var y = ((event.pageY - _canvas.offsetTop) / cellSize).toInt();
    return new Cell(x, y);
  }

  int get cellWidth => (_canvas.width / cellSize).ceil().toInt();
  int get cellHeight => (_canvas.height / cellSize).ceil().toInt();
}
