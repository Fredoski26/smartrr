import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/order_summary.dart';
import 'package:smartrr/models/country.dart';
import 'package:smartrr/models/location.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/country_service.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/emailValidator.dart';

class DeliveryDetails extends StatefulWidget {
  final Product product;
  const DeliveryDetails({super.key, required this.product});

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
          body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            title: Text(widget.product.name),
            pinned: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(180),
              child: Container(
                height: 150,
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: theme.darkTheme ? darkGrey : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 5),
                        blurRadius: 1.0,
                        color: Colors.black.withOpacity(.1),
                      )
                    ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              widget.product.images![0].url,
                              fit: BoxFit.cover,
                              height: 140,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              style: TextStyle().copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              "N${widget.product.price}",
                              style: TextStyle().copyWith(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  widget.product.description,
                                  style: TextStyle().copyWith(
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            ),
          )
        ],
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: theme.darkTheme ? darkGrey : Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 1.0,
                    color: Colors.black.withOpacity(.1),
                  )
                ]),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: SvgPicture.asset(
                            "assets/icons/carbon_delivery.svg",
                            width: 35,
                            height: 35,
                          ),
                        ),
                        Text(
                          "Delivery Details",
                          style: TextStyle().copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    'Choose your location',
                    style: TextStyle().copyWith(fontSize: 18),
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
                    icon: SvgPicture.asset("assets/icons/dropdown_icon.svg"),
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
                    icon: SvgPicture.asset("assets/icons/dropdown_icon.svg"),
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
                    icon: SvgPicture.asset("assets/icons/dropdown_icon.svg"),
                    validator: (country) =>
                        country == null ? "Select LGA" : null,
                    decoration: textInputDecoration(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: ((value) =>
                        value!.length < 3 ? "Enter a valid name" : null),
                    decoration: textInputDecoration(hint: "Name"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _addressController,
                    validator: ((value) =>
                        value!.length < 5 ? "Enter a valid address" : null),
                    decoration: textInputDecoration(hint: "Address"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _landMarkController,
                    validator: ((value) =>
                        value!.length < 5 ? "Enter a valid landmark" : null),
                    decoration: textInputDecoration(hint: "Major Landmark"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    maxLength: 11,
                    validator: ((value) =>
                        value!.length < 11 ? "Enter a valid phone" : null),
                    keyboardType: TextInputType.phone,
                    decoration: textInputDecoration(hint: "Phone"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: ((value) => !EmailValidator.isValidEmail(value!)
                        ? "Enter a valid email"
                        : null),
                    keyboardType: TextInputType.emailAddress,
                    decoration: textInputDecoration(hint: "Email Address"),
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
                                  product: widget.product,
                                  name: _nameController.text,
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  country: _country!.name,
                                  state: _state!.title,
                                  address: _addressController.text,
                                  lga: _lga!.title,
                                  landMark: _landMarkController.text,
                                  user: _currentUser!.uid,
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
          ),
        ),
      ));
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