import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTextState {
  final TextEditingController controller;
  final String text;

  const SearchTextState({
    required this.controller,
    this.text = '',
  });

  SearchTextState copyWith({
    TextEditingController? controller,
    String? text,
  }) {
    return SearchTextState(
      controller: controller ?? this.controller,
      text: text ?? this.text,
    );
  }
}

class SearchTextCubit extends Cubit<SearchTextState> {
  SearchTextCubit()
      : super(SearchTextState(controller: TextEditingController()));

  void updateText(String text) {
    emit(state.copyWith(text: text));
  }

  void clearText() {
    state.controller.clear();
    emit(state.copyWith(text: ''));
  }

  @override
  Future<void> close() {
    state.controller.dispose();
    return super.close();
  }
}
