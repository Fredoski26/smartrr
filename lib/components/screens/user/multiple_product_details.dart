import 'package:flutter/material.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/utils/colors.dart';

class MultipleProductDetails extends StatefulWidget {
  final Product product;
  const MultipleProductDetails({super.key, required this.product});

  @override
  State<MultipleProductDetails> createState() => _MultipleProductDetailsState();
}

class _MultipleProductDetailsState extends State<MultipleProductDetails> {
  @override
  Widget build(BuildContext context) {
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
                    color: Colors.white,
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
                            child: Image.asset(
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                widget.product.description,
                                style: TextStyle().copyWith(
                                  fontSize: 13,
                                  height: 1.2,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product.type == ProductType.multiple
                ? Expanded(
                    child: ListView.separated(
                        itemCount: widget.product.items!.length,
                        padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
                        separatorBuilder: (context, _) => Divider(),
                        itemBuilder: (context, index) {
                          final items = widget.product.items;
                          if (index == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Kit contains:",
                                  style: TextStyle().copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(items![index].item),
                                      Checkbox(
                                        onChanged: (val) => !val!,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("N${items[index].price}"),
                                      Text("1")
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(items![index].item),
                                  Checkbox(
                                    onChanged: (val) => !val!,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("N${items[index].price}"),
                                  Text("1")
                                ],
                              ),
                            );
                          }
                        }),
                  )
                : SizedBox(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Text("Continue"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
