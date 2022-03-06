import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:shop/models/categories_model.dart';
import 'package:shop/shared/components/component.dart';

import '../../layout/cubit/shop_cubit.dart';
import '../../layout/cubit/shop_states.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {

          var _cubit = ShopCubit.get(context);

          return BuildCondition(
            condition: _cubit.categoriesModel != null,
            builder: (context) => ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => _categoryItem(_cubit.categoriesModel!.data!.elements[index], context),
              separatorBuilder: (context, index) => separator(),
              itemCount: _cubit.categoriesModel!.data!.elements.length,
            ),
            fallback: (context) => Center(child: Lottie.asset('assets/animation/circular.json')),
          );
        },
    );
  }

  Widget _categoryItem(CategoryElement model, context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image(
              image: NetworkImage('${model.image}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${model.name}',
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 24,),
        ],
      ),
    );
  }
}
