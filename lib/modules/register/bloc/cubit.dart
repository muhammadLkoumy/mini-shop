import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/login_model.dart';
import 'package:shop/models/register_model.dart';
import 'package:shop/modules/register/bloc/states.dart';
import 'package:shop/shared/network/remote/dio.dart';
import 'package:shop/shared/network/remote/end_points.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool visibility = true;

  void changeVisibility() {
    visibility = !visibility;
    emit(ChangeVisibilityState());
  }

  RegisterModel? userRegisterModel;

  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String name,
  }) {
    emit(UserRegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        'email': email,
        'password': password,
        'phone': phone,
        'name': name,
        'image':'',
      },
    ).then((value) {
      userRegisterModel = RegisterModel.fromJson(value.data);
      emit(UserRegisterSuccessState(userRegisterModel!));
    }).catchError((error) {
      print(error);
      emit(UserRegisterErrorState(error.toString()));
    });
  }
}
