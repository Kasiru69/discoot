import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class groupcreationpopup extends StatefulWidget {
  final String uid;
  final List arr;
  const groupcreationpopup(this.uid,this.arr, {Key? key}) : super(key: key);

  @override
  State<groupcreationpopup> createState() => _groupcreationpopupState();
}

class _groupcreationpopupState extends State<groupcreationpopup> {
  String _uid="";
  List _lis=[];
  TextEditingController _groupname=new TextEditingController();
  TextEditingController _groupcategory=new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  creategroup(String a,String b)async {
    String s=a+","+b+","+_uid;
    String url="https://plume-mint-promotion.glitch.me/createserver="+s;
    http.Response res=await http.get(Uri.parse(url));
    String ok=res.body;
    print(ok);
    return ok;
  }
  Server(String s)async {
    String url="https://plume-mint-promotion.glitch.me/server="+s;
    http.Response res=await http.get(Uri.parse(url));
    List<dynamic> ok=json.decode(res.body);
    //print(ok);
    return ok;
  }
  @override
  void initState() {
    setState(() {
      _uid=widget.uid;
      _lis=widget.arr;
    });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black26,
      title: Text("Create server",style: TextStyle(color: Colors.white),),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _groupname,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),labelText: "Server Name"),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.length==0) {
                    return 'Please enter the server name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _groupcategory,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0)), enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                ),labelText: "Server Category"),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.length==0) {
                    return 'Please enter the server category';
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        SizedBox(
          child: ElevatedButton(onPressed: (){
            if(_formKey.currentState!.validate()){
              creategroup(_groupname.text.toString(),_groupcategory.text.toString()).then((str){
                if(str=="This group name already exist"){
                  showModalBottomSheet(context: context, builder:(BuildContext context){
                    return Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("this group name already exist",style: TextStyle(color: Colors.red),),
                        ),
                      ),
                    );
                  });
                  setState(() {
                    _groupcategory.text="";
                    _groupname.text="";
                  });
                }
                else{
                  /*Server(_uid).then((arr){
                    setState(() {
                      _lis=arr;
                      print(_lis);
                    });
                  });*/
                  Navigator.pop(context);
                }
              });
            }
          },
            child: Text("Create",style: TextStyle(color: Colors.white),),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple)),
          ),
        )
      ],
    );
  }
}
