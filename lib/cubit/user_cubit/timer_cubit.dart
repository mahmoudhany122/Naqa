import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeState {
  final Duration duration;
  final int messageIndex;
  HomeState({required this.duration, required this.messageIndex});
}

class HomeCubit extends Cubit<HomeState> {
  late Timer timer;
  final List<String> motivationMessages;

  HomeCubit({required this.motivationMessages})
      : super(HomeState(duration: Duration(), messageIndex: 0)) {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      final newDuration = state.duration + Duration(seconds: 1);
      int newIndex = state.messageIndex;
      if (newDuration.inSeconds % 10 == 0) {
        newIndex = (state.messageIndex + 1) % motivationMessages.length;
      }
      emit(HomeState(duration: newDuration, messageIndex: newIndex));
    });
  }

  @override
  Future<void> close() {
    timer.cancel();
    return super.close();
  }
}
