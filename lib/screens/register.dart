import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User {


  String name = '';
  String email = '';
  DateTime? bornDate;
  String gender = '';
  String password = '';
  String confirmPassword = '';

  save() {
    print('saving user using a web service');
  }
  @override
  String toString() {
    return 'Student: {name: ${name}, age: ${bornDate}, email: ${email}, gender:${gender},'
        'password:${password}}';
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _user = User();
  final TextEditingController _textController = new TextEditingController();


  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now()
    );

    if(picked != null) {

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
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _emailField(),
            _nameField(),
            _bornDateField(),
            _genderField(),
            _passwordField(),
            _confirmPasswordField(),
            SizedBox(height: 10),
            _registerButton(context),
            SizedBox(height: 30, ),
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

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        hintText: 'Email',
      ),
      validator: (value) => null,
      onChanged: (value) {
        setState(() => _user.email = value.toString());
      },
    );
  }
  Widget _bornDateField() {
    return TextFormField(
      controller: _textController,
      onTap: (){
        // Below line stops keyboard from appearing
        FocusScope.of(context).requestFocus(new FocusNode());

        // Show Date Picker Here
        _selectDate();

      },
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        labelText: "Date",
        icon: Icon(Icons.calendar_today),
      ),

    );
  }
  Widget _genderField() {
    return DropdownButtonFormField(
      items:[
        DropdownMenuItem(child: Text("Male"), value:'male'),
        DropdownMenuItem(child: Text("Female"), value:'female'),
        DropdownMenuItem(child: Text("Undefined"), value:'undefined'),
      ],
        onChanged: (value) {
          setState(() => _user.gender = value.toString());
        },
      decoration: InputDecoration(
        icon: Icon(Icons.person),
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

  Widget _registerButton(context){
    return ElevatedButton(
      onPressed: () {
        print(_user);

    },
      child: Text("Register"),
    );
  }

}

