import 'package:cardmap/screen/signup.dart';
import 'package:get/route_manager.dart';

part 'routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.signup,
      page: () => SignUpPage(),
    ),
  ];
}
