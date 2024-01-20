import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hotel_app_bloc/models/booking_model.dart';
import 'package:hotel_app_bloc/services/hotel_api.dart';
import 'package:meta/meta.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<BookingEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<BookingLoadingDataEvent>((event, emit) async {
      emit(BookingLoadingState());
      try{
        final result = await HotelApi().getBookingData();
        emit(BookingSuccessState(bookingModel: result));
      } catch(e) {
        emit(BookingErrorState());
      }
    });
  }
}
