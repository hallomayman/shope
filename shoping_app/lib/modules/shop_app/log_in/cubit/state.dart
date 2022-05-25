import 'package:shoping_app/models/login_model.dart';

abstract class ShoppingLogInState{}

class ShoppingLogInInitialState extends ShoppingLogInState{}

class ShoppingLogInLoadState extends ShoppingLogInState{}

class ShoppingLogInSuccessState extends ShoppingLogInState
{
  final LoginModel loginModel;

  ShoppingLogInSuccessState(this.loginModel);
}

class ShoppingLogInErrorState extends ShoppingLogInState{
  final String error;
  ShoppingLogInErrorState(this.error);
}