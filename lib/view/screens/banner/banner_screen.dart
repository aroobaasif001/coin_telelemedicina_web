// import 'package:coin_telelemedicina_web/widget/CustomText.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// import '../../../utils/AppTheme.dart';
// import '../../../widget/custom_appbar.dart';
// import '../dashboardScreen/widget/top_nav_bar_widget.dart';
// import 'addBannerScreen/add_banner_screen.dart';

// class BannersScreen extends StatefulWidget {
//   const BannersScreen({Key? key}) : super(key: key);

//   @override
//   _BannersScreenState createState() => _BannersScreenState();
// }

// class _BannersScreenState extends State<BannersScreen> {
//   List<Map<String, String>> banners = [
//     {
//       'title': 'Bienvenido a Telemedicina',
//       'description': 'Consulta con especialistas desde la comodidad de tu hogar',
//       'expiry': '31 dic 2025',
//       'order': 'Orden: 7',
//       'status': 'Active',
//     },
//     {
//       'title': 'Prevención COVID-19',
//       'description': 'Mantén la distancia social y usa mascarilla en lugares cerrados',
//       'expiry': '31 dic 2025',
//       'order': 'Orden: 2',
//       'status': 'Active',
//     },
//     {
//       'title': 'Salud Mental',
//       'description': 'Cuida tu salud mental. Consulta con nuestros especialistas',
//       'expiry': '31 dic 2025',
//       'order': 'Orden: 4',
//       'status': 'Active',
//     },
//     {
//       'title': 'Campaña de Vacunación',
//       'description': 'Mantén tus vacunas al día. ¡Protégete y protege a los demás!',
//       'expiry': '31 dic 2025',
//       'order': 'Orden: 5',
//       'status': 'Active',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//        appBar: PreferredSize(
//         preferredSize: Size.fromHeight(80),
//         child: TopNavBar(),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
            
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Banners",
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                   GestureDetector(
//                     onTap: () {
//                       Get.to(() => AddBannerScreen());
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                           color: AppTheme.primaryColor,
//                           borderRadius: BorderRadius.circular(12)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.add,
//                               color: Colors.white,
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             CustomText(
//                               text: 'New Banner',
//                               color: Colors.white,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//                             ),
//               ),
//             const SizedBox(height : 16),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 itemCount: banners.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, // 3 columns
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 0.85
//                 ),
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   final banner = banners[index];

//                   return Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Placeholder Image
//                         Container(
//                           height: 200,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
//                           ),
//                           child: const Center(
//                             child: Icon(Icons.image, size: 40, color: Colors.grey),
//                           ),
//                         ),

//                         // Banner Info
//                         Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 banner['title']!,
//                                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 banner['description']!,
//                                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 5),

//                               // Expiry Date and Status
//                               Row(
//                                 children: [
//                                   const Icon(Icons.calendar_today, size: 14),
//                                   const SizedBox(width: 4),
//                                   Text("Hasta: ${banner['expiry']!}", style: const TextStyle(fontSize: 12)),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),

//                               // Status & Order
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Chip(
//                                     label: Text(banner['status']!, style: const TextStyle(fontSize: 12)),
//                                     backgroundColor: Colors.green.shade300,
//                                   ),
//                                   Text(banner['order']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),

//                         // Action Buttons (Edit, Delete)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.edit, color: Colors.green, size: 18),
//                                 onPressed: () {
//                                   // Edit banner functionality
//                                 },
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.delete, color: Colors.red, size: 18),
//                                 onPressed: () {
//                                   // Delete banner functionality
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widget/custom_appbar.dart';
import '../dashboardScreen/widget/top_nav_bar_widget.dart';
import 'addBannerScreen/add_banner_screen.dart';

class BannersScreen extends StatefulWidget {
  const BannersScreen({Key? key}) : super(key: key);

  @override
  _BannersScreenState createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> banners = [];

  @override
  void initState() {
    super.initState();
    fetchBanners();  // Fetch the banners when the screen is loaded
  }

  // Function to fetch banners from Firebase Firestore
  Future<void> fetchBanners() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('banners').get();
      List<Map<String, dynamic>> fetchedBanners = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'description': doc['description'],
          'expiry': (doc['endDate'] as Timestamp).toDate(),
          'order': doc['order'].toString(),
          'status': doc['isActive'] ? 'Active' : 'Inactive',
        };
      }).toList();

      setState(() {
        banners = fetchedBanners;
      });
    } catch (e) {
      print('Error fetching banners: $e');
      Get.snackbar('Error', 'Failed to fetch banners');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: TopNavBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Banners", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AddBannerScreen());
                    },
                    child: Container(
                      decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 10),
                            CustomText(text: 'New Banner', color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: banners.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final banner = banners[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Placeholder Image
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          child: const Center(
                            child: Icon(Icons.image, size: 40, color: Colors.grey),
                          ),
                        ),
                        // Banner Info
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                banner['description'],
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              // Expiry Date and Status
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14),
                                  const SizedBox(width: 4),
                                  Text("Hasta: ${banner['expiry'].toLocal()}".split(' ')[0], style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 5),
                              // Status & Order
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    label: Text(banner['status'], style: const TextStyle(fontSize: 12)),
                                    backgroundColor: Colors.green.shade300,
                                  ),
                                  Text(banner['order'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Action Buttons (Edit, Delete)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.green, size: 18),
                                onPressed: () {
                                  // Edit banner functionality
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                onPressed: () {
                                  // Delete banner functionality
                                },
                              ),
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
    );
  }
}
