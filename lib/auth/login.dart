// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:raouda_collecte/api/api.dart';
import 'package:raouda_collecte/dashboard/dashboard.dart';
import 'package:raouda_collecte/function/function.dart';
import 'package:raouda_collecte/function/translate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String lang = 'Français';
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late bool displayPassword = false;
  late bool spinner = false;
  late Api api = Api();
  
  MaskTextInputFormatter phoneFormatter = new MaskTextInputFormatter(
    mask: '225 ##########', 
    filter: { "#": RegExp(r'[0-9]') },
    type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    super.initState();
    phoneController.text = '225 ';
    init();
  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
  }

  void _auth() async {
    
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
            Text(translate('wait',lang))
          ],
        ),
      ),
    );

    try {

      var response = await api.post('login', {"phone":phoneController.text,"password":passwordController.text});

      if (response['status'] == 'success') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cutomerData', jsonEncode(response));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Dashboard()),(routes)=>false);
      } else {
        Navigator.pop(context);
        print(response);
        _showResultDialog(response['message']);
      }
    } catch (error) {
       Navigator.pop(context);
      _showResultDialog('Erreur: $error');
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        toolbarHeight: 0,
        backgroundColor: primaryColor(),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                DropdownButton<String>(
                  style: TextStyle(color:Colors.black,fontSize: 15,),
                  icon: Icon(Icons.language),
                  iconSize: 23,
                  value: lang,
                  onChanged: (String? newLang) async {
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      lang = newLang!;
                      prefs.setString('lang',lang);
                    });
                  },
                  items: <String>['Français', 'English']
                    .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight:Radius.circular(25))
                ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                        child: logo(150),
                        alignment: Alignment.centerLeft,
                      ),
                      paddingTop(10),
                      Text(translate('login_text', lang),textAlign: TextAlign.start),
                      paddingTop(20),
                      Form(
                        key: _formKey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextFormField(
                                inputFormatters: [phoneFormatter],
                                textInputAction: TextInputAction.next,
                                controller: phoneController,
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  hintText: "225 0000000000",
                                  contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                  labelText: translate('label_phone', lang),
                                  labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(134, 255, 255, 255),
                                    )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(134, 255, 255, 255),
                                    )
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('error_phone', lang);
                                  }
                                  return null;
                                },
                              ),
                              paddingTop(15),
                              TextFormField(
                                textInputAction: TextInputAction.done,
                                controller: passwordController,
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                                  labelText: translate('label_password', lang),
                                  labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(134, 255, 255, 255),
                                    )
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        displayPassword = !displayPassword;
                                      });
                                    },
                                    child: !displayPassword ? Icon(BootstrapIcons.eye) : Icon(BootstrapIcons.eye_slash)
                                  ),
                                  suffixIconColor: Colors.black,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(134, 255, 255, 255),
                                    )
                                  ),
                                ),
                                obscureText: !displayPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('error_password', lang);
                                  }
                                  return null;
                                },
                              ),
                              paddingTop(20),
                              ElevatedButton(
                                onPressed: spinner==true ? null : () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    _auth();
                                  } 
                                },
                                child: spinner==true ? CircularProgressIndicator(color: const Color.fromARGB(135, 255, 255, 255)) : Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(15),
                                  child: Center(
                                    child: Text(translate('submit_login', lang),
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: primaryColor(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}