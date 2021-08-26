import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit , ShopStates>(
      listener: (context , state){
        if(state is ShopSuccessUserDataState){
          nameController.text = state.loginModel.data.name;
          emailController.text = state.loginModel.data.email;
          phoneController.text = state.loginModel.data.phone;
        }


      },
      builder: (context , state){

        var model = ShopCubit.get(context).userModel;

        nameController.text = model.data.name;
        emailController.text = model.data.email;
        phoneController.text = model.data.phone;


        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if(state is ShopLoadingUpdateDataState)
                    LinearProgressIndicator(),
                  SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (String value){
                      if(value.isEmpty){
                        return 'Name Must Not Be Empty' ;
                      }
                      return null;

                    },
                    label: 'Name',
                    prefix: Icons.person,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: emailController,
                    type: TextInputType.name,
                    validate: (String value){
                      if(value.isEmpty){
                        return 'Email Must Not Be Empty' ;
                      }
                      return null;

                    },
                    label: 'Email Address',
                    prefix: Icons.email,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.name,
                    validate: (String value){
                      if(value.isEmpty){
                        return 'Phone Must Not Be Empty' ;
                      }
                      return null;

                    },
                    label: 'Phone',
                    prefix: Icons.phone,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultButton(
                      function: (){
                        if(formKey.currentState.validate())
                          {
                            ShopCubit.get(context).updateUserData(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text
                            );
                          }

                      },
                      text: 'UPDATE'
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultButton(
                      function: (){
                        signOut(context);
                      },
                      text: 'LOG OUT'
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
