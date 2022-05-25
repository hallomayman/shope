import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoping_app/layouts/shop_app/cubit/cubit.dart';
import 'package:shoping_app/modules/shop_app/web_view/web_view.dart';

Widget defaultButton({
      double width = double.infinity,
      Color backGround = Colors.blue,
      bool isUpperCase = true,
     double radius=10.0,
     required function,
     required String text,
})=> Container(
  width: width,
  height: 40,
  child: MaterialButton(
    child: Text(
        (isUpperCase)?text.toUpperCase():text,
      style: TextStyle(color: Colors.white),
    ),
    onPressed: function,
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: backGround,
  ),
);


Widget defaultFormField({
  required TextEditingController textEditingController,
  required TextInputType type,
  bool isPassword=false,
  onSubmitted,
  onChange,
  onTap,
  required validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  fSuffix,
  bool isSelectedAble = true,
})=>TextFormField(
  controller: textEditingController,
  keyboardType: type,
  enabled: isSelectedAble,
  onFieldSubmitted: onSubmitted,
  onChanged: onChange,
  obscureText: isPassword,
  onTap: onTap,
  decoration: InputDecoration(
    hintText: label,
    prefixIcon: Icon(prefix),
    suffixIcon: (suffix !=null )?IconButton(onPressed: fSuffix,icon: Icon(suffix)):null,
    border: OutlineInputBorder(),
  ),
  validator: validate,
);

Widget buildTaskItem({
  required String title, required String date, required String time, required int id, context
}) => Dismissible(
  key: Key('$id'),
  onDismissed: (direction){

  },
  child:   Padding(
  
    padding: const EdgeInsets.all(20.0),
  
    child: Row(
  
      children: [
  
        CircleAvatar(
  
          radius: 40.0,
  
          child: Text(time),
  
        ),
  
        SizedBox(width: 20.0,),
  
        Expanded(
  
          child: Column(
  
            mainAxisSize: MainAxisSize.min,
  
            children: [
  
              Text(title,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),),
  
              Text(date,style: TextStyle(color: Colors.grey),),
  
            ],
  
          ),
  
        ),
  
        SizedBox(width: 20.0,),
  
        IconButton(onPressed: (){
  
          //AppCubit.get(context).updateData(status: 'done', id: id);
  
        }, icon: Icon(Icons.check_box,color: Colors.green,)),
  
        IconButton(onPressed: (){
  
         // AppCubit.get(context).updateData(status: 'archive', id: id);
  
        }, icon: Icon(Icons.archive,color: Colors.black45,)),
  
  
  
      ],
  
    ),
  
  ),
);

Widget tasksBuilder({required List<Map> tasks}) => ListView.separated(
    itemBuilder: (context, index) =>
        buildTaskItem(title: tasks[index]['title'],
            date: tasks[index]['date'],
            time: tasks[index]['time'],
            id: tasks[index]['id'],
            context: context),
    separatorBuilder: (context, index) =>
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Divider(),
        ),
    itemCount: tasks.length);

Widget buildArticleItems(article, context) => InkWell(
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen(article['url'])));
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        Container(

          width: 120.0,

          height: 120.0,

          decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(10.0),

              image: DecorationImage(

                image: NetworkImage('${article['urlToImage']}'),

                fit: BoxFit.cover,

              )

          ),

        ),

        SizedBox(width: 20.0,),

        Expanded(

          child: Container(

            height: 120.0,

            child: Column(

              mainAxisAlignment: MainAxisAlignment.start,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Expanded(child: Text('${article['title']}',maxLines: 3,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.bodyText1,),),

                Text('${article['publishedAt']}',style: TextStyle(color: Colors.grey),),

              ],),

          ),

        ),

      ],

    ),

  ),
);

Widget articleBuilder(list) => ListView.separated(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) => buildArticleItems(list[index], context),
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Divider(
        thickness: 4.0,
      ),
    ),
    itemCount: list.length);

void showToast({required String message, required ToastStates states}) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseStateColor(states),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates{
  SUCCESS, ERROR, WARNING
}

Color chooseStateColor(ToastStates states){

  Color color;

  switch(states){
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget load() => Center(
  child: CircularProgressIndicator(),
);

Widget buildFavoritesItems(model, cubit) => Padding(
  padding: const EdgeInsets.all(19.0),
  child: Container(
    height: 120.0,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage('${model!.image}'),
              fit: BoxFit.cover,
              height: 120.0,
              width: 120.0,
            ),
            if (model!.discount != 0)
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
        SizedBox(width: 20.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model!.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 1.1,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    '${model!.price!.round()}',
                    style: TextStyle(fontSize: 12.0, color: Colors.blue),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  if (model!.discount != 0)
                    Text(
                      '${model!.old_price!.round()}',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      cubit.changeFavorites(model!.id);
                    },
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: cubit.favorites[model!.id]? Colors.red :Colors.grey,
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
  ),
);

Widget buildSearchItems(model, cubit, context) => Padding(
  padding: const EdgeInsets.all(19.0),
  child: Container(
    height: 120.0,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage('${model!.image ??"https://www.google.co.il/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png"}'),
              fit: BoxFit.cover,
              height: 120.0,
              width: 120.0,
            ),
          ],
        ),
        SizedBox(width: 20.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model!.name??"No Name"}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 1.1,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    '${model!.price!.round() ?? "00"}',
                    style: TextStyle(fontSize: 12.0, color: Colors.blue),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                     ShopCubit.get(context).changeFavorites(model!.id);
                    },
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: /*(ShopCubit.get(context)!.favorites![model!.id]!) ? Colors.red :*/Colors.grey,
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
  ),
);


