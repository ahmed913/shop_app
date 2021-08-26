import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layOut.dart';
import 'package:shop_app/module/login/cubit/cubit.dart';
import 'package:shop_app/module/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache.dart';
import 'cubit/states.dart';

// ignore: must_be_immutable
class ShopLogin extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit() ,
      child: BlocConsumer<ShopLoginCubit , ShopLoginStates>(
        listener: (context , state){
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status) {
              print(state.loginModel.message);
              print(state.loginModel.data.token);

              CacheHelper.saveData(
                  key: 'token',
                  value: state.loginModel.data.token
              ).then((value) {

                token = state.loginModel.data.token;
                navigateAndFinish(context, ShopLayout());
              });
            } else {
              showToast(
                  text: state.loginModel.message,
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
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Login now to browse our hot offers',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
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
                            suffix: ShopLoginCubit.get(context).suffix,
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            onSubmit: (value)
                            {
                              if(formKey.currentState.validate())
                              {
                                ShopLoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text);
                              }
                            },
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            suffixPressed: () {

                              ShopLoginCubit.get(context).changePassowrdVisibility();
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
                          ConditionalBuilder(
                            condition: state is! ShopLoginLoadingState,
                            builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState.validate()) {
                                  ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                              text: 'login',
                              isUpperCase: true,
                            ),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator()),
                          ),



                          Center(
                            child: Row(
                              children: [
                                SizedBox(width: 10,),
                                Text("Don't have an account ?", style: TextStyle(fontSize: 17),),
                                Spacer(),
                                defaultTextButton(
                                    function: (){
                                      navigateTo(context , ShopRegister());
                                    },
                                    text: "Register"
                                ),
                                SizedBox(width: 10,)
                              ],
                            ),
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

