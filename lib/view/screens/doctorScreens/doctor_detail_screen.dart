// import 'package:flutter/material.dart';
// import 'package:coin_telelemedicina_web/model/provider_model.dart';

// import '../../../utils/AppTheme.dart';

// class DoctorDetailScreen extends StatelessWidget {
//   final ProviderModel doctor;

//   DoctorDetailScreen({required this.doctor});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(doctor.fullName,style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: doctor.photoUrl.isNotEmpty
//                   ? NetworkImage(doctor.photoUrl)
//                   : AssetImage('assets/img.png') as ImageProvider,
//             ),
//             SizedBox(height: 16),
//             Text("Full Name: ${doctor.fullName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("Specialty: ${doctor.specialty}"),
//             Text("Experience: ${doctor.experience} years"),
//             Text("Biography: ${doctor.biography}"),
//             Text("Education: ${doctor.education}"),
//             Text("Languages: ${doctor.languages.join(', ')}"),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:coin_telelemedicina_web/widget/custom_appbar.dart';
import 'package:coin_telelemedicina_web/widget/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/model/provider_model.dart';
import '../../../utils/AppTheme.dart';

class DoctorDetailScreen extends StatelessWidget {
  final ProviderModel doctor;

  DoctorDetailScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            CustomAppbar(isLeading: true,title: doctor.fullName,),
            Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  conColor: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Doctor Profile Image
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: doctor.photoUrl.isNotEmpty
                              ? NetworkImage(doctor.photoUrl)
                              : AssetImage('assets/img.png') as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Doctor Name
                      Text(
                        doctor.fullName,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomContainer(
                    conColor: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.person, "Full Name", doctor.fullName),
                        _buildDetailRow(Icons.medical_services, "Specialty", doctor.specialty),
                        _buildDetailRow(Icons.timer, "Experience", "${doctor.experience} years"),
                        _buildDetailRow(Icons.info_outline, "Biography", doctor.biography),
                        _buildDetailRow(Icons.school, "Education", doctor.education),
                        _buildDetailRow(Icons.language, "Languages", doctor.languages.join(', ')),
                        _buildDetailRow(Icons.star, "Rating", "${doctor.rating} ⭐ (${doctor.reviewCount} Reviews)"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(

        children: [
          Icon(icon, size: 24, color: Colors.blueGrey),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label: $value",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
