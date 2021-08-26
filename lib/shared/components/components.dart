import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layout/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.teal,
  bool isUpperCase = true,
  double radius = 3.0,
  @required Function function,
  @required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: (){
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultTextButton({
  @required Function function,
  @required String text,
}) =>
    TextButton(
      onPressed: (){
        function();
      },
      child: Text(
        text.toUpperCase(),
      ),
    );

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onTap,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      validator: validate ,

      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: (){
            suffixPressed();
          },
          icon: Icon(
            suffix,
          ),
        )
            : null,
        border: OutlineInputBorder(),
      ),
    );

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route) {
        return false;
      },
    );

void showToast({
  @required String text,
  @required ToastStates state,


}) => Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates {SUCCESS , ERROR , WARNING}

Color chooseToastColor (ToastStates  state)
{
  Color color ;
  switch(state)
  {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;

  }
  return color;
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(

      child: Container(
        color: Colors.teal,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              '  Profile ',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            UserAccountsDrawerHeader(
              accountEmail: Text('eng.ahmed.h.essa@gmail.com'),
              accountName: Text('Ahmed Hamdy Essa'),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Image.asset(
                  'assets/images/my photo.jpg',
                  fit: BoxFit.cover,
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
              otherAccountsPictures: <Widget>[
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('assets/images/s.jpg'),
                ),
              ],
            ),
            Divider(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildListProduct(model , context ,) => Padding(
  padding: const EdgeInsets.all(12.0),
  child: Container(
    height: 120,
    child: Row(
      children: [
        Stack(
          children: [
            Image(
              image: NetworkImage(model.image),
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
            if(model.discount != 0 )
              Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(7)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    'Discount',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
          ],
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1.3,fontWeight: FontWeight.bold,fontSize: 14),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    model.price.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1.4,fontWeight: FontWeight.bold,color: Colors.teal),

                  ),
                  SizedBox(width: 5),
                  if(model.discount != 0  )
                    Text(
                        model.id.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(height: 1.4,color: Colors.grey,decoration:TextDecoration.lineThrough)

                    ),
                  Spacer(),
                  IconButton(
                    icon: ShopCubit.get(context).favorites[model.id] ?  Icon(Icons.favorite) : Icon(Icons.favorite_border),

                    onPressed: () {

                      ShopCubit.get(context).changeFavorites(model.id);

                    },
                    color: Colors.red[900],
                  ),


                ],
              ),
            ],
          ),
        )

      ],
    ),
  ),
);


