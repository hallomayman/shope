import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/layouts/shop_app/shop_layout.dart';
import 'package:shoping_app/modules/shop_app/log_in/log_in.dart';
import 'package:shoping_app/modules/shop_app/register/cubit/cubit.dart';
import 'package:shoping_app/network/local/cash_helper.dart';
import 'package:shoping_app/shared/components/components.dart';
import 'package:shoping_app/shared/components/constants.dart';

import 'cubit/state.dart';

class ShopRegisterScreen extends StatefulWidget {
  @override
  _ShopRegisterScreenState createState() => _ShopRegisterScreenState();
}

class _ShopRegisterScreenState extends State<ShopRegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var passwordController = TextEditingController();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShoppingRegisterState>(
        listener: (context, state) {
          if(state is ShoppingRegisterSuccessState){
            if(state.loginModel.status!){

              showToast(message: state.loginModel.message!, states: ToastStates.SUCCESS);
              token = state.loginModel.data!.token!;
              CashHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value){
                token = state.loginModel.data!.token!;

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ShopLayout()));
              });

            }else{
              showToast(message: state.loginModel.message!, states: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          type: TextInputType.emailAddress,
                          prefix: Icons.email,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Enter Email";
                            }
                            return null;
                          },
                          label: 'Email',
                          textEditingController: emailController,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          type: TextInputType.phone,
                          prefix: Icons.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Enter Phone";
                            }
                            return null;
                          },
                          label: 'Phone',
                          textEditingController: phoneController,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          type: TextInputType.name,
                          prefix: Icons.person,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Enter Your Name";
                            }
                            return null;
                          },
                          label: 'Name',
                          textEditingController: nameController,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                          textEditingController: passwordController,
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            }
                            return null;
                          },
                          onSubmitted: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopRegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          suffix: isPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          isPassword: isPassword,
                          fSuffix: () {
                            setState(() {
                              isPassword = !isPassword;
                            });
                          },
                          label: "PassWord",
                          prefix: Icons.lock,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        (state is! ShoppingRegisterLoadState)
                            ? defaultButton(
                                text: "Register",
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                })
                            : load(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('you Have an Account ?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShopLoginScreen()));
                                },
                                child: Text("Login Now"))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

/*
* */
