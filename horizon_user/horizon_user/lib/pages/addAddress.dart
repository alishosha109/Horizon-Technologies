import 'package:flutter/material.dart';
import 'package:horizonuser/localization/localization_constants.dart';
import 'package:horizonuser/pages/payment.dart';
import 'package:validators/validators.dart';

import 'package:connectivity_widget/connectivity_widget.dart';

class AddressInfo extends StatefulWidget {
  final total_price;

  const AddressInfo({Key key, this.total_price}) : super(key: key);

  @override
  _AddressInfoState createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  bool internet = true;
  var first_name;
  var last_name;
  var build_no;
  var street_name;
  var region;
  var city;
  var phone_number;
  var phone_number2;
  var note;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(getTranslated(context,"Address Info"),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ConnectivityWidget(
        offlineCallback: (){
          internet=false;
        },
        onlineCallback: (){
          internet=true;
        },
        builder: (context, isOnline) => Center(
            child:main_add(context)
        ),

      ),
    );
  }



  Widget main_add(context){
    ConnectivityUtils.instance.setServerToPing("https://gist.githubusercontent.com/Vanethos/dccc4b4605fc5c5aa4b9153dacc7391c/raw/355ccc0e06d0f84fdbdc83f5b8106065539d9781/gistfile1.txt");
    ConnectivityUtils.instance.setCallback((response) => response.contains("This is a test!"));
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                title: TextFormField(
                  onChanged: (value){
                    setState(() {
                      first_name=value;
                    });
                  },
                  decoration: InputDecoration(
                    //hintText: 'First Name',
                    hintText: getTranslated(context,"First Name"), border: InputBorder.none

                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return getTranslated(context,"Enter First Name");
                    }
                  },
                ),
              )
            ),
            Card(
              child: ListTile(
                title: TextFormField(
                  onChanged: (value){
                    setState(() {
                      last_name=value;
                    });
                  },
                  decoration: InputDecoration(
                    //hintText: 'First Name',
                    hintText:getTranslated(context, "Last Name"),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return getTranslated(context,"Enter Last Name");
                    }
                  },
                ),
              ),
            ),
            Card(child: ListTile(title:TextFormField(
              onChanged: (value){
                setState(() {
                  build_no=value;
                });
              },
              decoration: InputDecoration(
                hintText: getTranslated(context,"Building No."),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return getTranslated(context,"Enter Building No.");
                }
              },
            ),),),
            Card(child: ListTile(title:TextFormField(
              onChanged: (value){
                setState(() {
                  street_name=value;
                });
              },
              decoration: InputDecoration(
                hintText: getTranslated(context,"Street Name"),
                  border: InputBorder.none
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return getTranslated(context,"Enter Street Name");
                }
              },
            ) ,),),

            Card(child: ListTile(title:TextFormField(
              onChanged: (value){
                setState(() {
                  region=value;
                });
              },
              decoration: InputDecoration(
                hintText: getTranslated(context,"Region"),
                  border: InputBorder.none
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return getTranslated(context,"Enter Region");
                }
              },
            ) ,),),
            Card(child: ListTile(title:TextFormField(
              onChanged: (value){
                setState(() {
                  city=value;
                });
              },
              decoration: InputDecoration(
                hintText: getTranslated(context,"City"),
                  border: InputBorder.none
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return getTranslated(context,"Enter City");
                }
              },
            ) ,),),

            Card(child: ListTile(title: TextFormField(
              onChanged: (value){
                setState(() {
                  phone_number=value;
                });
              },
              decoration: InputDecoration(
                hintText: getTranslated(context,"Phone Number"),
                  border: InputBorder.none
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return getTranslated(context,"Enter Phone Number");
                }else if(!isNumeric(value)){
                  return getTranslated(context,"Enter Phone Number");
                }
              },
            ),),),
            Card(child: ListTile(title:TextFormField(
              onChanged: (value){
                setState(() {
                  phone_number2=value;
                });
              },
              decoration: InputDecoration(
                hintText: getTranslated(context,"Phone Number 2"),
                  border: InputBorder.none
              ),

            ) ,),),
            Card(child: ListTile(title:TextFormField(
              onChanged: (value){
                setState(() {
                  note=value;
                });
              },
              decoration: InputDecoration(
                hintText: getTranslated(context,"Shipping Note"),
                 border: InputBorder.none
              ),

            ) ,),),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: RaisedButton(
                onPressed: (){
                  if(_formKey.currentState.validate()){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                      return Payment(fname: first_name,lname: last_name,build_no: build_no,sname: street_name,reg: region,city: city,phone_number: phone_number,total_price: widget.total_price,ph2:phone_number2==null?"":phone_number2,note:note==null?" ":note);
                    }
                    ));
                  }

                },
                elevation: 0.5,
                color: Colors.red,
                child: Center(
                  child: Text(
    getTranslated(context, 'Proceed To Payment'),
                  ),
                ),
                textColor: Colors.white,
              ),
            ),



          ],
        ),
      ),
    );
  }


}


