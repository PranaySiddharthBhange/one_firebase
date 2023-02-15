import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_firebase/UI/post/post_screen.dart';
import 'package:one_firebase/utils/utils.dart';
import '../../widgets/round_button.dart';
class VerifyCodeScreen extends StatefulWidget {
  final verificationId;
  const VerifyCodeScreen({Key? key,required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final verifyCodeController= TextEditingController();
  bool loading =false;
  final auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Verify"),
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
                controller: verifyCodeController,
                decoration: InputDecoration(
                    hintText: "Enter 6 Digit Code"
                ),
              ),
              SizedBox(
                height: 80,
              ),
              RoundButton(title: "Verify",loading: loading, onTap: ()async{
                setState(() {
                  loading =true;
                });
                final credential =PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verifyCodeController.text.toString());

                try{
                  await auth.signInWithCredential(credential);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(),));

                }
                catch(e){
                  setState(() {
                    loading =false;
                    utils().toastMessage(e.toString());
                  });
                }
              })
            ],
          ),
        )
    );
  }
}
