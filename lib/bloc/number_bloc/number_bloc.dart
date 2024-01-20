import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hotel_app_bloc/models/number_model.dart';
import 'package:hotel_app_bloc/services/hotel_api.dart';
import 'package:meta/meta.dart';

part 'number_event.dart';
part 'number_state.dart';

class NumberBloc extends Bloc<NumberEvent, NumberState> {
  NumberBloc() : super(NumberInitial()) {
    on<NumberEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<NumberLoadingDataEvent>((event, emit) async {
      emit(NumberLoadingState());
      try{
        final result = await HotelApi().getNumberData();
        emit(NumberSuccessState(numberModel: result));
      } catch(e) {
        emit(NumberErrorState());
      }
    });
  }
}
