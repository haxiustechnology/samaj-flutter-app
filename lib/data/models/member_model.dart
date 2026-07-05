class Member {
  final int id;
  final String firstName;
  final String? middleName;
  final String surname;
  final String? birthdate;
  final String gender;
  final int? age;
  final int? isDoingJob;
  final String? jobType;
  final String maritalStatus;
  final int villageId;
  final String? profileImage;
  final String? villageName;

  final String? sscSchool;
  final String? sscPercentage;
  final String? hscSchool;
  final String? hscPercentage;
  final String? bachelorDegree;
  final String? bachelorPercentage;
  final String? masterDegree;
  final String? masterPercentage;

  final String? mobile;
  final String? businessDetails;
  final String? jobPost;
  final String? otherEducation;

  Member({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.surname,
    this.birthdate,
    required this.gender,
    this.age,
    this.isDoingJob,
    this.jobType,
    required this.maritalStatus,
    required this.villageId,
    this.profileImage,
    this.villageName,
    this.sscSchool,
    this.sscPercentage,
    this.hscSchool,
    this.hscPercentage,
    this.bachelorDegree,
    this.bachelorPercentage,
    this.masterDegree,
    this.masterPercentage,
    this.mobile,
    this.businessDetails,
    this.jobPost,
    this.otherEducation,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'],
      surname: json['surname'] ?? '',
      birthdate: json['birthdate'],
      gender: json['gender'] ?? '',
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      isDoingJob: json['is_doing_job'] != null ? int.tryParse(json['is_doing_job'].toString()) : null,
      jobType: json['job_type'],
      maritalStatus: json['marital_status'] ?? '',
      villageId: json['village_id'] != null ? int.parse(json['village_id'].toString()) : 0,
      profileImage: json['profile_image'],
      villageName: json['village_name'],
      sscSchool: json['ssc_school'],
      sscPercentage: json['ssc_percentage']?.toString(),
      hscSchool: json['hsc_school'],
      hscPercentage: json['hsc_percentage']?.toString(),
      bachelorDegree: json['bachelor_degree'],
      bachelorPercentage: json['bachelor_percentage']?.toString(),
      masterDegree: json['master_degree'],
      masterPercentage: json['master_percentage']?.toString(),
      mobile: json['mobile'],
      businessDetails: json['business_details'],
      jobPost: json['job_post'],
      otherEducation: json['other_education'],
    );
  }
}
