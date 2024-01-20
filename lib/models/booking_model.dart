class BookingModel {
  int? id;
  String? hotelName;
  String? hotelAdress;
  int? horating;
  String? ratingName;
  String? departure;
  String? arrivalCountry;
  String? tourDateStart;
  String? tourDateStop;
  int? numberOfNights;
  String? room;
  String? nutrition;
  int? tourPrice;
  int? fuelCharge;
  int? serviceCharge;

  BookingModel(
      {this.id,
        this.hotelName,
        this.hotelAdress,
        this.horating,
        this.ratingName,
        this.departure,
        this.arrivalCountry,
        this.tourDateStart,
        this.tourDateStop,
        this.numberOfNights,
        this.room,
        this.nutrition,
        this.tourPrice,
        this.fuelCharge,
        this.serviceCharge});

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotelName = json['hotel_name'];
    hotelAdress = json['hotel_adress'];
    horating = json['horating'];
    ratingName = json['rating_name'];
    departure = json['departure'];
    arrivalCountry = json['arrival_country'];
    tourDateStart = json['tour_date_start'];
    tourDateStop = json['tour_date_stop'];
    numberOfNights = json['number_of_nights'];
    room = json['room'];
    nutrition = json['nutrition'];
    tourPrice = json['tour_price'];
    fuelCharge = json['fuel_charge'];
    serviceCharge = json['service_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hotel_name'] = this.hotelName;
    data['hotel_adress'] = this.hotelAdress;
    data['horating'] = this.horating;
    data['rating_name'] = this.ratingName;
    data['departure'] = this.departure;
    data['arrival_country'] = this.arrivalCountry;
    data['tour_date_start'] = this.tourDateStart;
    data['tour_date_stop'] = this.tourDateStop;
    data['number_of_nights'] = this.numberOfNights;
    data['room'] = this.room;
    data['nutrition'] = this.nutrition;
    data['tour_price'] = this.tourPrice;
    data['fuel_charge'] = this.fuelCharge;
    data['service_charge'] = this.serviceCharge;
    return data;
  }
}
