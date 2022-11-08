import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthusingbloc/cubits/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState>{

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  AuthCubit() : super(AuthInitialState()){
    User? currentUser=_firebaseAuth.currentUser;
    if(currentUser !=null){
      emit(AuthLoggedInState(currentUser));
    }else{
      emit(AuthLoggetOutState());
    }
  }

  String? verificationId;

  void sendOtp(String phoneNumber)async{
    emit(AuthLoadingState());
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
        verificationCompleted: (firebaseAuthCredentials){
          signInWithPhone(firebaseAuthCredentials);
        },
        verificationFailed: (error){
          emit(AuthErrorState(error.toString()));
        },
        codeSent: (verifiId,resendToken){
            verificationId=verifiId;
            emit(AuthCodeSentState());
        },
        codeAutoRetrievalTimeout: (verificationId){
          this.verificationId=verificationId;
        }
    );

  }

  void verifyOtp(String otp)async{
    emit(AuthLoadingState());
    PhoneAuthCredential credential=PhoneAuthProvider
        .credential(verificationId: verificationId!, smsCode: otp);
    signInWithPhone(credential);

  }

  void signInWithPhone(PhoneAuthCredential authCredential)async{
    try{
      UserCredential credential=await _firebaseAuth.signInWithCredential(authCredential);
      if(credential.user !=null){
        emit(AuthLoggedInState(credential.user!));
      }
    }on FirebaseAuthException catch(ex){
      emit(AuthErrorState(ex.message.toString()));
    }
  }

  void authSignOut()async{
    await _firebaseAuth.signOut();
    emit(AuthLoggetOutState());
  }

}