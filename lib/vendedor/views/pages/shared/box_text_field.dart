// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class BoxTextField extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSenha;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onFieldSubmitted;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final GlobalKey<FormFieldState>? formFieldKey;
  final String? hintText;
  final int? maxLines;
  final void Function(String)? onChanged;
  final bool isChat;

  const BoxTextField({
    super.key,
    required this.icon,
    required this.label,
    this.isSenha = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false,
    this.validator,
    this.onFieldSubmitted,
    this.controller,
    this.textInputType,
    this.formFieldKey,
    this.hintText,
    this.maxLines = 1,
    this.onChanged,
    this.isChat = false,
  });

  @override
  State<BoxTextField> createState() => _BoxTextFieldState();
}

class _BoxTextFieldState extends State<BoxTextField> {
  bool isObscure = false;
  double tamanho = 71;

  @override
  void initState() {
    isObscure = widget.isSenha;
    if (widget.isChat) {
      widget.controller!.addListener(_onTextChanged);
    }
    super.initState();
  }

  // Função chamada quando o texto é alterado
  void _onTextChanged() {
    if (widget.controller!.text.isEmpty) {
      // Se o texto estiver vazio, redefinir o tamanho para o valor inicial
      setState(() {
        tamanho = 71;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.isChat ? tamanho : null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Scrollbar(
          child: TextFormField(
            key: widget.formFieldKey,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            autocorrect: false,
            controller: widget.controller,
            readOnly: widget.readOnly,
            initialValue: widget.initialValue,
            inputFormatters: widget.inputFormatters,
            obscureText: isObscure,
            validator: widget.validator,
            onFieldSubmitted: widget.onFieldSubmitted,
            keyboardType: widget.textInputType,
            maxLines: widget.maxLines,
            onChanged: widget.isChat
                ? (value) {
                    final lineCount = value.split('\n').length;
                    if (lineCount <= 6) {
                      setState(() {
                        tamanho = 71 + (lineCount - 1) * 24;
                      });
                    }
                  }
                : widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 14, left: 14),
                child: Icon(
                  widget.icon,
                  size: 24,
                ),
              ),
              suffixIcon: widget.isSenha
                  ? IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      })
                  : null,
              label: Text(widget.label),
              isDense: true,
            ),
          ),
        ),
      ),
    );
  }
}
