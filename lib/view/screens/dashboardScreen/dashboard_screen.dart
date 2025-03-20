// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'widget/stat_card.dart';
// import 'widget/top_nav_bar_widget.dart';

// class DashboardScreen extends StatefulWidget {
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   String selectedTimeFilter = "30 days";
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   int patientCount = 0;
//   int doctorCount = 0;
//   int serviceCount = 0;
//   int appointmentCount = 0;
//   int completedAppointments = 0;
//   int companiesCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchStats();
//   }

//   Future<void> _fetchStats() async {
//     try {
//       var patientsSnapshot = await _firestore.collection('patients').get();
//       var doctorsSnapshot = await _firestore.collection('providers').get();
//       var servicesSnapshot = await _firestore.collection('services').get();
//       var appointmentsSnapshot = await _firestore.collection('appointments').get();
//       var completedAppointmentsSnapshot = await _firestore
//           .collection('appointments')
//           .where('status', isEqualTo: 'completed')
//           .get();
//       var companiesSnapshot = await _firestore.collection('interpreterProfiles').get();

//       setState(() {
//         patientCount = patientsSnapshot.docs.length;
//         doctorCount = doctorsSnapshot.docs.length;
//         serviceCount = servicesSnapshot.docs.length;
//         appointmentCount = appointmentsSnapshot.docs.length;
//         completedAppointments = completedAppointmentsSnapshot.docs.length;
//         companiesCount = companiesSnapshot.docs.length;
//       });
//     } catch (e) {
//       print("Error fetching stats: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(80),
//         child: TopNavBar(),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 10),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Dashboard",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       _buildTimeFilterButton("30 days"),
//                       _buildTimeFilterButton("60 days"),
//                       _buildTimeFilterButton("90 days"),
//                       SizedBox(width: 10),
//                       IconButton(
//                         icon: Icon(Icons.refresh, color: Colors.black),
//                         onPressed: _fetchStats,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             Divider(thickness: 1, color: Colors.grey[300]),
//             Text('General Statistics',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
//             _buildStatsGrid(),
           
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTimeFilterButton(String label) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 5),
//       child: InkWell(
//         onTap: () {
//           setState(() {
//             selectedTimeFilter = label;
//           });
//         },
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: selectedTimeFilter == label ? Colors.grey[400] : Colors.grey[300],
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: selectedTimeFilter == label ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsGrid() {
//     return GridView.count(
//       shrinkWrap: true,
//       crossAxisCount: 3,
//       crossAxisSpacing: 10,
//       mainAxisSpacing: 10,
//       childAspectRatio: 1.5,
//       children: [
//         StatCard(title: "Patients", value: "$patientCount", icon: FontAwesomeIcons.users, borderColor: Colors.green),
//         StatCard(title: "Doctors", value: "$doctorCount", icon: FontAwesomeIcons.userDoctor, borderColor: Colors.purple),
//         StatCard(title: "InterPreters", value: "$companiesCount", icon: FontAwesomeIcons.building, borderColor: Colors.amber),
//         StatCard(title: "Appointments", value: "$appointmentCount", icon: FontAwesomeIcons.calendarCheck, borderColor: Colors.teal),
//         StatCard(title: "Services", value: "$serviceCount", icon: FontAwesomeIcons.conciergeBell, borderColor: Colors.blue),
//         StatCard(title: "Completed Appointments", value: "$completedAppointments", icon: FontAwesomeIcons.check, borderColor: Colors.green),
//       ],
//     );
//   }

  
// }


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widget/stat_card.dart';
import 'widget/top_nav_bar_widget.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedTimeFilter = "30 days";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int patientCount = 0;
  int doctorCount = 0;
  int serviceCount = 0;
  int appointmentCount = 0;
  int completedAppointments = 0;
  int companiesCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      var patientsSnapshot = await _firestore.collection('patients').get();
      var doctorsSnapshot = await _firestore.collection('providers').get();
      var servicesSnapshot = await _firestore.collection('services').get();
      var appointmentsSnapshot = await _firestore.collection('appointments').get();
      var completedAppointmentsSnapshot = await _firestore
          .collection('appointments')
          .where('status', isEqualTo: 'completed')
          .get();
      var companiesSnapshot = await _firestore.collection('interpreterProfiles').get();

      setState(() {
        patientCount = patientsSnapshot.docs.length;
        doctorCount = doctorsSnapshot.docs.length;
        serviceCount = servicesSnapshot.docs.length;
        appointmentCount = appointmentsSnapshot.docs.length;
        completedAppointments = completedAppointmentsSnapshot.docs.length;
        companiesCount = companiesSnapshot.docs.length;
      });
    } catch (e) {
      print("Error fetching stats: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: TopNavBar(),
      ),
      body: SingleChildScrollView( // ✅ Fix overflow by enabling scrolling
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        _buildTimeFilterButton("30 days"),
                        _buildTimeFilterButton("60 days"),
                        _buildTimeFilterButton("90 days"),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.refresh, color: Colors.black),
                          onPressed: _fetchStats,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(thickness: 1, color: Colors.grey[300]),
              Text(
                'General Statistics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              
              _buildStatsGrid(), // ✅ Now properly scrollable
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFilterButton(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTimeFilter = label;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selectedTimeFilter == label ? Colors.grey[400] : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: selectedTimeFilter == label ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true, 
      physics: NeverScrollableScrollPhysics(), 
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        StatCard(title: "Patients", value: "$patientCount", icon: FontAwesomeIcons.users, borderColor: Colors.green),
        StatCard(title: "Doctors", value: "$doctorCount", icon: FontAwesomeIcons.userDoctor, borderColor: Colors.purple),
        StatCard(title: "InterPreters", value: "$companiesCount", icon: FontAwesomeIcons.building, borderColor: Colors.amber),
        StatCard(title: "Appointments", value: "$appointmentCount", icon: FontAwesomeIcons.calendarCheck, borderColor: Colors.teal),
        StatCard(title: "Services", value: "$serviceCount", icon: FontAwesomeIcons.conciergeBell, borderColor: Colors.blue),
        StatCard(title: "Completed Appointments", value: "$completedAppointments", icon: FontAwesomeIcons.check, borderColor: Colors.green),
      ],
    );
  }
}


