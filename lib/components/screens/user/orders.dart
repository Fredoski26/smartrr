import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/order_card.dart';
import 'package:smartrr/models/order.dart';
import 'package:smartrr/services/shop_service.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: StreamBuilder<List<Order>>(
        stream: ShopService.getAllOrders().asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  OrderCard(order: snapshot.data![index]),
            );
          } else
            return SizedBox();
        },
      ),
    );
  }
}
