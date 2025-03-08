import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/product_list.dart';

class CalculationWidget extends StatefulWidget {
  final products itemss;
  final Function(products) ondeleteditem;
  final Function(products) onUpdatedItem;
  final bool isCheapest;

  const CalculationWidget({
    Key? key,
    required this.itemss,
    required this.ondeleteditem,
    required this.onUpdatedItem,
    required this.isCheapest,
  }) : super(key: key);

  @override
  _CalculationWidgetState createState() => _CalculationWidgetState();
}

class _CalculationWidgetState extends State<CalculationWidget> {
  late TextEditingController priceController;
  late TextEditingController amountController;
  bool isSelected = false;
  String productName = "Product Name"; // Default product name
  TextEditingController productNameController = TextEditingController();

  // List of units for dropdown
  final List<String> units = ["mL", "oz","L", "g","kg","pack","bottle","box","piece","unit"];
  String selectedUnit = "mL"; // Default selected unit

  // List of promotions for dropdown
  final List<String> promotions = ["none", "1 get 1", "3 for 2", "4 for 3"];
  String selectedPromotion = "none"; // Default selected promotion

  // Function to calculate price per unit
  String get pricePerUnit {
    if (priceController.text.isEmpty || amountController.text.isEmpty || double.tryParse(priceController.text) == 0) {
      return "-";
    }
    double price = double.parse(priceController.text);
    int amount = int.parse(amountController.text);
    double adjustedPricePerUnit = _calculateAdjustedPricePerUnit(price, amount, selectedPromotion);
    return adjustedPricePerUnit.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController(text: widget.itemss.price?.toString() ?? '');
    amountController = TextEditingController(text: widget.itemss.amount?.toString() ?? '');
    productName = widget.itemss.product_name!;
    productNameController.text = productName;
  }

  @override
  void dispose() {
    priceController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _updateProduct() {
    setState(() {
      widget.itemss.price = double.tryParse(priceController.text);
      widget.itemss.amount = int.tryParse(amountController.text);
      widget.onUpdatedItem(widget.itemss);
    });
  }

  double _calculateAdjustedPricePerUnit(double price, int amount, String promotion) {
    double adjustedPrice = price;
    switch (promotion) {
      case "1 get 1":
        adjustedPrice = price / 2;
        break;
      case "3 for 2":
        adjustedPrice = price / 3;
        break;
      case "4 for 3":
        adjustedPrice = price / 4;
        break;
      default:
        adjustedPrice = price;
    }
    return adjustedPrice / amount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Product selector widget
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Set the background color here
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: widget.itemss.ischeck,
                          activeColor: const Color.fromARGB(255, 220, 82, 7),
                          onChanged: (bool? value) {
                            setState(() {
                              widget.itemss.ischeck = value!;
                              widget.onUpdatedItem(widget.itemss);
                            });
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: widget.itemss.product_name),
                            style: TextStyle(
                              color: widget.itemss.product_name!.isEmpty ? Colors.grey : Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.itemss.product_name,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                widget.itemss.product_name = value;
                                widget.onUpdatedItem(widget.itemss);
                              });
                            },
                          ),
                        ),
                        if (widget.isCheapest)
                          Container(
                            child: Icon(
                              Icons.star,
                              color: const Color.fromARGB(255, 220, 82, 7),
                              size: 50,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4), // Reduce the height to bring elements closer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("Price: "),
                            Container(
                              width: 60,
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Price',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                                onChanged: (value) {
                                  _updateProduct();
                                },
                              ),
                            ),
                            const SizedBox(width: 8), // Add some space between price and amount
                            Text("Amount: "),
                            Container(
                              width: 60,
                              child: TextField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Amount',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                ),
                                onChanged: (value) {
                                  _updateProduct();
                                },
                              ),
                            ),
                            const SizedBox(width: 4), // Reduce the width to bring elements closer
                            DropdownButtonHideUnderline(
                              child: Container(
                                width: 60, // Set the width to reduce the size
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedUnit,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedUnit = newValue!;
                                    });
                                  },
                                  items: units.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Price per unit: ${pricePerUnit} THB/${selectedUnit}",
                          style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,)),
                        Spacer(), // This will push the following widgets to the right
                        Text("Promo: "), // Add Promo text
                        DropdownButton<String>(
                          value: selectedPromotion,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPromotion = newValue!;
                              _updateProduct(); // Update the product when the promotion changes
                            });
                          },
                          items: promotions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}