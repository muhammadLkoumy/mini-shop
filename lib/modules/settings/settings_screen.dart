import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/modules/login/screen/login_screen.dart';
import 'package:shop/modules/on_boarding/screen.dart';
import 'package:shop/shared/components/component.dart';
import 'package:shop/shared/network/local/local.dart';

import '../../layout/cubit/shop_cubit.dart';
import '../../layout/cubit/shop_states.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {

        // check for null values
        nameController.text = ShopCubit.get(context).userModel != null? ShopCubit.get(context).userModel!.data!.name! : 'Name';
        emailController.text = ShopCubit.get(context).userModel != null? ShopCubit.get(context).userModel!.data!.email! : 'Email';
        phoneController.text = ShopCubit.get(context).userModel != null? ShopCubit.get(context).userModel!.data!.phone! : 'Phone';

        return BuildCondition(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (state is UpdateUserLoadingState)
                    const LinearProgressIndicator(
                      color: Colors.orange,
                    ),
                  _inputFields(),
                  _buttons(context),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Learn more? ',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      TextButton(
                        onPressed: () {
                          navigateTo(
                            context,
                            const OnBoarding(),
                          );
                        },
                        child: const Text(
                          'Take a tour',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Rowdies'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(
            child: Lottie.asset('assets/animation/circular.json'),
          ),
        );
      },
    );
  }

  Widget _inputFields() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person),
            label: Text('User Name'),
            border: OutlineInputBorder(),
          ),
          controller: nameController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return "Username mustn't be empty!";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email),
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
          height: 15,
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.phone),
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
          height: 15,
        ),
      ],
    );
  }

  Widget _buttons(context) {
    return Column(
      children: [
        Container(
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
              'update'.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Rowdies',
              ),
            ),
            onPressed: () {
              ShopCubit.get(context).updateUser(
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
              );
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
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
              'logout'.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Rowdies',
              ),
            ),
            onPressed: () {
              CacheHelper.removeData(key: 'token').then((value) {
                navigateAndFinish(context, LoginScreen());
              });
            },
          ),
        ),
      ],
    );
  }
}
