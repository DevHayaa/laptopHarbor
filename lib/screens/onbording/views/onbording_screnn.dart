import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:laptop_harbor/constants.dart';
import 'package:laptop_harbor/route/route_constants.dart';

class OnBordingScreen extends StatelessWidget {
  const OnBordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // GIF Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/illustration/onboard.gif',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: defaultPadding),

              // Title & Description
              Text(
                "Welcome to Laptop Harbor!",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Buy laptops, accessories, and more with a fast & secure experience.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: defaultPadding * 2),

              // Next Button
              SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, logInScreenRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/Arrow - Right.svg",
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
