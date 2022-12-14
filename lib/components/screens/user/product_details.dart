import "package:flutter/material.dart";
import 'package:smartrr/models/product.dart';
import 'package:smartrr/utils/colors.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    double productPrice = widget.product.price;

    List<ProductItemWithCheckbox> _productItems = widget.product.items!
        .map((item) => ProductItemWithCheckbox(
            item: item.item, price: item.price, quantity: item.quantity))
        .toList();

    _handleCheckboxChange(bool? val) {
      return !val!;
    }

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
                      "N$productPrice",
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
                    children: widget.product.items!
                        .map(
                          (item) => ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.item),
                                Checkbox(
                                  onChanged: _handleCheckboxChange,
                                  value: true,
                                ),
                              ],
                            ),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            selectedColor: darkGrey,
                            textColor: lightGrey,
                            selected: true,
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("N${item.price}"), Text("1")],
                            ),
                          ),
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
}
