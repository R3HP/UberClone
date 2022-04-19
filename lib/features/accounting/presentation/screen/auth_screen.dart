import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/accounting/presentation/controller/auth_controller.dart';
import 'package:taxi_line/features/accounting/presentation/widget/auth_form_text_form_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = false;
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = sl<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/auth_background.jpg'),
              fit: BoxFit.fill),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
          position: DecorationPosition.background,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(20.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7, sigmaY: 5),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 100),
                    reverseDuration: const Duration(milliseconds: 100),
                    curve: Curves.elasticIn,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.white.withOpacity(0.1)
                          ],
                              begin: AlignmentDirectional.topStart,
                              end: AlignmentDirectional.bottomEnd)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FittedBox(
                              child: Text(
                                'Use Your Email And Password to Login',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor.withRed(180),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (_isSignUp)
                              AuthFormTextFormField(
                                textController: _userNameController,
                                label: 'Username',
                              ),
                            if (_isSignUp)
                              const SizedBox(
                                height: 20,
                              ),
                            AuthFormTextFormField(
                                textController: _emailController,
                                label: 'Email'),
                            const SizedBox(
                              height: 20,
                            ),
                            AuthFormTextFormField(
                                textController: _passwordController,
                                label: 'Password'),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isSignUp = !_isSignUp;
                                  });
                                },
                                child: FittedBox(
                                  child: Text(
                                    _isSignUp
                                        ? 'Already A member ? Login'
                                        : 'Don\'t Have An Account Yet ? Create now',
                                    style: TextStyle(color: Theme.of(context).primaryColor.withRed(180)),
                                  ),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_isSignUp) {
                                      authController.createUser(
                                          _userNameController.text,
                                          _emailController.text,
                                          _passwordController.text);
                                    } else {
                                      authController.loginWithEmailAndPassword(
                                          _emailController.text,
                                          _passwordController.text);
                                    }
                                  }
                                },
                                child: Text(_isSignUp ? 'Signup' : 'Signin'))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

