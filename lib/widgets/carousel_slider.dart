import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final String initialItemName;
  final int initialAmount;
  final double initialPrice;
  final List<String> units;
  final bool isSelected;
  final Function(bool) onSelected;

  const ProductItem({
    Key? key,
    this.initialItemName = "Vaseline No.3",
    this.initialAmount = 250,
    this.initialPrice = 349.0,
    this.units = const ["ml", "oz", "g"],
    this.isSelected = false,
    required this.onSelected,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  String itemName = "";
  int amount = 0;
  double price = 0.0;
  int quantity = 1;
  bool isSelected = false;
  String selectedCapacity = "ml";

  @override
  void initState() {
    super.initState();
    itemName = widget.initialItemName;
    amount = widget.initialAmount;
    price = widget.initialPrice;
    selectedCapacity = widget.units.first;
    isSelected = widget.isSelected;
  }

  double get pricePerUnit => amount > 0 ? price / amount : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? Colors.orange.shade100 : Colors.transparent,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Selection Circle
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = !isSelected;
                    widget.onSelected(isSelected);
                  });
                },
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: isSelected ? Colors.orange : Colors.white,
                  child: isSelected ? Icon(Icons.check, size: 12, color: Colors.white) : null,
                ),
              ),
              const SizedBox(width: 8),

              // Item Name Text Field
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: itemName),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Item Name",
                  ),
                  onChanged: (value) {
                    setState(() {
                      itemName = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Amount Input
              SizedBox(
                width: 50,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: amount.toString()),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      amount = int.tryParse(value) ?? amount;
                    });
                  },
                ),
              ),

              // Capacity Dropdown
              DropdownButton<String>(
                value: selectedCapacity,
                underline: Container(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCapacity = newValue!;
                  });
                },
                items: widget.units.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Price and Quantity Row
          Row(
            children: [
              // Price Box
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: price.toString()),
                  decoration: InputDecoration(
                    labelText: "ราคา",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      price = double.tryParse(value) ?? price;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      },
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Price per Unit
          Row(
            children: [
              Text("ราคาต่อหน่วย"),
              const SizedBox(width: 8),
              Text(pricePerUnit.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
    );
  }
}
