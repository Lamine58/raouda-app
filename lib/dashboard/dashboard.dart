// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:raouda_collecte/api/api.dart';
import 'package:raouda_collecte/auth/login.dart';
import 'package:raouda_collecte/contribution/contributions.dart';
import 'package:raouda_collecte/customer/customer.dart';
import 'package:raouda_collecte/function/function.dart';
import 'package:raouda_collecte/function/translate.dart';
import 'package:raouda_collecte/payement/payments.dart';
import 'package:raouda_collecte/saving/savings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  String lang = 'Français';
  var app_name = 'RAOUDA COLLECTE';
  var last_name = '';
  var base = '';
  var id = '';
  var avatar;
  late Api api = Api();

  @override
  void initState() {
    super.initState();
    base = api.getbaseUpload();
    init();
  }

  init() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = jsonDecode(prefs.getString('cutomerData')!);

    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
    setState(() {
      last_name = data['customer']['last_name'];
      avatar = data['customer']['avatar'];
      id = data['customer']['id'];
    });

    refresh(data,prefs);
  }

  refresh(data,prefs) async {
    
    var response = await api.post('user', {"id":data['customer']['id']});

    try{
      if (response['status'] == 'success') {
        data = response;
        await prefs.setString('cutomerData', jsonEncode(response));
        setState(() {
          last_name = data['customer']['last_name'];
          avatar = data['customer']['avatar'];
        });
      }
    }catch(err){}

  }

  networkImage(){
    return NetworkImage(base+avatar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor(),
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor(),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left:25,right: 25,top: 20,bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.remove('cutomerData');
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (routes)=>false
                          );
                        },
                        child: Icon(BootstrapIcons.box_arrow_right,color: Colors.white)
                      ),
                      Expanded(
                        child: SizedBox()
                      ),
                      GestureDetector(
                        onTap: (){
                        },
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(73, 255, 255, 255),
                          backgroundImage: 
                          avatar==null
                          ? AssetImage('assets/images/avatar-1.png')
                          : networkImage(),
                          radius: 27,
                        ),
                      )
                    ],
                  ),
                  Text(
                    translate('welcome_dash', lang)+' $last_name',
                    style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.start,
                  ),
                  paddingTop(5),
                  Text(
                    translate('text_dash', lang)+' $app_name',
                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
                  paddingTop(15),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight:Radius.circular(25))
                ),
               child: Container(
                 padding: EdgeInsets.all(15),
                 child: Center(
                   child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: ()=>{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Contributions(id))
                                      )
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/5727623.webp',height: 100),
                                          Text(translate('contribution', lang))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7, 
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                paddingLeft(15),
                                Expanded(child:
                                  GestureDetector(
                                    onTap: ()=>{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Savings(id))
                                      )
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/4596523.webp',height: 100),
                                          Text(translate('saving', lang))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7, 
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ],
                        ),
                        paddingTop(15),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child:
                                  GestureDetector(
                                    onTap: ()=>{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Payments(id))
                                      )
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              Image.asset('assets/images/7218080.webp',height: 100),
                                              Text(translate('payment', lang))
                                            ],
                                          )
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7, 
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                                paddingLeft(15),
                                Expanded(child:
                                  GestureDetector(
                                    onTap: ()=>{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Customer())
                                      )
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/6138720.webp',height: 100),
                                          Text(translate('profil', lang))
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 7, 
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                   ),
                 ),
               ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
