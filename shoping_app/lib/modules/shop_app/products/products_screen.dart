import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/layouts/shop_app/cubit/cubit.dart';
import 'package:shoping_app/layouts/shop_app/cubit/states.dart';
import 'package:shoping_app/models/categories_model.dart';
import 'package:shoping_app/models/home_model.dart';
import 'package:shoping_app/shared/components/components.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        builder: (context, state) {
          var cubit = ShopCubit.get(context);

          return cubit.homeModel != null && cubit.categoriesModel != null
              ? productsBuilder(
                  ShopCubit.get(context).homeModel!, cubit.categoriesModel!, cubit)
              : load();
        },
        listener: (context, state) {
          if(state is ShopSuccessChangeFavoritesState){
            if(! state.model!.status){
              showToast(message: state.model!.message, states: ToastStates.ERROR);
            }
          }
        });
  }

  Widget productsBuilder(HomeModel model, CategoriesModel categoriesModel, cubit) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data!.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                viewportFraction: 1.0,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 11.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 11.0,
                  ),
                  Container(
                    height: 100.0,
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => buildCategoryItem(
                            categoriesModel.data!.data[index]),
                        separatorBuilder: (context, index) => SizedBox(
                              width: 11.0,
                            ),
                        itemCount: categoriesModel.data!.data.length),
                  ),
                  SizedBox(
                    height: 11.0,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 11.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.64,
                children: List.generate(model.data!.products.length,
                    (index) => productBuilder(model.data!.products[index], cubit)),
              ),
            ),
          ],
        ),
      );

  Widget load() => Center(
        child: CircularProgressIndicator(),
      );

  Widget productBuilder(ProductsModel productsModel, cubit) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage('${productsModel.image}'),
                  height: 200.0,
                  width: double.infinity,
                ),
                if (productsModel.discount != 0)
                  Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: Text(
                      "DISCOUNT",
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${productsModel.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.1,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${productsModel.price.round()}',
                        style: TextStyle(fontSize: 12.0, color: Colors.blue),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (productsModel.discount != 0)
                        Text(
                          '${productsModel.oldPrice.round()}',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          cubit.changeFavorites(productsModel.id);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor: cubit.favorites[productsModel.id]? Colors.red :Colors.grey,
                          child: Icon(
                            Icons.favorite_border,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildCategoryItem(DataModel dataModel) => Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image(
            image: NetworkImage('${dataModel.image}'),
            fit: BoxFit.cover,
            height: 100.0,
            width: 100.0,
          ),
          Container(
            color: Colors.black.withOpacity(
              0.8,
            ),
            width: 100.0,
            child: Text(
              '${dataModel.name}',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
}
