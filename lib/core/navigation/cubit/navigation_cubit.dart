import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void updateIndex(int index, {Map<String, dynamic>? data}) {
    emit(state.copyWith(index: index, data: data));
  }

  void updateData(Map<String, dynamic> data) {
    emit(state.copyWith(data: {...?state.data, ...data}));
  }

  dynamic getData(String key) {
    return state.data?[key];
  }

  void clearData() {
    emit(state.copyWith(data: {}));
  }
}
