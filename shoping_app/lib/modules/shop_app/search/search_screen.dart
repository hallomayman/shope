import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/modules/shop_app/search/cubit/cubit.dart';
import 'package:shoping_app/modules/shop_app/search/cubit/state.dart';
import 'package:shoping_app/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();


    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SearchCubit.get(context);

          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                        textEditingController: searchController,
                        type: TextInputType.text,
                        validate: (String? value) {
                          if(value!.isEmpty){
                            return 'Enter Text To Search';
                          }
                          return null;
                        },
                        onSubmitted: (String? text){
                          if(text!.isEmpty){
                            showToast(message: 'Enter Text To Search', states: ToastStates.ERROR);
                          }else{
                            cubit.search(text);
                          }
                        },
                        label: 'Search',
                        prefix: Icons.search),
                    SizedBox(height: 10.0,),
                    if(state is SearchLoadingState)
                    LinearProgressIndicator(),
                    SizedBox(height: 10.0,),
                    if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) =>  buildSearchItems(cubit.model!.data!.data![index]!, cubit, context),
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: cubit.model!.data!.data!.length),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
