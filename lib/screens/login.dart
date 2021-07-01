import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trainees_flutter/blocs/auth/auth_repository.dart';
import 'package:trainees_flutter/blocs/form_submission_status.dart';
import 'package:trainees_flutter/blocs/auth/login_bloc.dart';
import 'package:trainees_flutter/blocs/auth/login_event.dart';
import 'package:trainees_flutter/blocs/auth/login_state.dart';

class User {

  String email = '';

  String password = '';

  Future<dynamic> login(String username, String password) async  {

    try {
      http.Response a = await http.post(
        Uri.http('167.233.9.110', '/api/login/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'password': password,
        }),
      );

      return a;
    } catch(e){
      return false;
    }
  }

 Future<bool> auth(context)async {
     var res = await login(email, password);
      if(res.statusCode == 200){

        Navigator.pushReplacementNamed(context, '/home', arguments: jsonDecode(
            res.body)['token'].toString());
        return true;
      }
      return false;
  }
  @override
  String toString() {
    return 'email: ${email}' +
        'password:${password}}';
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>  {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _user = User();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: /*BlocProvider(
        create: (context) => LoginBloc(
      authRepo: context.read<AuthRepository>(),
    ),
      child:*/ _loginForm(context),
    );
    //);
  }

  Widget _loginForm(context) {
    return /*BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        final formStatus = state.formStatus;
        if (formStatus is SubmissionFailed) {
          _showSnackBar(context, formStatus.exception.toString());
        }
      },
      child:*/ Form(
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
            _registerButton(context),
            SizedBox(height: 70),
            _sessionOffline(context)
          ],
        ),
      ),
    );
      //);
  }

  Widget _passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.security),
        hintText: 'Password',
      ),
      validator: (value) => null,
        onChanged: (value) {
          setState(() => _user.password = value.toString());
        }
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Username',
      ),
      validator: (value) => null,
        onChanged: (value) {
          setState(() => _user.email = value.toString());
        }
    );
  }

  void login(context)async {

   /* context.read<LoginBloc>().add(
        LoginPasswordChanged(password: _user.password),
        LoginEmailChanged(email: _user.email),
        LoginSubmitted(),
    );*/


   bool res = await _user.auth(context);
   if( res == true) {
     _showToast(context, "Login with success!");
   }else {
     _showToast(context, "Login no successfull!");
   }
    //Navigator.pushNamed(context, '/home');
  }

  Widget _loginButton(context) {
    /*return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
        ? CircularProgressIndicator()
        :*/return ElevatedButton(
          onPressed: () { login(context);},
          child: Text("Login"),
      );
    //});
  }

  Widget _registerButton(context){
    return ElevatedButton(
      onPressed: () => {Navigator.pushNamed(context, '/register')},
      child: Text("Register"),
    );
  }

  Widget _sessionOffline(context){
    return Column(children:[Text('Offline? Try our Trainning Session module'),ElevatedButton(
        onPressed: () => {Navigator.pushNamed(context, '/sessionOffline')},
    child: Text("Trainning Session"),
    ), ]);
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }
}
