import 'package:diet/features/auth/presentation/auth_provider.dart';
import 'package:diet/features/tracker/presentation/providers/tracker_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../diet/data/models/meal_model.dart';

class MealLoggerScreen extends StatefulWidget {
  @override
  _MealLoggerScreenState createState() => _MealLoggerScreenState();
}

class _MealLoggerScreenState extends State<MealLoggerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  String _selectedType = 'snack';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1a1a1a),
      appBar: AppBar(
        title: Text('Log Meal', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff1f1f1f),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               Text(
                'Add New Meal',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              
              _buildTextField(_nameController, "Meal Name", Icons.fastfood),
              SizedBox(height: 15),
              _buildTextField(_caloriesController, "Calories", Icons.local_fire_department, isNumber: true),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildTextField(_proteinController, "Protein (g)", Icons.fitness_center, isNumber: true)),
                  SizedBox(width: 10),
                  Expanded(child: _buildTextField(_carbsController, "Carbs (g)", Icons.rice_bowl, isNumber: true)),
                  SizedBox(width: 10),
                  Expanded(child: _buildTextField(_fatsController, "Fats (g)", Icons.opacity, isNumber: true)),
                ],
              ),
              SizedBox(height: 20),
              
              // Type Selector
              DropdownButtonFormField<String>(
                value: _selectedType,
                dropdownColor: Color(0xff2d2d2d),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Meal Type",
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Color(0xff2d2d2d),
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: ['breakfast', 'lunch', 'dinner', 'snack']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
              
              SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: _saveMeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: context.watch<TrackerProvider>().isLoading 
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Add Meal', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.orange),
        filled: true,
        fillColor: Color(0xff2d2d2d),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        return null;
      },
    );
  }

  void _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;
     
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user == null) return;

    final meal = MealModel(
      id: Uuid().v4(),
      name: _nameController.text,
      calories: int.parse(_caloriesController.text),
      protein: int.parse(_proteinController.text),
      carbs: int.parse(_carbsController.text),
      fats: int.parse(_fatsController.text),
      type: _selectedType,
      description: '',
    );

    final success = await Provider.of<TrackerProvider>(context, listen: false).addMeal(user.uid, meal);

    if (success) {
      if (mounted) Navigator.pop(context);
    } else {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add meal')));
    }
  }
}
