import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/shop_states.dart';
import 'package:shop/models/categories_model.dart';
import 'package:shop/models/change_favorites_model.dart';
import 'package:shop/models/favorites_model.dart';
import 'package:shop/models/home_model.dart';
import 'package:shop/models/login_model.dart';
import 'package:shop/modules/categories/categories_screen.dart';
import 'package:shop/modules/favorites/favorites_screen.dart';
import 'package:shop/modules/products/products_screen.dart';
import 'package:shop/modules/settings/settings_screen.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/remote/dio.dart';
import 'package:shop/shared/network/remote/end_points.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'shop',
    'categories',
    'favorites',
    'settings',
  ];

  List<BottomNavigationBarItem> navBarItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Categories'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  int currentIndex = 0;

  void changeNavBar(int index) {
    currentIndex = index;
    emit(ShopChangeNavBarState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData() {
    // emit(GetHomeDataLoadingState());
    DioHelper.getData(
      url: HOME,
      token: TOKEN,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      // to get favorite items from product model by product id
      for (var item in homeModel!.data!.products) {
        favorites.addAll({
          item.id!: item.in_favorites!,
        });
      }

      emit(GetHomeDataSuccessState());
    }).catchError((error) {
      emit(GetHomeDataErrorState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    // emit(GetCategoriesDataLoadingState());
    DioHelper.getData(
      url: CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(GetCategoriesDataSuccessState());
    }).catchError((error) {
      emit(GetCategoriesDataErrorState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites({required int id}) {
    // to change favorites like realtime <true =><= false>
    favorites[id] = !favorites[id]!;
    emit(ChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      token: TOKEN,
      data: {
        'product_id': id,
      },
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      // to undo changes if there is any errors
      if (!changeFavoritesModel!.status!) {
        favorites[id] = !favorites[id]!;
        emit(ChangeFavoritesState());
      }
      getFavorites();
      emit(ChangeFavoritesState());
    }).catchError((error) {
      // to undo changes if there is any errors
      favorites[id] = !favorites[id]!;
      emit(ChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites() {
    DioHelper.getData(
      url: FAVORITES,
      token: TOKEN,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(GetFavoritesSuccessState());
    }).catchError((error) {
      print(error);
      emit(GetFavoritesErrorState());
    });
  }

  UserLoginModel? userModel;

  void getUser() {
    DioHelper.getData(
      url: PROFILE,
      token: TOKEN,
    ).then((value) {
      userModel = UserLoginModel.fromJson(value.data!);
      emit(GetUserSuccessState());
      print(TOKEN);
    }).catchError((error) {
      print(TOKEN);
      emit(GetUserErrorState());
    });
  }

  void updateUser({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(UpdateUserLoadingState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: TOKEN,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      emit(UpdateUserSuccessState());
      getUser();
    }).catchError((error) {
      emit(UpdateUserErrorState());
    });
  }
}
