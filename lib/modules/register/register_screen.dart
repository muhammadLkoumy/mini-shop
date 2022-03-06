import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/screen/home_page.dart';
import 'package:shop/modules/register/bloc/cubit.dart';
import 'package:shop/modules/register/bloc/states.dart';
import 'package:shop/shared/components/component.dart';
import 'package:shop/shared/network/local/local.dart';
import '../../shared/components/constants.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is UserRegisterSuccessState) {
          if (state.userRegisterModel.status!) {
            CacheHelper.setData(
                    key: 'token', value: state.userRegisterModel.data!.token)
                .then((value) {
              // to initialize token for the first time
              TOKEN = state.userRegisterModel.data!.token!;
              if (value) {
                navigateAndFinish(
                  context,
                  const HomePage(),
                );
                toast(
                  message: state.userRegisterModel.message!,
                  state: ToastState.SUCCESS,
                );
              }
            });
          } else {
            toast(
              message: state.userRegisterModel.message!,
              state: ToastState.ERROR,
            );
          }
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Transform.translate(
                  offset: const Offset(0, 0),
                  child: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black87,
                  ),
                )),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'register'.toUpperCase(),
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
                        condition: state is UserRegisterLoadingState,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        fallback: (context) => _registerButton(context),
                      ),
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

  Widget _inputFields(RegisterCubit cubit) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person),
            label: Text('Name'),
            border: OutlineInputBorder(),
          ),
          controller: nameController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return "Name mustn't be empty!";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 12,
        ),
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
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.phone_android),
            label: Text('Phone'),
            border: OutlineInputBorder(),
          ),
          controller: phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value!.isEmpty) {
              return "Phone mustn't be empty!";
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
            if (value!.isEmpty) {
              return "Password mustn't be empty!";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _registerButton(context) {
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
          'register'.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'Rowdies',
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            RegisterCubit.get(context).userRegister(
              email: emailController.text,
              password: passwordController.text,
              phone: phoneController.text,
              name: nameController.text,
            );
          }
        },
      ),
    );
  }
}
