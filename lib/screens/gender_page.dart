import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this package

// Add at the top of your file
enum Gender { male, female }

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  // Controllers
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  final PageController _controller = PageController();

  // User Data
  Gender? _selectedGender;
  DateTime? _selectedDate;
  String? _username;

  int currentPage = 0;
  final int totalPages = 9;

  // Focus on user selection
  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;

  // Calculate Age
  int _calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // Save date when selected
      _saveData();
    }
  }

  // **SAVE DATA FUNCTION**
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save gender
    if (_selectedGender != null) {
      await prefs.setString('gender', _selectedGender.toString());
    }

    // Save height
    if (_heightController.text.isNotEmpty) {
      await prefs.setDouble('height', double.parse(_heightController.text));
    }

    // Save weight
    if (_weightController.text.isNotEmpty) {
      await prefs.setDouble('weight', double.parse(_weightController.text));
    }

    // Save birth date
    if (_selectedDate != null) {
      await prefs.setString('birthDate', _selectedDate!.toIso8601String());
      await prefs.setInt('age', _calculateAge(_selectedDate!));
    }

    // Save username
    if (_usernameController.text.isNotEmpty) {
      await prefs.setString('username', _usernameController.text);
    }

    print('Data saved successfully!');
  }

  // **LOAD DATA FUNCTION**
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load gender
    String? genderString = prefs.getString('gender');
    if (genderString != null) {
      if (genderString.contains('male')) {
        setState(() {
          _selectedGender = Gender.male;
          _isMaleSelected = true;
        });
      } else if (genderString.contains('female')) {
        setState(() {
          _selectedGender = Gender.female;
          _isFemaleSelected = true;
        });
      }
    }

    // Load height
    double? savedHeight = prefs.getDouble('height');
    if (savedHeight != null) {
      _heightController.text = savedHeight.toString();
    }

    // Load weight
    double? savedWeight = prefs.getDouble('weight');
    if (savedWeight != null) {
      _weightController.text = savedWeight.toString();
    }

    // Load birth date
    String? savedDate = prefs.getString('birthDate');
    if (savedDate != null) {
      setState(() {
        _selectedDate = DateTime.parse(savedDate);
      });
    }

    // Load username
    String? savedUsername = prefs.getString('username');
    if (savedUsername != null) {
      _usernameController.text = savedUsername;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData(); // Load saved data when page starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff444444),
      appBar: AppBar(
        title: Text('${currentPage + 1}/$totalPages'),
        centerTitle: false,
        actions: [
          // Add a save button in app bar
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveData,
            tooltip: 'Save All Data',
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });
        },
        children: [
          // **PAGE 1: GENDER SELECTION**
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select Your Gender',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Female Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = Gender.female;
                          _isFemaleSelected = true;
                          _isMaleSelected = false;
                        });
                        _saveData(); // Save immediately on selection
                      },
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          color: _isFemaleSelected
                              ? Colors.orange.withOpacity(0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isFemaleSelected
                                ? Colors.orange
                                : Colors.grey,
                            width: 3,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.asset('assets/female.jpg'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Female',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    // Male Option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedGender = Gender.male;
                          _isMaleSelected = true;
                          _isFemaleSelected = false;
                        });
                        _saveData(); // Save immediately on selection
                      },
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          color: _isMaleSelected
                              ? Colors.orange.withOpacity(0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _isMaleSelected
                                ? Colors.orange
                                : Colors.grey,
                            width: 3,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.asset('assets/man.png'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Male',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_selectedGender != null)
                  Text(
                    'Selected: ${_selectedGender == Gender.male ? 'Male' : 'Female'}',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          // **PAGE 2: HEIGHT**
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/scale.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Height',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Please enter your height in centimeters',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter your height (cm)',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.orange, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.save, color: Colors.orange),
                          onPressed: _saveData,
                          tooltip: 'Save Height',
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        // Auto-save when user types (optional)
                        if (value.isNotEmpty && double.tryParse(value) != null) {
                          Future.delayed(Duration(seconds: 1), _saveData);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // **PAGE 3: WEIGHT**
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/weight.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Weight',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Please enter your weight in kilograms',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter your weight (kg)',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.orange, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.save, color: Colors.orange),
                          onPressed: _saveData,
                          tooltip: 'Save Weight',
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        if (value.isNotEmpty && double.tryParse(value) != null) {
                          Future.delayed(Duration(seconds: 1), _saveData);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // **PAGE 4: AGE/BIRTH DATE**
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/cake.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your age helps us calculate your daily calorie needs accurately',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Select Birth Date'
                          : 'Selected: ${DateFormat('dd-MMM-yyyy').format(_selectedDate!)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_selectedDate != null)
                    Column(
                      children: [
                        Text(
                          'Age: ${_calculateAge(_selectedDate!)} years',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _saveData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text('Save Age Data'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // **PAGE 5: USERNAME**
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/name.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Enter Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This will be your display name in the app',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.orange, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.save, color: Colors.orange),
                          onPressed: _saveData,
                          tooltip: 'Save Username',
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          Future.delayed(Duration(seconds: 1), _saveData);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // **Floating Action Button for Next/Save**
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentPage < totalPages - 1) {
            _controller.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            // On last page, save and navigate to home
            _saveData().then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile saved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to home screen
              // Navigator.pushReplacement(context,
              //   MaterialPageRoute(builder: (context) => HomeScreen()));
            });
          }
        },
        backgroundColor: Colors.orange,
        child: Icon(
          currentPage < totalPages - 1 ? Icons.arrow_forward : Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _usernameController.dispose();
    _controller.dispose();
    super.dispose();
  }
}