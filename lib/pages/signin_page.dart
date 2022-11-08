import 'package:firebaseauthusingbloc/constants/mycolors.dart';
import 'package:firebaseauthusingbloc/cubits/auth_cubit.dart';
import 'package:firebaseauthusingbloc/cubits/auth_state.dart';
import 'package:firebaseauthusingbloc/pages/signup_page.dart';
import 'package:firebaseauthusingbloc/pages/verify_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  final TextEditingController controller = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  String numberText = "";


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    codeController.setText('+92');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MyColors.backGroundColor,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text("SIGN  ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.white)),
          Text("In", style: TextStyle(fontSize: 32, color: Colors.orange))
        ]),
        elevation: 0.0,
      ),
      backgroundColor: MyColors.backGroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Image(
                image: AssetImage('assets/images/logo.png'),
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                  height: 50,
                  width: size.width * 0.9,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [],
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: MyColors.textFieldBorders),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        controller: codeController,
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone",
                                hintStyle: TextStyle(color: Colors.white70)),
                            onChanged: (val) {

                            }))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width * 0.94,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignUpPage()));
                      },
                      child: Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0, color: MyColors.textFieldBorders),
                    color: MyColors.textFieldBorders,
                    borderRadius: const BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                  ),
                  width: size.width * 0.94,
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                        if(state is AuthCodeSentState){
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => VerifyNumber()));
                        }
                    },
                    builder: (context, state) {
                      if(state is AuthLoadingState){
                        return const Center(child: CircularProgressIndicator(),);
                      }

                      return TextButton(
                          onPressed: () async {
                            numberText = codeController.text + controller.text;

                            BlocProvider.of<AuthCubit>(context).sendOtp(numberText);
                          },
                          child: const Text(
                            'Send Otp',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ));
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }


}
