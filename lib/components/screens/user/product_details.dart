import "package:flutter/material.dart";
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:smartrr/components/screens/user/delivery_details.dart';
import 'package:smartrr/components/widgets/shopping_cart.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late Product product;
  late double productPrice = widget.product.price;
  late List<ProductItemWithCheckbox> productItems;
  late List<ProductItemWithCheckbox> selectedItems;

  void _handleCheckboxChange(bool? val, ProductItemWithCheckbox item) {
    int itemIndex = productItems.indexOf(item);
    if (selectedItems.length <= 2 && !val!) {
      showToast(msg: "A least two items must be selected");
    } else {
      productItems[itemIndex].isSelected = val!;

      if (!val) {
        selectedItems.remove(item);
        productPrice -= item.price * item.quantity;
      } else {
        selectedItems.add(item);
        productPrice += item.price * item.quantity;
      }
      setState(() {});
    }
  }

  Widget productItemTile(ProductItemWithCheckbox item) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.item,
                style: TextStyle().copyWith(fontWeight: FontWeight.w600),
              ),
              Checkbox(
                onChanged: (val) {
                  _handleCheckboxChange(val, item);
                },
                value: item.isSelected,
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("N${item.price}"),
                ],
              ),
              item.isSelected ? itemQuantitySelector(item) : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  void incrementItemQuantity(ProductItemWithCheckbox item) {
    int itemIndex = selectedItems.indexOf(item);
    selectedItems[itemIndex].quantity++;
    productPrice += selectedItems[itemIndex].price;
    setState(() {});
  }

  void decrementItemQuantity(ProductItemWithCheckbox item) {
    int itemIndex = selectedItems.indexOf(item);
    selectedItems[itemIndex].quantity--;
    productPrice -= selectedItems[itemIndex].price;
    setState(() {});
  }

  Widget itemQuantitySelector(ProductItemWithCheckbox item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed:
              item.quantity > 1 ? () => decrementItemQuantity(item) : null,
          color: primaryColor,
          icon: Icon(
            Icons.remove,
            size: 20,
          ),
        ),
        SizedBox(width: 5.0),
        Text(item.quantity.toString()),
        SizedBox(width: 5.0),
        IconButton(
          onPressed:
              item.quantity < 10 ? () => incrementItemQuantity(item) : null,
          color: primaryColor,
          icon: Icon(
            Icons.add,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget productQuantitySelector() {
    incrementProductQuantity() {
      ++product.quantity;
      productPrice += product.price;
      setState(() {});
    }

    decrementProductQuantity() {
      --product.quantity;
      productPrice -= product.price;
      setState(() {});
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed:
              product.quantity > 1 ? () => decrementProductQuantity() : null,
          color: primaryColor,
          icon: Icon(
            FeatherIcons.minus,
            size: 20,
          ),
        ),
        SizedBox(width: 5.0),
        Text(product.quantity.toString()),
        SizedBox(width: 5.0),
        IconButton(
          onPressed:
              product.quantity < 10 ? () => incrementProductQuantity() : null,
          color: primaryColor,
          icon: Icon(
            FeatherIcons.plus,
            size: 20,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [ShoppingCart()]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: darkGrey.withOpacity(.2),
                      offset: Offset(0, 5),
                      blurRadius: 20,
                    )
                  ],
                ),
                child: ListView.builder(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: product.images!.length,
                  itemBuilder: (context, i) => Image.network(
                    product.images![i].url,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      productQuantitySelector()
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "N${productPrice.toStringAsFixed(2)}",
                      style: TextStyle().copyWith(
                        color: faintGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            widget.product.description,
                            style: TextStyle().copyWith(color: faintGrey),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextButton(
                        child: Text("Add to Cart"),
                        onPressed: null,
                      )),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeliveryDetails(
                                  product: Product(
                                id: product.id,
                                name: product.name,
                                price: productPrice,
                                description: product.description,
                                images: product.images,
                                items: selectedItems,
                                type: product.type,
                              )),
                            ),
                          ),
                          child: Text("Buy"),
                        ),
                      )
                    ],
                  ),
                  widget.product.type == ProductType.multiple
                      ? Row(
                          children: [
                            Text(
                              "Kit contains:",
                              style: TextStyle().copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  Column(
                    children: productItems
                        .map((item) => productItemTile(item))
                        .toList(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    product = widget.product;
    productItems = widget.product.items!
        .map((item) => ProductItemWithCheckbox(
            item: item.item, price: item.price, quantity: item.quantity))
        .toList();
    selectedItems = productItems.sublist(0);
    super.initState();
  }
}
