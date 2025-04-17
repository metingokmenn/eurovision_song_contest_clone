import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabAnimationState {
  final TabController? tabController;
  final int currentIndex;

  const TabAnimationState({
    this.tabController,
    this.currentIndex = 0,
  });

  TabAnimationState copyWith({
    TabController? tabController,
    int? currentIndex,
  }) {
    return TabAnimationState(
      tabController: tabController ?? this.tabController,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class TabAnimationCubit extends Cubit<TabAnimationState> {
  TabController? _tabController;
  final int tabCount;

  TabAnimationCubit({this.tabCount = 4}) : super(const TabAnimationState());

  void initializeTabController(TickerProvider vsync) {
    _tabController = TabController(
      length: tabCount,
      vsync: vsync,
    );

    _tabController!.addListener(_handleTabChange);

    emit(state.copyWith(
      tabController: _tabController,
    ));
  }

  void _handleTabChange() {
    if (_tabController != null && _tabController!.indexIsChanging) {
      emit(state.copyWith(
        currentIndex: _tabController!.index,
      ));
    }
  }

  void animateToTab(int index) {
    if (_tabController != null) {
      _tabController!.animateTo(index);
      emit(state.copyWith(currentIndex: index));
    }
  }

  @override
  Future<void> close() {
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();
    return super.close();
  }
}
