import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:coin_telelemedicina_web/model/appointment_model.dart';

class GetAllAppointment extends StatefulWidget {
  const GetAllAppointment({super.key});

  @override
  State<GetAllAppointment> createState() => _GetAllAppointmentState();
}

class _GetAllAppointmentState extends State<GetAllAppointment> with SingleTickerProviderStateMixin {
  String _selectedFilter = 'day';
  DateTime _selectedDate = DateTime.now();
  final List<String> _filterOptions = ['day', 'week', 'month', 'year'];
  final List<AppointmentModel> _appointments = [];
  String? _statusFilter;
  String? _languageFilter;
  bool? _interpreterFilter;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("All Appointments",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Patient', icon: Icon(Icons.person)),
            Tab(text: 'Doctor', icon: Icon(Icons.medical_services)),
            // Tab(text: 'Interpreter', icon: Icon(Icons.language)),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: Colors.white,
        ),
      ),
      body: Column(
        children: [
          _buildFilterCard(),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentsList(filterRole: 'patient'),
                _buildAppointmentsList(filterRole: 'doctor'),
                // _buildAppointmentsList(filterRole: 'interpreter'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard() {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Appointments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildFilterDropdown(),
                const SizedBox(width: 16),
                _buildDateSelector(),
              ],
            ),
            if (_hasActiveFilters()) _buildActiveFiltersChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          items: _filterOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value.capitalize(),
                style: TextStyle(color: Colors.grey[700]),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedFilter = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Flexible(
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        elevation: 0,
        child: InkWell(
          onTap: () {
            switch (_selectedFilter) {
              case 'day':
                _selectDate(context);
                break;
              case 'week':
                _selectWeek(context);
                break;
              case 'month':
                _selectMonth(context);
                break;
              case 'year':
                _selectYear(context);
                break;
            }
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 20, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  _getDateRangeText(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDateRangeText() {
    switch (_selectedFilter) {
      case 'day':
        return DateFormat('MMM dd, yyyy').format(_selectedDate);
      case 'week':
        return '${DateFormat('MMM dd').format(_getStartOfWeek())} - ${DateFormat('MMM dd, yyyy').format(_getEndOfWeek())}';
      case 'month':
        return DateFormat('MMMM yyyy').format(_selectedDate);
      case 'year':
        return DateFormat('yyyy').format(_selectedDate);
      default:
        return 'Select date';
    }
  }

  Widget _buildActiveFiltersChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_statusFilter != null)
            Chip(
              label: Text('Status: $_statusFilter'),
              backgroundColor: Colors.blue[50],
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => _removeFilter('status'),
            ),
          if (_languageFilter != null && _languageFilter!.isNotEmpty)
            Chip(
              label: Text('Language: $_languageFilter'),
              backgroundColor: Colors.green[50],
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => _removeFilter('language'),
            ),
          if (_interpreterFilter != null)
            Chip(
              label: const Text('Interpreter Needed'),
              backgroundColor: Colors.orange[50],
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => _removeFilter('interpreter'),
            ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _statusFilter != null ||
        (_languageFilter != null && _languageFilter!.isNotEmpty) ||
        _interpreterFilter != null;
  }

  Widget _buildAppointmentsList({required String filterRole}) {
    DateTime startDate;
    DateTime endDate;

    switch (_selectedFilter) {
      case 'day':
        startDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
        endDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day + 1);
        break;
      case 'week':
        startDate = _getStartOfWeek();
        endDate = _getEndOfWeek();
        break;
      case 'month':
        startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
        endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
        break;
      case 'year':
        startDate = DateTime(_selectedDate.year, 1, 1);
        endDate = DateTime(_selectedDate.year + 1, 1, 1);
        break;
      default:
        startDate = DateTime.now();
        endDate = DateTime.now().add(const Duration(days: 1));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(startDate))
          .where('date', isLessThan: DateFormat('yyyy-MM-dd').format(endDate))
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text(
                  'Error loading appointments',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No appointments found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        _appointments.clear();
        _appointments.addAll(
          snapshot.data!.docs
              .map((doc) => AppointmentModel.fromMap(doc.data() as Map<String, dynamic>))
              .where((appointment) => _filterAppointments(appointment) && _filterByRole(appointment, filterRole))
              .toList(),
        );

        if (_appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.filter_alt_off, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No matching appointments',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try changing your filter criteria',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: _appointments.length,
          itemBuilder: (context, index) {
            final appointment = _appointments[index];
            return _buildAppointmentCard(appointment);
          },
        );
      },
    );
  }

  bool _filterByRole(AppointmentModel appointment, String role) {
    switch (role) {
      case 'patient':
        return true; // Show all appointments for patients
      case 'doctor':
        return appointment.doctor.isNotEmpty; // Only show appointments with doctors assigned
      case 'interpreter':
        return appointment.isInterpreterNeeded; // Only show appointments needing interpreters
      default:
        return true;
    }
  }

  bool _filterAppointments(AppointmentModel appointment) {
    if (_statusFilter != null && appointment.status != _statusFilter) {
      return false;
    }
    if (_languageFilter != null &&
        _languageFilter!.isNotEmpty &&
        !appointment.language.toLowerCase().contains(_languageFilter!.toLowerCase())) {
      return false;
    }
    if (_interpreterFilter != null &&
        appointment.isInterpreterNeeded != _interpreterFilter) {
      return false;
    }
    return true;
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      appointment.service,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(appointment.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      appointment.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(appointment.status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${DateFormat('MMM dd, yyyy').format(DateTime.parse(appointment.date))} • ${appointment.time}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildDetailItem(Icons.person, appointment.patientName),
              if (appointment.doctor.isNotEmpty)
                _buildDetailItem(Icons.medical_services, appointment.doctor),
              if (appointment.isInterpreterNeeded && appointment.language.isNotEmpty)
                _buildDetailItem(Icons.language, appointment.language),
              if (appointment.agoraChannelId != null)
                _buildDetailItem(Icons.videocam, 'Video Call Ready'),
              if (appointment.attachedFiles.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Attachments:',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: appointment.attachedFiles
                          .map((file) => Chip(
                        label: Text(
                          file.split('/').last,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.grey[100],
                        visualDensity: VisualDensity.compact,
                      ))
                          .toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showAppointmentDetails(appointment),
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[800]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAppointmentDetails(AppointmentModel appointment) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  appointment.service,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Patient', appointment.patientName),
                if (appointment.doctor.isNotEmpty) _buildDetailRow('Doctor', appointment.doctor),
                _buildDetailRow('Date',
                    '${DateFormat('MMM dd, yyyy').format(DateTime.parse(appointment.date))} at ${appointment.time}'),
                _buildDetailRow('Status', appointment.status,
                    valueColor: _getStatusColor(appointment.status)),
                if (appointment.isInterpreterNeeded && appointment.language.isNotEmpty)
                  _buildDetailRow('Language', appointment.language),
                if (appointment.providerNotes.isNotEmpty)
                  _buildDetailRow('Provider Notes', appointment.providerNotes),
                if (appointment.patientNotes.isNotEmpty)
                  _buildDetailRow('Patient Notes', appointment.patientNotes),
                if (appointment.agoraChannelId != null)
                  _buildDetailRow('Agora Channel', appointment.agoraChannelId!),
                if (appointment.meetingUrl != null)
                  _buildDetailRow('Meeting URL', appointment.meetingUrl!),
                if (appointment.notes != null) _buildDetailRow('Notes', appointment.notes!),
                if (appointment.cancellationReason != null)
                  _buildDetailRow('Cancellation Reason', appointment.cancellationReason!),
                if (appointment.attachedFiles.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Attachments:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: appointment.attachedFiles
                            .map((file) => Chip(
                          label: Text(file.split('/').last),
                          onDeleted: () {},
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.grey[800],
              fontSize: 16,
            ),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  Future<void> _showAdvancedFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Advanced Filters'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      value: _statusFilter,
                      items: ['All', 'Scheduled', 'Confirmed', 'Completed', 'Cancelled']
                          .map((status) => DropdownMenuItem(
                        value: status == 'All' ? null : status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _statusFilter = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Language',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      initialValue: _languageFilter,
                      onChanged: (value) => _languageFilter = value,
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      title: const Text('Interpreter Needed'),
                      value: _interpreterFilter,
                      onChanged: (value) {
                        setState(() {
                          _interpreterFilter = value;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _resetFilters();
                  },
                  child: const Text('Reset'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _statusFilter = null;
      _languageFilter = null;
      _interpreterFilter = null;
    });
  }

  void _removeFilter(String filterType) {
    setState(() {
      switch (filterType) {
        case 'status':
          _statusFilter = null;
          break;
        case 'language':
          _languageFilter = null;
          break;
        case 'interpreter':
          _interpreterFilter = null;
          break;
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'confirmed':
        return Colors.blue;
      case 'pending':
      case 'scheduled':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectWeek(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  DateTime _getStartOfWeek() {
    return _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
  }

  DateTime _getEndOfWeek() {
    return _getStartOfWeek().add(const Duration(days: 6));
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}



///

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:coin_telelemedicina_web/model/appointment_model.dart';
//
// class GetAllAppointment extends StatefulWidget {
//   const GetAllAppointment({super.key});
//
//   @override
//   State<GetAllAppointment> createState() => _GetAllAppointmentState();
// }
//
// class _GetAllAppointmentState extends State<GetAllAppointment> {
//   String _selectedFilter = 'day';
//   DateTime _selectedDate = DateTime.now();
//   final List<String> _filterOptions = ['day', 'week', 'month', 'year'];
//   final List<AppointmentModel> _appointments = [];
//   String? _statusFilter;
//   String? _languageFilter;
//   bool? _interpreterFilter;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text("All Appointments",
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor:Colors.green,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_alt, color: Colors.white),
//             onPressed: _showAdvancedFilterDialog,
//             tooltip: 'Advanced Filters',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildFilterCard(),
//           const SizedBox(height: 8),
//           Expanded(
//             child: _buildAppointmentsList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFilterCard() {
//     return Card(
//       margin: const EdgeInsets.all(12),
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Filter Appointments',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[800],
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 _buildFilterDropdown(),
//                 const SizedBox(width: 16),
//                 _buildDateSelector(),
//               ],
//             ),
//             if (_hasActiveFilters()) _buildActiveFiltersChips(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFilterDropdown() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: _selectedFilter,
//           icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
//           items: _filterOptions.map((String value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(
//                 value.capitalize(),
//                 style: TextStyle(color: Colors.grey[700]),
//               ),
//             );
//           }).toList(),
//           onChanged: (String? newValue) {
//             setState(() {
//               _selectedFilter = newValue!;
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateSelector() {
//     return Flexible(
//       child: Material(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.white,
//         elevation: 0,
//         child: InkWell(
//           onTap: () {
//             switch (_selectedFilter) {
//               case 'day':
//                 _selectDate(context);
//                 break;
//               case 'week':
//                 _selectWeek(context);
//                 break;
//               case 'month':
//                 _selectMonth(context);
//                 break;
//               case 'year':
//                 _selectYear(context);
//                 break;
//             }
//           },
//           borderRadius: BorderRadius.circular(8),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey[300]!),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.calendar_today, size: 20, color: Colors.blue[700]),
//                 const SizedBox(width: 8),
//                 Text(
//                   _getDateRangeText(),
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[800],
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _getDateRangeText() {
//     switch (_selectedFilter) {
//       case 'day':
//         return DateFormat('MMM dd, yyyy').format(_selectedDate);
//       case 'week':
//         return '${DateFormat('MMM dd').format(_getStartOfWeek())} - ${DateFormat('MMM dd, yyyy').format(_getEndOfWeek())}';
//       case 'month':
//         return DateFormat('MMMM yyyy').format(_selectedDate);
//       case 'year':
//         return DateFormat('yyyy').format(_selectedDate);
//       default:
//         return 'Select date';
//     }
//   }
//
//   Widget _buildActiveFiltersChips() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: Wrap(
//         spacing: 8,
//         runSpacing: 8,
//         children: [
//           if (_statusFilter != null)
//             Chip(
//               label: Text('Status: $_statusFilter'),
//               backgroundColor: Colors.blue[50],
//               deleteIcon: const Icon(Icons.close, size: 16),
//               onDeleted: () => _removeFilter('status'),
//             ),
//           if (_languageFilter != null && _languageFilter!.isNotEmpty)
//             Chip(
//               label: Text('Language: $_languageFilter'),
//               backgroundColor: Colors.green[50],
//               deleteIcon: const Icon(Icons.close, size: 16),
//               onDeleted: () => _removeFilter('language'),
//             ),
//           if (_interpreterFilter != null)
//             Chip(
//               label: const Text('Interpreter Needed'),
//               backgroundColor: Colors.orange[50],
//               deleteIcon: const Icon(Icons.close, size: 16),
//               onDeleted: () => _removeFilter('interpreter'),
//             ),
//         ],
//       ),
//     );
//   }
//
//   bool _hasActiveFilters() {
//     return _statusFilter != null ||
//         (_languageFilter != null && _languageFilter!.isNotEmpty) ||
//         _interpreterFilter != null;
//   }
//
//   Widget _buildAppointmentsList() {
//     DateTime startDate;
//     DateTime endDate;
//
//     switch (_selectedFilter) {
//       case 'day':
//         startDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
//         endDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day + 1);
//         break;
//       case 'week':
//         startDate = _getStartOfWeek();
//         endDate = _getEndOfWeek();
//         break;
//       case 'month':
//         startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
//         endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
//         break;
//       case 'year':
//         startDate = DateTime(_selectedDate.year, 1, 1);
//         endDate = DateTime(_selectedDate.year + 1, 1, 1);
//         break;
//       default:
//         startDate = DateTime.now();
//         endDate = DateTime.now().add(const Duration(days: 1));
//     }
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('appointments')
//           .where('date', isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(startDate))
//           .where('date', isLessThan: DateFormat('yyyy-MM-dd').format(endDate))
//           .orderBy('date')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Error loading appointments',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey[700],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   snapshot.error.toString(),
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No appointments found',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey[700],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Try adjusting your filters',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         _appointments.clear();
//         _appointments.addAll(
//           snapshot.data!.docs
//               .map((doc) => AppointmentModel.fromMap(doc.data() as Map<String, dynamic>))
//               .where(_filterAppointments)
//               .toList(),
//         );
//
//         if (_appointments.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.filter_alt_off, size: 48, color: Colors.grey[400]),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No matching appointments',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey[700],
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Try changing your filter criteria',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           itemCount: _appointments.length,
//           itemBuilder: (context, index) {
//             final appointment = _appointments[index];
//             return _buildAppointmentCard(appointment);
//           },
//         );
//       },
//     );
//   }
//
//   bool _filterAppointments(AppointmentModel appointment) {
//     if (_statusFilter != null && appointment.status != _statusFilter) {
//       return false;
//     }
//     if (_languageFilter != null &&
//         _languageFilter!.isNotEmpty &&
//         !appointment.language.toLowerCase().contains(_languageFilter!.toLowerCase())) {
//       return false;
//     }
//     if (_interpreterFilter != null &&
//         appointment.isInterpreterNeeded != _interpreterFilter) {
//       return false;
//     }
//     return true;
//   }
//
//   Widget _buildAppointmentCard(AppointmentModel appointment) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {},
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       appointment.service,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _getStatusColor(appointment.status).withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       appointment.status.toUpperCase(),
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: _getStatusColor(appointment.status),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
//                   const SizedBox(width: 8),
//                   Text(
//                     '${DateFormat('MMM dd, yyyy').format(DateTime.parse(appointment.date))} • ${appointment.time}',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               _buildDetailItem(Icons.person, appointment.patientName),
//               if (appointment.doctor.isNotEmpty)
//                 _buildDetailItem(Icons.medical_services, appointment.doctor),
//               if (appointment.isInterpreterNeeded && appointment.language.isNotEmpty)
//                 _buildDetailItem(Icons.language, appointment.language),
//               if (appointment.agoraChannelId != null)
//                 _buildDetailItem(Icons.videocam, 'Video Call Ready'),
//               if (appointment.attachedFiles.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 8),
//                     Text(
//                       'Attachments:',
//                       style: TextStyle(
//                         color: Colors.grey[700],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Wrap(
//                       spacing: 8,
//                       children: appointment.attachedFiles
//                           .map((file) => Chip(
//                         label: Text(
//                           file.split('/').last,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                         backgroundColor: Colors.grey[100],
//                         visualDensity: VisualDensity.compact,
//                       ))
//                           .toList(),
//                     ),
//                   ],
//                 ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () => _showAppointmentDetails(appointment),
//                   child: const Text('View Details'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailItem(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: Colors.grey[600]),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(color: Colors.grey[800]),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _showAppointmentDetails(AppointmentModel appointment) async {
//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 spreadRadius: 5,
//               ),
//             ],
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   appointment.service,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildDetailRow('Patient', appointment.patientName),
//                 if (appointment.doctor.isNotEmpty) _buildDetailRow('Doctor', appointment.doctor),
//                 _buildDetailRow('Date',
//                     '${DateFormat('MMM dd, yyyy').format(DateTime.parse(appointment.date))} at ${appointment.time}'),
//                 _buildDetailRow('Status', appointment.status,
//                     valueColor: _getStatusColor(appointment.status)),
//                 if (appointment.isInterpreterNeeded && appointment.language.isNotEmpty)
//                   _buildDetailRow('Language', appointment.language),
//                 if (appointment.providerNotes.isNotEmpty)
//                   _buildDetailRow('Provider Notes', appointment.providerNotes),
//                 if (appointment.patientNotes.isNotEmpty)
//                   _buildDetailRow('Patient Notes', appointment.patientNotes),
//                 if (appointment.agoraChannelId != null)
//                   _buildDetailRow('Agora Channel', appointment.agoraChannelId!),
//                 if (appointment.meetingUrl != null)
//                   _buildDetailRow('Meeting URL', appointment.meetingUrl!),
//                 if (appointment.notes != null) _buildDetailRow('Notes', appointment.notes!),
//                 if (appointment.cancellationReason != null)
//                   _buildDetailRow('Cancellation Reason', appointment.cancellationReason!),
//                 if (appointment.attachedFiles.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Attachments:',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         children: appointment.attachedFiles
//                             .map((file) => Chip(
//                           label: Text(file.split('/').last),
//                           onDeleted: () {},
//                         ))
//                             .toList(),
//                       ),
//                     ],
//                   ),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text('Close'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: TextStyle(
//               color: valueColor ?? Colors.grey[800],
//               fontSize: 16,
//             ),
//           ),
//           const Divider(height: 16),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _showAdvancedFilterDialog() async {
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title: const Text('Advanced Filters'),
//               content: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         labelText: 'Status',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       value: _statusFilter,
//                       items: ['All', 'Scheduled', 'Confirmed', 'Completed', 'Cancelled']
//                           .map((status) => DropdownMenuItem(
//                         value: status == 'All' ? null : status,
//                         child: Text(status),
//                       ))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _statusFilter = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         labelText: 'Language',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       initialValue: _languageFilter,
//                       onChanged: (value) => _languageFilter = value,
//                     ),
//                     const SizedBox(height: 8),
//                     CheckboxListTile(
//                       title: const Text('Interpreter Needed'),
//                       value: _interpreterFilter,
//                       onChanged: (value) {
//                         setState(() {
//                           _interpreterFilter = value;
//                         });
//                       },
//                       controlAffinity: ListTileControlAffinity.leading,
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     _resetFilters();
//                   },
//                   child: const Text('Reset'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     setState(() {});
//                   },
//                   child: const Text('Apply'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _resetFilters() {
//     setState(() {
//       _statusFilter = null;
//       _languageFilter = null;
//       _interpreterFilter = null;
//     });
//   }
//
//   void _removeFilter(String filterType) {
//     setState(() {
//       switch (filterType) {
//         case 'status':
//           _statusFilter = null;
//           break;
//         case 'language':
//           _languageFilter = null;
//           break;
//         case 'interpreter':
//           _interpreterFilter = null;
//           break;
//       }
//     });
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'completed':
//         return Colors.green;
//       case 'confirmed':
//         return Colors.blue;
//       case 'pending':
//       case 'scheduled':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Colors.blue,
//               onPrimary: Colors.white,
//               onSurface: Colors.black,
//             ),
//             dialogBackgroundColor: Colors.white,
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   Future<void> _selectWeek(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   Future<void> _selectMonth(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       initialDatePickerMode: DatePickerMode.year,
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   Future<void> _selectYear(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//       initialDatePickerMode: DatePickerMode.year,
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   DateTime _getStartOfWeek() {
//     return _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
//   }
//
//   DateTime _getEndOfWeek() {
//     return _getStartOfWeek().add(const Duration(days: 6));
//   }
// }
//
// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
//   }
// }
//
//
//
