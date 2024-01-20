import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hotel_app_bloc/models/hotel_model.dart';
import 'package:hotel_app_bloc/services/hotel_api.dart';
import 'package:meta/meta.dart';

part 'hotel_event.dart';
part 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  HotelBloc() : super(HotelInitial()) {
    on<HotelEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<HotelDataLoadingEvent>((event, emit) async {
      emit(HotelLoadingState());
      try {
        final result = await HotelApi().getHotelData();
        emit(HotelSuccessState(hotelModel: result));
      } catch(e) {
        emit(HotelErrorState());
      }
    });
  }
}
