import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:prs_staff/src/style.dart';

// ignore: must_be_immutable
class CustomText extends StatelessWidget {
  String label;
  String hintText;
  String attribute;
  IconData icon;

  CustomText({
    this.label,
    this.hintText,
    this.attribute,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: FormBuilderTextField(
        attribute: attribute,
        initialValue: hintText,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          labelStyle: TextStyle(
            color: color2,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: color2,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(
            icon,
            color: color2,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  TextEditingController textEditingController;
  String labelText;
  Icon icon;
  TextInputType textInputType;
  int maxLenth;
  bool enable;

  CustomTextFormField({
    this.textEditingController,
    this.labelText,
    this.icon,
    this.maxLenth,
    this.textInputType,
    this.enable,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: labelText,
        labelStyle: TextStyle(
          color: color2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color2,
            width: 2,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
        counterText: '',
        prefixIcon: icon,
      ),
      keyboardType: textInputType,
      maxLength: maxLenth,
      enabled: enable,
    );
  }
}


customTextField(String label, String error) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(
          validator: FormBuilderValidators.required(
            errorText: error,
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );

customRadioGroup(String label, String attribute, String error,
        List<FormBuilderFieldOption> options) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilderRadioGroup(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: color2,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: color2,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
          attribute: attribute,
          validators: [
            FormBuilderValidators.required(errorText: error),
          ],
          options: options,
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
