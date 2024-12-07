import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key, required this.pageTitle});
  final String pageTitle;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String length = '';
  String width = '';
  String height = '';
  String unitPrice = '';
  String materialType = 'Concrete'; // Default material type
  String quantity = '';
  String extraPercentage = '';
  String selectedShape = 'Rectangle'; // Default shape
  String selectedUnit = 'Meters'; // Default unit
  String selectedVolumeUnit = 'Cubic Meters'; // Default volume unit
  String selectedMaterialType = 'Concrete'; // Default material type
  List<String> shapes = ['Rectangle', 'Square'];
  List<String> units = ['Meters', 'Feet'];
  List<String> volumeUnits = ['Cubic Meters', 'Cubic Feet'];
  List<String> materialTypes = ['Concrete', 'Bricks', 'Tiles'];
  double result = 0.0; // Store the result of the calculation

  Widget selectCalculator() {
    if (widget.pageTitle == 'Area Calculator') {
      return areaCalculator();
    }
    if (widget.pageTitle == 'Volume Calculator') {
      return volumeCalculator();
    }
    if (widget.pageTitle == 'Concrete Calculator') {
      return concreteCalculator();
    }
    if (widget.pageTitle == 'Material Cost') {
      return costCalculator();
    }
    return const Center(child: Text('Invalid Calculator Type'));
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.yellow.shade800,
      ),
      body: Column(
        children: [
          Expanded(child: selectCalculator()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Result: ${result.toStringAsFixed(3)}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: '$result'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Result copied to clipboard"),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget areaCalculator() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              inputContainer('Length', (value) => length = value),
              if (selectedShape == 'Rectangle') // Show width input only for rectangle
                inputContainer('Width', (value) => width = value),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              dropdownContainer('Shape', selectedShape, shapes, (value) {
                setState(() {
                  selectedShape = value!;
                });
              }),
              dropdownContainer('Unit', selectedUnit, units, (value) {
                setState(() {
                  selectedUnit = value!;
                });
              }),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  try {
                    if (length.isNotEmpty) {
                      double lengthValue = double.parse(length);
                      double widthValue = selectedShape == 'Rectangle' && width.isNotEmpty ? double.parse(width) : lengthValue;

                      // Convert units if necessary
                      if (selectedUnit == 'Feet') {
                        lengthValue *= 0.3048; // Convert feet to meters
                        widthValue *= 0.3048; // Convert feet to meters
                      }

                      // Calculate area based on selected shape
                      if (selectedShape == 'Square') {
                        result = calculateSquareArea(lengthValue);
                      } else if (selectedShape == 'Rectangle') {
                        result = calculateArea(lengthValue, widthValue);
                      }
                    } else {
                      showErrorDialog('Please fill in all the fields.');
                    }
                  } catch (e) {
                    showErrorDialog('Invalid Value');
                  }
                });
              },
              child: const Text('Calculate'),
            ),
          ),
        ],
      ),
    );
  }

  Widget volumeCalculator() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              inputContainer('Length', (value) => length = value),
              inputContainer('Width', (value) => width = value),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              inputContainer('Height', (value) => height = value),
              dropdownContainer('Volume Unit', selectedVolumeUnit, volumeUnits, (value) {
                setState(() {
                  selectedVolumeUnit = value!;
                });
              }),
            ],
          ),
          const SizedBox(height: 15),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  try {
                    if (length.isNotEmpty && width.isNotEmpty && height.isNotEmpty) {
                      double lengthValue = double.parse(length);
                      double widthValue = double.parse(width);
                      double heightValue = double.parse(height);

                      // Convert units if necessary
                      if (selectedVolumeUnit == 'Cubic Feet') {
                        lengthValue *= 0.3048; // Convert feet to meters
                        widthValue *= 0.3048; // Convert feet to meters
                        heightValue *= 0.3048; // Convert feet to meters
                      }

                      result = calculateVolume(lengthValue, widthValue, heightValue);
                    } else {
                      showErrorDialog('Please fill in all the fields.');;
                    }
                  } catch (e) {
                    showErrorDialog('Invalid Value');
                  }
                });
              },
              child: const Text('Calculate'),
            ),
          ),
        ],
      ),
    );
  }

  Widget concreteCalculator() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Center(child: inputContainer('Quantity', (value) => quantity = value)),
          ),
          const SizedBox(height: 20),
          Center(
            child: dropdownContainer('Material Type', selectedMaterialType, materialTypes, (value) {
              setState(() {
                selectedMaterialType = value!;
              });
            }),
          ),
          const SizedBox(height: 20),
          Center(child: inputContainer('Extra % (optional)', (value) => extraPercentage = value)),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  try {
                    if (quantity.isNotEmpty) {
                      double quantityValue = double.parse(quantity);
                      double extraPercent = extraPercentage.isNotEmpty ? double.parse(extraPercentage) / 100 : 0.0;

                      result = calculateConcreteCost(quantityValue, extraPercent);
                    } else {
                      showErrorDialog('Please fill in all the fields.');
                    }
                  } catch (e) {
                    showErrorDialog('Invalid Value');
                  }
                });
              },
              child: const Text('Calculate'),
            ),
          ),
        ],
      ),
    );
  }

  Widget costCalculator() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Center(child: inputContainer('Unit Price', (value) => unitPrice = value)),
          ),
          const SizedBox(height: 20),
          Center(child: inputContainer('Quantity', (value) => quantity = value)),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  try {
                    if (unitPrice.isNotEmpty && quantity.isNotEmpty) {
                      double priceValue = double.parse(unitPrice);
                      double quantityValue = double.parse(quantity);

                      result = calculateCost(priceValue, quantityValue);
                    } else {
                      showErrorDialog('Please fill in all the fields.');
                    }
                  } catch (e) {
                    showErrorDialog('Invalid Value');
                  }
                });
              },
              child: const Text('Calculate'),
            ),
          ),
        ],
      ),
    );
  }

  // Helper functions to calculate area, volume, etc.
  double calculateArea(double length, double width) {
    return length * width;
  }

  double calculateSquareArea(double length) {
    return length * length;
  }

  double calculateVolume(double length, double width, double height) {
    return length * width * height;
  }

  double calculateConcreteCost(double quantity, double extraPercent) {
    double baseCost = 100.0; // Assume a base cost for concrete, modify as needed
    return baseCost * quantity * (1 + extraPercent);
  }

  double calculateCost(double unitPrice, double quantity) {
    return unitPrice * quantity;
  }

  // Helper widgets to build input and dropdown fields
  Widget inputContainer(String label, Function(String) onChanged) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }

  Widget dropdownContainer(String label, String selectedItem, List<String> options, Function(String?) onChanged) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<String>(
        value: selectedItem,
        onChanged: onChanged,
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
