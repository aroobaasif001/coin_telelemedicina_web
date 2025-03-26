class AppointmentModel {
  String? appointmentId;
  String userId;
  String service;
  String date;
  String time;
  String doctor;
  String providerNotes;
  String language;
  String status;
  bool isInterpreterNeeded;
  List<String> attachedFiles;
  String patientId;
  String patientName;
  String patientNotes;
  String patientPhotoUrl;
  String? providerId;
  String serviceId;
  String createdAt;
  String updatedAt;
  bool isRescheduled;
  String? callStartTime;
  String? callEndTime;
  String? cancellationReason;
  String? meetingId;
  String? meetingUrl;
  String? notes;
  String? agoraChannelId;

  AppointmentModel({
    this.appointmentId,
    this.agoraChannelId,
    required this.userId,
    required this.service,
    required this.date,
    required this.time,
    required this.doctor,
    required this.providerNotes,
    required this.language,
    required this.status,
    required this.isInterpreterNeeded,
    required this.attachedFiles,
    required this.patientId,
    required this.patientName,
    required this.patientNotes,
    required this.patientPhotoUrl,
    this.providerId,
    required this.serviceId,
    required this.createdAt,
    required this.updatedAt,
    required this.isRescheduled,
    this.callStartTime,
    this.callEndTime,
    this.cancellationReason,
    this.meetingId,
    this.meetingUrl,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'userId': userId,
      'service': service,
      'date': date,
      'time': time,
      'agoraChannelId' : agoraChannelId,
      'doctor': doctor,
      'providerNotes': providerNotes,
      'language': language,
      'status': status,
      'isInterpreterNeeded': isInterpreterNeeded,
      'attachedFiles': attachedFiles,
      'patientId': patientId,
      'patientName': patientName,
      'patientNotes': patientNotes,
      'patientPhotoUrl': patientPhotoUrl,
      'providerId': providerId,
      'serviceId': serviceId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isRescheduled': isRescheduled,
      'callStartTime': callStartTime,
      'callEndTime': callEndTime,
      'cancellationReason': cancellationReason,
      'meetingId': meetingId,
      'meetingUrl': meetingUrl,
      'notes': notes,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      appointmentId: map['appointmentId'],
      userId: map['userId'],
      service: map['service'],
      date: map['date'],
      time: map['time'],
      doctor: map['doctor'],
      providerNotes: map['providerNotes'],
      language: map['language'],
      agoraChannelId: map['agoraChannelId'],
      status: map['status'],
      isInterpreterNeeded: map['isInterpreterNeeded'],
      attachedFiles: List<String>.from(map['attachedFiles']),
      patientId: map['patientId'],
      patientName: map['patientName'],
      patientNotes: map['patientNotes'],
      patientPhotoUrl: map['patientPhotoUrl'],
      providerId: map['providerId'],
      serviceId: map['serviceId'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      isRescheduled: map['isRescheduled'],
      callStartTime: map['callStartTime'],
      callEndTime: map['callEndTime'],
      cancellationReason: map['cancellationReason'],
      meetingId: map['meetingId'],
      meetingUrl: map['meetingUrl'],
      notes: map['notes'],
    );
  }
}