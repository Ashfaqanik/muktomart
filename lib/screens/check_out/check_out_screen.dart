import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mukto_mart/helper/keyboard.dart';
import 'package:mukto_mart/models/city_model.dart';
import 'package:mukto_mart/models/country_model.dart';
import 'package:mukto_mart/models/state_model.dart';
import 'package:mukto_mart/providers/cart_provider.dart';
import 'package:mukto_mart/providers/shipping_charge_provider.dart';
import 'package:mukto_mart/screens/home/components/terms_page.dart';
import 'package:mukto_mart/screens/profile/profile_screen.dart';
import 'package:mukto_mart/providers/coupon_provider.dart';
import 'package:mukto_mart/providers/order_provider.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/repo/check_out_repo.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:mukto_mart/variables/static_variables.dart';
import 'package:provider/provider.dart';
import 'package:mukto_mart/models/state_model.dart';
import 'package:mukto_mart/providers/check_out_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  List<Country> countries=[];
  List<States> statess=[];
  List<City> cities=[];
  String token;
  String radioPickUp;
  int radioPickUpSelected=0;
  int _radioSelected = 1;
  int _pickUpRadioSelected = 1;
  String _radioVal= 'Default Packaging';
  String _pickUpRadioVal= 'Default Packaging';
  int _radioDeliverySelected = 1;
  String _radioDeliveryVal = 'Cash On Delivery';
  int packingCost=0;
  String packingTitle;
  String pickUpPackingTitle;
  //String _pickUpLocation;
  List<dynamic> pickUps=[];
  CheckOutRepo checkOutRepo=CheckOutRepo();
  String shipping="Ship To Address";
  String country;
  String state;
  String city;
  int count=0;
  String name;
  String phone;
  String email;
  String address;
  String differentName;
  String differentPhone;
  String differentAddress;
  String differentCountry;
  String differentCity;
  String differentState;
  String postalCode;
  String orderNote;
  dynamic finalPrice;
  dynamic pickUpfinalPrice;
  dynamic totalPrice;
  String tnxId;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  //TextEditingController _pickUpController = TextEditingController();
  TextEditingController _orderNoteController = TextEditingController();
  bool _isLoading=false;
  bool _isLoading1=false;
  bool _isLoading2=false;
  bool condition = false;
  bool shipToDifferent=false;
  bool differentShipping=false;
  bool pickUp = false;
  String shippingCharge = 'true';
  void _initialize(ProfileProvider profileProvider,CheckOutProvider checkOutProvider,CouponProvider couponProvider,ShippingChargeProvider shippingChargeProvider){
    _nameController.text=profileProvider.userProfile.user.name??'';
    _emailController.text=profileProvider.userProfile.user.email??'';
    _phoneController.text=profileProvider.userProfile.user.phone??'';
    _addressController.text=profileProvider.userProfile.user.address??'';
    _countryController.text=profileProvider.userProfile.user.country??'';
    _stateController.text=profileProvider.userProfile.user.state??'';
    _cityController.text=profileProvider.userProfile.user.city??'';
    _orderNoteController.text='';
    setState((){
      radioPickUp = checkOutProvider.checkOut.pickups[0].location;
      pickUps=checkOutProvider.checkOut.pickups;
      profileProvider.userProfile.user.city==null?differentShipping=true:differentShipping=false;
      count++;
    });
    couponProvider.coupon.amount==null?totalPrice=checkOutProvider.checkOut.totalPrice:totalPrice=couponProvider.coupon.the0;
    finalPrice=differentShipping==false?totalPrice+checkOutProvider.checkOut.shippingData[0].price:totalPrice+shippingChargeProvider.shippingDataModel.shipping[0].price;
    pickUpfinalPrice=totalPrice+checkOutProvider.checkOut.shippingData[0].forPickup;
    print(totalPrice);
  }
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }
  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    final CheckOutProvider checkOutProvider = Provider.of<CheckOutProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context,listen: false);
    final CouponProvider couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final ShippingChargeProvider shippingChargeProvider = Provider.of<ShippingChargeProvider>(context, listen: false);
    final size= MediaQuery.of(context).size;
    if (count == 0) _initialize(profileProvider,checkOutProvider,couponProvider,shippingChargeProvider);
    if(shippingChargeProvider.countryList!=null)countries=shippingChargeProvider.countryList.country;
    if(shippingChargeProvider.stateList!=null)statess=shippingChargeProvider.stateList.state;
    if(shippingChargeProvider.cityList!=null)cities=shippingChargeProvider.cityList.city;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back), onPressed: () {
                Navigator.pop(context);
              //Navigator.pushNamedAndRemoveUntil(context, CartScreen.routeName,(Route<dynamic> route) => false);
            },),
            bottom: TabBar(
              indicatorColor: kPrimaryColor,
              unselectedLabelColor: kSecondaryColor,
              labelColor: kPrimaryColor,
              labelStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * .036
              ),
              tabs: [
                Tab(text: 'Home Delivery'),
                Tab(text: 'Pick Up'),
              ],
            ),
            title: Text("Billing Details",style: TextStyle(color: Colors.black)),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  _isLoading?Center(child: CircularProgressIndicator()):Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
                      child: ListView(
                        children: [
                          _buildTextForm('Name'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          _buildTextForm('Address'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          _buildTextForm('Email'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          _buildTextForm('Phone number'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          //_dropDownBuilder('Select Shipping'),
                          //SizedBox(height: getProportionateScreenHeight(20)),
                          //pickUp==true?_pickUpDropdown():Container(),
                          //SizedBox(height: getProportionateScreenHeight(20)),
                          profileProvider.userProfile.user.country==null?_dropDownBuilder('Select Country'):_buildTextForm('Country'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          profileProvider.userProfile.user.state==null?_dropDownBuilder('Select State'):_buildTextForm('State'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          profileProvider.userProfile.user.city==null?_dropDownBuilder('Select City'):_buildTextForm('City'),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: shipToDifferent,
                                  activeColor: kPrimaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      shipToDifferent = value;
                                    });
                                  },
                                ),
                                Text("Ship to a different Address",
                                    style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold))]),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          shipToDifferent==true?_shipToDifferent():Container(),
                          //SizedBox(height: getProportionateScreenHeight(15)),
                          _buildTextForm('Order Note (optional)'),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          Text('Total:'+ '  $totalPrice ৳',style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: size.width*.05),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _radioSelected,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = value;
                                    _radioVal = 'Default Packaging';
                                    packingTitle='Default Packaging';
                                    packingCost=checkOutProvider.checkOut.shippingData[0].price;
                                    finalPrice=totalPrice+checkOutProvider.checkOut.shippingData[0].price;
                                  });
                                },
                              ),
                              Text('Default Packaging'),
                              Radio(
                                value: 2,
                                groupValue: _radioSelected,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _radioSelected = value;
                                    _radioVal = 'Gift Packaging';
                                    packingTitle='Gift Packaging';
                                    finalPrice=totalPrice+checkOutProvider.checkOut.shippingData[0].price+checkOutProvider.checkOut.packageData[1].price;
                                  });
                                },
                              ),
                              Text('Gift Packaging + ৳15'),
                            ],
                          ),
                          shippingCharge=='true'?differentShipping==false?checkOutProvider.checkOut.shippingData[0].price==0?Text(checkOutProvider.checkOut.shippingData[0].title,style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: size.width*.05),):
                          Text('${checkOutProvider.checkOut.shippingData[0].title}+ ${checkOutProvider.checkOut.shippingData[0].price}৳',style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: size.width*.05),):
                          shippingChargeProvider.shippingDataModel.shipping[0].price==0?Text(shippingChargeProvider.shippingDataModel.shipping[0].title,style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: size.width*.05),):
                          Text('${shippingChargeProvider.shippingDataModel.shipping[0].title}+ ${shippingChargeProvider.shippingDataModel.shipping[0].price}৳',style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: size.width*.05),):Container(),
                          SizedBox(height: getProportionateScreenHeight(6)),
                          shippingCharge=='true'?differentShipping==false?Text(checkOutProvider.checkOut.shippingData[0].subtitle,style:
                          TextStyle(color: Colors.black,fontSize: size.width*.05),):
                          Text(shippingChargeProvider.shippingDataModel.shipping[0].subtitle,style:
                          TextStyle(color: Colors.black,fontSize: size.width*.05),):Container(),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          Text('Final Price:'+ '  $finalPrice ৳',style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: size.width*.05),),
                          SizedBox(height: getProportionateScreenHeight(12)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _radioDeliverySelected,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _radioDeliverySelected = value;
                                    _radioDeliveryVal = 'Cash On Delivery';
                                  });
                                },
                              ),
                              Text('Cash On Delivery'),
                              Radio(
                                value: 2,
                                groupValue: _radioDeliverySelected,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _radioDeliverySelected = value;
                                    _radioDeliveryVal = 'Online Payment';
                                  });
                                },
                              ),
                              Text('Online Payment'),
                            ],
                          ),
                          //T&C row
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: condition,
                                  activeColor: kPrimaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      condition = value;
                                    });
                                  },
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                      return TermsPage(appBarName: 'Terms & Condition',url: 'https://muktomart.com/app_pages/terms.php',);}));
                                  },
                                  child: Text("By continuing your confirm that you agree \nwith our Term and Condition",
                                      style: TextStyle(color: Colors.blue[500],decoration: TextDecoration.underline)),
                                )]),
                          SizedBox(height: getProportionateScreenHeight(40)),
                          SizedBox(
                            width: double.infinity,
                            height: getProportionateScreenHeight(56),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              color: condition==true?kPrimaryColor:Colors.grey,
                              onPressed: (){
                                name=_nameController.text;
                                email=_emailController.text;
                                address=_addressController.text;
                                phone=_phoneController.text;
                                country=profileProvider.userProfile.user.country==null?country:_countryController.text;
                                state=profileProvider.userProfile.user.state==null?state:_stateController.text;
                                city=profileProvider.userProfile.user.city==null?city:_cityController.text;
                                setState(() {
                                  tnxId=DateTime.now().millisecondsSinceEpoch.toString();
                                });
                                if(condition==true){
                                  if(country!=null||state!=null||city!=null){
                                    if(shipToDifferent==true && differentCity==null){
                                      Fluttertoast.showToast(
                                          msg: "Please fill all the required fields",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.redAccent,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }else{
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        if(_radioDeliveryVal=='Cash On Delivery'){
                                          setState(() {
                                            _isLoading=true;
                                          });
                                          checkOutRepo.submitCheckout(token, checkOutProvider.checkOut.totalQty, checkOutProvider.checkOut.totalPrice, 'Cash On Delivery',
                                              'Ship To Address', '', email, name, checkOutProvider.checkOut.shippingCost, checkOutProvider.checkOut.shippingData[0].title,
                                              packingCost, packingTitle, 0, phone, address, state, differentState,
                                              country, city, '', '', differentName, differentPhone,
                                              differentAddress, differentCountry, differentCity, postalCode, orderNote,
                                              couponProvider.coupon.code, couponProvider.coupon.discount, checkOutProvider.checkOut.digital, '').then((value){
                                            orderProvider.fetch(token).then((value){
                                              cartProvider.fetch(token).then((value){
                                                setState(() {
                                                  _isLoading=false;
                                                });
                                                _showDialog('Your orders are submitted..\n Please wait for your delivery..');
                                              });
                                            });
                                          });
                                        }else{
                                          sslCommerzCustomizedCall(checkOutProvider,orderProvider,cartProvider,finalPrice,couponProvider);
                                        }
                                      }
                                    }
                                  }else{
                                    Fluttertoast.showToast(
                                        msg: "Please fill all the required fields",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                }

                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  _isLoading?Center(child: CircularProgressIndicator()):Form(
                    key: _formKey1,
                    child: Padding(
                      padding: const EdgeInsets.only(left:8.0,right: 8.0,bottom: 8.0),
                      child: ListView(
                        children: [
                          _buildTextForm('Name'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          _buildTextForm('Address'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          _buildTextForm('Email'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          _buildTextForm('Phone number'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          //_dropDownBuilder('Select Shipping'),
                          //SizedBox(height: getProportionateScreenHeight(20)),
                          //pickUp==true?_pickUpDropdown():Container(),
                          //SizedBox(height: getProportionateScreenHeight(20)),

                          // profileProvider.userProfile.user.country==null?_dropDownBuilder('Select Country'):_buildTextForm('Country'),
                          // SizedBox(height: getProportionateScreenHeight(30)),
                          // profileProvider.userProfile.user.state==null?_dropDownBuilder('Select State'):_buildTextForm('State'),
                          // SizedBox(height: getProportionateScreenHeight(30)),
                          // profileProvider.userProfile.user.city==null?_dropDownBuilder('Select City'):_buildTextForm('City'),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          //SizedBox(height: getProportionateScreenHeight(15)),
                          _buildTextForm('Order Note (optional)'),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          // Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Checkbox(
                          //         value: pickUp,
                          //         activeColor: kPrimaryColor,
                          //         onChanged: (value) {
                          //           setState(() {
                          //             pickUp = value;
                          //           });
                          //           if(pickUp==true){
                          //             setState(() {
                          //               shippingCharge='false';
                          //               shipping="Pick Up";
                          //             });
                          //           }else{
                          //             setState(() {
                          //               shippingCharge='true';
                          //               shipping="Ship To Address";
                          //             });
                          //           }
                          //         },
                          //       ),
                          //       Text("PickUp?",
                          //           style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold))]),
                          Text('PickUp From:',style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: size.width*.05),),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: pickUps.length,
                              itemBuilder: (BuildContext ctx,int index){
                                return RadioListTile(
                                  title: Text("${pickUps[index].location}"),
                                  groupValue: radioPickUpSelected,
                                  activeColor: kPrimaryColor,
                                  value: index,
                                  onChanged: (val) {
                                    setState(() {
                                      radioPickUp = pickUps[index].location ;
                                      radioPickUpSelected = index;
                                    });
                                  },
                                );
                              }),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          Text('Total:'+ '  $totalPrice ৳',style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: size.width*.05),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _pickUpRadioSelected,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _pickUpRadioSelected = value;
                                    _pickUpRadioVal = 'Default Packaging';
                                    pickUpPackingTitle='Default Packaging';
                                    packingCost=checkOutProvider.checkOut.shippingData[0].price;
                                    pickUpfinalPrice=totalPrice+checkOutProvider.checkOut.shippingData[0].forPickup;
                                  });
                                },
                              ),
                              Text('Default Packaging'),
                              Radio(
                                value: 2,
                                groupValue: _pickUpRadioSelected,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _pickUpRadioSelected = value;
                                    _pickUpRadioVal = 'Gift Packaging';
                                    pickUpPackingTitle='Gift Packaging';
                                    pickUpfinalPrice=totalPrice+checkOutProvider.checkOut.shippingData[0].forPickup+checkOutProvider.checkOut.packageData[1].price;
                                  });
                                },
                              ),
                              Text('Gift Packaging + ৳15'),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          Text('Final Price:'+ '  $pickUpfinalPrice ৳',style:
                          TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: size.width*.05),),
                          SizedBox(height: getProportionateScreenHeight(12)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio(
                                value: 1,
                                groupValue: _radioDeliverySelected,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _radioDeliverySelected = value;
                                    _radioDeliveryVal = 'Cash On Delivery';
                                  });
                                },
                              ),
                              Text('Cash On Delivery'),
                              Radio(
                                value: 2,
                                groupValue: _radioDeliverySelected,
                                activeColor: kPrimaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _radioDeliverySelected = value;
                                    _radioDeliveryVal = 'Online Payment';
                                  });
                                },
                              ),
                              Text('Online Payment'),
                            ],
                          ),
                          //T&C row
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: condition,
                                  activeColor: kPrimaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      condition = value;
                                    });
                                  },
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                      return TermsPage(appBarName: 'Terms & Condition',url: 'https://muktomart.com/app_pages/terms.php',);}));
                                  },
                                  child: Text("By continuing your confirm that you agree \nwith our Term and Condition",
                                      style: TextStyle(color: Colors.blue[500],decoration: TextDecoration.underline)),
                                )]),
                          SizedBox(height: getProportionateScreenHeight(40)),
                          SizedBox(
                            width: double.infinity,
                            height: getProportionateScreenHeight(56),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              color: condition==true?kPrimaryColor:Colors.grey,
                              onPressed: (){
                                name=_nameController.text;
                                email=_emailController.text;
                                address=_addressController.text;
                                phone=_phoneController.text;
                                country=profileProvider.userProfile.user.country==null?country:_countryController.text;
                                state=profileProvider.userProfile.user.state==null?state:_stateController.text;
                                city=profileProvider.userProfile.user.city==null?city:_cityController.text;
                                setState(() {
                                  tnxId=DateTime.now().millisecondsSinceEpoch.toString();
                                });
                                if(condition==true){
                                  if(country!=null||state!=null||city!=null){
                                    if (_formKey1.currentState.validate()) {
                                      _formKey1.currentState.save();
                                      if(_radioDeliveryVal=='Cash On Delivery'){
                                        setState(() {
                                          _isLoading=true;
                                        });
                                        checkOutRepo.submitCheckout(token, checkOutProvider.checkOut.totalQty, checkOutProvider.checkOut.totalPrice, 'Cash On Delivery',
                                            'Pick Up', radioPickUp, email, name, 0, '',
                                            packingCost, pickUpPackingTitle, 0, phone, address, state, differentState,
                                            country, city, '', '', differentName, differentPhone,
                                            differentAddress, differentCountry, differentCity, postalCode, orderNote,
                                            couponProvider.coupon.code, couponProvider.coupon.discount, checkOutProvider.checkOut.digital, '').then((value){
                                          orderProvider.fetch(token).then((value){
                                            cartProvider.fetch(token).then((value){
                                              setState(() {
                                                _isLoading=false;
                                              });
                                              _showDialog('Your orders are submitted..\n Please wait for your delivery..');
                                            });
                                          });
                                        });
                                      }else{
                                        pickUpSslCommerzCustomizedCall(checkOutProvider,orderProvider,cartProvider,pickUpfinalPrice,couponProvider);
                                      }
                                    }
                                  }else{
                                    Fluttertoast.showToast(
                                        msg: "Please fill all the required fields",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.redAccent,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                }

                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
              _isLoading1?Center(child: CircularProgressIndicator()):Container()
            ],
          )
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() async {
    Navigator.pop(context);
    //Navigator.pushNamedAndRemoveUntil(context, CartScreen.routeName,(Route<dynamic> route) => false);
  }

  Widget _buildTextForm(String hint) {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    final size=MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,color: Colors.blue
          ),
        ),
        //height: size.height*.095,width: size.width*.8,
        child: TextFormField(
          enabled: hint == 'Name'?false:hint == 'Address'?false:hint == 'Country'?false:hint == 'State'?false:hint == 'City'?false:hint == 'Email'?profileProvider.userProfile.user.email==null?true:false:true,
          maxLines: hint == 'Address' ? 2 :hint == 'Enter Address' ? 2: null,
          controller: hint == 'Name'
              ? _nameController
              : hint == 'Address'
              ? _addressController
              : hint == 'Email'
              ? _emailController
              :hint == 'Order Note (optional)'
              ? _orderNoteController
              :hint == 'Country'
              ? _countryController
              :hint == 'State'
              ? _stateController
              :hint == 'City'
              ? _cityController
              :hint=="Phone number"?_phoneController:null,
          initialValue: null,
          decoration: FormDecoration.copyWith(
            prefixIcon: hint=='Name'?Icon(Icons.person,color: Colors.lightBlue):hint=='Email'?Icon(Icons.email,color: Colors.lightBlue):
            hint=='Phone number'?Icon(Icons.phone,color: Colors.lightBlue):hint=='Address'?Icon(Icons.location_on,color: Colors.lightBlue):
            hint=='Country'?Icon(Icons.location_on,color: Colors.lightBlue):hint == 'Order Note (optional)'?Icon(Icons.note,color: Colors.lightBlue):
            hint=='State'?Icon(Icons.location_on,color: Colors.lightBlue):hint=='City'?Icon(Icons.location_city,color: Colors.lightBlue):
            hint=='Enter Full Name'?Icon(Icons.person,color: Colors.lightBlue):hint=='Enter Phone Number'?Icon(Icons.phone,color: Colors.lightBlue):
            hint=='Enter Address'?Icon(Icons.location_on,color: Colors.lightBlue):hint=='Enter State'?Icon(Icons.location_on,color: Colors.lightBlue):
            hint=='Enter City'?Icon(Icons.location_city,color: Colors.lightBlue):hint=='Enter Postal Code'?Icon(Icons.code,color: Colors.lightBlue):null,
              alignLabelWithHint: true,
              hintText: hint,
              fillColor: Color(0xffF4F7F6)),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            if (hint == 'Name'){
                name = _nameController.text;
            }
            if (hint == 'Address'){

                address = _addressController.text;
            }
            if (hint == 'Email'){
                email = _emailController.text;
            }
            if (hint == 'Phone number'){

                phone = _phoneController.text;

            }
            if (hint == 'Country'){

              country=_countryController.text;
            }
            if (hint == 'State'){

                state = _stateController.text;

            }
            if (hint == 'City'){
                city = _cityController.text;

            }
            // if (hint == 'Enter Full Name'){
            //
            //     differentName = value;
            //
            // }
            // if (hint == 'Enter Phone Number'){
            //     differentPhone = value;
            // }
            // if (hint == 'Enter Address'){
            //
            //     differentAddress = value;
            //
            // }
            // if (hint == 'Enter City'){
            //
            //     differentCity = value;
            //
            // }
            // if (hint == 'Enter State'){
            //
            //     differentState = value;
            //
            // }
            // if (hint == 'Enter Postal Code'){
            //
            //     postalCode = value;
            //
            // }
            if (hint == 'Order Note (optional)'){

                orderNote = _orderNoteController.text;

            }
          },
          validator: (value) {
            if(hint=='Phone number'){
              if (value.isEmpty) {
                return "Please Enter your phone number";
              } else if (value.length != 11) {
                return "Phone Number must be of 11 digits";
              }
            }else if(hint=='Name'){
              if (value.isEmpty) {
                return "Please Enter your name";
              }
            }else if(hint=='Email'){
              if (value.isEmpty) {
                return "Please Enter your email";
              }
            }else if(hint=='Address'){
              if (value.isEmpty) {
                return "Please Enter your address";
              }
            }
            if(shipToDifferent==true){
            if(hint=='Enter Full Name'){
              if (value.isEmpty) {
                return "Please Enter your name";
              }
            }else if(hint=='Enter Phone Number'){
              if (value.isEmpty) {
                return "Please Enter your phone number";
              } else if (value.length != 11) {
                return "Phone Number must be of 11 digits";
              }
            }else if(hint=='Choose Country'){
              if (value.isEmpty) {
                return "Please Enter city";
              }
            }else if(hint=='Select City'){
              if (value.isEmpty) {
                return "Please Enter city";
              }
            }else if(hint=='Select State'){
              if (value.isEmpty) {
                return "Please Enter state";
              }
            }else if(hint=='Enter Postal Code'){
              if (value.isEmpty) {
                return "Please Enter postal code";
              }
            }else if(hint=='Enter Address'){
              if (value.isEmpty) {
                return "Please Enter your shipping address";
              }
            }
            }
            return null;
          },
        ),
      ),
    );
  }
  // Widget _pickUpDropdown(){
  //   Size size=MediaQuery.of(context).size;
  //   return Padding(
  //     padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8.0),
  //     child: Container(
  //       height: size.height*.095,width: size.width*.8,
  //       padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
  //       decoration: BoxDecoration(
  //           color: Color(0xffF4F7F5),
  //           //borderRadius: BorderRadius.all(Radius.circular(10)),
  //           border: Border.all(
  //           width: 1,color: Colors.blue
  //       ),
  //       ),
  //       child: DropdownButtonHideUnderline(
  //         child: DropdownButton(
  //           //isDense: true,
  //           isExpanded: true,
  //           value:_pickUpLocation,
  //           hint: Text('Pick Up From',style: TextStyle(
  //               color: Colors.grey[700],
  //               fontSize: 16)),
  //           items:pickUps.map((pick){
  //             return DropdownMenuItem(
  //               child: Text(pick.location, style: TextStyle(
  //                 color: Colors.grey[900],
  //                 fontSize: 16,)),
  //               value: pick.location.toString(),
  //             );
  //           }).toList(),
  //           onChanged: (newVal){
  //             setState(() {
  //               _pickUpLocation = newVal as String;
  //             });
  //           },
  //           dropdownColor: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _dropDownBuilder(String hint){
    final ShippingChargeProvider shippingChargeProvider = Provider.of<ShippingChargeProvider>(context);
    final CheckOutProvider checkOutProvider = Provider.of<CheckOutProvider>(context);


    Size size=MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8.0),
      child: Container(
        height: size.height*.095,
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
        decoration: BoxDecoration(
            color: Color(0xffF4F7F5),
            //borderRadius: BorderRadius.all(Radius.circular(10))
          border: Border.all(
              width: 1,color: Colors.blue
          ),
        ),
        //width: size.width*.75,
        child: DropdownButtonHideUnderline(

          child: DropdownButton(
            isExpanded: true,
            value:  hint=='Select Shipping'?shipping:
            hint=='Select Country'?country:
            hint=='Select State'?state:
            hint=='Select Different State'?differentState:
            hint=='Select City'?city:
            hint=='Select Different City'?differentCity:
            hint=='Choose Country'?differentCountry:null,

            hint: Text(hint,style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16)),
            items: hint=='Select Shipping'?StaticVariables.shipping.map((shipping){
              return DropdownMenuItem(
                child: Text(shipping,style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,)),
                value: shipping,
              );
            }).toList():hint=='Select Country'?countries.map((country){
              return DropdownMenuItem(
                onTap: (){
                  setState(() {
                    _isLoading1=true;
                  });
                  shippingChargeProvider.fetchStates(country.id).then((value){
                    setState(() {
                      shippingChargeProvider.stateList!=null?shippingChargeProvider.stateList.state!=null?statess=shippingChargeProvider.stateList.state:statess=[]:statess=[];
                      _isLoading1=false;
                    });
                  });

                },
                child: Text(country.countryName,style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,)),
                value: country,
              );
            }).toList():hint=='Choose Country'?countries.map((differentCountry){
              return DropdownMenuItem(
                onTap: (){
                  setState(() {
                    _isLoading1=true;
                  });
                  shippingChargeProvider.fetchStates(differentCountry.id).then((value){
                    setState(() {
                      shippingChargeProvider.stateList!=null?shippingChargeProvider.stateList.state!=null?statess=shippingChargeProvider.stateList.state:statess=[]:statess=[];
                      _isLoading1=false;
                    });
                  });

                },
                child: Text(differentCountry.countryName,style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,)),
                value: differentCountry.countryName,
              );
            }).toList():hint=='Select State'?statess.map((state){
              return DropdownMenuItem(
                onTap: (){
                  setState(() {
                    _isLoading2=true;
                  });
                  shippingChargeProvider.fetchCities(state.id).then((value){
                    setState(() {
                      shippingChargeProvider.cityList!=null?shippingChargeProvider.cityList.city!=null?cities=shippingChargeProvider.cityList.city:cities=[]:cities=[];
                      city=shippingChargeProvider.cityList.city[0].distName;
                      _isLoading2=false;
                    });
                  });
                },
                child: Text(state.diviName,style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,)),
                value: state.diviName,
              );
            }).toList():hint=='Select Different State'?statess.map((state){
              return DropdownMenuItem(
                onTap: (){
                  KeyboardUtil.hideKeyboard(context);
                  setState(() {
                    _isLoading1=true;
                  });
                  shippingChargeProvider.fetchCities(state.id).then((value){
                    setState(() {
                      shippingChargeProvider.cityList!=null?shippingChargeProvider.cityList.city!=null?cities=shippingChargeProvider.cityList.city:cities=[]:cities=[];
                      differentCity=shippingChargeProvider.cityList.city[0].distName;
                      shippingChargeProvider.fetchShippingCharge(checkOutProvider.checkOut.totalPrice,shippingChargeProvider.cityList.city[0].id).then((value){
                        setState(() {
                          differentShipping=true;
                          finalPrice=totalPrice+shippingChargeProvider.shippingDataModel.shipping[0].price;
                          _isLoading1=false;
                        });
                      });
                      _isLoading2=false;
                    });
                  });
                },
                child: Text(state.diviName,style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,)),
                value: state.diviName,
              );
            }).toList():hint=='Select City'?cities.map((city){
              return DropdownMenuItem(
                onTap: (){
                  setState(() {
                    _isLoading1=true;
                  });
                  shippingChargeProvider.fetchShippingCharge(checkOutProvider.checkOut.totalPrice,city.id).then((value){
                    setState(() {
                      differentShipping=true;
                      finalPrice=totalPrice+shippingChargeProvider.shippingDataModel.shipping[0].price;
                      _isLoading1=false;
                    });
                  });
                },
                child: _isLoading2?Center(child: CircularProgressIndicator()):Text(city.distName,style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,)),
                value: city.distName,
              );
            }).toList():hint=='Select Different City'?cities.map((cty){
              return DropdownMenuItem(
                onTap: (){
                  setState(() {
                    _isLoading1=true;
                  });
                  shippingChargeProvider.fetchShippingCharge(checkOutProvider.checkOut.totalPrice,cty.id).then((value){
                    setState(() {
                      differentShipping=true;
                      finalPrice=totalPrice+shippingChargeProvider.shippingDataModel.shipping[0].price;
                      _isLoading1=false;
                    });
                  });
                },
                child: _isLoading2?Center(child: CircularProgressIndicator()):Text(cty.distName,style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,)),
                value: cty.distName,
              );
            }).toList():null,
            onChanged: (newValue){
              setState(() {
                hint=='Select Shipping'?shipping = newValue:
                hint=='Select Country'?country=newValue:
                hint=='Select State'?state=newValue:
                hint=='Select Different State'?differentState=newValue:
                hint=='Select City'?city=newValue:
                hint=='Select Different City'?differentCity=newValue:
                hint=='Choose Country'?differentCountry=newValue:null;
              });
              if(shipping=="Pick Up"){
                setState(() {
                  pickUp=true;
                  shippingCharge='false';
                });
              }else if(shipping=="Ship To Address"){
                setState(() {
                  pickUp=false;
                  shippingCharge='true';
                });
              }
            },


            dropdownColor: Colors.white,
          ),
        ),
      ),
    );
  }

  _shipToDifferent(){
    return Padding(
      padding: const EdgeInsets.only(left:6.0,right: 6.0,bottom: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextForm('Enter Full Name'),
          SizedBox(height: getProportionateScreenHeight(30)),
          _buildTextForm('Enter Phone Number'),
          SizedBox(height: getProportionateScreenHeight(30)),
          _buildTextForm('Enter Address'),
          SizedBox(height: getProportionateScreenHeight(20)),
          _dropDownBuilder('Choose Country'),
          SizedBox(height: getProportionateScreenHeight(30)),
          _dropDownBuilder('Select Different State'),//_buildTextForm('Enter State'),
          SizedBox(height: getProportionateScreenHeight(30)),
          _dropDownBuilder('Select Different City'),//_buildTextForm('Enter City'),
          SizedBox(height: getProportionateScreenHeight(30)),
          _buildTextForm('Enter Postal Code'),
          SizedBox(height: getProportionateScreenHeight(30)),
        ],
      ),
    );
  }
  Future<void> sslCommerzCustomizedCall(CheckOutProvider checkOutProvider,OrderProvider orderProvider,CartProvider cartProvider,dynamic price,CouponProvider couponProvider) async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //Use the ipn if you have valid one, or it will fail the transaction.
            ipn_url: "https://muktomart.com",
            multi_card_name: '',
            currency: SSLCurrencyType.BDT,
            product_category: "Food",
            sdkType: SSLCSdkType.LIVE,
            store_id: 'muktomartlive',
            store_passwd: '60B784FEE687464171',
            total_amount: double.parse('$price'),
            tran_id: tnxId));
    sslcommerz
        .addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
            shipmentMethod: "yes",
            numOfItems: checkOutProvider.checkOut.products.length,
            shipmentDetails: ShipmentDetails(
                shipAddress1: differentAddress??'',
                shipCity: differentCity??'',
                shipCountry: differentCountry??'',
                shipName: differentName??'',
                shipPostCode: postalCode??'')))
        .addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: state,
            customerName: _nameController.text,
            customerEmail: _emailController.text,
            customerAddress1: _addressController.text,
            customerCity: city,
            customerPostCode: "",
            customerCountry: country,
            customerPhone: _phoneController.text))
        .addProductInitializer(
        sslcProductInitializer:
        // ***** ssl product initializer for general product STARTS*****
        SSLCProductInitializer(
            productName: checkOutProvider.checkOut.products[0].name,
            productCategory: "Widgets",
            general: General(
                general: "General Purpose",
                productProfile: "Product Profile"))
    )
        .addAdditionalInitializer(
        sslcAdditionalInitializer: SSLCAdditionalInitializer(
            valueA: "value a ",
            valueB: "value b",
            valueC: "value c",
            valueD: "value d"));
    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " +
          result.message.toString() +
          " code: " +
          result.code);
    } else {
      SSLCTransactionInfoModel model = result;
      if(model.status=='VALID'){
        checkOutRepo.submitCheckout(token, checkOutProvider.checkOut.totalQty, checkOutProvider.checkOut.totalPrice,  'SSLCommerz',
            'Ship To Address', '', email, name, checkOutProvider.checkOut.shippingCost, checkOutProvider.checkOut.shippingData[0].title,
            packingCost, packingTitle, 0, phone, address, state, differentState,
            country, city, '', '', differentName, differentPhone,
            differentAddress, differentCountry, differentCity, postalCode, orderNote,
            couponProvider.coupon.code, couponProvider.coupon.discount, checkOutProvider.checkOut.digital, tnxId).then((value){
          checkOutRepo.notifyPayment(model.tranId, 'VALID').then((value){
            orderProvider.fetch(token).then((value){
              cartProvider.fetch(token).then((value) {
                setState(() {
                  _isLoading=false;
                });
                _showDialog('Payment Successful\n your orders are placed');
              });
            });
          });
        });
      }else{
        checkOutRepo.notifyPayment(model.tranId, 'INVALID').then((value){
          orderProvider.fetch(token).then((value){
            Fluttertoast.showToast(
                msg: "Order Failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0);
          });

        });

      }
    }

  }

  Future<void> pickUpSslCommerzCustomizedCall(CheckOutProvider checkOutProvider,OrderProvider orderProvider,CartProvider cartProvider,dynamic price,CouponProvider couponProvider) async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //Use the ipn if you have valid one, or it will fail the transaction.
            ipn_url: "https://muktomart.com",
            multi_card_name: '',
            currency: SSLCurrencyType.BDT,
            product_category: "Food",
            sdkType: SSLCSdkType.LIVE,
            store_id: 'muktomartlive',
            store_passwd: '60B784FEE687464171',
            total_amount: double.parse('$price'),
            tran_id: tnxId));
    sslcommerz
        .addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
            shipmentMethod: "yes",
            numOfItems: checkOutProvider.checkOut.products.length,
            shipmentDetails: ShipmentDetails(
                shipAddress1: differentAddress??'',
                shipCity: differentCity??'',
                shipCountry: differentCountry??'',
                shipName: differentName??'',
                shipPostCode: postalCode??'')))
        .addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerState: state,
            customerName: _nameController.text,
            customerEmail: _emailController.text,
            customerAddress1: _addressController.text,
            customerCity: city,
            customerPostCode: "",
            customerCountry: country,
            customerPhone: _phoneController.text))
        .addProductInitializer(
        sslcProductInitializer:
        // ***** ssl product initializer for general product STARTS*****
        SSLCProductInitializer(
            productName: checkOutProvider.checkOut.products[0].name,
            productCategory: "Widgets",
            general: General(
                general: "General Purpose",
                productProfile: "Product Profile"))
    )
        .addAdditionalInitializer(
        sslcAdditionalInitializer: SSLCAdditionalInitializer(
            valueA: "value a ",
            valueB: "value b",
            valueC: "value c",
            valueD: "value d"));
    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " +
          result.message.toString() +
          " code: " +
          result.code);
    } else {
      SSLCTransactionInfoModel model = result;
      if(model.status=='VALID'){
        checkOutRepo.submitCheckout(token, checkOutProvider.checkOut.totalQty, checkOutProvider.checkOut.totalPrice,  'SSLCommerz',
            'Pick Up', radioPickUp, email, name, 0, '',
            packingCost, pickUpPackingTitle, 0, phone, address, state, differentState,
            country, city, '', '', differentName, differentPhone,
            differentAddress, differentCountry, differentCity, postalCode, orderNote,
            couponProvider.coupon.code, couponProvider.coupon.discount, checkOutProvider.checkOut.digital, tnxId).then((value){
          checkOutRepo.notifyPayment(model.tranId, 'VALID').then((value){
            orderProvider.fetch(token).then((value){
              cartProvider.fetch(token).then((value) {
                setState(() {
                  _isLoading=false;
                });
                _showDialog('Payment Successful\n your orders are placed');
              });
            });
          });
        });
      }else{
        checkOutRepo.notifyPayment(model.tranId, 'INVALID').then((value){
          orderProvider.fetch(token).then((value){
            Fluttertoast.showToast(
                msg: "Order Failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0);
          });
        });
      }
    }

  }

  _showDialog(String message) {
    final CartProvider cartProvider =
    Provider.of<CartProvider>(context, listen: false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {

          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.white,
              scrollable: true,
              contentPadding: EdgeInsets.all(20),
              title: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .030,
                  ),
                  Icon(Icons.check_circle_outline),
                  Text(       
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * .050,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              ProfileScreen()), (Route<dynamic> route) => false);
                          cartProvider.fetch(token);
          },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
