import 'package:shop/models/login_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class ChangeVisibilityState extends LoginStates {}

class UserLoginLoadingState extends LoginStates {}
class UserLoginSuccessState extends LoginStates {
  UserLoginModel userLoginModel;
  UserLoginSuccessState(this.userLoginModel);
}
class UserLoginErrorState extends LoginStates {
  final String error;
  UserLoginErrorState(this.error);
}