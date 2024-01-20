import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_app_bloc/bloc/number_bloc/number_bloc.dart';
import 'package:hotel_app_bloc/models/hotel_model.dart';
import 'package:hotel_app_bloc/screen_pages/number_page.dart';
import '../bloc/hotel_bloc/hotel_bloc.dart';
import '../components/custom_button.dart';
import '../services/hotel_api.dart';

class HotelPage extends StatefulWidget {
  const HotelPage({super.key});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  final hotelApi = HotelApi();
  int currentPage = 0;

  @override
  void initState() {
    BlocProvider.of<HotelBloc>(context).add(HotelDataLoadingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      body: BlocBuilder<HotelBloc, HotelState>(
  builder: (context, state) {
    if (state is HotelSuccessState) {
      return SingleChildScrollView(
        child: Column(
          children: [
            _carouselOfPhotos(state.hotelModel),
            _detailInformationHotel(state.hotelModel),
            CustomButton(onPressed: () {
              BlocProvider.of<NumberBloc>(context).add(NumberLoadingDataEvent());
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NumberPage()));
            },
                text: 'К выбору номера'
            ),
          ],
        ),
      );
    }
    if (state is HotelErrorState) {
      return const Center(child: Icon(Icons.error, size: 150));
    }
    return const Center(child: CircularProgressIndicator());
  },
),
    );
  }

  Widget _carouselOfPhotos(HotelModel hotelData) {
    double sidePadding = MediaQuery.of(context).size.width * 0.05;
    double imageWidth = MediaQuery.of(context).size.width * 0.9;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Отель', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Container(
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
                      itemCount: hotelData.imageUrls?.length,
                      onPageChanged: (int page) {
                        setState(() {
                          currentPage = page;
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              hotelData.imageUrls![index],
                              key: UniqueKey(),
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                                }
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
                          children:
                          List.generate(hotelData.imageUrls!.length, (index) => _buildDot(index, context)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.04,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFFFFC700).withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFC800), size: 15),
                      Text(' ${hotelData.rating} ${hotelData.ratingName}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFC800)))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Steigenberger Makadi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                TextButton(
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    foregroundColor: Colors.blue,
                  ),

                  onPressed: () {},
                  child: Text('${hotelData.adress}'),
                ),
                Row(
                  children: [
                    Text('от ${hotelData.minimalPrice} ₽ ', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                    Text('${hotelData.priceForIt}')
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _detailInformationHotel(HotelModel hotelData) {
    double sidePadding = MediaQuery.of(context).size.width * 0.05;
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Об отеле', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xFFFBFBFC),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${hotelData.aboutTheHotel?.peculiarities?[3]}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF828796))),
                        )),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xFFFBFBFC),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${hotelData.aboutTheHotel?.peculiarities?[1]}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF828796))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFFFBFBFC),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${hotelData.aboutTheHotel?.peculiarities?[2]}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF828796))),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFFFBFBFC),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${hotelData.aboutTheHotel?.peculiarities?[0]}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF828796))),
                  ),
                ),
                const SizedBox(height: 10),
                Text('${hotelData.aboutTheHotel?.description}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFFBFBFC),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildInfoContainer('assets/images/emoji-happy.png', 'Удобства', 'Самое необходимое'),
                      const SizedBox(height: 10),
                      _dash(),
                      const SizedBox(height: 10),
                      _buildInfoContainer('assets/images/tick-square.png', 'Что включено', 'Самое необходимое'),
                      const SizedBox(height: 10),
                      _dash(),
                      const SizedBox(height: 10),
                      _buildInfoContainer('assets/images/close-square.png', 'Что не включено', 'Самое необходимое'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInfoContainer(String assetName, String title, String subtitle) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.83,
      height: MediaQuery.of(context).size.height * 0.065,
      child: Row(
        children: [
          Image.asset(assetName),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF828796))),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_outlined),
        ],
      ),
    );
  }

  Widget _dash() {
    return Padding(
      padding: const EdgeInsets.only(left: 44),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: 1,
        color: const Color(0xFF828796).withOpacity(0.15),
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(duration: const Duration(milliseconds: 200),
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
