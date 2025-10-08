import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/services/onboarding_service.dart';
import '../../../shared/widgets/text_widget.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  String selectedGender = 'Man'; // Default selection

  Future<void> _completeOnboarding(BuildContext context) async {
    await OnboardingService.completeOnboarding();
    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }

  void _selectGender(String gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            tileMode: TileMode.mirror,
            end: Alignment.bottomCenter,
            colors: [AppColor.gradientStart, AppColor.gradientEnd],
          ),
        ),
        child: Stack(
          alignment: AlignmentGeometry.bottomCenter,
          children: [
            Image.asset('assets/images/man-chair.png', height: 812, width: 375),

            Positioned(
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                height: 244,
                width: MediaQuery.sizeOf(context).width - 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    CustomTextWidget.title24(
                      "Look Good, Feel Good",
                      color: AppColor.textdark,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    CustomTextWidget.subtitleNormal(
                      "Create your individual & unique style and look amazing everyday.",
                      color: AppColor.textgray,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Gender selection toggle buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _selectGender('Man'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedGender == 'Man'
                                  ? Color(AppColor.primaryColor)
                                  : AppColor.backgroundLight,
                              foregroundColor: selectedGender == 'Man'
                                  ? Colors.white
                                  : AppColor.textdark,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: CustomTextWidget(
                              text:"Men",
                              color: AppColor.textgray,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              )
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _selectGender('Woman'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedGender == 'Woman'
                                  ? Color(AppColor.primaryColor)
                                  : AppColor.backgroundLight,
                              foregroundColor: selectedGender == 'Woman'
                                  ? Colors.white
                                  : AppColor.textdark,
                              padding: const EdgeInsets.symmetric(
                                vertical:20,
                                horizontal:45, 
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child:  CustomTextWidget(
                              text:"Women",
                              color: selectedGender == 'Woman' ? Colors.white : AppColor.textgray,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                              )
                          ),
                          ),
                        
                      ],
                    ),

                    const SizedBox(height: 20),
                     
                     

                       ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
