class CartItem {
  final String image;
  final String name;
  final String priceSign;
  final String price;
  int quantity;

  CartItem({
    required this.image,
    required this.name,
    required this.priceSign,
    required this.price,
    this.quantity = 1,
  });

  // Convert a CartItem instance to a JSON object
  Map<String, dynamic> toJson() => {
        'image': image,
        'name': name,
        'priceSign': priceSign,
        'price': price,
        'quantity': quantity,
      };

  // Create a CartItem instance from a JSON object
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        image: json['image'],
        name: json['name'],
        priceSign: json['priceSign'],
        price: json['price'],
        quantity: json['quantity'],
      );
}

class Cart {
  final List<CartItem> items;

  Cart({required this.items});

  // Convert a Cart instance to a JSON object
  Map<String, dynamic> toJson() => {
        'items': items.map((item) => item.toJson()).toList(),
      };

  // Create a Cart instance from a JSON object
  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        items: (json['items'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList(),
      );
}
