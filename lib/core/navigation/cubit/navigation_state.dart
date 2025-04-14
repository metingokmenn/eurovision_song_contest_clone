class NavigationState {
  final int index;
  final Map<String, dynamic>? data;

  const NavigationState({this.index = 0, this.data});

  NavigationState copyWith({int? index, Map<String, dynamic>? data}) {
    return NavigationState(
      index: index ?? this.index,
      data: data ?? this.data,
    );
  }
}
