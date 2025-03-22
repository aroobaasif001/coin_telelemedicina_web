import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';

import '../dashboardScreen/widget/top_nav_bar_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: TopNavBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 8),
            CustomContainer(
              margin: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              conColor: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "General Summary",
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomContainer(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('notifications')
                            // .where('userId', isEqualTo: 'yourUserId') // Filter by user
                            // .where('isRead', isEqualTo: false) // Only count unread notifications
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Column(
                                  children: const [
                                    CustomText(
                                      text: "Total Notifications",
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(height: 8),
                                    CircularProgressIndicator(), // Show loading indicator while fetching data
                                  ],
                                );
                              }

                              int notificationCount = snapshot.data!.docs.length; // Get total count

                              return Column(
                                children: [
                                  const CustomText(
                                    text: "Total Notifications",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: "$notificationCount", // Show dynamic count
                                    fontSize: 24,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Card for Read Rate
                      Expanded(
                        child: CustomContainer(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                          child: Column(
                            children: const [
                              CustomText(
                                text: "Read Rate",
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: 8),
                              CustomText(
                                text: "54%",
                                fontSize: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            CustomContainer(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              borderRadius: BorderRadius.circular(15),
              conColor: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics by User Type
                  CustomText(
                    text: "Statistics by User Type",
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  CustomContainer(
                    margin: const EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(15),
                    conColor: Colors.white,
                    child: Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: CustomContainer(
                            padding: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                            child: _UserStatsWidget(
                              title: "Providers",
                             userId: 'Appointment Confirmed',
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomContainer(
                            padding: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                            child: _UserStatsWidget(
                              title: "Patients", userId: 'Nueva Cita',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            CustomContainer(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              borderRadius: BorderRadius.circular(10),
              conColor: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Breakdown by Notification Type",
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  CustomContainer(
                    margin: const EdgeInsets.all(10),
                    borderRadius: BorderRadius.circular(15),
                    conColor: Colors.white,
                    child: Row(
                      spacing: 10,
                      children:  [
                      Expanded(
                        child: CustomContainer(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                          child: _NotificationTypeWidget(
                              title: "New Appointments",
                              total: "18",
                              readRate: "80%",
                            ),
                          ),
                      ),
                        Expanded(
                          child: CustomContainer(
                            padding: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                            child: _NotificationTypeWidget(
                              title: "Appointment on Hold",
                              total: "11",
                              readRate: "70%",
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for "Statistics by User Type"
// class _UserStatsWidget extends StatelessWidget {
//   final String title;
//   final String total;
//   final String readRate;

//   const _UserStatsWidget({
//     Key? key,
//     required this.title,
//     required this.total,
//     required this.readRate,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomText(
//           text: title,
//           fontWeight: FontWeight.bold,
//         ),
//         const SizedBox(height: 8),
//         CustomText(
//           text: total,
//           fontSize: 20,
//         ),
//         const SizedBox(height: 4),
//         CustomText(
//           text: "Read Rate: $readRate",
//         ),
//       ],
//     );
//   }
// }



class _UserStatsWidget extends StatelessWidget {
  final String title;
  final String userId; // Pass user ID dynamically

  const _UserStatsWidget({
    Key? key,
    required this.title,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .where('title', isEqualTo: userId) // Filter by user ID
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: const [
              CustomText(
                text: "Loading...",
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8),
              CircularProgressIndicator(), // Show loading indicator
            ],
          );
        }

        var allNotifications = snapshot.data!.docs;
        int totalNotifications = allNotifications.length;
        int readNotifications = allNotifications
            .where((doc) => doc['read'] == true)
            .length;

        String readRate = totalNotifications > 0
            ? ((readNotifications / totalNotifications) * 100).toStringAsFixed(1) + "%"
            : "0%"; // Avoid division by zero

        return Column(
          children: [
            CustomText(
              text: title,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: "$totalNotifications", // Show total notifications count
              fontSize: 20,
            ),

            const SizedBox(height: 4),
            CustomText(
              text: "Read Rate: $readRate",
            ),
          ],
        );
      },
    );
  }
}

// Helper widget for "Breakdown by Notification Type"
class _NotificationTypeWidget extends StatelessWidget {
  final String title;
  final String total;
  final String readRate;

  const _NotificationTypeWidget({
    Key? key,
    required this.title,
    required this.total,
    required this.readRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: title,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        CustomText(
          text: total,
          fontSize: 20,
        ),
        const SizedBox(height: 4),
        CustomText(
          text: "Read Rate: $readRate",
        ),
      ],
    );
  }
}
