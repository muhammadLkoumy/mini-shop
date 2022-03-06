import 'package:shop/models/register_model.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class ChangeVisibilityState extends RegisterStates {}

class UserRegisterLoadingState extends RegisterStates {}
class UserRegisterSuccessState extends RegisterStates {
  RegisterModel userRegisterModel;
  UserRegisterSuccessState(this.userRegisterModel);
}
class UserRegisterErrorState extends RegisterStates {
  final String error;
  UserRegisterErrorState(this.error);
}