import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:horizonuser/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Methods{

  var headers = {'Authorization': 'Token ${Loginpage.usertoken.toString()}'};
  var rng = new Random();

  register(username,pass1)async{
    var url = 'http://horizonstore.pythonanywhere.com/rest-auth/registration/';
    var headers = {"Content-Type": "application/json"};
    var body = jsonEncode({
      "username":username,
      "password1":pass1,
      "password2":pass1,
    });
    var response = await http.post(url,body:body,headers: headers);
    print(response.body);
    var li = json.decode(response.body);
    if(response.statusCode !=201 ){
      return [false,li];
    }else{


      Loginpage.userid = li['user'].toString();
      Loginpage.usertoken  = li['key'].toString();

      return [true];
    }
  }

  rigesterbyfb(token)async{
    var url = 'http://horizonstore.pythonanywhere.com/rest-auth/facebook/';
    var url2 ;
    var headers2 = {"Content-Type": "application/json"};
    var body = jsonEncode({
      "access_token":token,
    });
    var response = await http.post(url,body:body,headers: headers2);
    print(token);
    print(response.statusCode);
    print(response.body);
    var li = json.decode(response.body);
    if(response.statusCode !=200 ){
      return [false,li];
    }else{
      Loginpage.userid = li['user'].toString();
      Loginpage.usertoken  = li['key'].toString();

      return [true,li['user'],li['key']];
    }
  }







  login(username,password)async{

    var url = 'http://horizonstore.pythonanywhere.com/rest-auth/login/';
    var response = await http.post(url, body: {'username': username, 'password': password},);
    Map<String, dynamic> map = json.decode(response.body);

    if(response.statusCode !=200 ){
      return false;
    }else{

      Loginpage.userid = map['user'].toString();
      Loginpage.usertoken  = map['key'].toString();
      return true;
    }
  }

  writeuserlogin(username,password,token)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(token!=null){
      prefs.setString("loginfb", "$token");
      prefs.remove("login");
      return;
    }
    prefs.setString("login", "$username/$password");
    prefs.remove("loginfb");

  }




  checkusertoken()async{
    var url = 'http://horizonstore.pythonanywhere.com/rest-auth/login/';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String log = prefs.get("login");
    String log2 = prefs.get("loginfb");
    if(log2 == null){
      if(log==null){
        return false;
      }
      var response = await http.post(url, body: {'username':log.split("/")[0], 'password': log.split("/")[1]});
      Map<String, dynamic> map = json.decode(response.body);
      if(response.statusCode !=200 ){
        return false;
      }else{
        Loginpage.userid = map['user'].toString();
        Loginpage.usertoken  = map['key'].toString();
        return true;
      }
    }else{

      var result = await rigesterbyfb(log2);
      print(result);
      if(result[0]){
        return true;

      }else{
        return false;
      }
    }

  }
  signout()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('login');
    prefs.remove('loginfb');
  }




  get_products()async{

    var url = 'http://horizonstore.pythonanywhere.com/product/';
    var response = await http.get(url,headers: headers);
    var li = json.decode(response.body);
    print(li);
    return li;
  }

  get_one_product(id)async{
    var url = 'http://horizonstore.pythonanywhere.com/product/$id';
    var response = await http.get(url,headers: headers);
    var li = json.decode(response.body);
    return li;
  }

  get_user()async{
    var url = 'http://horizonstore.pythonanywhere.com/getmeuser/';
    var response = await http.get(url,headers: headers);
    var li = json.decode(response.body);
    print(li);
    return li;

  }


  get_orders()async{
    var url = 'http://horizonstore.pythonanywhere.com/myorders/';
    var response = await http.get(url,headers: headers);
    var li = json.decode(response.body);
    return li;
  }

  getorderproducts(productids)async{
    var all=[];
    var li;
    if(productids == null){
      return [];
    }
    for(int i =0;i<productids.length;i++){
      var url = 'http://horizonstore.pythonanywhere.com/product/${productids[i]}/';
      var response = await http.get(url,headers: headers);
      response.statusCode==200?li = json.decode(response.body):li=null;
      all.add(li);
    }
    return all;

  }

  get_sp_order(no)async{
    var url = 'http://horizonstore.pythonanywhere.com/order/$no/';
    var response = await http.get(url,headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode(response.body);
    var li2 = utf8.decode(response.bodyBytes);
    print(li2);
    return [li,li2];
  }



  workonfavourites( prodids,int choice, [fav_delete=0])async{
    var url = 'http://horizonstore.pythonanywhere.com/myfavs/';
    var headers2 = {'Authorization': 'Token ${Loginpage.usertoken.toString()}',"Content-Type": "application/json"};

    if(choice ==1){
      var response = await http.get(url,headers: headers);
      if(response.statusCode ==404){
        var body = jsonEncode({
          "user":Loginpage.userid,
          "products":prodids,
        });
        var response2 = await http.post(url,body:body,headers: headers2);
        await uploadfavs();
      }else{
        var li = json.decode(response.body);
        List<int> members = [...li['products'].map((el) => el.toInt())];
        prodids.addAll(members);

        var body = jsonEncode({
          "products":prodids,
        });
        var response2 = await http.patch(url,body:body,headers: headers2);
        await uploadfavs();
      }

    }else{
      var response = await http.get(url,headers: headers);
      var li = json.decode(response.body);
      List<int> members = [...li['products'].map((el) => el.toInt())];
      //var del = int.parse(fav_delete);
      print(members);
      members.remove(fav_delete);
      print(members);
      var body = jsonEncode({
        "products":members,
      });
      var response2 = await http.patch(url,body:body,headers: headers2);
      await uploadfavs();
    }

  }


  uploadfavs()async{
    var url = 'http://horizonstore.pythonanywhere.com/myfavs/';
    var response = await http.get(url,headers: headers);
    if(response.statusCode==200){
      var li = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> members = [...li['products'].map((el) => el.toString())];
      prefs.setStringList("${Loginpage.userid}/favs", members);
    }else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList("${Loginpage.userid}/favs", []);
    }

  }


  get_favs()async{
    var all_favs=[];
    var split;
    var url;
    var response;
    var li;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> allprods = prefs.getStringList("${Loginpage.userid}/favs");
    if(allprods != null && allprods.length !=0){
      for(int i=0;i<allprods.length;i++){
        split = allprods[i].split("/");
        url = 'http://horizonstore.pythonanywhere.com/product/${split[0]}/';
        response = await http.get(url,headers: headers);
        li = json.decode(response.body);
        all_favs.add(li);
      }
    }else{
      workonfavourites([], 1);
    }
    return all_favs;
  }


  checkfavlist(idtocheck)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> allprods = prefs.getStringList("${Loginpage.userid}/favs");

    if(allprods == null){

      return false;
    }else{
      return allprods.contains(idtocheck.toString());

    }
  }

  clearfavlist()async{
    var url = 'http://horizonstore.pythonanywhere.com/myfavs/';
    var response = await http.delete(url,headers: headers);
    await uploadfavs();
  }

  editemail(email)async{
    var url = 'http://horizonstore.pythonanywhere.com/getmeuser/';
    var body = {
      'email':email.toString()
    };
    var response = await http.patch(url,body:body,headers: headers);

  }

  edit_first_name(fname)async{
    var url = 'http://horizonstore.pythonanywhere.com/getmeuser/';
    var body = {
      'first_name':fname.toString()
    };
    var response = await http.patch(url,body:body,headers: headers);

  }


  edit_last_name(lname)async{
    var url = 'http://horizonstore.pythonanywhere.com/getmeuser/';
    var body = {
      'last_name':lname.toString()
    };
    var response = await http.patch(url,body:body,headers: headers);

  }

  add_to_cart(id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> prod_ids = prefs.getStringList("${Loginpage.userid}/cart");
    if(prod_ids == null){
      prefs.setStringList("${Loginpage.userid}/cart", [id.toString()]);
      print(prod_ids);
    }else{
      prod_ids.add(id.toString());
      prefs.setStringList("${Loginpage.userid}/cart", prod_ids);

    }
  }
  remove_from_cart(id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prod_ids = prefs.getStringList("${Loginpage.userid}/cart");
    prod_ids.remove(id.toString());
    prefs.setStringList("${Loginpage.userid}/cart", prod_ids);

  }
  get_cart()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prod_ids = prefs.getStringList("${Loginpage.userid}/cart");
    return prod_ids;
  }
  check_cart(id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prod_ids = prefs.getStringList("${Loginpage.userid}/cart");
    if(prod_ids!=null){
      if(prod_ids.contains(id.toString())){
        return true;
      }
    }

    return false;
  }


    show_cart()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var prod_ids = prefs.getStringList("${Loginpage.userid}/cart");
      print(prod_ids);
    }

    get_total_price(pros)async{
    print(pros);
      int count = 0;
      pros.forEach((result){
        count+=result['new_price']!=0?result['new_price']:result['price'];
      });
      return count;
    }

    post_order(total,fname,lname,phone,city,area,street,b_no,ph1,ph2,note)async{
      var url2 = 'http://horizonstore.pythonanywhere.com/order/';
      var headers2 = {'Authorization': 'Token ${Loginpage.usertoken.toString()}',"Content-Type": "application/json"};
      var pros = await get_cart();
      var body = jsonEncode({
        "user":int.parse(Loginpage.userid) ,
        "products":pros,
        "total_price":total,
        "completed":false,
        "delivery_fees":40,
        "Type":"Cash On Delivery",
        "customer_name":"${fname+" "+lname}",
        "customer_no":"$phone",
        "customer_address":"$city $area $street $b_no",
        "customer_area":"$area",
        "customer_phone1":"$ph1",
        "customer_phone2":"$ph2",
        "note":note,
      });
      var response = await http.post(url2,body:body,headers: headers2);
      print(response.body);
      if(response.statusCode!=201){
        return false;
      }else{
        clearbasketlist();
        return true;
      }
    }

  send_notifications()async{
    print("here");
    var url = 'http://horizonstore.pythonanywhere.com/notify_tokens/';
    var response = await http.get(url, headers: headers);
    var li = json.decode(response.body);
    li.forEach((res){
      Firestore.instance.collection("notifications-store").document("${rng.nextInt(10000)}").setData({'shoptoken':"${res['name']}",});

    });
  }


  clearbasketlist()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("${Loginpage.userid}/cart");
  }

  get_search(value)async{
    var url = 'http://horizonstore.pythonanywhere.com/product?search=$value';
    var response = await http.get(url, headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode("${response.body}");
    return li;
  }

  get_colors()async{
    var url = 'http://horizonstore.pythonanywhere.com/colors/';
    var response = await http.get(url, headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode("${response.body}");
    return li;
  }


  get_rams()async{
    var url = 'http://horizonstore.pythonanywhere.com/rams/';
    var response = await http.get(url, headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode("${response.body}");
    return li;
  }


  get_hdds()async{
    var url = 'http://horizonstore.pythonanywhere.com/hdds/';
    var response = await http.get(url, headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode("${response.body}");
    return li;
  }


  get_ssds()async{
    var url = 'http://horizonstore.pythonanywhere.com/ssds/';
    var response = await http.get(url, headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode("${response.body}");
    return li;
  }



  get_gcards()async{
    var url = 'http://horizonstore.pythonanywhere.com/gcards/';
    var response = await http.get(url, headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode("${response.body}");
    return li;
  }


  get_ssizes()async{
    var url = 'http://horizonstore.pythonanywhere.com/ssizes/';
    var response = await http.get(url, headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode("${response.body}");
    return li;
  }

  get_brands()async{
    var url = 'http://horizonstore.pythonanywhere.com/brands/';
    var response = await http.get(url, headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode("${response.body}");
    return li;
  }

  get_proc()async{
    var url = 'http://horizonstore.pythonanywhere.com/proc/';
    var response = await http.get(url, headers: headers);
    if(response.statusCode!=200){
      return [];
    }
    var li = json.decode("${response.body}");
    return li;
  }

  check_promo(promo)async{
    print(promo);
    var url = 'http://horizonstore.pythonanywhere.com/promo_codes?search=$promo';
    var response = await http.get(url, headers: headers);
    var li = json.decode("${response.body}");
    if(response.statusCode!=200 || li.isEmpty){
      return [false];
    }else{
        for(int i =0;i<li[0]['user'].length;i++){
          if(int.parse(Loginpage.userid)==li[0]['user'][i]){
            print("here");
            return [false];
          }
        }

      return [true,li[0]['value'],li[0]['id']];
    }


  }
  decrease_promo(id)async{
    var new_users;
    var url = 'http://horizonstore.pythonanywhere.com/promo_codes/$id/';
    var response = await http.get(url, headers: headers);
    var li = json.decode("${response.body}");
    var headers2 = {"Content-Type": "application/json"};

    new_users = li['user'];
    new_users.add(Loginpage.userid);
    var body = jsonEncode({
      'quantity':(li['quantity'] - 1).toString(),
      'user':new_users
    });
    var response2 = await http.patch(url, body:body,headers: headers2);
    if ((li['quantity'] - 1) ==0){
      var response3= await http.delete(url,headers:headers);
    }
  }

}