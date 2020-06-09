import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import '../util/decimal_input_formatter.dart';

class InterestForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InterestFormState();
  }
}

class _InterestFormState extends State<InterestForm> {
  var _period = ["Years", "Months", "Days"];
  final _minimumPadding = 5.0;
  var _currentItemSelected = '';
  var displayResult = "";
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _period[0];
  }

  var principalController =
      MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
  var roiController = TextEditingController();
  var termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Interest Caluclator"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: textStyle,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter Principal amount';
                      }
                    },
                    controller: principalController,
                    decoration: InputDecoration(
                        labelText: "Principal",
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15,
                        ),
                        hintText: "Enter Principal e.g 1200",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 4)
                    ],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    style: textStyle,
                    controller: roiController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter Rate of Interest';
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Rate of Interest",
                        labelStyle: textStyle,
                        errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15,
                        ),
                        hintText: "Enter Interest e.g 2.4",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter Term';
                            }
                          },
                          style: textStyle,
                          controller: termController,
                          decoration: InputDecoration(
                              labelText: "Term",
                              errorStyle: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 15,
                              ),
                              labelStyle: textStyle,
                              hintText: "Time in Years",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                        Container(width: _minimumPadding * 5),
                        Expanded(
                            child: DropdownButton<String>(
                          items: _period.map((String value) {
                            return DropdownMenuItem<String>(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          value: _currentItemSelected,
                          onChanged: (String selectedNewValue) {
                            _onDropDownItemSelected(selectedNewValue);
                          },
                        ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        bottom: _minimumPadding, top: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              'Calculate',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState.validate()) {
                                  this.displayResult = _calculateTotalReturns();
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Reset',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                          ),
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: Text(
                    displayResult,
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("images/money.png");
    Image image = Image(image: assetImage);
    return Container(
      margin: EdgeInsets.all(_minimumPadding * 2),
      child: image,
      height: 125.0,
      width: 125.0,
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double principal = principalController.numberValue;
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalPayable = principal + (principal * roi * term) / 100;

    String formattedTerm =
        term.toString().replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");

    var numberFormat = new NumberFormat("#,##0.00", "en_US");

    String formattedTotalPayable = numberFormat.format(totalPayable);

    String result =
        'After $formattedTerm $_currentItemSelected, your investment will be worth $formattedTotalPayable ';

    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _period[0];
  }
}
