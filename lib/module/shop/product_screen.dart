import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/shop_app/categories_model.dart';
import 'package:shop_app/models/shop_app/home_model.dart';
import 'package:shop_app/shared/components/components.dart';

class ProductScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context , state){

        if(state is ShopSuccessChangeFavDataState)
          {
            if(!state.model.status)
              {
                showToast(text: state.model.message, state: ToastStates.ERROR);
              }
          }
      },
      builder: (context , state){
        return ConditionalBuilder(
            condition: ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoriesModel != null,
            builder: (context) => productBuilder(ShopCubit.get(context).homeModel , ShopCubit.get(context).categoriesModel ,context),
            fallback:(context) => Center(child: CircularProgressIndicator())
        );
      },
    );
  }
  Widget productBuilder(HomeModel model , CategoriesModel categoriesModel , context) => SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
            items: model.data.banners.map((e) => Image(
              image: NetworkImage('${e.image}'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),).toList(),
            options: CarouselOptions(
              height: 240,
              initialPage: 0,
              viewportFraction: 1,
              autoPlayAnimationDuration: Duration(seconds: 3),
              autoPlayInterval: Duration(seconds: 1)

            ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),
              ),
              Container(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                    itemBuilder: (context , index) =>  categoryItem(categoriesModel.data.data[index]),
                    separatorBuilder: (context , index) => SizedBox(width: 10,),
                    itemCount: categoriesModel.data.data.length,
                ),
              ),
              SizedBox(height: 15),

              Text(
                'New Product',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Container(
          color: Colors.grey[300],
          child: GridView.count(
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1 / 1.5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            children: List.generate(

                model.data.products.length,
                  (index) => buildGirdProduct(model.data.products[index] , context ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget categoryItem(ProductData model ) => InkWell(
    onTap: (){
      // navigateTo(context, SingleCategoryScreen(model.id, model.name),);
    },
    child: Container(
      width: 90.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image(
            image: NetworkImage(
              model.image,
            ),
            fit: BoxFit.cover,
            height: 90.0,
            width: 90.0,
          ),
          Container(
            width: double.infinity,
            height: 25.0,
            color: Colors.black.withOpacity(
              .8,
            ),
            child: Center(
              child: Text(
                model.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget buildGirdProduct (ProductModel model, context) => Container(
     color: Colors.white,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image(
                    image: NetworkImage(model.image),
                    height: 200,
                    width: double.infinity,
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
              Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1.3,fontWeight: FontWeight.bold,fontSize: 14),
              ),
              Row(
                children: [
                  Text(
                    model.price.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1.4,fontWeight: FontWeight.bold,color: Colors.teal),

                  ),
                  SizedBox(width: 5),
                  if(model.discount != 0 )
                    Text(
                    model.oldPrice.toString(),
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
              )

            ],
          ),
        ),
      ],
    ),
  );
}
