import 'package:firebaseauthusingbloc/constants/mycolors.dart';
import 'package:firebaseauthusingbloc/cubits/auth_cubit.dart';
import 'package:firebaseauthusingbloc/cubits/auth_state.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pinput/pinput.dart';

import 'home_page.dart';


enum Status { Waiting, Error }

class VerifyNumber extends StatelessWidget {

  VerifyNumber({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: MyColors.backGroundColor,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Verify  ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: Colors.white)),
                Text("Number",
                    style: TextStyle(fontSize: 32, color: Colors.orange))
              ]
          ),
          elevation: 0.0,
        ),
        backgroundColor: MyColors.backGroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text("OTP Verification",
                  style: TextStyle(
                      color: const Color(0xFF08C187).withOpacity(0.7),
                      fontSize: 30)),
            ),
            const SizedBox(height: 30,),
            Text("Enter OTP sent to",
                style: TextStyle(
                    color: Colors.grey.shade300, fontSize: 20)),
            Text("03043334445" ?? "",
              style: TextStyle(color: Colors.grey.shade50),),

            const SizedBox(height: 30,),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                Navigator.popUntil(context, (route) => route.isFirst);
                if(state is AuthLoggedInState){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder)=> HomePage()));
                }

                else if(state is AuthErrorState){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.toString()))
                  );
                }
              },
              builder: (context, state) {

                if(state is AuthLoadingState){
                  return const Center(child: CircularProgressIndicator(),);
                }

                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Pinput(
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    onCompleted: (pin) async {
                      BlocProvider.of<AuthCubit>(context).verifyOtp(pin);
                    },

                  ),
                );
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't receive the OTP?",
                  style: TextStyle(color: Colors.grey.shade50),),
                CupertinoButton(
                    child: const Text("RESEND OTP"),
                    onPressed: () async {})
              ],
            )
          ],
        )
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(20),
    ),
  );
}