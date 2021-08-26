import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/module/register/cubit_register/states.dart';
import 'package:shop_app/shared/network/remote/dio.dart';
import 'package:shop_app/shared/network/remote/end_point.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates>
{
  ShopRegisterCubit() : super(ShopRegisterInitialState());

  static ShopRegisterCubit get(context) => BlocProvider.of(context);

  ShopLoginModel registerModel;

  void userRegister({
    @required String name,

    @required String email,
    @required String password,
    @required String phone,
  })
  {
    emit(ShopRegisterLoadingState());
    DioHelper.postData(
        url: REGISTER,
        data:
        {
          "name" : name,
          "email" : email ,
          "password" : password ,
          "phone" : phone,
        },
    ).then((value)
    {
      print(value);
      registerModel = ShopLoginModel.fromJson(value.data);
      emit(ShopRegisterSuccessState(registerModel));
    }).catchError((error){
      emit(ShopRegisterErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;

    suffix = isPassword ?  Icons.visibility : Icons.visibility_off ;

    emit(ShopRegisterChangeVisibilityState());
  }

}