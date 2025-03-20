import 'package:coin_telelemedicina_web/widget/CustomText.dart';
import 'package:flutter/material.dart';

import '../../../widget/custom_appbar.dart';

class BannersScreen extends StatefulWidget {
  const BannersScreen({Key? key}) : super(key: key);

  @override
  _BannersScreenState createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {
  List<Map<String, String>> banners = [
    {
      'title': 'Bienvenido a Telemedicina',
      'description': 'Consulta con especialistas desde la comodidad de tu hogar',
      'expiry': '31 dic 2025',
      'order': 'Orden: 7',
      'status': 'Active',
    },
    {
      'title': 'Prevención COVID-19',
      'description': 'Mantén la distancia social y usa mascarilla en lugares cerrados',
      'expiry': '31 dic 2025',
      'order': 'Orden: 2',
      'status': 'Active',
    },
    {
      'title': 'Salud Mental',
      'description': 'Cuida tu salud mental. Consulta con nuestros especialistas',
      'expiry': '31 dic 2025',
      'order': 'Orden: 4',
      'status': 'Active',
    },
    {
      'title': 'Campaña de Vacunación',
      'description': 'Mantén tus vacunas al día. ¡Protégete y protege a los demás!',
      'expiry': '31 dic 2025',
      'order': 'Orden: 5',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppbar(title: 'Gestión de Banners',),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              CustomText(text: 'Gestión de Banners'),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Nuevo Banner", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    // Add new banner functionality
                  },
                ),
              ],
            ),
            const SizedBox(height : 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: banners.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85
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
                                banner['title']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                banner['description']!,
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
                                  Text("Hasta: ${banner['expiry']!}", style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 5),

                              // Status & Order
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Chip(
                                    label: Text(banner['status']!, style: const TextStyle(fontSize: 12)),
                                    backgroundColor: Colors.green.shade300,
                                  ),
                                  Text(banner['order']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
