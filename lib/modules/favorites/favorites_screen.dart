import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:shop/models/favorites_model.dart';
import 'package:shop/shared/components/component.dart';

import '../../layout/cubit/shop_cubit.dart';
import '../../layout/cubit/shop_states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = ShopCubit.get(context);

        return BuildCondition(
          condition: _cubit.favoritesModel == null ||
              _cubit.favoritesModel!.data!.favorites!.isEmpty,
          builder: (context) => Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .50,
                    height: MediaQuery.of(context).size.height * .3,

                    // this animation will start when favorite list is empty
                    child: Lottie.asset('assets/animation/empty.json'),
                  ),
                  const Text(
                    'No favorite Items yet!',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Ubuntu',
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => ListView.separated(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => _product(
                _cubit.favoritesModel!.data!.favorites![index].product!,
                context),
            separatorBuilder: (context, index) => separator(),
            itemCount: _cubit.favoritesModel!.data!.favorites!.length,
          ),
        );
      },
    );
  }

  Widget _product(FavoriteProduct model, context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  image: NetworkImage(
                    '${model.image}',
                  ),
                  height: 100,
                  width: 100,
                ),
                if (model.discount != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.red,
                    child: Text(
                      'DISCOUNT',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 8,
                            color: Colors.white,
                          ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${model.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 12,
                            height: 1.3,
                            color: Colors.black87,
                          ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price}',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontSize: 12,
                            ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice}',
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 10,
                                    color: Colors.grey.shade800,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                        ),
                      const Spacer(),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.red,
                        child: IconButton(
                            onPressed: () {
                              ShopCubit.get(context)
                                  .changeFavorites(id: model.id!);
                            },
                            icon: const Icon(
                              Icons.favorite_border,
                              size: 16,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
