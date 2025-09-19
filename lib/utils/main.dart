import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import '/providers/calorie_provider.dart';
import '/views/screens/main_dashboard.dart';
import '/views/screens/welcome/welcome_screen.dart';
import '/views/screens/add_food_screen.dart';
import '/views/screens/report_screen.dart';
import '/views/screens/profile_screen.dart';
import '/views/screens/meal_plan_screen.dart'; // New: For personalized meal plan
import '/views/screens/chatbot_screen.dart'; // New: For AI chatbot

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalorieProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FITGEN - Dinh Dưỡng AI Cá Nhân Hóa',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: primaryColor,
          scaffoldBackgroundColor: backgroundColor,
          textTheme: Theme.of(context).textTheme.apply(displayColor: textColor),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              padding: EdgeInsets.all(defaultPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: textFieldBorder,
            enabledBorder: textFieldBorder,
            focusedBorder: textFieldBorder,
          ),
        ),
        home: const WelcomeScreen(),
        onGenerateRoute: (settings) {
          Widget page;
          switch (settings.name) {
            case '/main-dashboard':
              page = const MainDashboard();
              break;
            case '/add-food':
              page = const AddFoodScreen();
              break;
            case '/report':
              page = const ReportScreen();
              break;
            case '/profile':
              page = const ProfileScreen();
              break;
            case '/meal-plan':
              page = const MealPlanScreen(mealData: {});
              break;
            case '/chatbot':
              page = const ChatbotScreen();
              break;
            default:
              page = const WelcomeScreen();
          }
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (_, animation, __, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        },
      ),
    );
  }
}
