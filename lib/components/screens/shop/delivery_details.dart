import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/shop/order_summary.dart';
import 'package:smartrr/models/cart.dart';
import 'package:smartrr/models/country.dart';
import 'package:smartrr/models/location.dart';
import 'package:smartrr/services/country_service.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/emailValidator.dart';

class DeliveryDetails extends StatefulWidget {
  final Cart cart;
  const DeliveryDetails({super.key, required this.cart});

  @override
  State<DeliveryDetails> createState() => _DeliveryDetailsState();
}

class _DeliveryDetailsState extends State<DeliveryDetails> {
  late User? _currentUser;
  late bool isDarkTheme;
  final _formKey = new GlobalKey<FormState>();

  Country? _country = null;
  MyLocation? _state = null;
  MyLocation? _lga = null;
  List<MyLocation> stateList = [];
  List<DropdownMenuItem<MyLocation>> _stateDropdownItems = [];
  List<DropdownMenuItem<MyLocation>> _lgaDropdownItems = [];
  List<DropdownMenuItem<Country>> _countries = [
    DropdownMenuItem(
      child: Text("Nigeria"),
      value: Country(code: "NG", name: "Nigeria"),
    ),
  ];

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _landMarkController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  double deliveryFee = 2000.00;

  @override
  Widget build(BuildContext context) {
    InputDecoration textInputDecoration({String? hint}) {
      return InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        hintText: "$hint",
        filled: true,
        fillColor: isDarkTheme ? Colors.grey.withOpacity(.2) : Colors.grey[100],
        focusedBorder: InputBorder.none,
        counterText: "",
        border: InputBorder.none,
      );
    }

    return Consumer<ThemeNotifier>(builder: (context, theme, _) {
      isDarkTheme = theme.darkTheme;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Checkout",
            style: TextStyle().copyWith(color: materialWhite),
          ),
          backgroundColor: primaryColor,
          centerTitle: false,
          iconTheme: IconThemeData().copyWith(color: Colors.white),
        ),
        body: ListView(
          padding: EdgeInsets.only(left: 16, right: 16, top: 18),
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Delivery Details",
                    style: TextStyle().copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(height: 32),
                  Container(
                    margin: EdgeInsets.all(32),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle().copyWith(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          DropdownButtonFormField<Country>(
                            isExpanded: true,
                            items: _countries,
                            value: _country,
                            onChanged: (Country? value) {
                              setState(() => _country = value!);
                              _getStates();
                            },
                            hint: Text(
                              'Country',
                              style: TextStyle().copyWith(
                                fontSize: 16,
                                color: theme.darkTheme ? lightGrey : darkGrey,
                              ),
                            ),
                            elevation: 1,
                            validator: (country) =>
                                country == null ? "Select country" : null,
                            decoration: textInputDecoration(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField<MyLocation>(
                            isExpanded: true,
                            items: _stateDropdownItems,
                            value: _state,
                            onChanged: (MyLocation? value) {
                              setState(() => _state = value!);
                              _getLocations();
                            },
                            hint: Text(
                              'State',
                              style: TextStyle().copyWith(
                                fontSize: 16,
                                color: theme.darkTheme ? lightGrey : darkGrey,
                              ),
                            ),
                            elevation: 1,
                            validator: (country) =>
                                country == null ? "Select state" : null,
                            decoration: textInputDecoration(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField(
                            isExpanded: true,
                            items: _lgaDropdownItems,
                            value: _lga,
                            onChanged: (MyLocation? location) async {
                              setState(() => _lga = location!);
                            },
                            hint: Text(
                              'LGA',
                              style: TextStyle().copyWith(
                                fontSize: 16,
                                color: theme.darkTheme ? lightGrey : darkGrey,
                              ),
                            ),
                            elevation: 1,
                            validator: (country) =>
                                country == null ? "Select LGA" : null,
                            decoration: textInputDecoration(),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _nameController,
                            validator: ((value) => value!.length < 3
                                ? "Enter a valid name"
                                : null),
                            decoration: textInputDecoration(hint: "Name"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _addressController,
                            validator: ((value) => value!.length < 5
                                ? "Enter a valid address"
                                : null),
                            decoration: textInputDecoration(hint: "Address"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _landMarkController,
                            validator: ((value) => value!.length < 5
                                ? "Enter a valid landmark"
                                : null),
                            decoration:
                                textInputDecoration(hint: "Major Landmark"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _phoneController,
                            maxLength: 11,
                            validator: ((value) => value!.length < 11
                                ? "Enter a valid phone"
                                : null),
                            keyboardType: TextInputType.phone,
                            decoration: textInputDecoration(hint: "Phone"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _emailController,
                            validator: ((value) =>
                                !EmailValidator.isValidEmail(value!)
                                    ? "Enter a valid email"
                                    : null),
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                textInputDecoration(hint: "Email Address"),
                          ),
                        ]),
                  ),
                  Divider(height: 32),
                  Text(
                    "Summary",
                    style: TextStyle().copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(height: 52),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal"),
                      Text("N${widget.cart.total.toStringAsFixed(2)}")
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery"),
                      Text("N${deliveryFee.toStringAsFixed(2)}")
                    ],
                  ),
                  Divider(height: 52),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "N${(deliveryFee + widget.cart.total).toStringAsFixed(2)}",
                        style: TextStyle().copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 50),
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderSummary(
                                  cart: Cart(
                                    products: widget.cart.products,
                                    total: widget.cart.total,
                                  ),
                                  name: _nameController.text,
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  country: _country!.name,
                                  state: _state!.title,
                                  address: _addressController.text,
                                  lga: _lga!.title,
                                  landMark: _landMarkController.text,
                                  user: _currentUser!.uid,
                                  deliveryFee: deliveryFee,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text("Continue"),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  _getStates() async {
    await CountryService.getStates(_country!.name).then((states) {
      List<MyLocation> items = [];
      for (int i = 0; i < states.length; i++) {
        if (states[i]["name"] == "Federal Capital Territory") {
          items.add(MyLocation("Abuja", "Abuja"));
        } else {
          items.add(MyLocation(states[i]["name"], states[i]["name"]));
        }
      }
      setState(() {
        stateList = items;
        _stateDropdownItems = items
            .map((state) => DropdownMenuItem(
                  child: Text(state.title),
                  value: state,
                ))
            .toList();
      });
      ;
    });
  }

  Future _getLocations({String? state}) async {
    CountryService.getCities(_country!.name, _state!.title).then((locations) {
      List<MyLocation> items = [];
      for (int i = 0; i < locations.length; i++) {
        items.add(MyLocation(locations[i], locations[i]));
      }
      setState(() {
        _lgaDropdownItems = locations
            .map((location) => DropdownMenuItem(
                  child: Text(location),
                  value: MyLocation(location, location),
                ))
            .toList();
      });
    });
  }

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser;
    _nameController =
        new TextEditingController(text: _currentUser?.displayName);
    _addressController = new TextEditingController();
    _landMarkController = new TextEditingController();
    _phoneController = new TextEditingController(
        text: _currentUser?.phoneNumber?.split("+")[1]);
    _emailController = new TextEditingController(text: _currentUser?.email);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _landMarkController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
