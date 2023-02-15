import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:one_firebase/utils/utils.dart';
import 'package:one_firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../post/post_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading =false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth=FirebaseAuth.instance;
  // bool loading=false;

  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.alternate_email)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.alternate_email)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            }
                            return null;
                          }),
                    ],
                  )),
              SizedBox(
                height: 50,
              ),
              RoundButton(
                title: "Sign Up",
                loading: loading,
                onTap: () {

                  if (_formkey.currentState!.validate()) {
                    _auth.createUserWithEmailAndPassword(
                        email:emailController.text.toString(),
                        password:passwordController.text.toString()).then((value){
                      setState(() {
                        loading=false;
                      });

                    }).onError((error, stackTrace){
                        utils().toastMessage(error.toString());
                    });
                  }
                  Navigator.push(context,MaterialPageRoute(builder:(context)=> PostScreen()));

                },
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Text("Already have an account"),
                  TextButton(onPressed:(){
                    Navigator.push(context,MaterialPageRoute(builder:(context)=> LoginScreen()));
                  }, child: Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
