abstract class MarkDutyState {}

class MarkDutyInitial extends MarkDutyState {}

class TimeUpdatedState extends MarkDutyState {
  final String formattedTime;

  TimeUpdatedState(this.formattedTime);
}

class MarkedInState extends MarkDutyState {}

class MarkedOutState extends MarkDutyState {}
