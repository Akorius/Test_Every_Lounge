//
//  Generated code. Do not modify.
//  source: order.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use acquiringTypeDescriptor instead')
const AcquiringType$json = {
  '1': 'AcquiringType',
  '2': [
    {'1': 'Unknown', '2': 0},
    {'1': 'Passages', '2': 1},
    {'1': 'Tinkoff', '2': 2},
    {'1': 'Alfa', '2': 3},
  ],
};

/// Descriptor for `AcquiringType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List acquiringTypeDescriptor = $convert.base64Decode(
    'Cg1BY3F1aXJpbmdUeXBlEgsKB1Vua25vd24QABIMCghQYXNzYWdlcxABEgsKB1RpbmtvZmYQAh'
    'IICgRBbGZhEAM=');

@$core.Deprecated('Use orderStatusDescriptor instead')
const OrderStatus$json = {
  '1': 'OrderStatus',
  '2': [
    {'1': 'Created', '2': 0},
    {'1': 'Confirmed', '2': 1},
    {'1': 'Paid', '2': 2},
    {'1': 'Completed', '2': 3},
    {'1': 'Cancelled', '2': 4},
    {'1': 'InitPay', '2': 5},
    {'1': 'BankPaid', '2': 6},
    {'1': 'Visited', '2': 7},
    {'1': 'Expired', '2': 8},
  ],
};

/// Descriptor for `OrderStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderStatusDescriptor = $convert.base64Decode(
    'CgtPcmRlclN0YXR1cxILCgdDcmVhdGVkEAASDQoJQ29uZmlybWVkEAESCAoEUGFpZBACEg0KCU'
    'NvbXBsZXRlZBADEg0KCUNhbmNlbGxlZBAEEgsKB0luaXRQYXkQBRIMCghCYW5rUGFpZBAGEgsK'
    'B1Zpc2l0ZWQQBxILCgdFeHBpcmVkEAg=');

@$core.Deprecated('Use orderDescriptor instead')
const Order$json = {
  '1': 'Order',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'createdAt', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updatedAt', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'airport', '3': 4, '4': 1, '5': 9, '10': 'airport'},
    {'1': 'amount', '3': 5, '4': 1, '5': 2, '10': 'amount'},
    {'1': 'pay_id', '3': 6, '4': 1, '5': 9, '9': 0, '10': 'payId', '17': true},
    {'1': 'service_id', '3': 7, '4': 1, '5': 5, '10': 'serviceId'},
    {'1': 'service_name', '3': 8, '4': 1, '5': 9, '10': 'serviceName'},
    {'1': 'status', '3': 9, '4': 1, '5': 14, '6': '.OrderStatus', '10': 'status'},
    {'1': 'contact_name', '3': 10, '4': 1, '5': 9, '10': 'contactName'},
    {'1': 'contact', '3': 11, '4': 1, '5': 11, '6': '.Contact', '10': 'contact'},
    {'1': 'fines', '3': 12, '4': 3, '5': 9, '10': 'fines'},
    {'1': 'internal_id', '3': 13, '4': 1, '5': 9, '10': 'internalId'},
    {'1': 'passengers', '3': 14, '4': 3, '5': 11, '6': '.OrderPassenger', '10': 'passengers'},
    {'1': 'qr', '3': 15, '4': 1, '5': 11, '6': '.Image', '9': 1, '10': 'qr', '17': true},
    {'1': 'organization', '3': 16, '4': 1, '5': 9, '10': 'organization'},
    {'1': 'valid_till', '3': 17, '4': 1, '5': 9, '10': 'validTill'},
    {'1': 'acquiringType', '3': 18, '4': 1, '5': 14, '6': '.AcquiringType', '9': 2, '10': 'acquiringType', '17': true},
  ],
  '8': [
    {'1': '_pay_id'},
    {'1': '_qr'},
    {'1': '_acquiringType'},
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode(
    'CgVPcmRlchIOCgJpZBgBIAEoBVICaWQSOAoJY3JlYXRlZEF0GAIgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjgKCXVwZGF0ZWRBdBgDIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBIYCgdhaXJwb3J0GAQgASgJUgdhaXJwb3J0Eh'
    'YKBmFtb3VudBgFIAEoAlIGYW1vdW50EhoKBnBheV9pZBgGIAEoCUgAUgVwYXlJZIgBARIdCgpz'
    'ZXJ2aWNlX2lkGAcgASgFUglzZXJ2aWNlSWQSIQoMc2VydmljZV9uYW1lGAggASgJUgtzZXJ2aW'
    'NlTmFtZRIkCgZzdGF0dXMYCSABKA4yDC5PcmRlclN0YXR1c1IGc3RhdHVzEiEKDGNvbnRhY3Rf'
    'bmFtZRgKIAEoCVILY29udGFjdE5hbWUSIgoHY29udGFjdBgLIAEoCzIILkNvbnRhY3RSB2Nvbn'
    'RhY3QSFAoFZmluZXMYDCADKAlSBWZpbmVzEh8KC2ludGVybmFsX2lkGA0gASgJUgppbnRlcm5h'
    'bElkEi8KCnBhc3NlbmdlcnMYDiADKAsyDy5PcmRlclBhc3NlbmdlclIKcGFzc2VuZ2VycxIbCg'
    'JxchgPIAEoCzIGLkltYWdlSAFSAnFyiAEBEiIKDG9yZ2FuaXphdGlvbhgQIAEoCVIMb3JnYW5p'
    'emF0aW9uEh0KCnZhbGlkX3RpbGwYESABKAlSCXZhbGlkVGlsbBI5Cg1hY3F1aXJpbmdUeXBlGB'
    'IgASgOMg4uQWNxdWlyaW5nVHlwZUgCUg1hY3F1aXJpbmdUeXBliAEBQgkKB19wYXlfaWRCBQoD'
    'X3FyQhAKDl9hY3F1aXJpbmdUeXBl');

@$core.Deprecated('Use orderPassengerDescriptor instead')
const OrderPassenger$json = {
  '1': 'OrderPassenger',
  '2': [
    {'1': 'fist_name', '3': 1, '4': 1, '5': 9, '10': 'fistName'},
    {'1': 'last_name', '3': 2, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'middle_name', '3': 3, '4': 1, '5': 9, '10': 'middleName'},
    {'1': 'age', '3': 4, '4': 1, '5': 5, '10': 'age'},
  ],
};

/// Descriptor for `OrderPassenger`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderPassengerDescriptor = $convert.base64Decode(
    'Cg5PcmRlclBhc3NlbmdlchIbCglmaXN0X25hbWUYASABKAlSCGZpc3ROYW1lEhsKCWxhc3Rfbm'
    'FtZRgCIAEoCVIIbGFzdE5hbWUSHwoLbWlkZGxlX25hbWUYAyABKAlSCm1pZGRsZU5hbWUSEAoD'
    'YWdlGAQgASgFUgNhZ2U=');

@$core.Deprecated('Use contactDescriptor instead')
const Contact$json = {
  '1': 'Contact',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'phone', '3': 2, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `Contact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactDescriptor = $convert.base64Decode(
    'CgdDb250YWN0EhIKBG5hbWUYASABKAlSBG5hbWUSFAoFcGhvbmUYAiABKAlSBXBob25lEhQKBW'
    'VtYWlsGAMgASgJUgVlbWFpbA==');

@$core.Deprecated('Use imageDescriptor instead')
const Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'url', '3': 2, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `Image`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageDescriptor = $convert.base64Decode(
    'CgVJbWFnZRIOCgJpZBgBIAEoBVICaWQSEAoDdXJsGAIgASgJUgN1cmw=');

@$core.Deprecated('Use errorMessageDescriptor instead')
const ErrorMessage$json = {
  '1': 'ErrorMessage',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `ErrorMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorMessageDescriptor = $convert.base64Decode(
    'CgxFcnJvck1lc3NhZ2USGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZQ==');

@$core.Deprecated('Use updateOrderRequestDescriptor instead')
const UpdateOrderRequest$json = {
  '1': 'UpdateOrderRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'id', '3': 2, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `UpdateOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateOrderRequestDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVPcmRlclJlcXVlc3QSFAoFdG9rZW4YASABKAlSBXRva2VuEg4KAmlkGAIgASgFUg'
    'JpZA==');

