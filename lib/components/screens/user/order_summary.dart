import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class OrderSummary extends StatelessWidget {
  final Product product;
  const OrderSummary({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String content = "Content: ";

    if (product.type == ProductType.multiple) {
      content += product.items!.map((item) => "${item.item}").join(", ");
    } else {
      content += product.name;
    }
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => Scaffold(
        appBar: AppBar(title: Text(product.name)),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            Text(
              "Order summary",
              textAlign: TextAlign.center,
              style: TextStyle().copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: 150,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: theme.darkTheme
                    ? Colors.grey.withOpacity(.2)
                    : Colors.white,
              ),
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
                            product.images![0].url,
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
                            product.name,
                            style: TextStyle().copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            "N${product.price}",
                            style: TextStyle().copyWith(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                content,
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
            SizedBox(height: 20.0),
            Container(
              // height: 150,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: theme.darkTheme
                    ? Colors.grey.withOpacity(.2)
                    : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Billing Information",
                    textAlign: TextAlign.center,
                    style: TextStyle().copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      content,
                      style: TextStyle().copyWith(
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(.2)),
            )
          ],
        ),
      ),
    );
  }
}
