import "package:flutter/material.dart";
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
        productPrice -= item.price;
      } else {
        selectedItems.add(item);
        productPrice += item.price;
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
    setState(() {});
  }

  void decrementItemQuantity(ProductItemWithCheckbox item) {
    int itemIndex = selectedItems.indexOf(item);
    selectedItems[itemIndex].quantity--;
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
        // GestureDetector(
        //   onTap: () => item.quantity > 1 ? decrementItemQuantity(item) : null,
        //   child: Container(
        //     padding: EdgeInsets.zero,
        //     decoration: BoxDecoration(
        //       color: primaryColor,
        //       borderRadius: BorderRadius.circular(5.0),
        //     ),
        //     child: Center(
        //       child: Icon(
        //         Icons.remove,
        //         size: 20,
        //       ),
        //     ),
        //   ),
        // ),
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
        // GestureDetector(
        //   onTap: () => item.quantity < 20 ? incrementItemQuantity(item) : null,
        //   child: Container(
        //     padding: EdgeInsets.zero,
        //     decoration: BoxDecoration(
        //       color: primaryColor,
        //       borderRadius: BorderRadius.circular(5.0),
        //     ),
        //     child: Center(
        //       child: Icon(
        //         Icons.add,
        //         size: 20,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.product.images!.length,
                  itemBuilder: (context, i) => Image.asset(
                    widget.product.images![i].url,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
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
                    children: [
                      Text(
                        widget.product.name,
                        style: TextStyle().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      "N${productPrice}",
                      style: TextStyle().copyWith(
                        color: primaryColor,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text("Buy"),
                          ),
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
                        .map((item) => productItemTile(item)
                            //     ListTile(
                            //   title: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         item.item,
                            //         style: TextStyle()
                            //             .copyWith(fontWeight: FontWeight.w600),
                            //       ),
                            //       Checkbox(
                            //         onChanged: (val) {
                            //           _handleCheckboxChange(val, item);
                            //         },
                            //         value: item.isSelected,
                            //       ),
                            //     ],
                            //   ),
                            //   dense: true,
                            //   contentPadding: EdgeInsets.zero,
                            //   selectedColor: darkGrey,
                            //   textColor: lightGrey,
                            //   selected: true,
                            //   subtitle: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Row(
                            //         children: [
                            //           Text("N${item.price}"),
                            //         ],
                            //       ),
                            //       itemQuantitySelector(item)
                            //     ],
                            //   ),
                            // ),
                            )
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
    productItems = widget.product.items!
        .map((item) => ProductItemWithCheckbox(
            item: item.item, price: item.price, quantity: item.quantity))
        .toList();
    selectedItems = productItems.sublist(0);
    super.initState();
  }
}
