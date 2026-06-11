import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'providers/rsvp_provider.dart';
import 'providers/study_group_provider.dart';
import 'providers/user_provider.dart';
import 'providers/club_provider.dart';
import 'providers/opportunity_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/rsvp_confirmed_screen.dart';
import 'screens/my_rsvps_screen.dart';
import 'screens/study_groups_screen.dart';
import 'screens/community_hub_screen.dart';
import 'screens/create_opportunity_screen.dart';
import 'models/event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RsvpProvider()),
        ChangeNotifierProvider(create: (_) => StudyGroupProvider()..loadDummyGroups()),
        ChangeNotifierProvider(create: (_) => UserProvider()..load()),
        ChangeNotifierProvider(create: (_) => ClubProvider()..load()),
        ChangeNotifierProvider(create: (_) => OpportunityProvider()..load()),
      ],
      child: const ALUStrideApp(),
    ),
  );
}

class ALUStrideApp extends StatelessWidget {
  const ALUStrideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Stride',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.burgundy,
          secondary: AppColors.navy,
        ),
      ),
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return _fadeRoute(const SplashScreen());
          case '/onboarding':
            return _slideRoute(const OnboardingScreen());
          case '/login':
            return _slideRoute(const LoginScreen());
          case '/register':
            return _slideRoute(const RegisterScreen());
          case '/main':
            return _fadeRoute(const MainScreen());
          case '/rsvp-confirmed':
            final event = settings.arguments as Event;
            return _slideUpRoute(RsvpConfirmedScreen(event: event));
          case '/my-rsvps':
            return _slideRoute(const MyRsvpsScreen());
          case '/event-detail':
            final event = settings.arguments as Event;
            return _slideRoute(EventDetailScreen(event: event));
          case '/study-groups':
            return _fadeRoute(const StudyGroupsScreen());
          case '/community-hub':
            final clubId = settings.arguments as String;
            return _slideRoute(CommunityHubScreen(clubId: clubId));
          case '/create-opportunity':
            return _slideUpRoute(const CreateOpportunityScreen());
          default:
            return _fadeRoute(const SplashScreen());
        }
      },
    );
  }

  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  PageRouteBuilder _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  PageRouteBuilder _slideUpRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}