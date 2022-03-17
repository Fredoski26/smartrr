import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem(
      {Key key, this.label = "•", @required this.body, this.title = ""})
      : super(key: key);

  final String label, body, title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: ListTile(
        horizontalTitleGap: 0.0,
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Text(
          label,
          style: TextStyle().copyWith(fontWeight: FontWeight.bold),
        ),
        title: title.isNotEmpty
            ? Text(title, style: Theme.of(context).textTheme.bodyText1)
            : null,
        subtitle: Text(
          body,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
