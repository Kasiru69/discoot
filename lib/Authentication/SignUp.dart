import 'package:discoot/Functions/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _email=new TextEditingController();
  TextEditingController _password=new TextEditingController();
  TextEditingController _username=new TextEditingController();
  TextEditingController _chat=new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Signupid(String s)async {
    String url="https://plume-mint-promotion.glitch.me/sign="+s;
    http.Response res=await http.get(Uri.parse(url));
    String ok=res.body;
    //print(ok);
    return ok;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("asset/bg.jpeg"),
                fit: BoxFit.fill,
              )
          ),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height/1.5,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _username,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),labelText: "Username"),
                      style: TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.length==0) {
                          return 'Please enter the username';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/3-16,
                    child: ElevatedButton(onPressed: ()async{
                      if(_formKey.currentState!.validate()) {
                        String s=_email.text.toString()+","+_password.text.toString()+","+_username.text.toString();
                        Signupid(s).then((str){
                          if(str=="this email already exist"){
                            showModalBottomSheet(context: context, builder:(BuildContext context){
                              return Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text("this email already exist",style: TextStyle(color: Colors.red),),
                                  ),
                                ),
                              );
                            });
                            setState(() {
                              _email.text="";
                              _password.text="";
                            });
                          }
                          else if(_email.text.toString().contains("-") || _email.text.toString().contains("/")){
                            showModalBottomSheet(context: context, builder:(BuildContext context){
                              return Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text("the email cannot contain '-','/'",style: TextStyle(color: Colors.red),),
                                  ),
                                ),
                              );
                            });
                            setState(() {
                              _email.text="";
                              _password.text="";
                            });
                          }
                          else if(!_email.text.toString().contains("@gmail.com")){
                            showModalBottomSheet(context: context, builder:(BuildContext context){
                              return Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text("the email should be in the form of xxx@gmail.com",style: TextStyle(color: Colors.red),),
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
                            print(str);
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>home(str)));
                          }
                        });
                        //print(ok);
                      }
                    },
                      child: Text("Register",style: TextStyle(fontSize: MediaQuery.of(context).size.height/30,color: Colors.white),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
    ),
      ));
  }
}
