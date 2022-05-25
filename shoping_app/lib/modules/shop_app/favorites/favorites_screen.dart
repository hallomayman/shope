import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/layouts/shop_app/cubit/cubit.dart';
import 'package:shoping_app/layouts/shop_app/cubit/states.dart';
import 'package:shoping_app/models/favorites_model.dart';
import 'package:shoping_app/shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(builder: (context, state){

      var cubit = ShopCubit.get(context);

      if(state is !ShopLoadingGetFavoritesState){
        return ListView.separated(
            itemBuilder: (context, index) =>  buildFavoritesItems(cubit.favoritesModel!.data!.data![index]!.product, cubit),
            separatorBuilder: (context, index) => Divider(),
            itemCount: cubit.favoritesModel!.data!.data!.length);
      }else{
        return load();
      }
    }, listener: (context, state){});
  }

}
