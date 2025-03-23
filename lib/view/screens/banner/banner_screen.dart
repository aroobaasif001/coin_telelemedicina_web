import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
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
    fetchBanners();
  }

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
          'status': doc['isActive'] ? 'active'.tr : 'inactive'.tr, // Use translation key
        };
      }).toList();

      setState(() {
        banners = fetchedBanners;
      });
    } catch (e) {
      print('Error fetching banners: $e');
      Get.snackbar('error'.tr, 'failed_to_fetch_banners'.tr); // Use translation key
    }
  }

  Future<void> deleteBanner(String id) async {
    try {
      await _firestore.collection('banners').doc(id).delete();
      Get.snackbar('success'.tr, 'banner_deleted_successfully'.tr); // Use translation key
      fetchBanners();
    } catch (e) {
      print('Error deleting banner: $e');
      Get.snackbar('error'.tr, 'failed_to_delete_banner'.tr); // Use translation key
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: TopNavBar(),
      ),
      body: CustomContainer(
        conColor: Colors.white,
        margin: EdgeInsets.all(10),
        borderRadius: BorderRadius.circular(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('banners'.tr, // Use translation key
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => MainLayout(child: AddBannerScreen()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 10),
                              CustomText(text: 'new_banner'.tr, color: Colors.white), // Use translation key
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 800 ? 3 : 1;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: banners.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
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
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 14),
                                        const SizedBox(width: 4),
                                        Text("${'expiry'.tr}: ${banner['expiry'].toLocal()}".split(' ')[0], // Use translation key
                                            style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Chip(
                                          label: Text(banner['status'], style: const TextStyle(fontSize: 12)),
                                          backgroundColor: banner['status'] == 'active'.tr // Use translation key
                                              ? Colors.green.shade300
                                              : Colors.red.shade300,
                                        ),
                                        Text(banner['order'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.green, size: 18),
                                      onPressed: () {
                                        Get.to(() => MainLayout(child: AddBannerScreen()));
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                                      onPressed: () => deleteBanner(banner['id']),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}