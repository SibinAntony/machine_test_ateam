import 'dart:ui';

import 'package:flutter/material.dart';

import 'color.dart';

String googleApiKey = 'AIzaSyApjU9e6B4XB5Z_rXTar29xexmPij43RMw';

bool isValidEmail(String email) {
  String emailRegex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
  return RegExp(emailRegex).hasMatch(email);
}

String orderStatus(String status) {
  String statusOrder = 'haii';
  switch (status) {
    case '1':
      return "Order Pending";
    case '2':
      return "Order Accepted";
    case '3':
      return "Order is In Progress";
    case '4':
      return "Order Picked";
    case '5':
      return "On the way";
    case '6':
      return "Completed";
    case '7':
      return "Cancelled";
  }

  return statusOrder;
}

Color orderStatusColor(String status) {
  switch (status) {
    case '1':
      return orderPending;
    case '2':
      return orderAccepted;
    case '3':
      return orderInProgress;
    case '4':
      return orderCompleted;
    case '5':
      return orderCompleted;
    case '6':
      return orderCompleted;
    case '7':
      return orderPending;
  }

  return orderPending;
}
