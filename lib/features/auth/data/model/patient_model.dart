class PatientModel {
  String? uid;
  String? name;
  String? email;
  String? image;
  String? age;
  String? bio;
  String? city;
  String? gender;
  String? phone;

  PatientModel({
    this.uid,
    this.name,
    this.email,
    this.image,
    this.age,
    this.bio,
    this.city,
    this.gender,
    this.phone,
  });

  PatientModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    age = json['age'];
    bio = json['bio'];
    city = json['city'];
    gender = json['gender'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['age'] = age;
    data['bio'] = bio;
    data['city'] = city;
    data['gender'] = gender;
    data['phone'] = phone;
    return data;
  }
}
