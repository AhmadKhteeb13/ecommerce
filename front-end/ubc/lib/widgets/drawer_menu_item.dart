import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DrawerMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool lastItem;
  final String pageUrl;

  const DrawerMenuItem(
      {Key? key,
      required this.title,
      required this.icon,
      required this.lastItem,
      required this.pageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          if(title == "Sign out"){
            final storage = FlutterSecureStorage();
          await storage.write(key: 'email', value: null);
          await storage.write(key: 'password', value: null);
          }
          Navigator.pushNamed(
            context,
            pageUrl,
          );
        },
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                    ),
                    Icon(
                      icon,
                      color: Colors.red,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 13,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: "Raleway",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!lastItem)
                Container(
                  margin: EdgeInsets.only(right: 0.4 * width, top: 8),
                  height: 1,
                  width: 0.266 * width,
                  color: const Color(0xFF979797),
                )
            ])),
      ),
    );
  }
}
