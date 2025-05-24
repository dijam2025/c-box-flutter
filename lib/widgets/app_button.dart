import 'package:flutter/material.dart';

/// 재사용 가능한 커스텀 버튼 컴포넌트
///
/// [label]: 버튼에 표시될 텍스트
/// [onPressed]: 버튼 클릭 콜백
/// [icon]: 버튼에 아이콘을 함께 표시하고 싶을 때
/// [backgroundColor]: 버튼 배경 색상
/// [textColor]: 버튼 텍스트 색상
/// [borderRadius]: 버튼 모서리 둥글기
/// [elevation]: 버튼 그림자 깊이
/// [padding]: 버튼 내부 여백
/// [border]: 버튼 테두리
/// [width], [height]: 버튼 크기 (선택적)

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;
  final BorderRadiusGeometry borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderSide? border;
  final double? width;
  final double? height;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.indigo,
    this.textColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.elevation = 2.0,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    this.border,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasIcon = icon != null;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: padding,
        fixedSize: width != null || height != null
            ? Size(width ?? double.infinity, height ?? 48)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border ?? BorderSide.none,
        ),
      ),
      child: hasIcon
          ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ],
      )
          : Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}