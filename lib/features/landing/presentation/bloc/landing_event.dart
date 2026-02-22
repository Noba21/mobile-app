part of 'landing_bloc.dart';

abstract sealed class LandingEvent extends Equatable {
  const LandingEvent();

  @override
  List<Object?> get props => [];
}

final class LandingLoadRequested extends LandingEvent {
  const LandingLoadRequested();
}
