import 'package:ecommerce_app/core/constents/app_colors.dart';
import 'package:ecommerce_app/core/constents/assets.dart';
import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/shared/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LoginRegisterView extends StatelessWidget {
  const LoginRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),

                    // Title
                    CustomTextWidget.title24(
                      "Let's Get Started",
                      textAlign: TextAlign.center,
                      color: AppColor.textdark,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    SvgPicture.asset(
                      "assets/icons/Logo.svg",
                      height: 100,
                      width: 100,
                    ),

                    SizedBox(height: screenHeight * 0.06),

                    // facebook button
                    Container(
                      width: double.infinity,
                      height:  screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.bluefacebook,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {}
                          ,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.assetsIconsFacebook,
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 10),
                              CustomTextWidget(
                                text: "Facebook",
                                color: AppColor.backgroundLight,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                        ),
                      ),  

                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // twitter button
                    Container(
                      width: double.infinity,
                      height:  screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.tewiterColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {}
                          ,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.assetsIconsTwitter,
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 10),
                              CustomTextWidget(
                                text: "Twitter",
                                color: AppColor.backgroundLight,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                        ),
                      ),  

                    ),

                    SizedBox(height: screenHeight * 0.02),
                    // Google button
                    Container(
                      width: double.infinity,
                      height:  screenHeight * 0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.googleColor,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {}
                          ,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.assetsIconsGoogle,
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 10),
                              CustomTextWidget(
                                text: "Google",
                                color: AppColor.backgroundLight,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                        ),
                      ),  

                    ),


                    Spacer(),


                    // Already have account section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextWidget(
                          text: "Already have an account?",
                          color: AppColor.textgray,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.login),
                          child: CustomTextWidget(
                            text: "Signin",
                            color: AppColor.textdark,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),
                  ],
                ),
              ),
            ),

            // Create Account Button
            Container(
              width: double.infinity,
              height:  screenHeight * 0.08,
              decoration: const BoxDecoration(color: AppColor.primaryColor),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => context.push(AppRoutes.register),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.01),
                      CustomTextWidget(
                        text: "Create an Account",
                        color: AppColor.backgroundLight,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
