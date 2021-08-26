import 'package:shop_app/models/shop_app/change_fav_model.dart';
import 'package:shop_app/models/shop_app/login_model.dart';

abstract class ShopStates{}

class ShopInititialState extends ShopStates{}

class ShopChangeBottNavBarState extends ShopStates{}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategorDataState extends ShopStates {}

class ShopErrorCategorDataState extends ShopStates {}

class ShopChangeFavDataState extends ShopStates {}

class ShopSuccessChangeFavDataState extends ShopStates {

  final ChangeFavModel model ;

  ShopSuccessChangeFavDataState(this.model);

}

class ShopErrorChangeFavDataState extends ShopStates {}

class ShopLoadingFavoritesDataState extends ShopStates {}

class ShopSuccessFavoritesDataState extends ShopStates {}

class ShopErrorFavoritesDataState extends ShopStates {}

class ShopLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {
 final ShopLoginModel loginModel ;

  ShopSuccessUserDataState(this.loginModel);
}

class ShopErrorUserDataState extends ShopStates {}


class ShopLoadingUpdateDataState extends ShopStates {}

class ShopSuccessUpdateDataState extends ShopStates {
  final ShopLoginModel loginModel ;

  ShopSuccessUpdateDataState(this.loginModel);
}

class ShopErrorUpdateDataState extends ShopStates {}