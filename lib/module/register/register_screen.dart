import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layOut.dart';
import 'package:shop_app/module/register/cubit_register/cubit.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache.dart';

import 'cubit_register/states.dart';

// ignore: must_be_immutable
class ShopRegister extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit() ,
      child: BlocConsumer<ShopRegisterCubit , ShopRegisterStates>(
        listener: (context , state){
          if (state is ShopRegisterSuccessState) {
            if (state.registerModel.status) {
              print(state.registerModel.message);
              print(state.registerModel.data.token);

              CacheHelper.saveData(
                  key: 'token',
                  value: state.registerModel.data.token
              ).then((value) {

                token = state.registerModel.data.token;
                navigateAndFinish(context, ShopLayout());
              });
            } else {
              showToast(
                  text: state.registerModel.message,
                  state: ToastStates.ERROR
              );
            }
          }

        },
        builder: (context , state){
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validate: (String value) {
                            if (value.isEmpty) {

                              return 'please enter your Name address';
                            }
                          },
                          label: 'Name',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {

                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          suffix: ShopRegisterCubit.get(context).suffix,
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          onSubmit: (value)
                          {
                            if(formKey.currentState.validate())
                            {
                              ShopRegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                phone: phoneController.text
                              );
                            }
                          },
                          isPassword: ShopRegisterCubit.get(context).isPassword,
                          suffixPressed: () {

                            ShopRegisterCubit.get(context).changePasswordVisibility();
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {

                              return 'please enter your phone address';
                            }
                          },
                          label: 'Phone',
                          prefix: Icons.phone,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! ShopRegisterLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState.validate()) {
                                ShopRegisterCubit.get(context).userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text
                                );
                              }
                            },
                            text: 'Register',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),






                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

