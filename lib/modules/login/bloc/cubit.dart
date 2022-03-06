import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/login_model.dart';
import 'package:shop/modules/login/bloc/states.dart';
import 'package:shop/shared/network/remote/dio.dart';
import 'package:shop/shared/network/remote/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool visibility = true;

  void changeVisibility() {
    visibility = !visibility;
    emit(ChangeVisibilityState());
  }

  late UserLoginModel userLoginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(UserLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      userLoginModel = UserLoginModel.fromJson(value.data);
      emit(UserLoginSuccessState(userLoginModel));
    }).catchError((error) {
      print(error.toString());
      emit(UserLoginErrorState(error.toString()));
    });
  }
}
