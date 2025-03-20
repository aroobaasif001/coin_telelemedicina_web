import 'package:coin_telelemedicina_web/components/app_colors.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

class PatientViewScreen extends StatelessWidget {
  const PatientViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // We have 2 tabs: Upcoming Consultations & History
      child: Scaffold(
        // Custom top app bar
        body: Column(
          children: [
            // Top AppBar
            const CustomAppbar(title: 'Patient Profile'),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row that holds the left (Profile) and right (Info) panels
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ====== LEFT PROFILE CARD ======
                        Container(
                          width: 300, // Fixed width for the profile card
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    "https://via.placeholder.com/150", // Replace with patient photo URL
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const CustomText(
                                  text: "Sandra Josefina",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 4),
                                CustomText(
                                  text: "sandra.josefina@example.com",
                                  color: Colors.grey[700],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // ====== RIGHT PANEL (Personal & Additional Info) ======
                        Expanded(
                          child: Column(
                            children: [
                              // PERSONAL INFORMATION CARD
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: "Personal Information",
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const Divider(),
                                      // ID, Phone, Birthdate
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _infoField(
                                              label: "ID / Document",
                                              value: "402-1234567-2",
                                            ),
                                          ),
                                          Expanded(
                                            child: _infoField(
                                              label: "Phone",
                                              value: "+1 (555) 123-4567",
                                            ),
                                          ),
                                          Expanded(
                                            child: _infoField(
                                              label: "Birthdate",
                                              value: "01/01/2001",
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // Location (Province, Canton, Parish)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _infoField(
                                              label: "Province",
                                              value: "Some Province",
                                            ),
                                          ),
                                          Expanded(
                                            child: _infoField(
                                              label: "Canton",
                                              value: "Some Canton",
                                            ),
                                          ),
                                          Expanded(
                                            child: _infoField(
                                              label: "Parish",
                                              value: "Some Parish",
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // Status, Disability
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _infoField(
                                              label: "Status",
                                              value: "Active",
                                            ),
                                          ),
                                          Expanded(
                                            child: _infoField(
                                              label: "Disability",
                                              value: "Deaf",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ADDITIONAL INFORMATION CARD
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: "Additional Information",
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _infoField(
                                              label: "Registration Date",
                                              value: "March 10, 2025",
                                            ),
                                          ),
                                          Expanded(
                                            child: _infoField(
                                              label: "Last Update",
                                              value: "March 10, 2025",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // ============== TABS (UPCOMING CONSULTATIONS / HISTORY) ==============
                    Container(
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        labelColor: Colors.black,
                        isScrollable: true,
                        dividerColor: Colors.transparent,
                        indicatorColor: AppColor.greenColor, // from your app_colors.dart
                        tabs: const [
                          Tab(text: "Upcoming Consultations"),
                          Tab(text: "History"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // TabBarView
                    SizedBox(
                      height: 200, // Adjust as needed
                      child: TabBarView(
                        children: [
                          // Upcoming Consultations
                          Center(
                            child: CustomText(
                              text: "No scheduled consultations",
                              color: Colors.grey[600],
                            ),
                          ),
                          // History
                          Center(
                            child: CustomText(
                              text: "No history available",
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for displaying label/value pairs
  Widget _infoField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          const SizedBox(height: 4),
          CustomText(
            text: value,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}