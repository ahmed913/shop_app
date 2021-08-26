import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/models/shop_app/add_fav_model.dart';
import 'package:shop_app/module/shop/search/searchCubit/cubit.dart';
import 'package:shop_app/shared/components/components.dart';

import 'searchCubit/states.dart';

class SearchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit , SearchStates>(
        listener: (context , states){},
        builder: (context , states){
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                   defaultFormField(
                       controller: searchController,
                       type: TextInputType.text,
                       validate: (String text){
                         if(text.isEmpty){
                           return "enter text to search";
                         }
                         return null;
                       },
                       onSubmit: (String text){
                         SearchCubit.get(context).search(text);
                       },
                       label: 'Search',
                       prefix: Icons.search
                   ),
                    SizedBox(height: 20),
                    if(states is SearchLoadingState)
                      LinearProgressIndicator(),
                    SizedBox(height: 20),
                    if(states is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) => buildListProduct(SearchCubit.get(context).model.data.data[index] , context ,  ),
                        separatorBuilder: (context, index) => Container(
                          width: double.infinity,
                          height: 1.0,
                          color: Colors.grey[300],
                        ),
                        itemCount: SearchCubit.get(context).model.data.data.length,
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
