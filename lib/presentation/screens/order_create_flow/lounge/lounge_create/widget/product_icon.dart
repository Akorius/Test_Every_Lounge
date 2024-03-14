import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductIcon extends StatelessWidget {
  ProductIcon({
    Key? key,
    required this.product,
  }) : super(key: key);

  final String product;

  final productImagesMap = {
    "air-condition": AppImages.airCondition,
    "alcohol-drink": AppImages.alcDrink,
    "biz-zone": AppImages.bizZone,
    "electrical-socket": AppImages.electricalSocket,
    "internet": AppImages.internet,
    "limited-people": AppImages.limitedPeople,
    "luggage-packing": AppImages.luggagePacking,
    "meal": AppImages.meal,
    "playroom": AppImages.playroom,
    "press": AppImages.press,
    "registration": AppImages.registration,
    "shower": AppImages.shower,
    "transfer": AppImages.transfer,
    "tv": AppImages.tv,
    "wardrobe": AppImages.wardrobe,
    "announcements": AppImages.announcements,
    "baby-changing": AppImages.babyChanging,
    "champagne": AppImages.champagne,
    "cocktails": AppImages.cocktails,
    "conference-hall": AppImages.conferenceHall,
    "entertainment-area": AppImages.entertainmentArea,
    "fax": AppImages.fax,
    "flight-time": AppImages.flightTime,
    "fruits": AppImages.fruits,
    "hot-dishes": AppImages.hotDishes,
    "laptop": AppImages.laptop,
    "luggage-storage": AppImages.luggageStorage,
    "massage-chair": AppImages.massageChair,
    "menu": AppImages.menu,
    "nail-polish": AppImages.nailPolish,
    "phone": AppImages.phoneLounge,
    "prayer-room": AppImages.prayerRoom,
    "printer": AppImages.printer,
    "runway-view": AppImages.runwayView,
    "salad": AppImages.salad,
    "security-check": AppImages.securityCheck,
    "sleeping-places": AppImages.sleepingPlaces,
    "smoking-area": AppImages.smokingArea,
    "snacks": AppImages.snacks,
    "sofa": AppImages.sofa,
    "spa": AppImages.spa,
    "vegan": AppImages.vegan,
    "wc": AppImages.wc,
    "wifi": AppImages.wifi,
  };

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(productImagesMap[product] ?? AppImages.close);
  }
}
