import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CurrencyDropdownButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CurrencySwitcherControl extends StatefulWidget {
  @override
  _CurrencySwitcherControlState createState() =>
      _CurrencySwitcherControlState();
}

class _CurrencySwitcherControlState extends State<CurrencySwitcherControl> {
  String _leftDropdownValue = 'USD';
  String _rightDropdownValue = 'USD';

  _buildUSFlag() {
    return Container(
      width: 40,
      height: 45,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: SvgPicture.asset(
            'lib/assets/img/us-flag.svg',
            fit: BoxFit.cover,
          )),
    );
  }

  Widget _buildLeftDropdown() {
    return Flexible(
        fit: FlexFit.loose,
        child: DropdownButton(
          value: _leftDropdownValue,
          elevation: 16,
          isDense: true,
          iconSize: 0.0,
          isExpanded: true,
          onChanged: (v) {
            setState(() {
              _leftDropdownValue = v;
            });
          },
          selectedItemBuilder: (BuildContext context) {
            return <String>['RUB', "EUR", "USD"].map<Widget>((String item) {
              if (item == 'USD') {
                return Row(
                  children: [
                    _buildUSFlag(),
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "1 USD",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                );
              }

              return Text(item);
            }).toList();
          },
          items: <String>['RUB', "EUR", "USD"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
        ));
  }

  Widget _buildRightDropdown() {
    return Container(); //
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLeftDropdown(),
        _buildRightDropdown(),
      ],
    );
  }
}
