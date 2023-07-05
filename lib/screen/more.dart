import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({
    super.key,
  });

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              children: [
                const UserAccountsDrawerHeader(
                  otherAccountsPictures: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.settings,
                          size: 35,
                        )
                      ],
                    )
                  ],
                  accountName: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "name",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  accountEmail: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: ClipOval(),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("로그아웃"),
                  onTap: signUserOut,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
