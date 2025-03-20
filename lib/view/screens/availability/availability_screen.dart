import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({Key? key}) : super(key: key);

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  int selectedIndex = 0; // 0: Doctors, 1: Interpreters

  @override
  Widget build(BuildContext context) {
    // Example data for Doctors
    final List<Map<String, String>> doctorsData = [
      {
        "name": "Dra. María Rodríguez",
        "specialty": "Pediatrics",
        "status": "Active",
      },
      {
        "name": "Juan Pérez",
        "specialty": "General Medicine",
        "status": "Inactive",
      },
    ];

    // Example data for Interpreters
    final List<Map<String, String>> interpretersData = [
      {
        "name": "Jesús Sánchez",
        "specialty": "No specialty",
        "status": "Active",
      },
      {
        "name": "Carlos Sánchez",
        "specialty": "Sign Language",
        "status": "Inactive",
      },
    ];

    // Determine which data to display based on selectedIndex.
    final currentData = selectedIndex == 0 ? doctorsData : interpretersData;

    return Scaffold(
      // appBar: CustomAppbar(title: 'Availability Management'),
      body: Column(
        children: [
          CustomAppbar(title: 'Availability Management'),
          const SizedBox(height: 16),
          // Page Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                const Text(
                  "Availability Management",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // Green "New Availability" Button
                MaterialButton(
                  onPressed: () {
                    // Add your functionality here
                  },
                  color: Colors.green,
                  // Button color
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.add, color: Colors.white),
                      SizedBox(width: 6), // Spacing between icon and text
                      CustomText(text: "New Availability"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomContainer(
            conColor: Colors.white,
            padding: EdgeInsets.all(5),
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Search by name or specialty...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          // Handle search/filter logic
                        },
                      ),
                      const SizedBox(height: 16),
                      // Buttons to switch views (Doctors / Interpreters)
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = 0;
                              });
                            },
                            child: CustomContainer(
                              width: 100,
                              border: Border(
                                  bottom: BorderSide(
                                      color: selectedIndex == 0 ? Colors.green : Colors.transparent,
                                      width: 2)),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.medical_services_outlined,
                                    color: selectedIndex == 0 ? Colors.green : Colors.grey,
                                  ),
                                  SizedBox(height: 5),
                                  CustomText(
                                    text: "Doctors",
                                    color: selectedIndex == 0 ? Colors.green : Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            child: CustomContainer(
                              width: 100,
                              border: Border(
                                  bottom: BorderSide(
                                      color: selectedIndex == 1 ? Colors.green : Colors.transparent,
                                      width: 2)),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.medical_services_outlined,
                                    color: selectedIndex == 1 ? Colors.green : Colors.grey,
                                  ),
                                  SizedBox(height: 5),
                                  CustomText(
                                    text: "Interpreters",
                                    color: selectedIndex == 1 ? Colors.green : Colors.grey,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                // Display content based on the selected index.
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: currentData.map((person) {
                      final bool statusIsActive = (person["status"] == "Active");
                      return Card(
                        color: Colors.white,
                        elevation: 2,
                        shadowColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          width: 240, // Adjust card width as needed
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),

                          ),
                          child: MaterialButton(
                            onPressed: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name
                                  CustomText(
                                    text: person["name"] ?? "",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  const SizedBox(height: 4),
                                  // Specialty
                                  CustomText(
                                    text: person["specialty"] ?? "",
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(height: 8),
                                  // Status Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusIsActive ? Colors.green.shade50 : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: CustomText(
                                      text: person["status"] ?? "",
                                      color: statusIsActive ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
