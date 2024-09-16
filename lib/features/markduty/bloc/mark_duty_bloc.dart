import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'mark_duty_event.dart';
import 'mark_duty_state.dart';

class MarkDutyBloc extends Bloc<MarkDutyEvent, MarkDutyState> {
  Timer? _timer;

  MarkDutyBloc() : super(MarkDutyInitial()) {
    on<LoadTimeEvent>(_onLoadTime);
    on<MarkInEvent>(_onMarkIn);
    on<MarkOutEvent>(_onMarkOut);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(LoadTimeEvent());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onLoadTime(LoadTimeEvent event, Emitter<MarkDutyState> emit) {
    final String formattedTime = DateFormat('dd-MMM-yyyy hh:mm a').format(DateTime.now());
    emit(TimeUpdatedState(formattedTime));
  }

  void _onMarkIn(MarkInEvent event, Emitter<MarkDutyState> emit) {
    emit(MarkedInState());
  }

  void _onMarkOut(MarkOutEvent event, Emitter<MarkDutyState> emit) {
    emit(MarkedOutState());
  }
}
