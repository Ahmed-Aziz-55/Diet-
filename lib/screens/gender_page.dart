import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_screen.dart';

enum Gender { male, female }
enum Goal { lose, maintain, gain }
enum ActivityLevel { sedentary, light, moderate, active, veryActive }

class GenderPage extends StatefulWidget {
  final String userId;

  const GenderPage({required this.userId, super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  final PageController _controller = PageController();

  // User Data
  Gender? _selectedGender;
  DateTime? _selectedDate;
  Goal? _selectedGoal;
  ActivityLevel? _selectedActivityLevel;

  int currentPage = 0;
  final int totalPages = 7; // Updated to 7 pages

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

  // Calculate BMR (Basal Metabolic Rate)
  double _calculateBMR() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;
    int age = _calculateAge(_selectedDate ?? DateTime.now());

    if (_selectedGender == Gender.male) {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  // Calculate TDEE (Total Daily Energy Expenditure)
  double _calculateTDEE(double bmr) {
    double activityMultiplier = 1.2;

    switch (_selectedActivityLevel) {
      case ActivityLevel.sedentary:
        activityMultiplier = 1.2;
        break;
      case ActivityLevel.light:
        activityMultiplier = 1.375;
        break;
      case ActivityLevel.moderate:
        activityMultiplier = 1.55;
        break;
      case ActivityLevel.active:
        activityMultiplier = 1.725;
        break;
      case ActivityLevel.veryActive:
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }

    return bmr * activityMultiplier;
  }

  // Calculate Daily Calories based on Goal
  Map<String, dynamic> _calculateDailyCalories() {
    double bmr = _calculateBMR();
    double tdee = _calculateTDEE(bmr);

    double targetCalories = tdee;
    String description = 'Maintain Weight';

    if (_selectedGoal == Goal.lose) {
      targetCalories = tdee - 500; // 500 calorie deficit for weight loss
      description = 'Weight Loss (500 cal deficit)';
    } else if (_selectedGoal == Goal.gain) {
      targetCalories = tdee + 500; // 500 calorie surplus for weight gain
      description = 'Weight Gain (500 cal surplus)';
    }

    return {
      'bmr': bmr,
      'tdee': tdee,
      'dailyCalories': targetCalories,
      'goalDescription': description,
      'protein': (targetCalories * 0.3) / 4, // 30% from protein
      'carbs': (targetCalories * 0.5) / 4,   // 50% from carbs
      'fats': (targetCalories * 0.2) / 9,    // 20% from fats
    };
  }

  // Save ALL Data to Firestore
  Future<void> _saveAllDataToFirestore() async {
    try {
      Map<String, dynamic> calorieData = _calculateDailyCalories();

      await _firestore.collection('users').doc(widget.userId).update({
        'profileComplete': true,
        'gender': _selectedGender == Gender.male ? 'male' : 'female',
        'height': double.tryParse(_heightController.text),
        'weight': double.tryParse(_weightController.text),
        'birthDate': _selectedDate?.toIso8601String(),
        'age': _calculateAge(_selectedDate ?? DateTime.now()),
        'goal': _selectedGoal?.toString().split('.').last,
        'activityLevel': _selectedActivityLevel?.toString().split('.').last,
        'targetWeight': double.tryParse(_targetWeightController.text),
        ...calorieData,
        'lastUpdated': DateTime.now(),
      });

    } catch (e) {
      // Handle error cleanly or use a logger
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff444444),
      appBar: AppBar(
        title: Text('${currentPage + 1}/$totalPages'),
        centerTitle: false,
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
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    child: Image.asset('assets/gender.PNG'), // Add gender icon
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Select Your Gender',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Male Card
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender = Gender.male;
                          });
                        },
                        child: Container(
                          width: 150,
                          height: 200,
                          decoration: BoxDecoration(
                            color: _selectedGender == Gender.male
                                ? Colors.blue.withOpacity(0.3)
                                : Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedGender == Gender.male
                                  ? Colors.blue
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.male,
                                size: 80,
                                color: _selectedGender == Gender.male
                                    ? Colors.blue
                                    : Colors.white,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Male',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Female Card
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedGender = Gender.female;
                          });
                        },
                        child: Container(
                          width: 150,
                          height: 200,
                          decoration: BoxDecoration(
                            color: _selectedGender == Gender.female
                                ? Colors.pink.withOpacity(0.3)
                                : Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _selectedGender == Gender.female
                                  ? Colors.pink
                                  : Colors.grey,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.female,
                                size: 80,
                                color: _selectedGender == Gender.female
                                    ? Colors.pink
                                    : Colors.white,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Female',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // **PAGE 2: DATE OF BIRTH**
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/age.jpg'), // Add age icon
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Select Your Date of Birth',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'We use this to calculate your age',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Select Date of Birth'
                          : 'Selected: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_selectedDate != null)
                    Text(
                      'Age: ${_calculateAge(_selectedDate!)} years',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // **PAGE 3: HEIGHT**
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/height.PNG'), // Add height icon
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Enter Your Height',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'In centimeters (cm)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter height in cm',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.orange, width: 2),
                        ),
                        suffixText: 'cm',
                        suffixStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_heightController.text.isNotEmpty)
                    Text(
                      'Height: ${_heightController.text} cm',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // **PAGE 4: WEIGHT**
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/weight.png'), // Add weight icon
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Enter Your Weight',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'In kilograms (kg)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter weight in kg',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.orange, width: 2),
                        ),
                        suffixText: 'kg',
                        suffixStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 30),
                  if (_weightController.text.isNotEmpty)
                    Text(
                      'Weight: ${_weightController.text} kg',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // **PAGE 5: GOAL SELECTION**
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/goal.png'), // Add goal icon
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Select Your Goal',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Weight Loss Card
                  _buildGoalCard(
                    title: 'Weight Loss',
                    subtitle: 'Lose 0.5-1 kg per week',
                    icon: Icons.trending_down,
                    isSelected: _selectedGoal == Goal.lose,
                    onTap: () {
                      setState(() {
                        _selectedGoal = Goal.lose;
                      });
                    },
                  ),

                  SizedBox(height: 15),

                  // Weight Maintenance Card
                  _buildGoalCard(
                    title: 'Maintain Weight',
                    subtitle: 'Keep your current weight',
                    icon: Icons.trending_flat,
                    isSelected: _selectedGoal == Goal.maintain,
                    onTap: () {
                      setState(() {
                        _selectedGoal = Goal.maintain;
                      });
                    },
                  ),

                  SizedBox(height: 15),

                  // Weight Gain Card
                  _buildGoalCard(
                    title: 'Weight Gain',
                    subtitle: 'Gain 0.25-0.5 kg per week',
                    icon: Icons.trending_up,
                    isSelected: _selectedGoal == Goal.gain,
                    onTap: () {
                      setState(() {
                        _selectedGoal = Goal.gain;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // **PAGE 6: ACTIVITY LEVEL**
          Container(
            color: Color(0xff444444),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 130,
                    width: 150,
                    child: Image.asset('assets/activity.png'), // Add activity icon
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Activity Level',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'How active are you?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Activity Level Options
                  _buildActivityCard(
                    title: 'Sedentary',
                    subtitle: 'Little or no exercise',
                    isSelected: _selectedActivityLevel == ActivityLevel.sedentary,
                    onTap: () {
                      setState(() {
                        _selectedActivityLevel = ActivityLevel.sedentary;
                      });
                    },
                  ),

                  SizedBox(height: 15),

                  _buildActivityCard(
                    title: 'Lightly Active',
                    subtitle: 'Light exercise 1-3 days/week',
                    isSelected: _selectedActivityLevel == ActivityLevel.light,
                    onTap: () {
                      setState(() {
                        _selectedActivityLevel = ActivityLevel.light;
                      });
                    },
                  ),

                  SizedBox(height: 15),

                  _buildActivityCard(
                    title: 'Moderately Active',
                    subtitle: 'Moderate exercise 3-5 days/week',
                    isSelected: _selectedActivityLevel == ActivityLevel.moderate,
                    onTap: () {
                      setState(() {
                        _selectedActivityLevel = ActivityLevel.moderate;
                      });
                    },
                  ),

                  SizedBox(height: 15),

                  _buildActivityCard(
                    title: 'Very Active',
                    subtitle: 'Hard exercise 6-7 days/week',
                    isSelected: _selectedActivityLevel == ActivityLevel.active,
                    onTap: () {
                      setState(() {
                        _selectedActivityLevel = ActivityLevel.active;
                      });
                    },
                  ),

                  SizedBox(height: 15),

                  _buildActivityCard(
                    title: 'Extremely Active',
                    subtitle: 'Very hard exercise & physical job',
                    isSelected: _selectedActivityLevel == ActivityLevel.veryActive,
                    onTap: () {
                      setState(() {
                        _selectedActivityLevel = ActivityLevel.veryActive;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // **PAGE 7: TARGET WEIGHT & SUMMARY**
          SingleChildScrollView(
            child: Container(
              color: Color(0xff444444),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      child: Image.asset('assets/target.jpg'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Target Weight',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'What is your target weight?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _targetWeightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter target weight (kg)',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.orange, width: 2),
                          ),
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Summary Card
                    if (_selectedGoal != null)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Your Plan Summary',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Goal:', style: TextStyle(color: Colors.white70)),
                                Text(
                                  _selectedGoal == Goal.lose ? 'Weight Loss' :
                                  _selectedGoal == Goal.gain ? 'Weight Gain' : 'Maintain',
                                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Daily Calories:', style: TextStyle(color: Colors.white70)),
                                Text(
                                  '${_calculateDailyCalories()['dailyCalories'].round()} cal',
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Validation based on current page
          bool canProceed = true;
          switch (currentPage) {
            case 0:
              canProceed = _selectedGender != null;
              break;
            case 1:
              canProceed = _selectedDate != null;
              break;
            case 2:
              canProceed = _heightController.text.isNotEmpty &&
                  double.tryParse(_heightController.text) != null;
              break;
            case 3:
              canProceed = _weightController.text.isNotEmpty &&
                  double.tryParse(_weightController.text) != null;
              break;
            case 4:
              canProceed = _selectedGoal != null;
              break;
            case 5:
              canProceed = _selectedActivityLevel != null;
              break;
            case 6:
              canProceed = _targetWeightController.text.isNotEmpty &&
                  double.tryParse(_targetWeightController.text) != null;
              break;
          }

          if (!canProceed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please fill all required information'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (currentPage < totalPages - 1) {
            _controller.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          } else {
            // Save all data and go to dashboard
            await _saveAllDataToFirestore();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(userId: widget.userId),
              ),
            );
          }
        },
        backgroundColor: Colors.orange,
        child: Icon(
          currentPage < totalPages - 1 ? Icons.arrow_forward : Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.orange : Colors.white, size: 30),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: Colors.orange),
          ],
        ),
      ),
    );
  }
}