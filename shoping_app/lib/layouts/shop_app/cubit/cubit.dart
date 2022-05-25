import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/layouts/shop_app/cubit/states.dart';
import 'package:shoping_app/models/categories_model.dart';
import 'package:shoping_app/models/change_favorites_model.dart';
import 'package:shoping_app/models/favorites_model.dart';
import 'package:shoping_app/models/home_model.dart';
import 'package:shoping_app/models/login_model.dart';
import 'package:shoping_app/modules/shop_app/categories/categories_screen.dart';
import 'package:shoping_app/modules/shop_app/favorites/favorites_screen.dart';
import 'package:shoping_app/modules/shop_app/products/products_screen.dart';
import 'package:shoping_app/modules/shop_app/settings/settings_screen.dart';
import 'package:shoping_app/network/end_point.dart';
import 'package:shoping_app/network/remote/dio_helper.dart';
import 'package:shoping_app/shared/components/constants.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen()
  ];

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Categories'),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<int?, bool?> favorites = {};

  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    /*if(token.length<2){
      token = CashHelper.getData(key: 'token');
    }*/
    DioHelper.getData(url: HOME, authorization: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorite,
        });
      });
      //print(homeModel!.data!.products[0][].toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print('${error.toString()}');
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() {
    emit(ShopLoadingHomeDataState());

    /*if(token.length<2){
      token = CashHelper.getData(key: 'token');
    }*/
    DioHelper.getData(url: GET_CATEGORIES, authorization: token).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print('${error.toString()}');
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeModel? change;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;

    emit(ShopChangeFavoritesState());

    DioHelper.postData(
            url: FAVORITES,
            data: {'product_id': productId},
            authorization: token)
        .then((value) {
      change = ChangeModel.fromJson(value.data);

      if (!change!.status) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
      }

      emit(ShopSuccessChangeFavoritesState(change));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      print('${error.toString()}');
      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavoritesData() {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(url: FAVORITES, authorization: token).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print('${error.toString()}');
      emit(ShopErrorGetFavoritesState());
    });
  }

  LoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingGetUserState());

    DioHelper.getData(url: PROFILE, authorization: token).then((value) {
      print(value.data.toString());
      userModel = LoginModel.fromJson(value.data);

      print(userModel!.data!.name.toString());
      emit(ShopSuccessGetUserState(userModel!));
    }).catchError((error) {
      print('${error.toString()}');
      emit(ShopErrorGetUserState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateState());

    DioHelper.putData(url: UPDATE_PROFILE, authorization: token, data: {
      'name': name,
      'phone': phone,
      'email': email,
    }).then((value) {
      print(value.data.toString());
      userModel = LoginModel.fromJson(value.data);

      print(userModel!.data!.name.toString());
      emit(ShopSuccessUpdateState(userModel!));
    }).catchError((error) {
      print('${error.toString()}');
      emit(ShopErrorUpdateState());
    });
  }
}
