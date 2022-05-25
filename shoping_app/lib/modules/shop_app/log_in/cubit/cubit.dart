import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/models/login_model.dart';
import 'package:shoping_app/modules/shop_app/log_in/cubit/state.dart';
import 'package:shoping_app/network/end_point.dart';
import 'package:shoping_app/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShoppingLogInState> {
  ShopLoginCubit() : super(ShoppingLogInInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  LoginModel ?loginModel;

  void userLogin({required String email, required String password}) {
    emit(ShoppingLogInLoadState());

    //LOGIN = login
    DioHelper.postData(url: LOGIn, data: {'email': email, 'password': password})
        .then((value) {
      print(value.data);
      loginModel = LoginModel.fromJson(value.data);
      emit(ShoppingLogInSuccessState(loginModel!));
    }).catchError((error) {
      print('${error.toString()}');
      emit(ShoppingLogInErrorState(error.toString()));
    });
  }
}
