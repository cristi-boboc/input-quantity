import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BorderShapeBtn {
  none,
  circle,
  square,
  //rhombus  // on development
}

class InputQty extends StatefulWidget {
  /// maximum value input
  /// default  `maxVal = num.maxFinite`,
  final num maxVal;

  /// intial value
  /// default `initVal = 0`
  /// To show decimal number, set `initVal` with decimal format
  /// eg: `initVal = 0.0`
  ///
  final num initVal;

  /// minimum value
  /// default `minVal = 0`
  final num minVal;

  /// steps increase and decrease
  /// defalult `steps = 1`
  /// also support for decimal steps
  /// eg: `steps = 3.14`
  final num steps;

  /// ```dart
  /// Function(num? value) onChanged
  /// ```
  /// update value every changes
  /// the `runType` is `num`.
  /// parse to `int` : `value.toInt();`
  /// parse to `double` : `value.toDouble();`
  final ValueChanged<num?> onQtyChanged;

  /// wrap [TextFormField] with [IntrinsicWidth] widget
  /// this will make the width of [InputQty] set to intrinsic width
  /// default  `isIntrinsicWidth = true`
  /// if `false` wrapped with `Expanded`
  final bool isIntrinsicWidth;

  /// Custom decoration of [TextFormField]
  /// default value:
  ///```dart
  /// const InputDecoration(
  ///  border: UnderlineInputBorder(),
  ///  isDense: true,
  ///  isCollapsed: true,)
  ///```
  /// add [contentPadding] to costumize distance between value
  /// and the button
  final InputDecoration? textFieldDecoration;

  /// custom icon for button plus
  final Widget? plusBtn;

  /// Custom icon for button minus
  /// default size is 16
  final Widget? minusBtn;

  /// button color primary
  /// used when availabe to press
  final Color btnColor1;

  /// button color secondary
  /// used when not able to press
  final Color btnColor2;

  /// spalsh radius effect
  /// default = 16
  final double? splashRadius;

  /// border shape of button
  /// - none,
  /// - circle,
  /// - square
  final BorderShapeBtn borderShape;

  ///boxdecoration
  ///use when you want to customize border
  ///around widget
  final BoxDecoration? boxDecoration;

  /// show message when the value reach the maximum or
  /// minimum value
  final bool showMessageLimit;

  final double width;

  final double height;

  final TextStyle? textStyle;

  final bool integer;

  final bool autoFocus;

  const InputQty({
    Key? key,
    this.initVal = 1,
    this.showMessageLimit = true,
    this.boxDecoration,
    this.borderShape = BorderShapeBtn.circle,
    this.splashRadius,
    this.textFieldDecoration,
    this.isIntrinsicWidth = true,
    required this.onQtyChanged,
    this.maxVal = double.maxFinite,
    this.minVal = 0,
    this.plusBtn,
    this.minusBtn,
    this.steps = 1,
    this.btnColor1 = Colors.green,
    this.btnColor2 = Colors.grey,
    this.height = 34,
    this.width = 100,
    this.textStyle,
    this.integer = true,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  State<InputQty> createState() => _InputQtyState();
}

class _InputQtyState extends State<InputQty> {
  /// text controller of textfield
  TextEditingController _valCtrl = TextEditingController();

  /// current value of quantity
  /// late num value;
  late ValueNotifier<num?> currentval;

  /// [InputDecoration] use for [TextFormField]
  /// use when [textFieldDecoration] not null
  final _inputDecoration = const InputDecoration(
    border: UnderlineInputBorder(),
    isDense: true,
    contentPadding: kIsWeb ? EdgeInsets.only(bottom: 4) : null,
    isCollapsed: true,
  );
  @override
  void initState() {
    currentval = ValueNotifier(widget.initVal);
    _valCtrl = TextEditingController(text: "${widget.initVal}");
    widget.onQtyChanged(num.tryParse(_valCtrl.text));
    super.initState();
  }

  bool _keyboardIsVisible() {
    return (WidgetsBinding.instance.window.viewInsets.bottom > 0.0);
  }

  void defaultQty() {
    if (_valCtrl.text.isEmpty && _keyboardIsVisible()) {
      _valCtrl.text = '${widget.initVal}';
    }
  }

  @override
  void didUpdateWidget(InputQty oldWidget) {
    defaultQty();
    super.didUpdateWidget(oldWidget);
  }

  /// Increase current value
  /// based on steps
  /// default [steps] = 1
  /// When the current value is empty string, and press [plus] button
  /// then firstly, it set the [value]= [initVal],
  /// after that [value] += [steps]
  void plus() {
    num value = num.tryParse(_valCtrl.text) ?? widget.initVal;
    value += widget.steps;

    if (value >= widget.maxVal) {
      value = widget.maxVal;
    }

    /// set back to the controller
    _valCtrl.text = "$value";
    currentval.value = value;

    /// move cursor to the right side
    _valCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _valCtrl.text.length));
    widget.onQtyChanged(num.tryParse(value.toString()));
  }

  /// decrese current value based on stpes
  /// default [steps] = 1
  /// When the current [value] is empty string, and press [minus] button
  /// then firstly, it set the [value]= [initVal],
  /// after that [value] -= [steps]
  void minus() {
    num value = num.tryParse(_valCtrl.text) ?? widget.initVal;
    value -= widget.steps;
    if (value <= widget.minVal) {
      value = widget.minVal;
    }

    /// set back to the controller
    _valCtrl.text = "$value";
    currentval.value = value;

    /// move cursor to the right side
    _valCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _valCtrl.text.length));
    widget.onQtyChanged(num.tryParse(value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return widget.isIntrinsicWidth ? IntrinsicWidth(child: _buildInputQty()) : _buildInputQty();
  }

  /// build widget input quantity
  Widget _buildInputQty() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: !widget.isIntrinsicWidth ? widget.width : null,
            height: !widget.isIntrinsicWidth ? widget.height : null,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            alignment: Alignment.center,
            decoration: widget.boxDecoration ??
                BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.8),
                  borderRadius: BorderRadius.circular(5),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<num?>(
                    valueListenable: currentval,
                    builder: (context, value, child) {
                      bool limitBtmState = (value ?? widget.initVal) > widget.minVal;
                      return BuildBtn(
                        btnColor: limitBtmState ? widget.btnColor1 : widget.btnColor2,
                        isPlus: false,
                        borderShape: widget.borderShape,
                        splashRadius: widget.splashRadius,
                        onChanged: limitBtmState ? minus : null,
                        child: widget.minusBtn,
                      );
                    }),
                Expanded(child: _buildtextfield(autoFocus: widget.autoFocus)),
                ValueListenableBuilder<num?>(
                    valueListenable: currentval,
                    builder: (context, value, child) {
                      bool limitTopState = (value ?? widget.initVal) < widget.maxVal;

                      return BuildBtn(
                        btnColor: limitTopState ? widget.btnColor1 : widget.btnColor2,
                        isPlus: true,
                        borderShape: widget.borderShape,
                        onChanged: limitTopState ? plus : null,
                        splashRadius: widget.splashRadius,
                        child: widget.plusBtn,
                      );
                    }),
              ],
            ),
          ),
          if (widget.showMessageLimit) _buildMsgLimit()
        ],
      );

  /// widget textformfield
  Widget _buildtextfield({required bool autoFocus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        decoration: widget.textFieldDecoration ?? _inputDecoration,
        style: widget.textStyle,
        controller: _valCtrl,
        onChanged: (strVal) {
          num? temp = num.tryParse(_valCtrl.text);
          if (temp == null) return;
          if (temp > widget.maxVal) {
            temp = widget.maxVal;
            _valCtrl.text = "${widget.maxVal}";
            _valCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _valCtrl.text.length));
          } else if (temp < widget.minVal) {
            temp = widget.minVal;
            _valCtrl.text = temp.toString();
            _valCtrl.selection = TextSelection.fromPosition(TextPosition(offset: _valCtrl.text.length));
          }
          num? newVal = num.tryParse(_valCtrl.text);
          widget.onQtyChanged(newVal);
          currentval.value = newVal;
        },
        keyboardType: TextInputType.number,
        inputFormatters: widget.integer
            ? [FilteringTextInputFormatter.digitsOnly]
            : [FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\-?\d*"))],
      ),
    );
  }

  Widget _buildMsgLimit() => ValueListenableBuilder<num?>(
      valueListenable: currentval,
      builder: (context, val, __) {
        if (val == null) return const SizedBox();
        final value = val;
        if (value <= widget.minVal) {
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'minimum stock quantity: ${widget.minVal}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (value >= widget.maxVal) {
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              "maximum stock quantity: ${widget.maxVal}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const SizedBox();
        }
      });

  @override
  void dispose() {
    super.dispose();
    _valCtrl.dispose();
  }
}

class BuildBtn extends StatelessWidget {
  final Widget? child;
  final Function()? onChanged;
  final bool isPlus;
  final Color btnColor;
  final double? splashRadius;

  final BorderShapeBtn borderShape;

  const BuildBtn({
    super.key,
    this.splashRadius,
    this.borderShape = BorderShapeBtn.circle,
    required this.isPlus,
    this.onChanged,
    this.btnColor = Colors.teal,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: borderShape == BorderShapeBtn.none ? null : Border.all(color: btnColor),
        borderRadius: borderShape == BorderShapeBtn.circle ? BorderRadius.circular(9999) : null,
      ),
      child: IconButton(
        color: btnColor,
        constraints: const BoxConstraints(),
        padding: EdgeInsets.zero,
        onPressed: () {
          if (onChanged != null) {
            onChanged!();

            ///turn off keyboard
            FocusScope.of(context).unfocus();
          }
        },
        disabledColor: btnColor,
        splashRadius: splashRadius ?? 16,
        icon: child ?? Icon(isPlus ? Icons.add : Icons.remove, size: 16),
      ),
    );
  }
}
