import 'package:coin_telelemedicina_web/view/screens/patient/patient_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:get/get.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({Key? key}) : super(key: key);

  @override
  _PatientScreenState createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Sample patient data
  List<Map<String, String>> patients = [
    {
      'name': 'Sandra Josefina',
      'email': 'userinfo4@gmail.com',
      'disability': 'Auditory',
      'location': 'Santo Domingo, Santo Domingo Norte',
      'gender': 'Female',
      'status': 'Active',
      'registration': '13 Mar 2025',
    },
    {
      'name': 'Maria del Mar',
      'email': 'prueba25@gmail.com',
      'disability': 'Cognitive',
      'location': 'Santo Domingo, Santo Domingo Norte',
      'gender': 'Female',
      'status': 'Active',
      'registration': '09 Mar 2025',
    },
    {
      'name': 'Miguel Aguirre',
      'email': 'test298@gmail.com',
      'disability': 'Cognitive',
      'location': 'Santo Domingo, Santo Domingo Este',
      'gender': 'Non-binary',
      'status': 'Active',
      'registration': '27 Feb 2025',
    },
    {
      'name': 'Muhammad Mawaz',
      'email': 'mawaz@gmail.com',
      'disability': 'Visual',
      'location': 'Santiago, Licey al Medio',
      'gender': 'Non-binary',
      'status': 'Active',
      'registration': '25 Feb 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          CustomAppbar(title: 'Patient Management'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // ✅ Search Bar & Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Patient Management',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      icon: const Icon(Icons.add, color: Colors.white, size: 13),
                      label: const Text("New Patient",
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                      onPressed: () {
                        // Add new patient functionality
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ✅ Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Search by name, email or disability...',
                      prefixIcon: Icon(Icons.search, size: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ✅ Scrollable Table using ListView.builder
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ClipRect(
                child: Container(
                  width: 1100, // Adjusted to fit the table properly
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      // Table Headers
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.grey.shade200,
                        child: Row(
                          children: const [
                            Expanded(flex: 3, child: Text("Patient", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text("Disability", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text("Location", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text("Gender", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text("Status", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text("Registration", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text("Actions", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.grey),

                      // Table Rows using ListView.builder
                      SizedBox(
                        height: 400, // Prevents overflow issue
                        child: ListView.builder(
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                              ),
                              child: Row(
                                children: [
                                  // ✅ Patient Name & Email
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        const CircleAvatar(radius: 13),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(patient['name']!,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                                overflow: TextOverflow.ellipsis),
                                            Text(patient['email']!,
                                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                                                overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // ✅ Disability
                                  Expanded(
                                    flex: 2,
                                    child: Chip(
                                      label: Text(patient['disability']!, style: const TextStyle(fontSize: 13)),
                                      backgroundColor: Colors.green.shade100,
                                    ),
                                  ),

                                  // ✅ Location
                                  Expanded(
                                    flex: 2,
                                    child: Text(patient['location']!, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                                  ),

                                  // ✅ Gender
                                  Expanded(
                                    flex: 2,
                                    child: Chip(
                                      label: Text(patient['gender']!, style: const TextStyle(fontSize: 13)),
                                      backgroundColor: Colors.blue.shade100,
                                    ),
                                  ),

                                  // ✅ Status
                                  Expanded(
                                    flex: 2,
                                    child: Chip(
                                      label: Text(patient['status']!, style: const TextStyle(fontSize: 13)),
                                      backgroundColor: Colors.green.shade300,
                                    ),
                                  ),

                                  // ✅ Registration Date
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 13),
                                        const SizedBox(width: 4),
                                        Text(patient['registration']!, style: const TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                  ),

                                  // ✅ Actions
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(icon: const Icon(Icons.remove_red_eye, color: Colors.blue, size: 13), onPressed: () {
                                          Get.to(()=> PatientViewScreen());
                                        }),
                                        IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 13), onPressed: () {}),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
