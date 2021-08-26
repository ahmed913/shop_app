import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/module/login/cubit/states.dart';
import 'package:shop_app/shared/network/remote/dio.dart';
import 'package:shop_app/shared/network/remote/end_point.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>
{
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  ShopLoginModel loginModel;

  void userLogin({
  @required String email,
    @required String password
})
  {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
        url: LOGIN,
        data:
        {
          "email" : email ,
          "password" : password ,
        },
    ).then((value)
    {
      print(value);
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopLoginSuccessState(loginModel));
    }).catchError((error){
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility;
  bool isPassword = true;

  void changePassowrdVisibility()
  {
    isPassword = !isPassword;

    suffix = isPassword ?  Icons.visibility : Icons.visibility_off ;

    emit(ShopChangeVisibilityState());
  }

}