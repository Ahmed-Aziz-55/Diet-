import 'package:diet/features/auth/presentation/auth_provider.dart';
import 'package:diet/features/home/presentation/dashboard_provider.dart';
import 'package:diet/features/diet/presentation/screens/diet_plans_screen.dart';
import 'package:diet/features/tracker/presentation/providers/tracker_provider.dart';
import 'package:diet/features/tracker/presentation/screens/meal_logger_screen.dart';
import 'package:diet/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  const DashboardScreen({required this.userId, super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).loadUserData(widget.userId);
      Provider.of<TrackerProvider>(context, listen: false).loadDailyLog(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Scaffold(
            backgroundColor: Color(0xff1a1a1a),
            body: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }

        final userData = provider.userData;
        
        return Scaffold(
          backgroundColor: Color(0xff1a1a1a),
          appBar: AppBar(
            title: Text(
              'Calorigram',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xff1f1f1f),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Consumer<TrackerProvider>(
              builder: (context, trackerProvider, child) {
                final dailyLog = trackerProvider.todayLog;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Text(
                      'Welcome, ${userData?['username'] ?? 'User'}!',
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

                    // Daily Calories Card (Using Tracker Data)
                    _buildCalorieCard(userData, dailyLog),
                    SizedBox(height: 30),

                    // Macronutrients Section (Using Tracker Data)
                    Text(
                      'Daily Macronutrients',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 15),
                    _buildMacroCard(userData, dailyLog),
                    SizedBox(height: 30),

                    // Progress Section (Using User Data)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildProgressCard(
                            title: 'Current Weight',
                            value: '${userData?['weight']?.round() ?? 0} kg',
                            icon: Icons.monitor_weight,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildProgressCard(
                            title: 'Target Weight',
                            value: '${userData?['targetWeight']?.round() ?? 0} kg',
                            icon: Icons.flag,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

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
                              Navigator.push(context, MaterialPageRoute(builder: (_) => MealLoggerScreen()));
                            },
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.restaurant_menu,
                            label: 'Diet Plans',
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => DietPlansScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(0xff1f1f1f),
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
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
    );
  }

  Widget _buildCalorieCard(Map<String, dynamic>? userData, dynamic dailyLog) {
    double targetCalories = userData?['dailyCalories']?.toDouble() ?? 2000;
    String goal = userData?['goal'] ?? 'maintain';
    
    int consumedCalories = dailyLog?.totalCalories ?? 0;
    double progress = targetCalories > 0 ? (consumedCalories / targetCalories) : 0.0;
    if (progress > 1.0) progress = 1.0;

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
            color: Colors.orange.withValues(alpha: 0.3),
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
                    'Calories Left',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  Text(
                    '${(targetCalories - consumedCalories).round()}',
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
                  color: Colors.white.withValues(alpha: 0.2),
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
            value: progress, 
            backgroundColor: Colors.white.withValues(alpha: 0.3),
            color: Colors.white,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Consumed: $consumedCalories',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Text(
                'Target: ${targetCalories.round()}',
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

  Widget _buildMacroCard(Map<String, dynamic>? userData, dynamic dailyLog) {
    double targetProtein = userData?['protein']?.toDouble() ?? 100;
    double targetCarbs = userData?['carbs']?.toDouble() ?? 250;
    double targetFats = userData?['fats']?.toDouble() ?? 70;
    
    int consumedProtein = dailyLog?.totalProtein ?? 0;
    int consumedCarbs = dailyLog?.totalCarbs ?? 0;
    int consumedFats = dailyLog?.totalFats ?? 0;

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
            value: '$consumedProtein / ${targetProtein.round()}g',
            progress: targetProtein > 0 ? (consumedProtein / targetProtein).clamp(0.0, 1.0) : 0,
            color: Colors.blue,
          ),
          SizedBox(height: 15),
          _buildMacroRow(
            label: 'Carbs',
            value: '$consumedCarbs / ${targetCarbs.round()}g',
            progress: targetCarbs > 0 ? (consumedCarbs / targetCarbs).clamp(0.0, 1.0) : 0,
            color: Colors.green,
          ),
          SizedBox(height: 15),
          _buildMacroRow(
            label: 'Fats',
            value: '$consumedFats / ${targetFats.round()}g',
            progress: targetFats > 0 ? (consumedFats / targetFats).clamp(0.0, 1.0) : 0,
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
          backgroundColor: Colors.white.withValues(alpha: 0.1),
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
                  color: color.withValues(alpha: 0.2),
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
