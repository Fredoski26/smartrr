import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/shop/product_details.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/shop_service.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class PortraitProductCard extends StatelessWidget {
  final Product product;
  PortraitProductCard({super.key, required this.product});

  final _cartBox = Hive.box<Product>("cart");

  ButtonStyle textButtonStyle = ButtonStyle().copyWith(
    textStyle: MaterialStatePropertyAll(TextStyle().copyWith(fontSize: 12)),
    iconSize: MaterialStatePropertyAll(12),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          PageTransition(
            child: ProductDetails(
              product: product,
            ),
            type: PageTransitionType.rightToLeft,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.darkTheme ? darkGrey : Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Image.network(
                      product.images![0].url,
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: imageLoadingBuilder,
                    ),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(.36),
                          Color(0xFF1E1E1E).withOpacity(0)
                        ],
                        stops: [0.0, 0.5],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle().copyWith(
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "N${product.price.toStringAsFixed(2)}",
                          style: TextStyle().copyWith(
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable: _cartBox.listenable(),
                            builder: (context, cart, __) {
                              if (!ShopService.isInCart(product.id)) {
                                return TextButton.icon(
                                  onPressed: () => ShopService.addtoCart(
                                      {product.id: product}),
                                  icon: Icon(Icons.add),
                                  label: Text("Add"),
                                  style: textButtonStyle,
                                );
                              } else {
                                return TextButton.icon(
                                  onPressed: () =>
                                      ShopService.removeFromCart(product.id),
                                  icon: Icon(Icons.remove),
                                  label: Text("Remove"),
                                  style: textButtonStyle,
                                );
                              }
                            })
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget imageLoadingBuilder(context, child, loadingProgress) {
    if (loadingProgress == null)
      return child;
    else
      return Center(
        child: Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: lightGrey,
                size: 50,
              ),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                  value: loadingProgress.expectedTotalBytes != null
                      ? (loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!)
                      : null,
                ),
              )
            ],
          ),
        ),
      );
  }
}
