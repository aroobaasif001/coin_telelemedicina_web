// import 'package:flutter/material.dart';
// import 'package:coin_telelemedicina_web/model/interpreter_model.dart';

// import '../../../utils/AppTheme.dart';

// class InterpreterDetailScreen extends StatelessWidget {
//   final InterpreterModel interpreter;

//   InterpreterDetailScreen({required this.interpreter});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        appBar: AppBar(
//         centerTitle: true,
//         title: Text(interpreter.fullName,style: TextStyle(color: Colors.white),),backgroundColor:AppTheme.primaryColor),

   
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: interpreter.photoUrl.isNotEmpty
//                   ? NetworkImage(interpreter.photoUrl)
//                   : AssetImage('assets/img.png') as ImageProvider,
//             ),
//             SizedBox(height: 16),
//             Text("Full Name: ${interpreter.fullName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("Education: ${interpreter.education}"),
//             Text("Experience: ${interpreter.experience} years"),
//             Text("Languages: ${interpreter.languages.join(', ')}"),
//             Text("Interpreter Types: ${interpreter.interpreterTypes.join(', ')}"),
//             Text("Rating: ${interpreter.rating}"),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:coin_telelemedicina_web/model/interpreter_model.dart';
import '../../../utils/AppTheme.dart';

class InterpreterDetailScreen extends StatelessWidget {
  final InterpreterModel interpreter;

  InterpreterDetailScreen({required this.interpreter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          interpreter.fullName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: interpreter.photoUrl.isNotEmpty
                    ? NetworkImage(interpreter.photoUrl)
                    : AssetImage('assets/img.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 16),

            // Full Name
            Text(
              interpreter.fullName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Divider(thickness: 1, height: 24),

            // Details Card
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
                    _buildDetailRow(Icons.person, "Full Name", interpreter.fullName),
                    _buildDetailRow(Icons.school, "Education", interpreter.education),
                    _buildDetailRow(Icons.timer, "Experience", "${interpreter.experience} years"),
                    _buildDetailRow(Icons.language, "Languages", interpreter.languages.join(', ')),
                    _buildDetailRow(Icons.translate, "Interpreter Types", interpreter.interpreterTypes.join(', ')),
                    _buildDetailRow(Icons.star, "Rating", "${interpreter.rating} ⭐"),
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

