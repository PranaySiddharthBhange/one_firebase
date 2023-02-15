import 'package:flutter/material.dart';
import 'package:one_firebase/UI/auth/login_with_phone_number.dart';
import 'package:one_firebase/UI/auth/signup_screen.dart';
import 'package:one_firebase/UI/post/post_screen.dart';
import 'package:one_firebase/utils/utils.dart';
import 'package:one_firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool loading = false;

  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text.toString())
        .then((value) {
      utils().toastMessage(value.user!.email.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PostScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text("Login"),
      ),
      body: Padding(
        padding:EdgeInsets.symmetric(horizontal: 20),
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
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        decoration:InputDecoration(
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
            const SizedBox(
              height: 50,
            ),
            RoundButton(
              title: "Login",
              loading: loading,
              onTap: () {
                if (_formkey.currentState!.validate()) {
                  login();
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text("SignUp")),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder:(context) =>LoginWithPhoneNumber()) );
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.black)
                    ),
                    child: Center(
                      child: Text("Login with phone number"),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
