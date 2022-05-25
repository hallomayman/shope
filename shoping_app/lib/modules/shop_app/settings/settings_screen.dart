import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/layouts/shop_app/cubit/cubit.dart';
import 'package:shoping_app/layouts/shop_app/cubit/states.dart';
import 'package:shoping_app/shared/components/components.dart';
import 'package:shoping_app/shared/components/constants.dart';

class SettingsScreen extends StatelessWidget {
  var forKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          if (cubit.userModel != null) {
            nameController.text = cubit.userModel!.data!.name!;
            emailController.text = cubit.userModel!.data!.email!;
            phoneController.text = cubit.userModel!.data!.phone!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: forKey,
                  child: Column(
                    children: [
                      if(state is ShopLoadingUpdateState)LinearProgressIndicator(),
                      SizedBox(height: 20.0,),
                      defaultFormField(
                        textEditingController: nameController,
                        type: TextInputType.name,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'name most not be empty';
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: Icons.person,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultFormField(
                        textEditingController: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'emailAddress most not be empty';
                          }
                          return null;
                        },
                        label: 'Email Address',
                        prefix: Icons.email,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultFormField(
                        textEditingController: phoneController,
                        type: TextInputType.phone,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'phone most not be empty';
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefix: Icons.phone,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultButton(
                          function: () {
                            if(forKey.currentState!.validate()){
                              cubit.updateUserData(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phone: phoneController.text);
                            }
                          },
                          text: 'Update'),
                      SizedBox(
                        height: 16.0,
                      ),
                      defaultButton(
                          function: () {
                            signOut(context);
                          },
                          text: 'LogOut'),
                    ],
                  ),
                ),
              ),

            );
          } else {
            return load();
          }
        },
        listener: (context, state) {
          if(state is ShopSuccessUpdateState)
            showToast(message: '${state.model.message}', states: ToastStates.SUCCESS);

        });
  }
}
