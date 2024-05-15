import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:discoot/Functions/search.dart';
import 'package:discoot/popup/groupcreation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class home extends StatefulWidget {
  final String uid;
  const home(this.uid, {Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String _uid="",_test="Servers";
  List _servers=[];
  List _serversid=[];
  List _members=[];
  int _flag=0,_idx=-1;
  List _chats=[];
  List _sender=[];
  List _tym=[];
  List _senderid=[];
  bool _istyping=false;
  Map<String,List> map={};
  late io.Socket socket;
  TextEditingController _chat=new TextEditingController();
  @override
  void initState() {
    setState(() {
      _uid=widget.uid;
      Server(_uid).then((arr){
        setState(() {
          List temparr=arr;
          List ok=temparr.reversed.toList();
          List lasttmp=[];
          for(int i=0;i<ok.length;i++){
            String it=ok[i];
            List<String> parts = it.split('-');
            lasttmp.add(parts[0]);
          }
          setState(() {
            _servers=lasttmp;
            _serversid=ok;
          });
          print(_servers[0].toString().length);
        });
      });
    });
    setState(() {
      socket = io.io('https://periodic-rogue-trampoline.glitch.me/', <String, dynamic>{
        'autoConnect': false,
        'transports': ['websocket'],
      });
      socket.connect();
    });
    //socket.connect();
    socket.onConnect((_) {
      print('Connected to the socket server');
    });
    socket.on('typing', (_) {
      setState(() {
        _istyping = true;
        if(!map.containsKey(_[0])) map[_[0]]=[];
        List? tmp=map[_[0]];
        if(tmp!=null) if(!tmp.contains(_[1])) tmp.add(_[1]);
        if(tmp!=null) map[_[0]]=tmp;
        print(tmp);
      });
    });

    socket.on('stoppedTyping', (_) {
      setState(() {
        _istyping = false;
        List? tmp=map[_[0]];
        if(tmp!=null) tmp.remove(_[1]);
        if(tmp!=null) map[_[0]]=tmp;
      });
    });
    socket.on('delete',(_){
      if(_[0]==_serversid[_idx]){
        setState(() {
          _chats[_[1]]='Message was deleted';
        });
      }
    });
    socket.on('chat_message', (data) {
      print("message got");
      setState(() {
        if(data[2]==_serversid[_idx]){
          print(_serversid[_idx]);
          print(data[1]);
          if(data[1]!=_uid){
            _chats=_chats.reversed.toList();
            _chats.add(data[0]);
            _chats=_chats.reversed.toList();
            _tym=_tym.reversed.toList();
            _tym.add(data[3]);
            _tym=_tym.reversed.toList();
            _senderid=_senderid.reversed.toList();
            _senderid.add(data[1]);
            _senderid=_senderid.reversed.toList();
            uidtoname(data[1]).then((s){
              setState(() {
                _sender=_sender.reversed.toList();
                _sender.add(s);
                _sender=_sender.reversed.toList();
              });
            });
            //print("${data[0]} ${_uid}");
          }
        }
      });
    });
    //super.initState();
  }
  uidtoname(String s)async{
    String url="https://plume-mint-promotion.glitch.me/uidtoname="+s;
    http.Response res=await http.get(Uri.parse(url));
    String str=res.body;
    return str;
  }
  bool check(Map<String,List> map,int index){
    List? tmp=map[_serversid[_idx]];
    if(tmp!=null){
      if(tmp.contains(_members[index]['id'])) return true;
      else return false;
    }
    return false;
  }
  Members(String s)async{
    String url="https://plume-mint-promotion.glitch.me/members="+s;
    http.Response res=await http.get(Uri.parse(url));
    List<dynamic> ok=json.decode(res.body);
    print(ok);
    return ok;
  }
  Server(String s)async {
    String url="https://plume-mint-promotion.glitch.me/server="+s;
    http.Response res=await http.get(Uri.parse(url));
    List<dynamic> ok=json.decode(res.body);
    print(ok);
    return ok;
  }
  Sendmessage(String a,String b,String c,String d)async{
    String s=a+","+b+","+c+","+d;
    String url="https://plume-mint-promotion.glitch.me/sendmessage="+s;
    http.Response res=await http.get(Uri.parse(url));
  }
  Getmessage(String a)async{
    String url="https://plume-mint-promotion.glitch.me/getmessage="+a;
    http.Response res=await http.get(Uri.parse(url));
    List<dynamic> ok=json.decode(res.body);
    return ok;
  }
  Deletemessage(String s)async{
    String url="https://plume-mint-promotion.glitch.me/deletemessage="+s;
    http.Response res=await http.get(Uri.parse(url));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width/10,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  right: BorderSide(
                    color: Colors.blue, // choose your border color here
                    width: 2.0, // choose the width of the border
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        
                        ElevatedButton(onPressed: ()async{
                          final result=await showDialog(context: context, builder: (context)=>groupcreationpopup(_uid,_servers));
                          setState(() {
                            Server(_uid).then((arr){
                              setState(() {
                                List temparr=arr;
                                List ok=temparr.reversed.toList();
                                List lasttmp=[];
                                for(int i=0;i<ok.length;i++){
                                  String it=ok[i];
                                  List<String> parts = it.split('-');
                                  lasttmp.add(parts[0]);
                                }
                                setState(() {
                                  _servers=lasttmp;
                                });
                              });
                              print(arr);
                            });
                          });
                        },
                          child: Text("Create a server",style: TextStyle(color: Colors.white,fontSize: 10),),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Servers",style: TextStyle(color: Colors.white,fontSize: 20),),
                        IconButton(onPressed: (){
                          setState(() {
                            Server(_uid).then((arr){
                              //for(int i=0;i<arr.length;i++) _servers.add(arr[i] as String);
                              setState(() {
                                List temparr=arr;
                                List ok=temparr.reversed.toList();
                                List lasttmp=[];
                                for(int i=0;i<ok.length;i++){
                                  String it=ok[i];
                                  List<String> parts = it.split('-');
                                  lasttmp.add(parts[0]);
                                }
                                setState(() {
                                  _servers=lasttmp;
                                  _serversid=ok;
                                });
                                print(_servers[0].toString().length);
                              });
                            });
                          });
                        }, icon:Icon(Icons.refresh,color: Colors.white,size: 15,))
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height-87-11,
                      width: MediaQuery.of(context).size.width/10,
                      child: ListView.builder(itemCount:_servers.length,itemBuilder:(context,index){
                        return Container(
                          height: MediaQuery.of(context).size.height/20,
                          width: MediaQuery.of(context).size.width/10,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.blue, // choose your border color here
                                width: 2.0, // choose the width of the border
                              ),
                            )
                          ),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                _flag=1;
                                _idx=index;
                                _members=[];
                                _chats=[];
                                _sender=[];
                                _tym=[];
                                _chat.text="";
                                setState(() {
                                  //socketton(_idx);
                                  Getmessage(_serversid[index]).then((arr){
                                    List tmpchat=[];
                                    List tmpsender=[];
                                    List tmptym=[];
                                    List tmpsenderid=[];
                                    for(int i=0;i<arr.length;i++){
                                      tmpchat.add(arr[i]['message']);
                                      tmpsender.add(arr[i]['sender']);
                                      tmptym.add(arr[i]['time']);
                                      tmpsenderid.add(arr[i]['senderid']);
                                    }
                                    setState(() {
                                      _chats=tmpchat.reversed.toList();
                                      _tym=tmptym.reversed.toList();
                                      _sender=tmpsender.reversed.toList();
                                      _senderid=tmpsenderid.reversed.toList();
                                    });
                                  });
                                  Members(_serversid[index]).then((arr){
                                    setState(() {
                                      _members=arr;
                                    });
                                  });
                                });
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                              width: MediaQuery.of(context).size.height/30,
                              height: MediaQuery.of(context).size.height/30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.people,
                                  color: Colors.white,
                                  size: MediaQuery.of(context).size.height/40,
                                ),
                                ),
                                ),
                                SizedBox(width: 5,),
                                Text("${_servers[index]}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/30,color: Colors.white),)
                              ],
                            ),
                          )
                        );
                      }),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width/4,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  right: BorderSide(
                    color: Colors.blue, // choose your border color here
                    width: 2.0, // choose the width of the border
                  ),
                ),
              ),
              child:(_flag==0)?Search(_uid):Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height/20,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue, // choose your border color here
                              width: 2.0, // choose the width of the border
                            ),
                          )
                      ),
                      child: Row(
                        children: [
                          IconButton(onPressed: (){
                            setState(() {
                              _flag=0;
                              socket.disconnect();
                              _members=[];
                            });
                          }, icon: Icon(Icons.arrow_back),color: Colors.white,),
                          SizedBox(width: 70,),
                          Text("${_servers[_idx]}",style:TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.height/30),)
                        ],
                      ),
                    ),
                    Text("${_members.length} members",style: TextStyle(color: Colors.white54),),
                    SizedBox(height: 5,),
                    Container(
                      height: MediaQuery.of(context).size.height-5-MediaQuery.of(context).size.height/20-20,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(itemCount:_members.length,itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height/10+20,
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.blue, // choose your border color here
                                    width: 2.0, // choose the width of the border
                                  ),
                                )
                            ),
                            child: Row(
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
                                      Icons.person,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.height/30,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("${_members[index]['username']}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/30,color: Colors.white),),
                                    (_members[index]['status']=='creator')?Text("${_members[index]['status']}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40,color: Colors.green),):
                                    Text("${_members[index]['status']}",style: TextStyle(fontSize: MediaQuery.of(context).size.height/40,color: Colors.white54),),
                                    (check(map,index))?Text("typing...",style: TextStyle(color: Colors.white),):Text("")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ) ,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/4-MediaQuery.of(context).size.width/10,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("asset/bg.jpeg"),
                    fit: BoxFit.fill,
                  )
              ),
              child: (_flag==0)?Center(
                child: Container(
                  height: 30,
                  width: (MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/4-MediaQuery.of(context).size.width/10)/2,
                  color: Colors.black54,
                  child: Center(child: Text("Select a server to start messaging",style: TextStyle(color: Colors.white),)),
                )
              ):Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height-50,
                    width: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/4-MediaQuery.of(context).size.width/10,
                    child: ListView.builder(reverse:true,itemCount:_sender.length,itemBuilder: (context,index){
                      return Expanded(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: (MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/4-MediaQuery.of(context).size.width/10)/3,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.cyan, // Blue border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.height/15,
                                        height: MediaQuery.of(context).size.height/15,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: MediaQuery.of(context).size.height/30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${_sender[index]}",style: TextStyle(color: Colors.green),),
                                          (_chats[index]!="Message was deleted")?Text("${_chats[index]}",style: TextStyle(color: Colors.green,fontSize: 20),):Text("${_chats[index]}",style: TextStyle(color: Colors.red,fontSize: 20),),
                                          Row(
                                            children: [
                                              SizedBox(width: (MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/4-MediaQuery.of(context).size.width/10)/6-10,),
                                              Text("${_tym[index]}",style: TextStyle(color: Colors.green),),
                                              (_senderid[index]==_uid && _chats[index]!="Message was deleted")?IconButton(onPressed: (){
                                                showDialog(context: context,
                                                    builder: (BuildContext context){
                                                      return AlertDialog(
                                                        title: Text('Delete Message'),
                                                        content: Text('Are you sure you want to delete this item?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              String s=_serversid[_idx]+","+(_sender.length-index-1).toString();
                                                              Deletemessage(s);
                                                              List tmp=[];
                                                              tmp.add(_serversid[_idx]); tmp.add(index);
                                                              socket.emit('delete',tmp);
                                                              setState(() {
                                                                _chats[index]="Message was deleted";
                                                              });
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('Delete'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('Cancel'),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                );
                                              },
                                                  icon: Icon(Icons.delete),
                                                color: Colors.green,
                                              ):SizedBox()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                    }),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width/4-MediaQuery.of(context).size.width/10,
                    child: TextField(
                      controller: _chat,
                      onChanged: (text){
                        if (text.isNotEmpty && !_istyping) {
                          List tmp=[];
                          tmp.add(_uid); tmp.add(_serversid[_idx]);
                          socket.emit('typing',tmp);
                        }
                        if (text.isEmpty && _istyping) {
                          List tmp=[];
                          tmp.add(_uid); tmp.add(_serversid[_idx]);
                          socket.emit('stoppedTyping',tmp);
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: (){
                            String str=_chat.text.toString();
                            DateTime Time=DateTime.now();
                            String time=Time.hour.toString()+":"+Time.minute.toString();
                            if(str.length>0){
                              List temp=[];
                              temp.add(str); temp.add(_uid); temp.add(_serversid[_idx]); temp.add(time);
                              socket.emit("chat_message",temp);
                              List tmp=[];
                              tmp.add(_uid); tmp.add(_serversid[_idx]);
                              socket.emit('stoppedTyping',tmp);
                              _chat.text="";
                              Sendmessage(_serversid[_idx],str,_uid,time);
                              setState(() {
                                List? tmp=map[_serversid[_idx]];
                                if(tmp!=null) tmp.remove(_uid);
                                if(tmp!=null) map[_serversid[_idx]]=tmp;
                                _chats=_chats.reversed.toList();
                                _chats.add(str);
                                _chats=_chats.reversed.toList();
                                _tym=_tym.reversed.toList();
                                _tym.add(time);
                                _tym=_tym.reversed.toList();
                                _senderid=_senderid.reversed.toList();
                                _senderid.add(_uid);
                                _senderid=_senderid.reversed.toList();
                                uidtoname(_uid).then((s){
                                  setState(() {
                                    _sender=_sender.reversed.toList();
                                    _sender.add(s);
                                    _sender=_sender.reversed.toList();
                                  });
                                });
                              });
                            }
                          },
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),hintText: "Enter your text",
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
