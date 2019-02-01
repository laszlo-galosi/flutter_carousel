import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive.dart';
import 'package:intl/intl.dart';

const double _pickerSheetHeight = 216.0;
const double _pickerItemHeight = 32.0;

typedef IndexValueMapper = dynamic Function(int index);

class CupertinoPickerWidget extends StatelessWidget {
  CupertinoPickerWidget(
      {Key key,
      @required this.itemBuilder,
      this.onSelectedItemChanged,
      this.indexMapper,
      this.value,
      this.label,
      this.valueFormat});

  final String label;
  final dynamic value;
  final ValueChanged<dynamic> onSelectedItemChanged;
  final PickerItemListBuilder itemBuilder;
  final IndexValueMapper indexMapper;

  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0);

  final ValueFormatter valueFormat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoBottomPicker(
              picker: CupertinoPicker(
                  scrollController: _scrollController,
                  itemExtent: _pickerItemHeight,
                  backgroundColor: CupertinoColors.white,
                  onSelectedItemChanged: (int index) {
                    if (indexMapper != null)
                      onSelectedItemChanged(indexMapper(index));
                  },
                  children: itemBuilder(context)),
            );
          },
        );
      },
      child: CupertinoListItem(children: [
        label != null ? Text(label) : Container(),
        Text(
          valueFormat(value) ?? value.toString(),
          style: const TextStyle(color: CupertinoColors.inactiveGray),
        )
      ]),
    );
  }
}

class CupertinoDateTimePicker extends StatelessWidget {
  CupertinoDateTimePicker({
    Key key,
    @required this.value,
    @required this.onDateTimeChanged,
    this.mode,
    this.label,
    this.valueFormat,
  });

  final CupertinoDatePickerMode mode;
  final ValueChanged<DateTime> onDateTimeChanged;
  final DateTime value;
  final ValueFormatter valueFormat;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return CupertinoBottomPicker(
                    picker: CupertinoDatePicker(
                        mode: mode ?? CupertinoDatePickerMode.date,
                        initialDateTime: value,
                        onDateTimeChanged: onDateTimeChanged));
              });
        },
        child: CupertinoListItem(children: [
          Text(label ?? 'Date'),
          Text(
            valueFormat(value) ?? DateFormat.yMMMMd().format(value),
            style: const TextStyle(color: CupertinoColors.inactiveGray),
          )
        ]));
  }
}

class CupertinoBottomPicker extends StatelessWidget {
  CupertinoBottomPicker({this.picker});

  final Widget picker;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _pickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}

class CupertinoListItem extends StatelessWidget {
  CupertinoListItem({Key key, this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
          bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
        ),
      ),
      height: 44.0,
      child: SafeArea(
        top: false,
        bottom: false,
        child: DefaultTextStyle(
          style: const TextStyle(
            letterSpacing: -0.24,
            fontSize: 17.0,
            color: CupertinoColors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
      ),
    );
  }
}
