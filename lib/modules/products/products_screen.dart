import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shop/models/categories_model.dart';
import 'package:shop/models/home_model.dart';

import '../../layout/cubit/shop_cubit.dart';
import '../../layout/cubit/shop_states.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var _cubit = ShopCubit.get(context);
        return BuildCondition(
          condition: _cubit.homeModel != null && _cubit.categoriesModel != null,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _banners(_cubit.homeModel!, context),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Categories',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Ubuntu'),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => _categoryItem(
                        _cubit.categoriesModel!.data!.elements[index], context),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 5,
                    ),
                    itemCount: _cubit.categoriesModel!.data!.elements.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'New Products',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Ubuntu'),
                  ),
                ),
                Container(
                  color: Colors.grey.shade300,
                  child: GridView.count(
                    crossAxisCount: 2,
                    // create list of grid items
                    children: List.generate(
                      // length
                      _cubit.homeModel!.data!.products.length,
                      // item
                      (index) => _product(
                          _cubit.homeModel!.data!.products[index], context),
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    childAspectRatio: 1 / 1.4,
                  ),
                ),
              ],
            ),
          ),
          fallback: (context) => Center(
            child: Lottie.asset('assets/animation/circular.json'),
          ),
        );
      },
    );
  }

  Widget _banners(HomeModel model, context) {
    return Container(
      height: MediaQuery.of(context).size.height * .252,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87),
      ),
      child: CarouselSlider(
        items: model.data!.banners
            .map(
              (banner) => CachedNetworkImage(
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                imageUrl: "${banner.image}",
                //placeholder: (context, url) => Lottie.asset('assets/animation/ripple.gif'),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )
            .toList(),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * .25,
          initialPage: 0,
          autoPlay: true,
          enableInfiniteScroll: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(seconds: 2),
          viewportFraction: 1.0,
          reverse: false,
          scrollDirection: Axis.horizontal,
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  Widget _product(ProductModel model, context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              CachedNetworkImage(
                height: 120,
                width: 120,
                imageUrl: "${model.image}",
                //placeholder: (context, url) => Lottie.asset('assets/animation/ripple.gif'),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
          const SizedBox(
            height: 10,
          ),
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
                      fontSize: 14,
                      color: Colors.blue,
                    ),
              ),
              const SizedBox(
                width: 10,
              ),
              if (model.discount != 0)
                Text(
                  '${model.old_price}',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 10,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              const Spacer(),
              CircleAvatar(
                radius: 16,
                backgroundColor: ShopCubit.get(context).favorites[model.id!]!
                    ? Colors.red
                    : Colors.grey.shade400,
                child: IconButton(
                    onPressed: () {
                      ShopCubit.get(context).changeFavorites(id: model.id!);
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
    );
  }

  Widget _categoryItem(CategoryElement model, context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          width: 120,
          height: 100,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CachedNetworkImage(
            imageUrl: "${model.image}",
            //placeholder: (context, url) => Lottie.asset('assets/animation/ripple.gif'),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Container(
          width: 120,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.6),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          child: Text(
            '${model.name}',
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
          ),
        ),
      ],
    );
  }
}
