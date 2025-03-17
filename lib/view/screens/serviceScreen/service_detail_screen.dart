// import 'package:flutter/material.dart';
// import 'package:coin_telelemedicina_web/model/service_model.dart';

// class ServiceDetailScreen extends StatelessWidget {
//   final ServiceModel service;

//   ServiceDetailScreen({required this.service});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(service.name)),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: service.icon.isNotEmpty
//                   ? NetworkImage(service.icon)
//                   : AssetImage('assets/default_service.png') as ImageProvider,
//             ),
//             SizedBox(height: 16),
//             Text("Name: ${service.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("Description: ${service.description}"),
//             Text("Duration: ${service.duration} mins"),
//             Text("Price: \$${service.price}"),
//             Text("Requires Interpreter: ${service.requiresInterpreter ? 'Yes' : 'No'}"),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/model/service_model.dart';

import '../../../utils/AppTheme.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;

  ServiceDetailScreen({required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        centerTitle: true,
        title: Text(service.name,style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Service Icon
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: service.icon.isNotEmpty
                  ? NetworkImage(service.icon)
                  : AssetImage('assets/default_service.png') as ImageProvider,
            ),
            SizedBox(height: 16),

            // Service Name
            Text(
              service.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(thickness: 1, height: 24),

            // Service Details in a Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.description, "Description", service.description),
                    _buildDetailRow(Icons.timer, "Duration", "${service.duration} mins"),
                    _buildDetailRow(Icons.monetization_on, "Price", "\$${service.price}"),
                    _buildDetailRow(Icons.language, "Requires Interpreter", service.requiresInterpreter ? "Yes" : "No"),
                    if (service.requiresInterpreter && service.supportedInterpreterTypes.isNotEmpty)
                      _buildDetailRow(Icons.translate, "Supported Interpreter Types", service.supportedInterpreterTypes.join(', ')),
                  ],
                ),
              ),
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

