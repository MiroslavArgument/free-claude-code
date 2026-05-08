enum NavDirection { up, down, left, right }

extension NavAxis on NavDirection {
  bool get isVertical => this == NavDirection.up || this == NavDirection.down;
  bool get isHorizontal => !isVertical;
}
