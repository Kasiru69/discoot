import 'dart:convert';

import 'package:discoot/Authentication/SignUp.dart';
import 'package:discoot/Functions/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email=new TextEditingController();
  TextEditingController _password=new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _ok="";
  Logintoken(String s)async {
    String url="https://plume-mint-promotion.glitch.me/login="+s;
    http.Response res=await http.get(Uri.parse(url));
    setState(() {
      _ok=res.body;
    });
    //print(ok);
    return _ok;
  }
  Tokendecode(String s)async{
    String url="https://plume-mint-promotion.glitch.me/decode="+s;
    http.Response res=await http.get(Uri.parse(url));
    print(res.body);
    return res.body;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key:_formKey,
        child: Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("asset/bg.jpeg"),
                  fit: BoxFit.fill,
                )
            ),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width/3,
              color: Colors.black54,
              child: Column(
                children: [
                  Text("Discoot",style: TextStyle(fontSize: 30,color: Colors.white54),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),labelText: "Email"),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _password,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),labelText: "Password"),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.length==0) {
                          return 'Please enter the password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/3-16,
                    child: ElevatedButton(onPressed: ()async{
                      if(_formKey.currentState!.validate()) {
                        String s=_email.text.toString()+","+_password.text.toString();
                        Logintoken(s).then((str){
                          if(str=="The email does not exist or the entered password is incorrect"){
                            showModalBottomSheet(context: context, builder:(BuildContext context){
                              return Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text("This email address donot exist or incorrect password entered",style: TextStyle(color: Colors.red),),
                                  ),
                                ),
                              );
                            });
                            setState(() {
                              _email.text="";
                              _password.text="";
                            });
                          }
                          else{
                            Tokendecode(str).then((strr){
                              //print(str);
                              print(strr);
                              Navigator.push(context,MaterialPageRoute(builder: (context)=>home(strr)));
                            });
                          }
                        });
                        //print(ok);
                      }
                    },
                      child: Text("login",style: TextStyle(fontSize: MediaQuery.of(context).size.height/30,color: Colors.white),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Don't have an account? ",style: TextStyle(color: Colors.white)),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                          },
                          child: Text("Register",style: TextStyle(color: Colors.blue),),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
