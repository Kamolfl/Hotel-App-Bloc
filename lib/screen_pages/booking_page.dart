import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_app_bloc/models/booking_model.dart';
import '../bloc/booking_bloc/booking_bloc.dart';
import '../components/custom_button.dart';
import '../models/tourist_info_model.dart';
import '../services/hotel_api.dart';
import '../utils/phone_input_formatter.dart';
import 'paid_for_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final hotelApi = HotelApi();
  int? price;
  final _formKey = GlobalKey<FormState>();
  final Map<TextEditingController, bool> _controllerValidation = {};
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = true;
  final List<bool> _isVisibleList = [false];
  List<TouristInfoModel> tourists = [];
  final FocusNode _focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    tourists.add(TouristInfoModel());
    _focusNode.addListener(_focusChanged);
  }

  void _focusChanged() {
    if (_focusNode.hasFocus && _phoneController.text.isEmpty){
      _phoneController.text = '(***) ***-**-**';
      _phoneController.selection = const TextSelection.collapsed(offset: 1);
    } else if (_focusNode.hasFocus && _phoneController.text == '(***) ***-**-**') {
      _phoneController.clear();
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var tourist in tourists) {
      tourist.dispose();
    }
    _focusNode.removeListener(_focusChanged);
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingErrorState) {
            return const Center(child: Icon(Icons.error, size: 150));
          }
          if (state is BookingSuccessState) {
            int tourPrice = state.bookingModel.tourPrice ?? 0;
            int fuelCharge = state.bookingModel.fuelCharge ?? 0;
            int serviceCharge = state.bookingModel.serviceCharge ?? 0;
            price = tourPrice + fuelCharge + serviceCharge;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  _myAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _blockWithTheNumber(state.bookingModel),
                          _theBlockWithTheReservationData(state.bookingModel),
                          _aBlockWithInformationAboutTheBuyer(),
                          _tourists(),
                          _addTourists(),
                          _theBlockWithTheFinalPrice(state.bookingModel),
                          CustomButton(onPressed: () {
                            bool isFormValid = _formKey.currentState!.validate();
                            bool isPhoneValid = PhoneInputFormatter().isPhoneValid(_phoneController.text);
                            bool areAllTouristsFieldsValid = _controllerValidation.values.every((isValid) => isValid);
                            if (isFormValid && _isEmailValid && areAllTouristsFieldsValid && isPhoneValid) {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PaidForPage()));
                            } else {
                              String errorMessage = 'Данные необходимо заполнить.';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                ),
                              );
                            }
                          }, text: 'Оплатить $price ₽'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                }
            ),
            const Text(
              'Бронирование',
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

  Widget _blockWithTheNumber(BookingModel hotelBookingData) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          // height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
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
                      Text('${hotelBookingData.horating} ${hotelBookingData.ratingName}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFC800)))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Steigenberger Makadi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    foregroundColor: Colors.blue,
                  ), child: Text('${hotelBookingData.hotelAdress}'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _theBlockWithTheReservationData(BookingModel hotelBookingData) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bookingDataRow('Вылет из', hotelBookingData.departure),
                Row(
                  children: [
                    const Text('Страна, город    ', style: TextStyle(color: Color(0x7F828796), fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    Expanded(child: Text('${hotelBookingData.arrivalCountry}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.start)),
                  ],
                ),
                _bookingDataRow('Даты', '${hotelBookingData.tourDateStart} – ${hotelBookingData.tourDateStop}'),
                _bookingDataRow('Кол-во ночей', hotelBookingData.numberOfNights),
                _bookingDataRow('Отель', 'Steigenberger Makadi'),
                _bookingDataRow('Номер', hotelBookingData.room),
                _bookingDataRow('Питание', hotelBookingData.nutrition),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _aBlockWithInformationAboutTheBuyer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text('Информация о покупателе', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF6F6F9),
                // color: const Color(0x00eb5757).withOpacity(0.15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _phoneController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [PhoneInputFormatter()],
                  decoration: const InputDecoration(
                    prefixText: '+7 ',
                    labelText: 'Номер телефона',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA9ABB7),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              // width: MediaQuery.of(context).size.width * 0.9,
              // height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _isEmailValid ? const Color(0xFFF6F6F9) : const Color(0x00eb5757).withOpacity(0.15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Почта',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA9ABB7),
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    final regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                    bool isValid = value != null && value.isNotEmpty && regex.hasMatch(value);
                    setState(() {
                      _isEmailValid = isValid;
                    });
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Эти данные никому не передаются. После оплаты мы вышли чек на указанный вами номер и почту', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF828796))),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _tourists() {
    const List<String> numbers = ['Первый', 'Второй', 'Третий', 'Четвертый', 'Пятый', 'Шестой', 'Седьмой',
      'Восьмой', 'Девятый', 'Десятый', 'Одиннадцатый', 'Двенадцатый', 'Тринадцатый', 'Четырнадцатый',
      'Пятнадцатый', 'Шестнадцатый', 'Семнадцатый', 'Восемнадцатый', 'Девятнадцатый', 'Двадцатый'];
    return Column(
      children: List.generate(tourists.length, (index) {
        String touristLabel;
        if (index < numbers.length) {
          touristLabel = '${numbers[index]} турист';
        } else {
          int numericLabel = index + 1;
          touristLabel = '$numericLabel турист';
        }
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(touristLabel, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isVisibleList[index] = !_isVisibleList[index];
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFF0D72FF).withOpacity(0.1),
                            ),
                            child: Icon(_isVisibleList[index] ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF0D72FF)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Offstage(
                offstage: _isVisibleList[index],
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _touristData('Имя', tourists[index].nameController),
                      const SizedBox(height: 10),
                      _touristData('Фамилия', tourists[index].surNameController),
                      const SizedBox(height: 10),
                      _touristData('Дата рождения', tourists[index].dateOfBirthController),
                      const SizedBox(height: 10),
                      _touristData('Гражданство', tourists[index].citizenshipController),
                      const SizedBox(height: 10),
                      _touristData('Номер загранпаспорта', tourists[index].passportNumberController),
                      const SizedBox(height: 10),
                      _touristData('Срок действия загранпаспорта', tourists[index].validPeriodPassportController),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      }),
    );
  }

  Widget _touristData(String title, TextEditingController controller) {
    _controllerValidation.putIfAbsent(controller, () => true);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _controllerValidation[controller]! ? const Color(0xFFF6F6F9) : const Color(0x00eb5757).withOpacity(0.15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          controller: controller,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: title,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFFA9ABB7),
            ),
            border: InputBorder.none,
          ),
          validator: (value) {
            bool isValid = value != null && value.isNotEmpty;
            _controllerValidation[controller] = isValid;
            setState(() {});
            return null;
          },
        ),
      ),
    );
  }

  Widget _addTourists() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Добавить туриста', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            InkWell(
              onTap: () {
                setState(() {
                  _isVisibleList.add(true);
                  tourists.add(TouristInfoModel());
                });
              },
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF0D72FF),
                  ),
                  child:  const Icon(Icons.add, color: Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _theBlockWithTheFinalPrice(BookingModel hotelBookingData) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Тур', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF828796))),
                    Padding(
                      padding: const EdgeInsets.only(right: 7.0),
                      child: Text('${hotelBookingData.tourPrice} ₽', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Топливный сбор', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF828796))),
                    Padding(
                      padding: const EdgeInsets.only(right: 7.0),
                      child: Text('${hotelBookingData.fuelCharge} ₽', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Сервисный сбор', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF828796))),
                    Padding(
                      padding: const EdgeInsets.only(right: 7.0),
                      child: Text('${hotelBookingData.serviceCharge} ₽', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('К оплате', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF828796))),
                    Padding(
                      padding: const EdgeInsets.only(right: 7.0),
                      child: Text('$price ₽', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _bookingDataRow(String title, dynamic subtitle) {
    String stringSubtitle = subtitle.toString();
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(title, style: const TextStyle(color: Color(0x7F828796), fontSize: 16, fontWeight: FontWeight.w400)),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Text(stringSubtitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.start),
        ),
      ],
    );
  }
}

