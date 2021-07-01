import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  String name = '';
  String email = '';
  String username = '';
  DateTime? bornDate;
  String gender = '';
  String password = '';
  String confirmPassword = '';

  Future<bool> register(String email, String name, String username,
      String password, String confirmPassword) async {
    try {
      http.Response a = await http.post(
        Uri.http('167.233.9.110', '/api/register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'first_name': name,
          'username': username,
          'password': password,
          'password2': confirmPassword,
          'email': email,
        }),
      );

      if(a.statusCode >= 400){
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> save() async {
    return await register(email, name, username, password, confirmPassword);
  }

  @override
  String toString() {
    return 'Trainee: {name: ${name}, birthdate: ${bornDate}, email: ${email}, gender:${gender},'
        'password:${password}, $username, }';
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> _formRegisterKey = GlobalKey<FormState>();
  final _user = User();
  final TextEditingController _textController = new TextEditingController();

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (picked != null) {
      setState(() {
        _user.bornDate = picked;
        _textController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _registerForm(context),
    );
  }

  Widget _registerForm(context) {
    return Form(
      key: _formRegisterKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _emailField(),
            _nameField(),
            _userNameField(),
            // _bornDateField(),
            //_genderField(),
            _passwordField(),
            _confirmPasswordField(),
            SizedBox(height: 10),
            _registerButton(context),
            SizedBox(
              height: 30,
            ),
            Text('Do you already have an account?'),
            _loginButton(context),
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
      onChanged: (value) {
        setState(() => _user.password = value.toString());
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(Icons.security),
        hintText: 'Confirm Password',
      ),
      validator: (value) => null,
      onChanged: (value) {
        setState(() => _user.confirmPassword = value.toString());
      },
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Name',
      ),
      validator: (value) => null,
      onChanged: (value) {
        setState(() => _user.name = value.toString());
      },
    );
  }

  Widget _userNameField() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Username',
      ),
      validator: (value) => null,
      onChanged: (value) {
        setState(() => _user.username = value.toString());
      },
    );
  }

  Widget _emailField() {
    final RegExp emailRegex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Email',
      ),
      validator: (value) {
        if (!emailRegex.hasMatch(value!)) {
          return 'Please enter valid email';
        }
        return null;
      },
      onChanged: (value) {
        setState(() => _user.email = value.toString());
      },
    );
  }

  Widget _bornDateField() {
    return TextFormField(
      controller: _textController,
      onTap: () {
        // Below line stops keyboard from appearing
        FocusScope.of(context).requestFocus(new FocusNode());

        // Show Date Picker Here
        _selectDate();
      },
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelText: "Birth Date",
        icon: Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _genderField() {
    return DropdownButtonFormField(
      items: [
        DropdownMenuItem(child: Text("Male"), value: 'male'),
        DropdownMenuItem(child: Text("Female"), value: 'female'),
        DropdownMenuItem(child: Text("Undefined"), value: 'undefined'),
      ],
      onChanged: (value) {
        setState(() => _user.gender = value.toString());
      },
      decoration: InputDecoration(
        icon: Icon(Icons.transgender),
        hintText: 'Gender',
      ),
      validator: (value) => _user.gender = value.toString(),
    );
  }

  Widget _loginButton(context) {
    return ElevatedButton(
      onPressed: () => {Navigator.pushNamed(context, '/login')},
      child: Text("Login"),
    );
  }

  Widget _registerButton(context) {
    return ElevatedButton(
      onPressed: () async {
        bool res = await _user.save();

        if (res == true) {
          _showToast(context, 'Registration with success');
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          _showToast(context, 'Insuccess registration :(');
        }
      },
      child: Text("Register"),
    );
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
