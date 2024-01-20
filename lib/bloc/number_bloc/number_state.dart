part of 'number_bloc.dart';

@immutable
abstract class NumberState {}

class NumberInitial extends NumberState {}

class NumberLoadingState extends NumberState {}

// ignore: must_be_immutable
class NumberSuccessState extends NumberState {
  NumberModel numberModel;
  NumberSuccessState({required this.numberModel});
}

class NumberErrorState extends NumberState {}