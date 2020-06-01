import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';
import 'package:jayshowloaction/utility/my_style.dart';

class ProfileDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[50],
      child: ContactUs(
        cardColor: MyStyle().primaryColor,
        textColor: Colors.teal.shade900,
        logo: AssetImage('images/image_contact.png'),
        companyName: 'สำนักวิศวกรรม',
        email: 'engchp@thaipbs.or.th',
        phoneNumber: '027902314',
        website: 'https://www.thaipbs.or.th/home',
        line: 'https://lin.ee/sWgXrlr',
        tagLine: 'ไทยพีบีเอส',
        twitterHandle: 'thaipbs',
        facebook: 'ThaiPBSFan',
      ),
    );
  }
}
