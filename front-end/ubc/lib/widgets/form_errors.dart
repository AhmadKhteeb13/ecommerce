import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormError extends StatelessWidget {
  final List<String?> errors;
  const FormError({Key? key, required this.errors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index]!, width: width)),
    );
  }

  Row formErrorText({required String error, required double width}) {
    
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/Error.svg",
          height: 0.037 * width,
          width: 0.037 * width,
        ),
        SizedBox(
          width: 0.026 * width,
        ),
        Text(error)
      ],
    );
  }
}
