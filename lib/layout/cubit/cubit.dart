import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/shop_app/change_fav_model.dart';
import 'package:shop_app/models/shop_app/categories_model.dart';
import 'package:shop_app/models/shop_app/favModel.dart';
import 'package:shop_app/models/shop_app/home_model.dart';
import 'package:shop_app/models/shop_app/login_model.dart';
import 'package:shop_app/module/shop/categories_screen.dart';
import 'package:shop_app/module/shop/favourite_screen.dart';
import 'package:shop_app/module/shop/product_screen.dart';
import 'package:shop_app/module/shop/settings_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/remote/dio.dart';
import 'package:shop_app/shared/network/remote/end_point.dart';



// String token = CacheHelper.getData(key: 'token');

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() : super(ShopInititialState());

  static ShopCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductScreen(),
    CategoriesScreen(),
    FavouriteScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index)
  {
    currentIndex = index;
    emit(ShopChangeBottNavBarState());
  }

  HomeModel homeModel;

  Map<int , bool> favorites = {} ;

  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
    ).then((value)
    {
      homeModel = HomeModel.fromJson(value.data);

      homeModel.data.products.forEach((element) {
        favorites.addAll({
          element.id : element.inFavorites
        });
      });

      print(homeModel.status);

      emit(ShopSuccessHomeDataState());
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel categoriesModel;

  void getCategories()
  {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value)
    {
      categoriesModel = CategoriesModel.fromJson(value.data);

      print(categoriesModel.status);

      emit(ShopSuccessCategorDataState());
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorCategorDataState());
    });
  }

  ChangeFavModel changeFavModel ;

  void changeFavorites(int productId)
  {
    favorites[productId] = !favorites[productId];
    emit(ShopChangeFavDataState());

    DioHelper.postData(
      url: FAVORITES,
      data: { 'product_id' :  productId },
      token: token,

    ).then((value)
    {
      changeFavModel = ChangeFavModel.fromJson(value.data);
      emit(ShopSuccessChangeFavDataState(changeFavModel));
      if(!changeFavModel.status) {
        favorites[productId] = !favorites[productId];
      }else {
        getFavorites();
      }
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorChangeFavDataState());

    });
  }

  FavoritesModel favoritesModel;

  void getFavorites() {
    emit(ShopLoadingFavoritesDataState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data) ;


      emit(ShopSuccessFavoritesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorFavoritesDataState());
    });
  }

  ShopLoginModel userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data) ;

      emit(ShopSuccessUserDataState( userModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  ShopLoginModel updateUserModel;
  void updateUserData({
    @required String name ,
    @required String email ,
    @required String phone ,

  }) {
    emit(ShopLoadingUpdateDataState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name' : name ,
        'email' : email,
        'phone' : phone ,

      }
    ).then((value) {
      updateUserModel = ShopLoginModel.fromJson(value.data) ;

      emit(ShopSuccessUserDataState(updateUserModel));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateDataState());
    });
  }



    // CartModel cartModel;
  //
  // getCart()
  // {
  //   emit(AppUpdateCartLoadingState());
  //
  //   repository
  //       .getCartData(token: userToken)
  //       .then((value)
  //   {
  //     cartModel = CartModel.fromJson(value.data);
  //
  //     emit(AppCartSuccessState());
  //
  //     print('success cart');
  //   }).catchError((error) {
  //     print('error cart ${error.toString()}');
  //     emit(AppCartErrorState(error.toString()));
  //   });
  }


