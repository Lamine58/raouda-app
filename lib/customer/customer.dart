// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_new, use_build_context_synchronously
import 'dart:convert';
import 'dart:io';

import 'package:raouda_collecte/api/api.dart';
import 'package:raouda_collecte/dashboard/dashboard.dart';
import 'package:raouda_collecte/function/function.dart';
import 'package:raouda_collecte/function/translate.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Customer extends StatefulWidget {
  
  const Customer({super.key});
  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {

  String lang = 'Français';
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  late String id = '';
  final _formKey = GlobalKey<FormState>();
  late bool displayPassword = false;
  late bool spinner = false;
  late Api api = Api();

  var base = '';
  
  var _avatarFile;
  var _avatar_url;

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
    
    setState(() {
      phoneController.text = data['customer']['phone'];
      id = data['customer']['id'];
      _avatar_url = data['customer']['avatar'];
      emailController.text = data['customer']['email'] ?? '';
      firstNameController.text = data['customer']['first_name'] ?? '';
      lastNameController.text = data['customer']['last_name'] ?? '';
      addressController.text = data['customer']['address'] ?? '';
    });
  }

  Future<void> _pickImage() async {

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  _source(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(BootstrapIcons.image,color: primaryColor()),
                    paddingLeft(10),
                    Text(translate('open_library', lang),style: TextStyle(fontFamily: 'Roboto'))
                  ],
                ),
              ),
              Divider(),
              GestureDetector(
                onTap: (){
                  _source(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(BootstrapIcons.camera,color: primaryColor()),
                    paddingLeft(10),
                    Text(translate('open_camera', lang),style: TextStyle(fontFamily: 'Roboto'))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

  }

  _source(source) async {

    Navigator.pop(context);
    final pickedImage = await ImagePicker().pickImage(source: source);

    var data;

    if (pickedImage != null) {
      data = await compressImage(pickedImage.path, targetSize: 250 * 1024);
    }

    setState(() {
      if (data != null) {
        _avatarFile = File(data.path);
      }
    });
  }
  
  void _saveData() async {
    
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
      
    var photo = _avatarFile;

    try {

      var response;

      if(photo!=null){

        response = await api.upload('customer-data',photo, {
          "id": id,
          "email": emailController.text,
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "address": addressController.text,
        });

      }else{
        
        response = await api.post('customer-data', {
          "id": id,
          "email": emailController.text,
          "first_name": firstNameController.text,
          "last_name": lastNameController.text,
          "address": addressController.text,
        });
      }
      

      if (response['status'] == 'success') {

        Navigator.pop(context);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cutomerData', jsonEncode(response));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
        _showResultDialog(response['message']);
      } else {
        Navigator.pop(context);
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
        toolbarHeight: 40,
        title: Text(translate('profil', lang),style: TextStyle(fontSize: 15,color: Colors.white)),
        backgroundColor: primaryColor(),
        elevation: 0,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _pickImage();
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child:  Stack(
                                children: [
                                  _avatarFile != null
                                  ? CircleAvatar(
                                      backgroundImage:  FileImage(_avatarFile), 
                                      backgroundColor: grayColor(),
                                      radius: 60,
                                    )
                                  : (_avatar_url!= null && _avatar_url!='') ?
                                  CircleAvatar(
                                      backgroundImage:  NetworkImage(api.getbaseUpload()+_avatar_url), 
                                      backgroundColor: grayColor(),
                                      radius: 60,
                                    )
                                  : CircleAvatar(
                                    backgroundImage: const AssetImage('assets/images/avatar-1.png'), 
                                    backgroundColor: grayColor(),
                                    radius: 60,
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.only(top:7,right: 7,left:7,bottom: 7),
                                      decoration: BoxDecoration(
                                        color: primaryColor(),
                                        borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: Icon(BootstrapIcons.camera_fill,color: Colors.white,)
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                          controller: phoneController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('label_phone', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_phone', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('label_email', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_email', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: firstNameController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('label_first_name', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_first_name', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: lastNameController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('label_last_name', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_last_name', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          controller: addressController,
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left:15,top: 15,bottom: 20,right: 15),
                            labelText: translate('label_location', lang),
                            labelStyle: TextStyle(color: Color.fromARGB(255, 120, 120, 120),fontWeight: FontWeight.w300),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 204, 204, 204).withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Color.fromARGB(134, 255, 255, 255),
                              )
                            ),
                          ),
                          keyboardType: TextInputType.streetAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return translate('error_location', lang);
                            }
                            return null;
                          },
                        ),
                        paddingTop(15),
                        ElevatedButton(
                          onPressed: spinner==true ? null : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _saveData();
                            } 
                          },
                          child: spinner==true ? CircularProgressIndicator(color: const Color.fromARGB(135, 255, 255, 255)) : Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(translate('confirm_data', lang),
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300)
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: primaryColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        paddingTop(20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}