//import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoping_app/layouts/shop_app/cubit/cubit.dart';
import 'package:shoping_app/layouts/shop_app/shop_layout.dart';
import 'package:shoping_app/modules/shop_app/log_in/log_in.dart';
import 'package:shoping_app/modules/shop_app/on_boarding/onboarding_screen.dart';
import 'package:shoping_app/shared/bloc_observe.dart';
import 'package:shoping_app/shared/components/constants.dart';
import 'package:shoping_app/shared/cubit/cubit.dart';
import 'package:shoping_app/shared/cubit/states.dart';
import 'package:shoping_app/styles/themes/themes.dart';
import 'network/local/cash_helper.dart';
import 'network/remote/dio_helper.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CashHelper.init();

  bool? isDark = CashHelper.getData(key: 'isDark');
  Widget widget;
  bool? onBoarding = CashHelper.getData(key: 'onBoarding');
  token = CashHelper.getData(key: 'token') ?? '';

  if (onBoarding != null) {
    if (token.isNotEmpty) {
      widget = ShopLayout();
    } else
      widget = ShopLoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(isDark: isDark ?? false, startWidget: widget));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({required this.isDark, required this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()..changeAppMode(boolShared: isDark)),
        BlocProvider(
            create: (context) => ShopCubit()
              ..getHomeData()
              ..getUserData()
              ..getCategoriesData()
              ..getFavoritesData()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, states) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
