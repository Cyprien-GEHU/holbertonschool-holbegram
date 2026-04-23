import 'package:flutter/material.dart';
import 'package:holbegram/screens/auth/login_screen.dart';
import 'package:holbegram/screens/auth/upload_image_screen.dart';
import '../../widgets/text_field.dart';

class SignUp extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;

  const SignUp({
    super.key,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.passwordConfirmController,
  });

  @override
  State<SignUp> createState() => _SignupState();
}

class _SignupState extends State<SignUp> {
  late bool _passwordVisible;
  late bool _comfirmPasswordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    _comfirmPasswordVisible = true;
  }

  @override
  void dispose() {
    widget.emailController.dispose();
    widget.usernameController.dispose();
    widget.passwordController.dispose();
    widget.passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 28),
            const Text(
              "Holbegram",
              style: TextStyle(
                fontFamily: "Billabong",
                fontSize: 50,
              ),
            ),
            Image.asset("assets/images/logo.png", width: 80, height: 60,),

            Padding( padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: const Text( 
                      "Sign up to see photos and videos from your friends.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 86, 84, 84)
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFieldInput(
                    controller: widget.emailController,
                    ispassword: false,
                    hintText: "Email",
                    keyboardType : TextInputType.emailAddress,
                  ),

                  SizedBox(height: 20),
                  TextFieldInput(
                    controller: widget.usernameController,
                    ispassword: false,
                    hintText: "Full name",
                    keyboardType : TextInputType.text,
                  ),

                  SizedBox(height: 24),
                  TextFieldInput(
                    controller: widget.passwordController,
                    ispassword: !_passwordVisible,
                    hintText: "Password",
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      alignment: Alignment.bottomLeft,
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      icon: Icon(
                        _passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                      ),
                    ),
                  ),

                  SizedBox(height: 24),
                  TextFieldInput(
                    controller: widget.passwordConfirmController,
                    ispassword: !_comfirmPasswordVisible,
                    hintText: "Comfirm Password",
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      alignment: Alignment.bottomLeft,
                      onPressed: () {
                        setState(() {
                          _comfirmPasswordVisible = !_comfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _comfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                      ),
                    ),
                  ),
                  const SizedBox( height: 28),

                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(218, 226, 37, 24),
                        ),
                      ),
                    onPressed: () async {
                      if (widget.passwordConfirmController.text != widget.passwordController.text)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("password do not match"))
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPicture(
                            email: widget.emailController.text, 
                            password: widget.passwordController.text, 
                            username: widget.usernameController.text)
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height:24),
            Divider(thickness: 2),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have an account ?"),
                  TextButton(
                    onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                  emailController: TextEditingController(),  
                                  passwordController: TextEditingController(), 
                                )
                              ),
                            );
                          },
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(218, 226, 37, 24)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        )
      )
    );
  }
}