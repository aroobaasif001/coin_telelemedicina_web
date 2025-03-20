import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppbar(title: 'Notifications Management',),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // General Summary
                  CustomText(
                    text: "General Summary",
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Card for Total Notifications
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: const [
                                CustomText(
                                  text: "Total Notifications",
                                  fontWeight: FontWeight.bold,
                                ),
                                SizedBox(height: 8),
                                CustomText(
                                  text: "65",
                                  fontSize: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Card for Read Rate
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Statistics by User Type
                  CustomText(
                    text: "Statistics by User Type",
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _UserStatsWidget(
                            title: "Providers",
                            total: "26",
                            readRate: "100%",
                          ),
                          _UserStatsWidget(
                            title: "Patients",
                            total: "28",
                            readRate: "72%",
                          ),
                          _UserStatsWidget(
                            title: "Unknown",
                            total: "1",
                            readRate: "55%",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Breakdown by Notification Type
                  CustomText(
                    text: "Breakdown by Notification Type",
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize ?? 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _NotificationTypeWidget(
                            title: "New Appointments",
                            total: "18",
                            readRate: "80%",
                          ),
                          _NotificationTypeWidget(
                            title: "Appointment on Hold",
                            total: "11",
                            readRate: "70%",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Helper widget for "Statistics by User Type"
class _UserStatsWidget extends StatelessWidget {
  final String title;
  final String total;
  final String readRate;

  const _UserStatsWidget({
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
