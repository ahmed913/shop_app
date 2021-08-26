
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/module/shop/search/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';


// ignore: must_be_immutable
class ShopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context , state){},
      builder: (context , state){
        var cubit = ShopCubit.get(context);
        return Scaffold(
          drawer: MyDrawer(),
        appBar: AppBar(
          title: Text("Salla"),
          actions: [
            IconButton(
              onPressed:() => navigateTo(context , SearchScreen()),
              icon: Icon(Icons.search)
          )],
        ),
        body: cubit.bottomScreens[cubit.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  cubit.changeBottom(index);
                },
                currentIndex: cubit.currentIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home_sharp),
                      label: 'Home'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.category_outlined),
                      label: 'Categories'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'Favourites'
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings'
                  ),
                ],

              ),
        );},
    );
  }
}
