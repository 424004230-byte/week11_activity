abstract class Payable {
  void processPayment(double amount);
}

mixin EnergySaver {
  void enableEcoMode() {
    print("Eco Mode Activated: Lowering power consumption.");
  }
}

class VendingMachine implements Payable {
  String location;
  double _balance = 0.0;

  VendingMachine(this.location);

  double get balance => _balance;

  @override
  void processPayment(double amount) {
    if (amount > 0) {
      _balance += amount;
      print("[$location] Payment of \$$amount processed. Total balance: \$$_balance");
    }
  }

  void dispenseProduct() {
    print("[$location] Dispensing standard product...");
  }
}

class SnackVendingMachine extends VendingMachine with EnergySaver {
  int snackCount;

  SnackVendingMachine(String location, this.snackCount) : super(location);

  @override
  void dispenseProduct() {
    if (snackCount > 0) {
      snackCount--;
      print("[$location] Dispensed a snack! Snacks remaining: $snackCount");
    } else {
      print("[$location] Snack machine is out of stock.");
    }
  }

  Future<String> restockSnacks(int amount) async {
    print("[$location] Connecting to inventory server...");
    await Future.delayed(Duration(seconds: 2));
    snackCount += amount;
    return "[$location] Restock complete! New snack count: $snackCount";
  }
}

class DrinkVendingMachine extends VendingMachine {
  double temperatureCelsius;

  DrinkVendingMachine(String location, this.temperatureCelsius) : super(location);

  @override
  void dispenseProduct() {
    print("[$location] Dispensing a cold drink chilled at $temperatureCelsius°C!");
  }
}

void main() async {
  SnackVendingMachine snackMachine = SnackVendingMachine('Library Hall', 0);
  DrinkVendingMachine drinkMachine = DrinkVendingMachine('Main Lobby', 4.0);

  snackMachine.dispenseProduct();

  print("Requesting inventory update...");
  
  String restockStatus = await snackMachine.restockSnacks(10);
  print(restockStatus);

  snackMachine.dispenseProduct();
  drinkMachine.processPayment(3.50);
  drinkMachine.dispenseProduct();
}
