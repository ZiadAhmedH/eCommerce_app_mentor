import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../shared/widgets/custom_widget.dart';
import '../../cubit/register_cubit.dart';

class RegisterFormActions extends StatelessWidget {
  final VoidCallback onRegisterPressed;

  const RegisterFormActions({
    super.key,
    required this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
     var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        const SizedBox(height: 32),

        BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            return CustomButton(
              text: 'Sign Up',
              isLoading: state is RegisterLoading,
              onPressed: state is RegisterLoading ? null : onRegisterPressed,
             borderRadius: 0,   
             height: screenHeight * 0.08,
            );
          },
        ),


      
      ],
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../../core/constents/app_colors.dart';
// import '../../../../../core/routing/app_routes.dart';
// import '../../../../../shared/widgets/text_widget.dart';

// class RegisterFormActions extends StatelessWidget {
//   final VoidCallback onRegisterPressed;

//   const RegisterFormActions({super.key, required this.onRegisterPressed});

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Container(
//       width: double.infinity,
//       height: screenHeight * 0.08,
//       decoration: const BoxDecoration(color: AppColor.primaryColor),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () => context.push(AppRoutes.register),
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(height: screenHeight * 0.01),
//                 CustomTextWidget(
//                   text: "Sign Up",
//                   color: AppColor.backgroundLight,
//                   fontSize: 17,
//                   fontWeight: FontWeight.w500,
//                   textAlign: TextAlign.center,
//                 ),
//                 Spacer()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
