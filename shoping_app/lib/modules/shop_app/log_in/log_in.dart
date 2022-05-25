import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/layouts/shop_app/shop_layout.dart';
import 'package:shoping_app/modules/shop_app/log_in/cubit/cubit.dart';
import 'package:shoping_app/modules/shop_app/log_in/cubit/state.dart';
import 'package:shoping_app/modules/shop_app/register/register.dart';
import 'package:shoping_app/network/local/cash_helper.dart';
import 'package:shoping_app/shared/components/components.dart';
import 'package:shoping_app/shared/components/constants.dart';

class ShopLoginScreen extends StatefulWidget {
  @override
  _ShopLoginScreenState createState() => _ShopLoginScreenState();
}

class _ShopLoginScreenState extends State<ShopLoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShoppingLogInState>(
        listener: (context, state) {
          if(state is ShoppingLogInSuccessState){
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
                          "LOGIN",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          "Login now and Browse our hot offers",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.grey),
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
                          height: 10,
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
                          onSubmitted: (value){
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
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
                        (state is! ShoppingLogInLoadState)
                            ? defaultButton(
                                text: "LogIn",
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                })
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('you don\'t Have Account ?'),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShopRegisterScreen()));
                                },
                                child: Text("Register Now"))
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
  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
