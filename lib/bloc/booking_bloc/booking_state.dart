part of 'booking_bloc.dart';

@immutable
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoadingState extends BookingState {}

// ignore: must_be_immutable
class BookingSuccessState extends BookingState {
  BookingModel bookingModel;
  BookingSuccessState({required this.bookingModel});
}

class BookingErrorState extends BookingState {}