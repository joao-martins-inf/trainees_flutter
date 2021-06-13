import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loginForm(context),
    );
  }

  Widget _loginForm(context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _emailField(),
            _passwordField(),
            SizedBox(height: 10,),
            _loginButton(context),
            SizedBox(height: 30),
            Text('Do not have an account?'),
            _registerButton(context)
          ],
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.security),
        hintText: 'Password',
      ),
      validator: (value) => null,
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Email',
      ),
      validator: (value) => null,
    );
  }

  Widget _loginButton(context) {
    return ElevatedButton(
      onPressed: () => {Navigator.pushNamed(context, '/home')},
      child: Text("Login"),
    );
  }

  Widget _registerButton(context){
    return ElevatedButton(
      onPressed: () => {Navigator.pushNamed(context, '/register')},
      child: Text("Register"),
    );
  }
}
