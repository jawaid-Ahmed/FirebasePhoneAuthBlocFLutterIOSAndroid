import 'package:firebaseauthusingbloc/cubits/auth_cubit.dart';
import 'package:firebaseauthusingbloc/cubits/auth_state.dart';
import 'package:firebaseauthusingbloc/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        actions: [
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {

              if(state is AuthLoggetOutState){
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (builder)=> SignInPage()));
              }
            },
            builder: (context, state) {
              return IconButton(onPressed: (){
                BlocProvider.of<AuthCubit>(context).authSignOut();
              }, icon: Icon(Icons.logout));
            },
          ),
        ],
      ),
    );
  }
}
