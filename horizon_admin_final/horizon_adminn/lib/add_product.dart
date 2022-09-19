import 'dart:io';
import 'package:flutter/material.dart';
import 'package:horizonadminn/main.dart';
import 'package:horizonadminn/products.dart';
import 'package:image_picker/image_picker.dart';
class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}
class Types {
  //int id;
  String name;

  Types( this.name);

  static List<Types> getTypes() {
    return <Types>[
      Types( 'Laptop'),
      Types( 'Gaming Laptop'),
      Types( 'Notebook'),
      Types( '2 in 1'),
      Types( 'Tablet'),
    ];
  }
}
class _AddProductState extends State<AddProduct> {
  List<Types> _types = Types.getTypes();
  List<DropdownMenuItem<Types>> _dropdownMenuItems;
  Types _selectedtype;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String productname;
  String productid;
  double productprice;
  int productquantity;
  String material;
  List colors;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  List<DropdownMenuItem<String>> categorieslist = [];
  List<DropdownMenuItem<String>> bothgendercategorylist= [];
  List<DropdownMenuItem<String>> maleorfemalelist= [];
  String _currentCategory;
  List<String> selectedSizes = <String>[];
  List<String> selectedColors = <String>[];
  File _image1;
  File _image2;
  File _image3;
  String imgdownload1;
  String imgdownload2;
  String imgdownload3;
  String dropdown;
  var products;
  bool internet = true;
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_types);
    _selectedtype = _dropdownMenuItems[0].value;
    super.initState();
  }
  List<DropdownMenuItem<Types>> buildDropdownMenuItems(List types) {
    List<DropdownMenuItem<Types>> items = List();
    for (Types type in types) {
      items.add(
        DropdownMenuItem(
          value: type,
          child: Text(type.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Types selectedtype) {
    setState(() {
      _selectedtype = selectedtype;
    });
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.blue[800],


          title: Text(
            "Add Products",
            style: TextStyle(color: white),
          ),
        ),
        body: addProduct(),
        backgroundColor: Colors.grey[300],
      );

  }

  Widget addProduct(){
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.5), width: 2.5),
                        onPressed: () {
                          _selectImage(
                              ImagePicker.pickImage(
                                  source: ImageSource.gallery,maxHeight: 900,maxWidth: 900),
                              1);
                        },
                        child: _displayChild1()),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.5), width: 2.5),
                        onPressed: () {
                          _selectImage(
                              ImagePicker.pickImage(
                                  source: ImageSource.gallery,maxHeight: 900,maxWidth: 900),
                              2);
                        },
                        child: _displayChild2()),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      borderSide: BorderSide(
                          color: grey.withOpacity(0.5), width: 2.5),
                      onPressed: () {
                        _selectImage(
                            ImagePicker.pickImage(
                                source: ImageSource.gallery,maxHeight: 900,maxWidth: 900),
                            3);
                      },
                      child: _displayChild3(),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Enter a product name with 10 characters at maximum',
                textAlign: TextAlign.center,
                style: TextStyle(color: red, fontSize: 12),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    productname = value;
                  });
                },
                decoration: InputDecoration(hintText: 'Product name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the product name';
                  } else if (value.length > 10) {
                    return 'Product name cant have more than 10 letters';
                  }
                  return '';
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    productid = value;
                  });
                },
                decoration: InputDecoration(hintText: 'Product id'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the product id';
                  }
                  return '';
                },
              ),
            ),


//              select category
            Row(

              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Types"),
                ),


                DropdownButton(
                  hint: new Text("Types"),
                  value: _selectedtype,
                  items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,

                ),

              ],
            ),

//
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    productquantity = int.parse(value);
                  });
                },
               // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Quantity',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter the quantity';
                  }
                  return '';
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    productprice = double.parse(value);
                  });
                },
               // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Price',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'You must enter price';
                  }
                  return '';
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    //material = value;
                  });
                },
                //keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Brand',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                   // material = value;
                  });
                },
                //keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Screen Size',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    //material = value;
                  });
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Processor',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    //material = value;
                  });
                },
                //keyboardType: TextInputType.,
                decoration: InputDecoration(
                  hintText: 'Hard Disk',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    //material = value;
                  });
                },
                //keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Graphic Card Capacity',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    //material = value;
                  });
                },
                //keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Ram',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    //material = value;
                  });
                },
                //keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Color',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    //material = value;
                  });
                },
                //keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Operating System',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    //material = value;
                  });
                },
                //keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Speed',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Colors.blue[800],
                  textColor: white,
                  child: Text('Upload Product'),
                  onPressed: ()  {

                  },
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }






  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState((){
          _image1 = tempImg;
        });
        break;
      case 2:
        setState((){
          _image2 = tempImg;
        });
        break;
      case 3:
        setState((){
          _image3 = tempImg;
        });
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {

      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image2,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image3,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }


  showLoadingDialog(BuildContext context,isloading) async {
    if(isloading){
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {return new WillPopScope(onWillPop: () async => false,
              child: SimpleDialog(backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10,),
                        Text("Please Wait....",style: TextStyle(color: Colors.blueAccent),)
                      ]),
                    )
                  ]));
          });
    }else{
      return "";
    }

  }







}