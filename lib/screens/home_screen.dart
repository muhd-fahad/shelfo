import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset("assets/logo/app_logo_Primary.svg",height: 24,fit: BoxFit.fitWidth,),
        actions: [
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none_rounded,size: 24,)),
              IconButton(onPressed: () {}, icon: Icon(Icons.account_circle_outlined,size: 24,)),
            ],
          )
        ],
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: .center,
          children: [
            SizedBox(
              height: 150 ,
              width: .infinity,
              child: Placeholder(
                child: Center(child: Text("Quick info cards")),
              )),
            Text("Whereas disregard and contempt for human rights have resulted"),
          ],
        ),
      ),
    );
  }
}
