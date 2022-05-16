import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latres_tpm_035/LoginRegisterPage/register_page.dart';
import 'package:latres_tpm_035/common_submit_button.dart';
import 'package:latres_tpm_035/helper/hive_database.dart';
import 'package:latres_tpm_035/helper/shared_preference.dart';
import 'package:latres_tpm_035/main_menu/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if(form != null){
      if (form.validate()) {
        ('Form is valid');
      } else {
        ('Form is invalid');
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white70),
                        labelText: "Username",
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.white38),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))
                        ),

                    ),
                    validator: (value) => value!.isEmpty ? 'Username null':null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white70),
                        label: Text("Password"),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.white38),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                            borderRadius:
                            BorderRadius.all(Radius.circular(25.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 3, color: Colors.grey),
                          borderRadius:
                          BorderRadius.all(Radius.circular(25.0))
                      ),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Password null' : null,
                  ),
                ),
                _buildLoginButton(),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CommonSubmitButton(
        labelButton: "LOGIN",
        submitCallback: (value) {
          validateAndSave();
          String currentUsername = _usernameController.value.text;
          String currentPassword = _passwordController.value.text;

          _processLogin(currentUsername, currentPassword);
        },
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CommonSubmitButton(
        labelButton: "REGISTER",
        submitCallback: (value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RegisterPage(),
            ),
          );
        },
      ),
    );
  }

  void _processLogin(String username, String password) async {
    final HiveDatabase _hive = HiveDatabase();
    bool found = false;

    found = _hive.checkLogin(username, password);
    if(!found) {
      _showToast("Account not found",
          duration: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    } else{
      String? history = _hive.getHistory(username);
      String? image = _hive.getImage(username);
      SharedPreference().setLogin(username, password);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Homepage(username:username, password: password, history: "$history", image: "$image",),
        ),
      );
    }
  }

  void _showToast(String msg, {Toast? duration, ToastGravity? gravity}){
    Fluttertoast.showToast(msg: msg, toastLength: duration, gravity: gravity);
  }
}





































