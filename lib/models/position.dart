const String alphabet = 'abcdefghijklmnopqrstuvwxyz';

class Position {
  final int x;
  final int y;

  String get positionName => _getPositionName();

  Position(x, y) : 
    x = _validate(x),
    y = _validate(y);



  Position? move(int xDirection, yDirection) {
    if (x + xDirection < 0 || x + xDirection > 7) return null;
    if (y + yDirection < 0 || y + yDirection > 7) return null;

    return Position(x + xDirection, y + yDirection);
  }


  static int _validate(int value) {
    if (value < 0 || value > 7) throw ArgumentError('Position must be between 0 and 7.');
    return value; 
  }

  String _getPositionName() {
    return alphabet[x] + (y + 1).toString();
  }
}
