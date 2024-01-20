

import 'package:dio/dio.dart';
import 'package:hotel_app_bloc/models/booking_model.dart';
import 'package:hotel_app_bloc/models/hotel_model.dart';
import 'package:hotel_app_bloc/models/number_model.dart';

class HotelApi {
  Dio dio = Dio();

  Future<HotelModel> getHotelData() async {
    try{
      Response response = await dio.get('https://run.mocky.io/v3/d144777c-a67f-4e35-867a-cacc3b827473');
      final responseData =response.data;
      if (response.statusCode == 200) {
        return HotelModel.fromJson(responseData);
      } else {
        throw Exception('Не удалось загрузить данные об отеле');
      }
    } catch (e) {
      throw Exception('Не удалось загрузить данные об отеле: $e');
    }
  }

  Future<NumberModel> getNumberData() async {
    try{
      Response response = await dio.get('https://run.mocky.io/v3/8b532701-709e-4194-a41c-1a903af00195');
      final responseData = response.data;
      if (response.statusCode == 200) {
        return NumberModel.fromJson(responseData);
      } else {
        throw Exception('Не удалось загрузить данные о номерах комнат');
      }
    } catch (e) {
      throw Exception('Не удалось загрузить данные о номерах комнат: $e');
    }
  }

  Future<dynamic> getBookingData() async {
    try {
      Response response = await dio.get('https://run.mocky.io/v3/63866c74-d593-432c-af8e-f279d1a8d2ff');
      final responseData = response.data;
      if (response.statusCode == 200) {
        return BookingModel.fromJson(responseData);
      } else {
        throw Exception('Не удалось загрузить данные об бронирование номере отела');
      }
    } catch(e) {
      throw Exception('Не удалось загрузить данные об бронирование номере отела: $e');
    }
  }
}