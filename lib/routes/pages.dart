import 'package:cardmap/screen/cardselection.dart';
import 'package:cardmap/screen/question.dart';
import 'package:cardmap/screen/signup.dart';
import 'package:get/route_manager.dart';

part 'routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.signup,
      page: () => const SignUpPage(),
    ),
    GetPage(
      name: Routes.cardselection,
      page: () => const CardSelection(),
    ),
    GetPage(
      name: Routes.chatscreen,
      page: () => ChatScreen(),
    ),
  ];
}
