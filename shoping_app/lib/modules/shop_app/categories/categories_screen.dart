import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/layouts/shop_app/cubit/cubit.dart';
import 'package:shoping_app/layouts/shop_app/cubit/states.dart';
import 'package:shoping_app/models/categories_model.dart';
import 'package:shoping_app/shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(builder: (context, state){

      var cubit = ShopCubit.get(context);
      if(state is !ShopLoadingHomeDataState){
        return ListView.separated(
            itemBuilder: (context, index) =>  buildCatItem(cubit.categoriesModel!.data!.data[index]),
            separatorBuilder: (context, index) => Divider(),
            itemCount: cubit.categoriesModel!.data!.data.length);
      }else {
        return load();
      }

    }, listener: (context, state){});
  }

  Widget buildCatItem(DataModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Image(
              image: NetworkImage('${model.image}'),
              height: 80.0,
              width: 80.0,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 21.0,
            ),
            Text(
              '${model.name}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      );
}
