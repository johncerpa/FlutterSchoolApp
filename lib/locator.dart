import 'package:get_it/get_it.dart';
import 'package:login/services/api.dart';
import 'package:login/services/authentication_service.dart';
import 'package:login/services/courses_service.dart';
import 'package:login/services/person_service.dart';
import 'package:login/viewmodels/course_details.dart';
import 'package:login/viewmodels/home.dart';
import 'package:login/viewmodels/login.dart';
import 'package:login/viewmodels/person_details.dart';
import 'package:login/viewmodels/signup.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => CourseService());
  locator.registerLazySingleton(() => PersonService());
  locator.registerLazySingleton(() => Api());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => SignUpModel());
  locator.registerFactory(() => CourseViewModel());
  locator.registerFactory(() => PersonViewModel());
}
