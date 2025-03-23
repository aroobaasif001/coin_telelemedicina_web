import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../widget/CustomText.dart';

class AddBannerScreen extends StatefulWidget {
  @override
  _AddBannerScreenState createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for each input
  final TextEditingController actionUrlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController orderController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 30));
  bool isActive = true;

  // Function to save the banner to Firestore
  Future<void> saveBanner() async {
    try {
      await _firestore.collection('banners').add({
        'actionUrl': actionUrlController.text,
        'description': descriptionController.text,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'endDate': Timestamp.fromDate(endDate),
        'imageUrl': null, // You can store image URL if required later
        'isActive': isActive,
        'order': int.tryParse(orderController.text) ?? 1,
        'startDate': Timestamp.fromDate(startDate),
        'title': titleController.text,
        'type': typeController.text,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      Get.snackbar('Success'.tr, 'banner_added_successfully'.tr);
      clearFields(); // Clear the input fields after successful submission
    } catch (e) {
      print('Error saving banner: $e');
      Get.snackbar('Error'.tr, 'failed_to_add_banner'.tr);
    }
  }

  void clearFields() {
    actionUrlController.clear();
    descriptionController.clear();
    titleController.clear();
    typeController.clear();
    orderController.clear();
    setState(() {
      startDate = DateTime.now();
      endDate = DateTime.now().add(Duration(days: 30));
      isActive = true;
    });
  }

  // Date picker functions for start and end date
  Future<void> pickStartDate() async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ??
        startDate;
    setState(() {
      startDate = pickedDate;
    });
  }

  Future<void> pickEndDate() async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ??
        endDate;
    setState(() {
      endDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        title: Text("add_banner".tr,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("action_url".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              TextField(
                controller: actionUrlController,
                decoration: InputDecoration(
                  hintText: "enter_action_url".tr,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12),
              Text("description".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "enter_description".tr,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12),
              Text("start_date".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text("${startDate.toLocal()}".split(' ')[0],
                          style: TextStyle(fontSize: 14)),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: pickStartDate,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text("end_date".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text("${endDate.toLocal()}".split(' ')[0],
                          style: TextStyle(fontSize: 14)),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: pickEndDate,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text("title".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "enter_title".tr,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12),
              Text("type".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              TextField(
                controller: typeController,
                decoration: InputDecoration(
                  hintText: "enter_type".tr,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12),
              Text("order".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              TextField(
                controller: orderController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "enter_order".tr,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text("is_active".tr,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Switch(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: saveBanner,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: 'save_banner'.tr,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}