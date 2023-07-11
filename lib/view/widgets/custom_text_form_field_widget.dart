import 'package:flutter/material.dart';

import '../../viewmodel/login_viewmodel.dart';

///Username ve Password için Custom TextFormField yapısı
class CustomTextFormField extends StatelessWidget {
  final LoginViewModel c;
  final String labelText;
  final TextEditingController controller;
  const CustomTextFormField(
      {super.key,
      required this.c,
      required this.labelText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: TextFormField(
          controller: controller,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              labelText: labelText,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          validator: (value) {
            if (value != null && value == '') {
              return 'Bu alanı boş bırakamazsınız!';
            }
            return null;
          },
        ),
      ),
    );
  }
}
