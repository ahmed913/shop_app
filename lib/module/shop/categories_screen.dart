import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/shop_app/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var categories = ShopCubit.get(context).categoriesModel;

        return ConditionalBuilder(
          condition: categories != null,

          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => categoryItem(categories.data.data[index]),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
            itemCount: categories.data.data.length,
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget categoryItem(ProductData model) => InkWell(
    onTap: (){
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                2.0,
              ),
              image: DecorationImage(
                image: NetworkImage(
                  '${model.image}',),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            '${model.name}',
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios
          )
        ],
      ),
    ),
  );
}