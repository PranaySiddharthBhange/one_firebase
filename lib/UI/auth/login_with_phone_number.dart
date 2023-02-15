import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_firebase/UI/auth/verify_code.dart';
import 'package:one_firebase/utils/utils.dart';
import 'package:one_firebase/widgets/round_button.dart';
class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController= TextEditingController();
  bool loading =false;
  final auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
              SizedBox(
                height: 80,
              ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: "Enter Phone Number"
              ),
            ),
            SizedBox(
              height: 80,
            ),
            RoundButton(title: "Login",loading: loading, onTap: (){
              setState(() {
                loading=true;
              });
              auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){},
                  verificationFailed:(e){
                    setState(() {
                      loading=false;
                    });
                  utils().toastMessage(e.toString());
                  },
                  codeSent: (String verificationId,int? token){
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>VerifyCodeScreen(verificationId:verificationId ,) ));
                    setState(() {
                      loading=false;
                    });
                  },
                  codeAutoRetrievalTimeout: (e){
                  utils().toastMessage(e.toString());
                  }
              );
            })
          ],
        ),
      )
    );
  }
}
