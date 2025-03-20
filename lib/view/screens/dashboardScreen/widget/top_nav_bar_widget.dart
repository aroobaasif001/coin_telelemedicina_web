import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Title
            Text(
              "Admin Panel - Telemedicine App",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // Right Section: Admin Email + Profile
            Row(
              children: [
                Text(
                  "admin@email.com",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text("A", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}