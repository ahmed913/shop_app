
import 'package:shop_app/module/login/shop_login_Screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache.dart';



void signOut(context)
{
  CacheHelper.removeData(
      key: "token"
  ).then((value)
  {
    if(value)
    {
      navigateAndFinish(context, ShopLogin());
    }
  });
}

String token = '' ;
