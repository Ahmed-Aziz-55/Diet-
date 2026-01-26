import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diet_provider.dart';
import '../../domain/entities/diet_plan.dart';

class DietPlansScreen extends StatefulWidget {
  @override
  _DietPlansScreenState createState() => _DietPlansScreenState();
}

class _DietPlansScreenState extends State<DietPlansScreen> {
  @override
  void initState() {
    super.initState();
    // Load plans when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DietProvider>(context, listen: false).loadDietPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1a1a1a),
      appBar: AppBar(
        title: Text('Diet Plans', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff1f1f1f),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Consumer<DietProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.orange));
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Text(
                provider.errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (provider.dietPlans.isEmpty) {
             return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.no_meals, size: 60, color: Colors.white38),
                  SizedBox(height: 10),
                  Text(
                    'No diet plans available yet.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: provider.dietPlans.length,
            itemBuilder: (context, index) {
              final plan = provider.dietPlans[index];
              return _buildDietPlanCard(plan);
            },
          );
        },
      ),
    );
  }

  Widget _buildDietPlanCard(DietPlan plan) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xff2d2d2d),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Image or Gradient
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  plan.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${plan.totalCalories} Calories',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Meals List
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.description,
                  style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 15),
                ...plan.meals.map((meal) => _buildMealRow(meal)).toList(),
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Select this plan logic explicitly if needed
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('View Details', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealRow(meal) { // using dynamic for quick access or explicit type
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.restaurant_menu, size: 16, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '${meal.type.toUpperCase()}: ${meal.name}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Text(
            '${meal.calories} cal',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
