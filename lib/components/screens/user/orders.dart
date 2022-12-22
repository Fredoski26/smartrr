import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/order_card.dart';
import 'package:smartrr/models/order.dart';
import 'package:smartrr/services/shop_service.dart';
import 'package:smartrr/utils/colors.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});
  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: StreamBuilder<List<Order>>(
        stream: ShopService.getAllOrders(userId: _currentUser!.uid).asStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) =>
                    OrderCard(order: snapshot.data![index]),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        color: lightGrey,
                        size: 40,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You have no orders",
                        style: TextStyle().copyWith(color: lightGrey),
                      )
                    ],
                  )
                ],
              );
            }
          } else
            return SizedBox();
        },
      ),
    );
  }
}
