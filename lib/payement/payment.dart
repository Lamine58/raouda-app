// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:raouda_collecte/api/api.dart';
import 'package:raouda_collecte/dashboard/dashboard.dart';
import 'package:raouda_collecte/function/function.dart';
import 'package:raouda_collecte/function/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Payment extends StatefulWidget {

  final contribution;
  final customer_id;
  final contribution_id;

  const Payment(this.contribution,this.customer_id,this.contribution_id,{Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {


  String lang = 'Français';
  late Api api = Api();

  @override
  void initState() {
    super.initState();
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
  }

  void _showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
        title: Text('Réponse',style: TextStyle(fontSize: 20),),
        content: Text(result,style: TextStyle(fontWeight: FontWeight.w300)),
      ),
    );
  }

  pay(channel) async {
      
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
        contentPadding: EdgeInsets.all(15),
        content: Row(
          children: [
            CircularProgressIndicator(),
            paddingLeft(20),
            Text('Veuillez patienter ...')
          ],
        ),
      ),
    );

    try {

      dynamic response;
      response = await api.post('payment-contribution',{"customer_id":widget.customer_id,"contribution_id":widget.contribution_id,"channel":channel});
      
      if (response['status'] == 'success') {

        final Uri url = Uri.parse(response['url']);
        await launchUrl(url, mode:LaunchMode.externalApplication);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route)=>false
        );

      } else {
        Navigator.pop(context);
        _showResultDialog(response['message']);
      }
    } catch (error) {
       Navigator.pop(context);
      _showResultDialog('Erreur: $error');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: primaryColor(),
        toolbarHeight: 40,
        elevation: 0,
        title: Text(
          widget.contribution['name'],
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: Colors.white
          )
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: primaryColor(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left:25,right: 25,top: 0,bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate('title', lang),
                    style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.start,
                  ),
                  paddingTop(5),
                  Text(translate('amount', lang) + " : ${widget.contribution['amount']} XOF",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300),textAlign: TextAlign.start),
                  paddingTop(5),
                  Text(
                    translate('description', lang),
                    style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
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
                                      pay('WAVECI')
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top:30,bottom:30,left: 30,right: 30),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/wave.png',height: 100),
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
                                      pay('OMCIV2')
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top:30,bottom:30,left: 30,right: 30),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/om.png',height: 100),
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
                                      pay('MOMOCI')
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top:30,bottom:30,left: 30,right: 30),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/mtn.png',height: 100),
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
                                      pay('FLOOZ')
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top:30,bottom:30,left: 30,right: 30),
                                      child: Column(
                                        children: [
                                          Image.asset('assets/images/moov.png',height: 100),
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
