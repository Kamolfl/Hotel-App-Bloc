part of 'booking_bloc.dart';

@immutable
abstract class BookingEvent {}

class BookingLoadingDataEvent extends BookingEvent {}