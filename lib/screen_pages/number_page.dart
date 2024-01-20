import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_app_bloc/bloc/booking_bloc/booking_bloc.dart';
import 'package:hotel_app_bloc/models/number_model.dart';

import '../bloc/number_bloc/number_bloc.dart';
import '../components/custom_button.dart';
import '../services/hotel_api.dart';
import 'booking_page.dart';

class NumberPage extends StatefulWidget {
  const NumberPage({super.key});

  @override
  State<NumberPage> createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
  final hotelApi = HotelApi();
  int currentPage1 = 0;
  int currentPage2 = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      body: BlocBuilder<NumberBloc, NumberState>(
        builder: (context, state) {
          if (state is NumberErrorState) {
            return const Center(child: Icon(Icons.error, size: 150,));
          } if (state is NumberSuccessState) {
            return Column(
              children: [
                _myAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _blockWithTheNumber1(state.numberModel),
                        _blockWithTheNumber2(state.numberModel),
                      ],
                    ),
                  ),
                ),
              ],
            );

          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _myAppBar() {
    return SafeArea(
      bottom: false,
      child: Container(
        color: Colors.white,
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pop(context);
                }),
            const Text(
              'Steigenberger Makadi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Opacity(
              opacity: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined),
                onPressed: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blockWithTheNumber1(NumberModel numberData) {
    double sidePadding = MediaQuery.of(context).size.width * 0.05;
    double imageWidth = MediaQuery.of(context).size.width * 0.9;
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  width: imageWidth,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey,
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                          itemCount:
                          numberData.rooms?[0].imageUrls?.length,
                          onPageChanged: (int page) {
                            setState(() {
                              currentPage1 = page;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  numberData.rooms![0].imageUrls![index],
                                  key: UniqueKey(),
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ));
                                    }
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Container(
                                      width: imageWidth,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.blueGrey,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Изображение отсутствует',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                ));
                          }),
                      Positioned(
                        bottom: 10,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.02,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  numberData.rooms![0].imageUrls!.length,
                                      (index) => _buildDot(index, context, currentPage1)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('${numberData.rooms?[0].name}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFFBFBFC),
                        ),
                        child: Center(
                            child: Text(
                                '${numberData.rooms?[0].peculiarities?[0]}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF828796)))),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFFBFBFC),
                        ),
                        child: Center(
                            child: Text(
                                '${numberData.rooms?[0].peculiarities?[1]}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF828796)))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 29,
                    // width: 200,
                    width: MediaQuery.of(context).size.width * 0.58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF0D72FF).withOpacity(0.1),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Подробнее о номере',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0D72FF))),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_ios_outlined,
                            color: Color(0xFF0D72FF))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('${numberData.rooms?[0].price} ₽ ',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500)),
                    Text('${numberData.rooms?[0].pricePer}',
                        style: const TextStyle(color: Color(0xFF828796)))
                  ],
                ),
                CustomButton(
                    onPressed: () {
                      BlocProvider.of<BookingBloc>(context).add(BookingLoadingDataEvent());
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BookingPage()));
                    },
                    text: 'Выбрать номер'),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _blockWithTheNumber2(NumberModel numberData) {
    double sidePadding = MediaQuery.of(context).size.width * 0.05;
    double imageWidth = MediaQuery.of(context).size.width * 0.9;
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  width: imageWidth,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey,
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                          itemCount:
                          numberData.rooms?[1].imageUrls?.length,
                          onPageChanged: (int page) {
                            setState(() {
                              currentPage2 = page;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  numberData.rooms![1].imageUrls![index],
                                  key: UniqueKey(),
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ));
                                    }
                                  },
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    return Container(
                                      width: imageWidth,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.blueGrey,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Изображение отсутствует',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  },
                                ));
                          }),
                      Positioned(
                        bottom: 10,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.02,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  numberData.rooms![1].imageUrls!.length,
                                      (index) => _buildDot(index, context, currentPage2)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text('${numberData.rooms?[1].name}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.37,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFFBFBFC),
                        ),
                        child: Center(
                            child: Text(
                                '${numberData.rooms?[1].peculiarities?[0]}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF828796)))),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFFBFBFC),
                        ),
                        child: Center(
                            child: Text(
                                '${numberData.rooms?[1].peculiarities?[1]}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF828796)))),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.54,
                        height: MediaQuery.of(context).size.height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFFBFBFC),
                        ),
                        child: Center(
                            child: Text(
                                '${numberData.rooms?[1].peculiarities?[2]}',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF828796)))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 29,
                    // width: 200,
                    width: MediaQuery.of(context).size.width * 0.58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF0D72FF).withOpacity(0.1),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Подробнее о номере',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0D72FF))),
                        SizedBox(width: 5),
                        Icon(Icons.arrow_forward_ios_outlined,
                            color: Color(0xFF0D72FF))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('${numberData.rooms?[1].price} ₽ ',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500)),
                    Text('${numberData.rooms?[1].pricePer}',
                        style: const TextStyle(color: Color(0xFF828796)))
                  ],
                ),
                CustomButton(
                    onPressed: () {
                      BlocProvider.of<BookingBloc>(context).add(BookingLoadingDataEvent());
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BookingPage()));
                    },
                    text: 'Выбрать номер'),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index, BuildContext context, int currentPage) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
