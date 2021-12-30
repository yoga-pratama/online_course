import 'package:hive/hive.dart';

part 'registrasi.g.dart';

@HiveType(typeId: 0)
class Registrasi extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? birth;

  @HiveField(2)
  String? address;

  @HiveField(3)
  String? telephone;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? courseName;

  /*  Registrasi(this.address, this.name, this.birth, this.telephone, this.email,
      this.courseName); */
}
