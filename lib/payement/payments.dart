// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raouda_collecte/api/api.dart';
import 'package:raouda_collecte/function/function.dart';
import 'package:raouda_collecte/function/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Payments extends StatefulWidget {

  var customer_id;

  Payments(this.customer_id,{Key? key}) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {

  var load = true;
  int selectedOption = 0;
  List filteredList = [];
  List itemList = [];
  // ignore: non_constant_identifier_names
  dynamic next_page_url;
  TextEditingController searchController = TextEditingController();
  List options = [];
  final ScrollController _scrollController = ScrollController();
  late Api api = Api();
  bool _isLoading = false;

  String lang = 'Français';
  NumberFormat currencyFormatter = NumberFormat.currency(locale: 'fr_XOF', symbol: 'XOF');

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
        _loadData();
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    data();
    searchController.addListener(filterItems);
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadData() async {

    if (!_isLoading && next_page_url!=null) {

      setState(() {
        _isLoading = true;
      });

      try {

        dynamic response;

        response = await api.url(next_page_url+'&customer_id='+widget.customer_id);

        if (response != false) {
          setState(() {
            var data = response['data']['data'];
            next_page_url = response['data']['next_page_url'];
            _isLoading = false;
            data.forEach((acte) {
              itemList.add(acte);
            });
            filteredList = itemList;
          });
        }
      } catch (e) {
        print(e);
        print('Veuillez verifier votre connexion internet');
      }
    }
  }
  
  data() async {
    
    var response = await api.get('payments?customer_id='+widget.customer_id);

    print(response);

    try{
      if (response['status'] == 'success') {
        setState(() {
          itemList = response['data']['data'];
          next_page_url = response['data']['next_page_url'];
          filteredList = itemList;
          load = false;
        });
      }
    }catch(err){}

  }

  init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('lang')!=null){
      setState(() {
        lang = prefs.getString('lang')!;
      });
    }
  }

  void filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredList = itemList.where((item) =>  item['name'].toString().toLowerCase().contains(query)).toList();
    });
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
          'Historique des paiements',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
            color: Colors.white
          )
        ),
      ),
      backgroundColor: primaryColor(),
      body: 
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15,right: 15,top: 10),
            decoration: BoxDecoration(
              color: primaryColor(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: TextField(
                      style: TextStyle(color: Colors.white), // Couleur du texte
                      controller: searchController,
                        decoration: InputDecoration(
                          hintText: translate('search', lang),
                          labelStyle: TextStyle(color: Colors.white), // Couleur du texte du label
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintStyle: TextStyle(color: Color.fromARGB(90, 245, 245, 245),fontWeight: FontWeight.w300),
                          filled: true,
                          fillColor: Colors.grey[200]?.withOpacity(0.2), // Couleur de fond (sera obscurcie par le dégradé)
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(77, 255, 255, 255),
                            )
                          ),
                          suffixIcon: Icon(BootstrapIcons.search,color: const Color.fromARGB(77, 255, 255, 255),)
                        ),
                    ),
                  ),
                )
              ],
            ),
          ),
          paddingTop(20),
          load==false && filteredList.isEmpty
          ? Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child : Text(translate('empty', lang))
                  ),
                ],
              ),
            ),
          )
          : load
          ? Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator(color: primaryColor())),
                ],
              ),
            ),
          )
          : Expanded(
            child:Container(
            padding: EdgeInsets.only(top: 15,left: 5,right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
            ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return Container(
                          padding: EdgeInsets.all(7),
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 237, 237, 237),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['reference_operateur'],textAlign:TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Roboto',fontSize: 15)),
                                          paddingTop(3),
                                          Text(currencyFormatter.format(int.parse(item['amount'])),textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto')),
                                          Text(item['contribution_id']==null ? 'Epargne' : 'Cotisation',textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                          Text(dateLang(item['created_at'],lang),textAlign:TextAlign.start,style: TextStyle(fontFamily: 'Roboto',fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ImageChannel(item['channel'])
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}