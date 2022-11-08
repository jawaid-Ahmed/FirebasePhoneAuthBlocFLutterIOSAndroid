import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauthusingbloc/cubits/auth_cubit.dart';
import 'package:firebaseauthusingbloc/cubits/auth_state.dart';
import 'package:firebaseauthusingbloc/pages/home_page.dart';
import 'package:firebaseauthusingbloc/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (oldState,newState){
            return oldState is AuthInitialState;
          },
          builder: (context, state) {

            if(state is AuthLoggedInState){
              return HomePage();

            }else if(state is AuthLoggetOutState){
              return SignInPage();

            }else{
              //you can set splash screen here
              return SignInPage();

            }

          },
        ),
      ),
    );
  }
}

