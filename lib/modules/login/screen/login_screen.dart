import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/screen/home_page.dart';
import 'package:shop/modules/login/bloc/cubit.dart';
import 'package:shop/modules/login/bloc/states.dart';
import 'package:shop/modules/register/register_screen.dart';
import 'package:shop/shared/components/component.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/local/local.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is UserLoginSuccessState) {
          if (state.userLoginModel.status!) {
            TOKEN = state.userLoginModel.data!.token!;
            CacheHelper.setData(
                    key: 'token', value: state.userLoginModel.data!.token)
                .then((value) {
              if (value) {
                navigateAndFinish(context, const HomePage());
                // toast(
                //     message: state.userLoginModel.message!,
                //     state: ToastState.SUCCESS);
              }
            });
          } else {
            // toast(
            //     message: state.userLoginModel.message!,
            //     state: ToastState.ERROR);
          }
        }
      },
      builder: (context, state) {
        var cubit = LoginCubit.get(context);

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'login'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          fontFamily: 'Rowdies',
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      _inputFields(cubit),
                      const SizedBox(
                        height: 12,
                      ),
                      BuildCondition(
                        condition: state is! UserLoginLoadingState,
                        builder: (context) => _loginButton(cubit),
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      _bottomRow(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _inputFields(LoginCubit cubit) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            label: Text('Email'),
            border: OutlineInputBorder(),
          ),
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return "Email mustn't be empty!";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_open),
            suffixIcon: IconButton(
              onPressed: () {
                cubit.changeVisibility();
              },
              icon: Icon(
                cubit.visibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
            label: const Text('Password'),
            border: const OutlineInputBorder(),
          ),
          obscureText: cubit.visibility,
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value!.isEmpty || value.contains('/') || value.contains('-')) {
              return "Password mustn't be empty!";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _loginButton(LoginCubit cubit) {
    return Container(
      width: double.infinity,
      height: 45,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: MaterialButton(
        color: Colors.black87,
        height: 45,
        child: Text(
          'login'.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'Rowdies',
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            cubit.userLogin(
              email: emailController.text,
              password: passwordController.text,
            );
          }
        },
      ),
    );
  }

  Widget _bottomRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have account?",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'Ubuntu',
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        TextButton(
          onPressed: () {
            navigateTo(context, RegisterScreen());
          },
          child: const Text(
            'register now',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'Rowdies',
            ),
          ),
        ),
      ],
    );
  }
}
