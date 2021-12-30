import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:online_course/global.dart';
import 'package:online_course/models/registrasi.dart';

class DetailPendaftaran extends StatefulWidget {
  const DetailPendaftaran({Key? key, this.reg}) : super(key: key);

  final Registrasi? reg;

  @override
  _DetailPendaftaran createState() => _DetailPendaftaran();
}

class _DetailPendaftaran extends State<DetailPendaftaran> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  String dropdownValue = 'Pilih Kelas Kursus';

  TextEditingController textName = TextEditingController();
  TextEditingController textDateBirth = TextEditingController();
  TextEditingController textAddress = TextEditingController();
  TextEditingController textPhone = TextEditingController();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textCourseChoose = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      dropdownValue = widget.reg!.courseName!;
      textCourseChoose.text = widget.reg!.courseName!;

      textDateBirth.text = widget.reg!.birth!;
      textName.text = widget.reg!.name!;
      textAddress.text = widget.reg!.address!;
      textPhone.text = widget.reg!.telephone!;
      textEmail.text = widget.reg!.email!;
    });
  }

  submitForm(String type) async {
    final FormState? form = _formKey.currentState;

    setState(() {
      isLoading = true;
    });

    switch (type) {
      case "u":
        if (form!.validate()) {
          var box = await Hive.openBox('registerBox');

          box.getAt((widget.reg!.key));

          widget.reg!.name = textName.text;
          widget.reg!.birth = textDateBirth.text;
          widget.reg!.address = textAddress.text;
          widget.reg!.email = textEmail.text;
          widget.reg!.telephone = textPhone.text;
          widget.reg!.courseName = dropdownValue;

          widget.reg!.save();

          setState(() {
            isLoading = false;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 5),
                content: Text("Berhasil update data"),
              ),
            );
          });
        }
        break;

      case "d":
        var box = await Hive.openBox('registerBox');
        box.delete(widget.reg!.key);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text("Data berhasil di hapus"),
          ),
        );

        Navigator.pop(context, true);
        break;
      default:
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        /*  firstDate: DateTime(2015, 8), */
        /* firstDate: DateTime.now().subtract(const Duration(days: 0)), */
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        textDateBirth.text = selectedDate.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Detail Pendaftaran Kursus"),
      ),
      body: Form(
        key: _formKey,
        child: Card(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Daftar Kursus",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(color: Colors.black),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: textName,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      hintText: 'Nama Lengkap',
                      labelText: 'Nama Lengkap',
                    ),
                    validator: (val) {
                      return val != null && val != ""
                          ? null
                          : 'Isi Nama lengkap';
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: textDateBirth,
                    keyboardType: TextInputType.none,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.blue,
                      ),
                      hintText: 'Tanggal Lahir',
                      labelText: 'Tanggal Lahir',
                    ),
                    onTap: () => _selectDate(context),
                    validator: (val) {
                      return val != null && val != ""
                          ? null
                          : 'Isi Tanggal Lahir';
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: textAddress,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.home,
                        color: Colors.blue,
                      ),
                      hintText: 'Alamat',
                      labelText: 'Alamat',
                    ),
                    validator: (val) {
                      return val != null && val != "" ? null : 'Isi Alamat';
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: textPhone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.phone_android,
                        color: Colors.blue,
                      ),
                      hintText: 'Telepon',
                      labelText: 'Telepon',
                    ),
                    validator: (val) {
                      return val != null && val != "" ? null : 'Isi No Telepon';
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: textEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.mail,
                        color: Colors.blue,
                      ),
                      hintText: 'Email',
                      labelText: 'Email',
                    ),
                    validator: (val) {
                      return val != null && val != "" ? null : 'Isi Email';
                    },
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  validator: (val) {
                    return val == "Pilih Kelas Kursus"
                        ? 'Isi Pilihan Kursus'
                        : null;
                  },
                  style: const TextStyle(color: Colors.black),
                  /*  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ), */
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: Global.courseName
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.blue),
                          onPressed: isLoading == true
                              ? null
                              : () {
                                  submitForm("u");
                                },
                          child: const Text('Update'))),
                  Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: isLoading == true
                              ? null
                              : () {
                                  submitForm("d");
                                },
                          child: const Text('Delete'))),
                ],
              ),
              /*  Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16.0),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
                        onPressed: isLoading == true ? null : submitForm,
                        child: const Text('Simpan'))),
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
