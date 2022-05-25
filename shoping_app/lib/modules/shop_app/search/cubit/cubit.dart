import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/models/search_model.dart';
import 'package:shoping_app/modules/shop_app/search/cubit/state.dart';
import 'package:shoping_app/network/end_point.dart';
import 'package:shoping_app/network/remote/dio_helper.dart';
import 'package:shoping_app/shared/components/constants.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? model;

  void search(String text) {

    emit(SearchLoadingState());

    DioHelper.postData(
      url: SEARCH,
      authorization: token,
      data: {'text': text},
    ).then((value) {

      model = SearchModel.fromJson(value.data);

      emit(SearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SearchErrorState());
    });
  }
}
