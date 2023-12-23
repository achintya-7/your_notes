import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey.shade900,
        child: Column(
          children: [
            80.heightBox,
            "Made By".text.white.xl3.semiBold.make().p(16),
            "Achintya".text.white.bold.xl4.make().shimmer(primaryColor: Vx.pink500, secondaryColor: Vx.blue500),
            20.heightBox,
            ElevatedButton(
              onPressed: () => launchUrlString("https://linktr.ee/achintya_only"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              child: "Link Tree".text.white.make(),
            ),
            IconButton(
              onPressed: () => launchUrlString("https://github.com/achintya-7/notesApp_flutter"),
              icon: Image.asset('assets/images/icons8-github-96.png'),
              iconSize: 80,
            )
          ],
        ),
      ),
    );
  }
}
