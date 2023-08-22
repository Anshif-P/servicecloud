import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/home_screen/banner_items.dart';

class Appbanner {
  final int id;
  final carosalDetials;
  final thumbnailurl;

  Appbanner(this.id, this.thumbnailurl, this.carosalDetials);
}

List<Appbanner> appBannerList = [
  Appbanner(
      1,
      WorkContainer1(),
      page1(
        loggeduser: loggeduserTemp!,
      )),
  Appbanner(
      2,
      WorkContainer2(),
      page2(
        loggeduser: loggeduserTemp!,
      )),
];

class WorkContainer1 extends StatelessWidget {
  const WorkContainer1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        image: AssetImage(
          'lib/image/works.png',
        ),
        fit: BoxFit.fill,
      ),
    );
  }
}

class WorkContainer2 extends StatelessWidget {
  const WorkContainer2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        image: AssetImage(
          'lib/image/Progress overview-cuate.png',
        ),
        fit: BoxFit.fill,
      ),
    );
  }
}
