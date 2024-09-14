class OrdersModel {
  String key;
  String customerId;
  String customerName;
  String customerMobile;
  String customerEmail;
  String categoryId;
  String categoryName;
  String vendorId;
  String vendorName;
  double vendorLatitude;
  double vendorLongitude;
  String itemsListStr;
  String itemsListImageURL;
  bool isByCall;
  bool isImgSelected;
  double customerDeliveryLatitude;
  double customerDeliveryLongitude;
  String customerDeliveryFullAddress;
  String customerDeliveryPinCode;
  String orderType;
  String orderID;
  String orderCreatedDate;
  String orderStatus;
  String deliveryManId;
  String deliveryManMobileNumber;
  String deliveryManName;
  String deliveryManNotes;
  String deliveryCharge;
  String totalAmount;
  String billURL;
  String paymentType;


  OrdersModel(
      this.key,
      this.customerId,
      this.customerName,
      this.customerMobile,
      this.customerEmail,
      this.categoryId,
      this.categoryName,
      this.vendorId,
      this.vendorName,
      this.vendorLatitude,
      this.vendorLongitude,
      this.itemsListStr,
      this.itemsListImageURL,
      this.isByCall,
      this.isImgSelected,
      this.customerDeliveryLatitude,
      this.customerDeliveryLongitude,
      this.customerDeliveryFullAddress,
      this.customerDeliveryPinCode,
      this.orderType,
      this.orderID,
      this.orderCreatedDate,
      this.orderStatus,
      this.deliveryManId,
      this.deliveryManName,
      this.deliveryManMobileNumber,
      this.deliveryManNotes,
      this.deliveryCharge,
      this.totalAmount,
      this.billURL,
      this.paymentType,

      );

  @override
  String toString() {
    return 'OrdersModel{key: $key, customerId: $customerId, customerName: $customerName, customerMobile: $customerMobile, customerEmail: $customerEmail, categoryId: $categoryId, categoryName: $categoryName, vendorId: $vendorId, vendorName: $vendorName, vendorLatitude: $vendorLatitude, vendorLongitude: $vendorLongitude, itemsListStr: $itemsListStr, itemsListImageURL: $itemsListImageURL, isByCall: $isByCall, isImgSelected: $isImgSelected, customerDeliveryLatitude: $customerDeliveryLatitude, customerDeliveryLongitude: $customerDeliveryLongitude, customerDeliveryFullAddress: $customerDeliveryFullAddress, customerDeliveryPinCode: $customerDeliveryPinCode, orderType: $orderType, orderID: $orderID, orderCreatedDate: $orderCreatedDate, orderStatus: $orderStatus, deliveryManId: $deliveryManId, deliveryManMobileNumber: $deliveryManMobileNumber, deliveryManName: $deliveryManName, deliveryManNotes: $deliveryManNotes}';
  }
}
