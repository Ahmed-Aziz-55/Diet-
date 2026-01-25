import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  DashboardScreen({required this.userId, Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        setState(() {
          _userData = doc.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Color(0xff1a1a1a),
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff1a1a1a),
      appBar: AppBar(
        title: Text(
          'Calorie Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xff444444),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Welcome, ${_userData?['username'] ?? 'User'}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Track your daily nutrition',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 30),

            // Daily Calories Card
            _buildCalorieCard(),
            SizedBox(height: 30),

            // Macronutrients Section
            Text(
              'Daily Macronutrients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            _buildMacroCard(),
            SizedBox(height: 30),

            // Progress Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildProgressCard(
                    title: 'Current Weight',
                    value: '${_userData?['weight']?.round() ?? 0} kg',
                    icon: Icons.monitor_weight,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: _buildProgressCard(
                    title: 'Target Weight',
                    value: '${_userData?['targetWeight']?.round() ?? 0} kg',
                    icon: Icons.flag,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.add,
                    label: 'Add Meal',
                    onTap: () {
                      // Navigate to add meal screen
                    },
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.track_changes,
                    label: 'Log Weight',
                    onTap: () {
                      // Navigate to weight log screen
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff444444),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Food Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieCard() {
    double dailyCalories = _userData?['dailyCalories']?.toDouble() ?? 0;
    String goal = _userData?['goal'] ?? 'maintain';

    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffFF8A00),
            Color(0xffFF5E00),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Calories',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    '${dailyCalories.round()}',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  goal == 'lose' ? Icons.trending_down :
                  goal == 'gain' ? Icons.trending_up : Icons.trending_flat,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          LinearProgressIndicator(
            value: 0.4, // You can calculate this from consumed calories
            backgroundColor: Colors.white.withOpacity(0.3),
            color: Colors.white,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 cal',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '${dailyCalories.round()} cal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard() {
    double protein = _userData?['protein']?.toDouble() ?? 0;
    double carbs = _userData?['carbs']?.toDouble() ?? 0;
    double fats = _userData?['fats']?.toDouble() ?? 0;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xff444444),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _buildMacroRow(
            label: 'Protein',
            value: '${protein.round()}g',
            progress: 0.3,
            color: Colors.blue,
          ),
          SizedBox(height: 15),
          _buildMacroRow(
            label: 'Carbs',
            value: '${carbs.round()}g',
            progress: 0.5,
            color: Colors.green,
          ),
          SizedBox(height: 15),
          _buildMacroRow(
            label: 'Fats',
            value: '${fats.round()}g',
            progress: 0.2,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow({
    required String label,
    required String value,
    required double progress,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withOpacity(0.1),
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildProgressCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xff444444),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff444444),
        padding: EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.orange, size: 30),
          SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}