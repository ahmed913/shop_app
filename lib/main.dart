
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/layout/shop_layOut.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache.dart';
import 'package:shop_app/shared/network/remote/dio.dart';

import 'layout/cubit/cubit.dart';
import 'module/login/shop_login_Screen.dart';
import 'module/on_board/on_Boarding_Screen.dart';
import 'shared/styles/blocObserver.dart';
import 'shared/styles/theme/theme.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);

  if(onBoarding != null)
  {
    if(token != null) widget = ShopLayout();
    else widget = ShopLogin();
  }else{
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    startWidget: widget,
  ));

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Widget startWidget;

  MyApp({this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create :(BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),
      child: BlocConsumer<ShopCubit , ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            theme: lightTheme,
            home: startWidget,
          );
        },
      ),
    );
  }
}
