import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum CustomButtonType { primary, secondary, outline, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final CustomButtonType type;
  final bool isFullWidth;
  final IconData? icon;
  final bool isLoading;
  
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = CustomButtonType.primary,
    this.isFullWidth = false,
    this.icon,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CustomButtonType.primary:
        return _buildElevatedButton();
      case CustomButtonType.secondary:
        return _buildSecondaryButton();
      case CustomButtonType.outline:
        return _buildOutlinedButton();
      case CustomButtonType.text:
        return _buildTextButton();
    }
  }
  
  Widget _buildElevatedButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildButtonContent(),
      ),
    );
  }
  
  Widget _buildSecondaryButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
        ),
        child: _buildButtonContent(),
      ),
    );
  }
  
  Widget _buildOutlinedButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildButtonContent(),
      ),
    );
  }
  
  Widget _buildTextButton() {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      child: _buildButtonContent(),
    );
  }
  
  Widget _buildButtonContent() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    
    return Text(text);
  }
}