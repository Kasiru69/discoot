import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Search extends StatefulWidget {
  final String uid;
  const Search(this.uid, {Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _search=new TextEditingController();
  List _arr=[];
  String _uid="";
  String check(List arr,String s){
    print(arr);
    for(int i=0;i<arr.length;i++) if(arr[i]['id']==s) return arr[i]['status'];
    return 'join';
  }
  searchname(String s)async{
    String url="https://plume-mint-promotion.glitch.me/findgroup="+s;
    http.Response res=await http.get(Uri.parse(url));
    List ok=json.decode(res.body);
    print(ok);
    return ok;
  }
  joingroup(String a,String b)async{
    String s=a+','+b;
    String url="https://plume-mint-promotion.glitch.me/joingroup="+s;
    http.Response res=await http.get(Uri.parse(url));
  }
  @override
  void initState() {
    setState(() {
      _uid=widget.uid;
      searchname(" ").then((arr){
        setState(() {
          _arr=arr;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _search,
                onChanged: (_search){
                  print(_search.toString());
                  String s=_search.toString();
                  if(s.length==0) s=" ";
                  searchname(s).then((arr){
                    setState(() {
                      _arr=arr;
                    });
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter the category',
                  suffixIcon: IconButton(onPressed: (){

                  }, icon:Icon(Icons.search)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue,width: 2.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.2,
                child: (_arr.length>0)?ListView.builder(itemCount:_arr.length,itemBuilder: (context,index){
                  return Container(
                      height: MediaQuery.of(context).size.height/10,
                      width: MediaQuery.of(context).size.width/10,
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue, // choose your border color here
                              width: 2.0, // choose the width of the border
                            ),
                          )
                      ),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.height/20,
                            height: MediaQuery.of(context).size.height/20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.people,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.height/30,
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${_arr[index]['name']}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/30,color: Colors.white),),
                              Text("${_arr[index]['category']}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40,color: Colors.white54),),
                            ],
                          ),
                          (check(_arr[index]['list'],_uid)=='join')?ElevatedButton(onPressed: (){
                            setState(() {
                              joingroup(_arr[index]['id'],_uid).then((){
                                searchname(" ").then((arr){
                                  setState(() {
                                    _arr=arr;
                                  });
                                });
                              });
                            });
                          },
                          child:Text("${check(_arr[index]['list'],_uid)}",style: TextStyle(color: Colors.white54),),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                            ),
                          ):Text("${check(_arr[index]['list'],_uid)}",style: TextStyle(color: Colors.purple),),
                        ],
                      ));
                }):Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.2,
                  child: Center(
                    child: Text("No server with this group category exists",style: TextStyle(color: Colors.white),),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
