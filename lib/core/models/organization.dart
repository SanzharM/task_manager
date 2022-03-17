class Organization {
  int? id;
  String? name;
  String? description;
  String? phone;
  String? email;

  Organization({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.email,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization();
  }
}
