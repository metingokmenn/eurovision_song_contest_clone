class NavigationState {
  final int index;

  const NavigationState({this.index = 0});

  NavigationState copyWith({int? index}) {
    return NavigationState(index: index ?? this.index);
  }
}
