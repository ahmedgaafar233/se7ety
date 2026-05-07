class AppointmentModel {
  String? appointmentId;
  String? doctorId;
  String? doctorName;
  String? doctorImage;
  String? doctorSpecialization;
  String? doctorAddress;
  String? patientId;
  String? patientName;
  String? patientPhone;
  String? patientDescription;
  String? date;
  String? time;
  bool? isCompleted;

  AppointmentModel({
    this.appointmentId,
    this.doctorId,
    this.doctorName,
    this.doctorImage,
    this.doctorSpecialization,
    this.doctorAddress,
    this.patientId,
    this.patientName,
    this.patientPhone,
    this.patientDescription,
    this.date,
    this.time,
    this.isCompleted,
  });

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    doctorId = json['doctorId'];
    doctorName = json['doctorName'];
    doctorImage = json['doctorImage'];
    doctorSpecialization = json['doctorSpecialization'];
    doctorAddress = json['doctorAddress'];
    patientId = json['patientId'];
    patientName = json['patientName'];
    patientPhone = json['patientPhone'];
    patientDescription = json['patientDescription'];
    date = json['date'];
    time = json['time'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointmentId'] = appointmentId;
    data['doctorId'] = doctorId;
    data['doctorName'] = doctorName;
    data['doctorImage'] = doctorImage;
    data['doctorSpecialization'] = doctorSpecialization;
    data['doctorAddress'] = doctorAddress;
    data['patientId'] = patientId;
    data['patientName'] = patientName;
    data['patientPhone'] = patientPhone;
    data['patientDescription'] = patientDescription;
    data['date'] = date;
    data['time'] = time;
    data['isCompleted'] = isCompleted;
    return data;
  }
}
