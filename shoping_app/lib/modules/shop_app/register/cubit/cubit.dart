import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/models/login_model.dart';
import 'package:shoping_app/modules/shop_app/register/cubit/state.dart';
import 'package:shoping_app/network/end_point.dart';
import 'package:shoping_app/network/remote/dio_helper.dart';

class ShopRegisterCubit extends Cubit<ShoppingRegisterState> {
  ShopRegisterCubit() : super(ShoppingRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void userRegister(
      {required String email,
      required String password,
      required String phone,
      required String name}) {
    emit(ShoppingRegisterLoadState());

    //LOGIN = login

    DioHelper.postData(url: REGISTER, data: {
      'email': email,
      'password': password,
      'name' : name,
      'phone' : phone
    }).then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      emit(ShoppingRegisterSuccessState(loginModel!));
    }).catchError((error) {
      print('${error.toString()}');
      emit(ShoppingRegisterErrorState(error.toString()));
    });
  }
}
