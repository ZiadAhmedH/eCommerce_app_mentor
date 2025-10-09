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
    return Scaffold(
     
      body:Column(
        children: [
          Expanded(
            child: Column(
              children: [
                 SizedBox(height: MediaQuery.of(context).size.height*0.1),
                 Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     CustomTextWidget.title24(
                      "Let’s Get Started",
                      textAlign: TextAlign.center,
                      color: AppColor.textdark,
                     ),
                   ],
                 ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02),
                 SvgPicture.asset(Assets.assetsIconsLogo , color:AppColor.primaryColor ,height: 100,width: 100,),
            
            
                  SizedBox(height: MediaQuery.of(context).size.height*0.05),
            
                  Spacer(),
                  
            
                  
              ],
            ),
          ),
          
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            height: MediaQuery.of(context).size.height*0.08,
            width: double.infinity,
             decoration: BoxDecoration(
              color: AppColor.primaryColor,),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2 ,
                    child: GestureDetector(
                      onTap: (){
                         context.go(AppRoutes.register);
                      },
                      child: CustomTextWidget(
                        text: "Create an Account",
                        color: AppColor.backgroundLight,
                        fontSize: 17, 
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
          ),
        ],
      )
    );
  }
}