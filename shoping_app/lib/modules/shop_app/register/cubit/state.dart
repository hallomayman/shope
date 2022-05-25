import 'package:shoping_app/models/login_model.dart';

abstract class ShoppingRegisterState{}

class ShoppingRegisterInitialState extends ShoppingRegisterState{}

class ShoppingRegisterLoadState extends ShoppingRegisterState{}

class ShoppingRegisterSuccessState extends ShoppingRegisterState
{
  final LoginModel loginModel;

  ShoppingRegisterSuccessState(this.loginModel);
}

class ShoppingRegisterErrorState extends ShoppingRegisterState{
  final String error;
  ShoppingRegisterErrorState(this.error);
}