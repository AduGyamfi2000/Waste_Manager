import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String name = "";
  late String email;
  late String phoneno;
  late String password;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final reference = FirebaseDatabase.instance.ref('user');
  bool obscuretext = true;
  bool loginclicked = false;
  final formkey = GlobalKey<FormState>();
  void createnewUser() async {
    final FormState? formState = formkey.currentState;
    if (formState!.validate()) {
      formState.save();
      auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((userCredential) {
        reference.child(userCredential.user!.uid).child("name").set(name);
        reference.child(userCredential.user!.uid).child("email").set(email);
        reference.child(userCredential.user!.uid).child("mobile").set(phoneno);
        Navigator.pushReplacementNamed(context, "/my");
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.orange,
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Image.asset(
                "lib/assets/electronics-recycling.jpeg",
                fit: BoxFit.fill,
              ),
              Text(
                "Welcome $name",
                textScaleFactor: 1.2,
                style: const TextStyle(color: Colors.white),
              ),
              const Text(
                "Sign in",
                textScaleFactor: 1.2,
                style: TextStyle(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  onChanged: (changed) {
                    name = changed;
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " invalid name";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: "Name", labelText: "Enter Name"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  onChanged: (changed) {
                    phoneno = changed;
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.length < 10) {
                      return " invalid number";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: "Mobile number", labelText: "Enter here"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  onChanged: (changed) {
                    email = changed;
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return " Email required!";
                    } else if (!EmailValidator.validate(email)) {
                      return "invalid email";
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                      hintText: "Email", labelText: "Enter Email"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  obscureText: obscuretext,
                  onChanged: (changed) {
                    password = changed;
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null) {
                      return " invalid password";
                    } else {
                      if (value.length < 6) {
                        return "password too short";
                      } else {
                        return null;
                      }
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscuretext = !obscuretext;
                          });
                          FocusScope.of(context).unfocus();
                        },
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.white,
                        ),
                      ),
                      labelText: "Enter Password"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loginclicked = true;
                    });
                    if (formkey.currentState!.validate()) {
                      createnewUser();
                    }
                  },
                  child: const Text(
                    "Sign in",
                    textScaleFactor: 1.5,
                  )),
              const SizedBox(
                height: 10,
              ),
              loginclicked
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
