part of 'hotel_bloc.dart';

@immutable
abstract class HotelState {}

class HotelInitial extends HotelState {}

class HotelLoadingState extends HotelState {}

// ignore: must_be_immutable
class HotelSuccessState extends HotelState {
  HotelModel hotelModel;
  HotelSuccessState({required this.hotelModel});
}

class HotelErrorState extends HotelState {}