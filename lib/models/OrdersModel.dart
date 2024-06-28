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
      );
}
