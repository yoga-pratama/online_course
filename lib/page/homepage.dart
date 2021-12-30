import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:online_course/global.dart';
import 'package:online_course/models/registrasi.dart';
import 'package:online_course/page/detail_pendaftaran.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 0;
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

  List<Registrasi> registerData = [];

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() async {
    var box = await Hive.openBox('registerBox');

    box.values.toList().forEach((element) {
      setState(() {
        registerData.add(element);
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  void submitForm() async {
    final FormState? form = _formKey.currentState;

    setState(() {
      isLoading = true;
    });

    if (form!.validate()) {
      var box = await Hive.openBox('registerBox');
      var register = Registrasi()
        ..name = textName.text
        ..birth = textDateBirth.text
        ..address = textAddress.text
        ..email = textEmail.text
        ..telephone = textPhone.text
        ..courseName = dropdownValue;

      box.add(register);

      setState(() {
        isLoading = false;

        textName.text = "";
        textDateBirth.text = "";
        textAddress.text = "";
        textEmail.text = "";
        textPhone.text = "";
        dropdownValue = "Pilih Kelas Kursus";

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text("Berhasil menyimpan data"),
          ),
        );
      });
    }
  }

  Future refreshData() async {
    registerData.clear();
    await Future.delayed(const Duration(seconds: 2));

    var box = await Hive.openBox('registerBox');

    box.values.toList().forEach((element) {
      setState(() {
        registerData.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              "List Peserta Kursus",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text("Tarik untuk refresh data"),
          ),
          const SizedBox(
            height: 10,
          ),
          registerData.isEmpty == true
              ? Container()
              : Expanded(
                  child: RefreshIndicator(
                  color: Colors.red,
                  onRefresh: refreshData,
                  child: ListView.builder(
                      itemCount: registerData.length,
                      itemBuilder: (context, idx) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Card(
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => DetailPendaftaran(
                                            reg: registerData[idx],
                                          )),
                                );
                              },
                              leading: const Icon(
                                Icons.book,
                                color: Colors.blue,
                              ),
                              title: Text(
                                  "Kelas ${registerData[idx].courseName.toString().toUpperCase()}"),
                              subtitle: Text(
                                  "Nama ${registerData[idx].name!} ,Telp & Email : ${registerData[idx].telephone} - ${registerData[idx].email}"),
                              trailing: const Icon(Icons.arrow_right),
                            ),
                          ),
                        );
                      }),
                )),
        ],
      ),
      Form(
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
              Align(
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
              ),
            ],
          ),
        ),
      ),

      /*  Text(
      'Index 2: School',
      style: optionStyle,
    ), */
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(Global.appName),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Daftar',
          ),
          /* BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ), */
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
