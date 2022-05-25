import 'package:shoping_app/models/change_favorites_model.dart';
import 'package:shoping_app/models/login_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates{}

class ShopSuccessHomeDataState extends ShopStates{}

class ShopErrorHomeDataState extends ShopStates{}

class ShopSuccessCategoriesState extends ShopStates{}

class ShopErrorCategoriesState extends ShopStates{}

class ShopSuccessChangeFavoritesState extends ShopStates{
  ChangeModel? model;
  ShopSuccessChangeFavoritesState(this.model);
}

class ShopChangeFavoritesState extends ShopStates{}

class ShopErrorChangeFavoritesState extends ShopStates{}

class ShopSuccessGetFavoritesState extends ShopStates{}

class ShopLoadingGetFavoritesState extends ShopStates{}

class ShopErrorGetFavoritesState extends ShopStates{}

class ShopSuccessGetUserState extends ShopStates{
  late final LoginModel model;
  ShopSuccessGetUserState(this.model);
}

class ShopLoadingGetUserState extends ShopStates{}

class ShopErrorGetUserState extends ShopStates{}

class ShopLoadingUpdateState extends ShopStates{}

class ShopSuccessUpdateState extends ShopStates{
  late final LoginModel model;
  ShopSuccessUpdateState(this.model);
}

class ShopErrorUpdateState extends ShopStates{}

