import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/product_details.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class PortraitProductCard extends StatelessWidget {
  final Product product;
  const PortraitProductCard({super.key, required this.product});

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
                              color: Color(0xFF222227),
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
                            color: Color(0xFF595959),
                            fontSize: 16,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add),
                          label: Text("Add"),
                        )
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
