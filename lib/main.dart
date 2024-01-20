import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_app_bloc/bloc/booking_bloc/booking_bloc.dart';
import 'package:hotel_app_bloc/screen_pages/hotel_page.dart';

import 'bloc/hotel_bloc/hotel_bloc.dart';
import 'bloc/number_bloc/number_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HotelBloc(),
        ),
        BlocProvider(
          create: (context) => NumberBloc(),
        ),
        BlocProvider(create: (context) => BookingBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ),
        home: const HotelPage(),
      ),
    );
  }
}

