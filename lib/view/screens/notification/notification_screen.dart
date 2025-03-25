import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                    text: 'general_summary'.tr, // Use translation key
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

                              int notificationCount = snapshot.data!.docs.length;

                              return Column(
                                children: [
                                  CustomText(
                                    text: 'total_notifications'.tr, // Use translation key
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: "$notificationCount",
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
                            children: [
                              CustomText(
                                text: 'read_rate'.tr, // Use translation key
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 8),
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
                    text: 'statistics_by_user_type'.tr, // Use translation key
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
                              title: 'providers'.tr, // Use translation key
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
                              title: 'patients'.tr, // Use translation key
                              userId: 'Nueva Cita',
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
                    text: 'breakdown_by_notification_type'.tr, // Use translation key
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
                      children: [
                        Expanded(
                          child: CustomContainer(
                            padding: const EdgeInsets.all(16),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                            child: _NotificationTypeWidget(
                              title: 'new_appointments'.tr, // Use translation key
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
                              title: 'appointment_on_hold'.tr, // Use translation key
                              total: "11",
                              readRate: "70%",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
class _UserStatsWidget extends StatelessWidget {
  final String title;
  final String userId;

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
          .where('title', isEqualTo: userId)
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
            : "0%";
        double readRatePercent = totalNotifications > 0
            ? (readNotifications / totalNotifications)
            : 0.0;
        return Column(
          children: [
            CustomText(
              text: title,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: "$totalNotifications",
              fontSize: 20,
            ),
            const SizedBox(height: 4),
            CustomText(
              text: "Read Rate: $readRate",
            ),
            LinearProgressIndicator(
              value: readRatePercent, // Should be 0.0 to 1.0
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
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