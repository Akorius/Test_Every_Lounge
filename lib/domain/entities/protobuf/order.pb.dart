//
//  Generated code. Do not modify.
//  source: order.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $1;
import 'order.pbenum.dart';

export 'order.pbenum.dart';

class Order extends $pb.GeneratedMessage {
  factory Order({
    $core.int? id,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.String? airport,
    $core.double? amount,
    $core.String? payId,
    $core.int? serviceId,
    $core.String? serviceName,
    OrderStatus? status,
    $core.String? contactName,
    Contact? contact,
    $core.Iterable<$core.String>? fines,
    $core.String? internalId,
    $core.Iterable<OrderPassenger>? passengers,
    Image? qr,
    $core.String? organization,
    $core.String? validTill,
    AcquiringType? acquiringType,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (airport != null) {
      $result.airport = airport;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (payId != null) {
      $result.payId = payId;
    }
    if (serviceId != null) {
      $result.serviceId = serviceId;
    }
    if (serviceName != null) {
      $result.serviceName = serviceName;
    }
    if (status != null) {
      $result.status = status;
    }
    if (contactName != null) {
      $result.contactName = contactName;
    }
    if (contact != null) {
      $result.contact = contact;
    }
    if (fines != null) {
      $result.fines.addAll(fines);
    }
    if (internalId != null) {
      $result.internalId = internalId;
    }
    if (passengers != null) {
      $result.passengers.addAll(passengers);
    }
    if (qr != null) {
      $result.qr = qr;
    }
    if (organization != null) {
      $result.organization = organization;
    }
    if (validTill != null) {
      $result.validTill = validTill;
    }
    if (acquiringType != null) {
      $result.acquiringType = acquiringType;
    }
    return $result;
  }
  Order._() : super();
  factory Order.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Order.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Order', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'createdAt', protoName: 'createdAt', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'updatedAt', protoName: 'updatedAt', subBuilder: $1.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'airport')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OF)
    ..aOS(6, _omitFieldNames ? '' : 'payId')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'serviceId', $pb.PbFieldType.O3)
    ..aOS(8, _omitFieldNames ? '' : 'serviceName')
    ..e<OrderStatus>(9, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: OrderStatus.Created, valueOf: OrderStatus.valueOf, enumValues: OrderStatus.values)
    ..aOS(10, _omitFieldNames ? '' : 'contactName')
    ..aOM<Contact>(11, _omitFieldNames ? '' : 'contact', subBuilder: Contact.create)
    ..pPS(12, _omitFieldNames ? '' : 'fines')
    ..aOS(13, _omitFieldNames ? '' : 'internalId')
    ..pc<OrderPassenger>(14, _omitFieldNames ? '' : 'passengers', $pb.PbFieldType.PM, subBuilder: OrderPassenger.create)
    ..aOM<Image>(15, _omitFieldNames ? '' : 'qr', subBuilder: Image.create)
    ..aOS(16, _omitFieldNames ? '' : 'organization')
    ..aOS(17, _omitFieldNames ? '' : 'validTill')
    ..e<AcquiringType>(18, _omitFieldNames ? '' : 'acquiringType', $pb.PbFieldType.OE, protoName: 'acquiringType', defaultOrMaker: AcquiringType.Unknown, valueOf: AcquiringType.valueOf, enumValues: AcquiringType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Order clone() => Order()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Order copyWith(void Function(Order) updates) => super.copyWith((message) => updates(message as Order)) as Order;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Order create() => Order._();
  Order createEmptyInstance() => create();
  static $pb.PbList<Order> createRepeated() => $pb.PbList<Order>();
  @$core.pragma('dart2js:noInline')
  static Order getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Order>(create);
  static Order? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get createdAt => $_getN(1);
  @$pb.TagNumber(2)
  set createdAt($1.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureCreatedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Timestamp get updatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set updatedAt($1.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatedAt() => clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureUpdatedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get airport => $_getSZ(3);
  @$pb.TagNumber(4)
  set airport($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAirport() => $_has(3);
  @$pb.TagNumber(4)
  void clearAirport() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get amount => $_getN(4);
  @$pb.TagNumber(5)
  set amount($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAmount() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmount() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get payId => $_getSZ(5);
  @$pb.TagNumber(6)
  set payId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPayId() => $_has(5);
  @$pb.TagNumber(6)
  void clearPayId() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get serviceId => $_getIZ(6);
  @$pb.TagNumber(7)
  set serviceId($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasServiceId() => $_has(6);
  @$pb.TagNumber(7)
  void clearServiceId() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get serviceName => $_getSZ(7);
  @$pb.TagNumber(8)
  set serviceName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasServiceName() => $_has(7);
  @$pb.TagNumber(8)
  void clearServiceName() => clearField(8);

  @$pb.TagNumber(9)
  OrderStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(OrderStatus v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get contactName => $_getSZ(9);
  @$pb.TagNumber(10)
  set contactName($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasContactName() => $_has(9);
  @$pb.TagNumber(10)
  void clearContactName() => clearField(10);

  @$pb.TagNumber(11)
  Contact get contact => $_getN(10);
  @$pb.TagNumber(11)
  set contact(Contact v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasContact() => $_has(10);
  @$pb.TagNumber(11)
  void clearContact() => clearField(11);
  @$pb.TagNumber(11)
  Contact ensureContact() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.List<$core.String> get fines => $_getList(11);

  @$pb.TagNumber(13)
  $core.String get internalId => $_getSZ(12);
  @$pb.TagNumber(13)
  set internalId($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasInternalId() => $_has(12);
  @$pb.TagNumber(13)
  void clearInternalId() => clearField(13);

  @$pb.TagNumber(14)
  $core.List<OrderPassenger> get passengers => $_getList(13);

  @$pb.TagNumber(15)
  Image get qr => $_getN(14);
  @$pb.TagNumber(15)
  set qr(Image v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasQr() => $_has(14);
  @$pb.TagNumber(15)
  void clearQr() => clearField(15);
  @$pb.TagNumber(15)
  Image ensureQr() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get organization => $_getSZ(15);
  @$pb.TagNumber(16)
  set organization($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasOrganization() => $_has(15);
  @$pb.TagNumber(16)
  void clearOrganization() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get validTill => $_getSZ(16);
  @$pb.TagNumber(17)
  set validTill($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasValidTill() => $_has(16);
  @$pb.TagNumber(17)
  void clearValidTill() => clearField(17);

  @$pb.TagNumber(18)
  AcquiringType get acquiringType => $_getN(17);
  @$pb.TagNumber(18)
  set acquiringType(AcquiringType v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasAcquiringType() => $_has(17);
  @$pb.TagNumber(18)
  void clearAcquiringType() => clearField(18);
}

class OrderPassenger extends $pb.GeneratedMessage {
  factory OrderPassenger({
    $core.String? fistName,
    $core.String? lastName,
    $core.String? middleName,
    $core.int? age,
  }) {
    final $result = create();
    if (fistName != null) {
      $result.fistName = fistName;
    }
    if (lastName != null) {
      $result.lastName = lastName;
    }
    if (middleName != null) {
      $result.middleName = middleName;
    }
    if (age != null) {
      $result.age = age;
    }
    return $result;
  }
  OrderPassenger._() : super();
  factory OrderPassenger.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OrderPassenger.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OrderPassenger', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fistName')
    ..aOS(2, _omitFieldNames ? '' : 'lastName')
    ..aOS(3, _omitFieldNames ? '' : 'middleName')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'age', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OrderPassenger clone() => OrderPassenger()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OrderPassenger copyWith(void Function(OrderPassenger) updates) => super.copyWith((message) => updates(message as OrderPassenger)) as OrderPassenger;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderPassenger create() => OrderPassenger._();
  OrderPassenger createEmptyInstance() => create();
  static $pb.PbList<OrderPassenger> createRepeated() => $pb.PbList<OrderPassenger>();
  @$core.pragma('dart2js:noInline')
  static OrderPassenger getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderPassenger>(create);
  static OrderPassenger? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fistName => $_getSZ(0);
  @$pb.TagNumber(1)
  set fistName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFistName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFistName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastName => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLastName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get middleName => $_getSZ(2);
  @$pb.TagNumber(3)
  set middleName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMiddleName() => $_has(2);
  @$pb.TagNumber(3)
  void clearMiddleName() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get age => $_getIZ(3);
  @$pb.TagNumber(4)
  set age($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAge() => $_has(3);
  @$pb.TagNumber(4)
  void clearAge() => clearField(4);
}

class Contact extends $pb.GeneratedMessage {
  factory Contact({
    $core.String? name,
    $core.String? phone,
    $core.String? email,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (phone != null) {
      $result.phone = phone;
    }
    if (email != null) {
      $result.email = email;
    }
    return $result;
  }
  Contact._() : super();
  factory Contact.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Contact.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Contact', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'phone')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Contact clone() => Contact()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Contact copyWith(void Function(Contact) updates) => super.copyWith((message) => updates(message as Contact)) as Contact;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Contact create() => Contact._();
  Contact createEmptyInstance() => create();
  static $pb.PbList<Contact> createRepeated() => $pb.PbList<Contact>();
  @$core.pragma('dart2js:noInline')
  static Contact getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Contact>(create);
  static Contact? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get phone => $_getSZ(1);
  @$pb.TagNumber(2)
  set phone($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPhone() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhone() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => clearField(3);
}

class Image extends $pb.GeneratedMessage {
  factory Image({
    $core.int? id,
    $core.String? url,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (url != null) {
      $result.url = url;
    }
    return $result;
  }
  Image._() : super();
  factory Image.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Image.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Image', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Image clone() => Image()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Image copyWith(void Function(Image) updates) => super.copyWith((message) => updates(message as Image)) as Image;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Image create() => Image._();
  Image createEmptyInstance() => create();
  static $pb.PbList<Image> createRepeated() => $pb.PbList<Image>();
  @$core.pragma('dart2js:noInline')
  static Image getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Image>(create);
  static Image? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get url => $_getSZ(1);
  @$pb.TagNumber(2)
  set url($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearUrl() => clearField(2);
}

class ErrorMessage extends $pb.GeneratedMessage {
  factory ErrorMessage({
    $core.String? message,
  }) {
    final $result = create();
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  ErrorMessage._() : super();
  factory ErrorMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ErrorMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ErrorMessage', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ErrorMessage clone() => ErrorMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ErrorMessage copyWith(void Function(ErrorMessage) updates) => super.copyWith((message) => updates(message as ErrorMessage)) as ErrorMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorMessage create() => ErrorMessage._();
  ErrorMessage createEmptyInstance() => create();
  static $pb.PbList<ErrorMessage> createRepeated() => $pb.PbList<ErrorMessage>();
  @$core.pragma('dart2js:noInline')
  static ErrorMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ErrorMessage>(create);
  static ErrorMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);
}

class UpdateOrderRequest extends $pb.GeneratedMessage {
  factory UpdateOrderRequest({
    $core.String? token,
    $core.int? id,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  UpdateOrderRequest._() : super();
  factory UpdateOrderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateOrderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateOrderRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateOrderRequest clone() => UpdateOrderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateOrderRequest copyWith(void Function(UpdateOrderRequest) updates) => super.copyWith((message) => updates(message as UpdateOrderRequest)) as UpdateOrderRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateOrderRequest create() => UpdateOrderRequest._();
  UpdateOrderRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateOrderRequest> createRepeated() => $pb.PbList<UpdateOrderRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateOrderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateOrderRequest>(create);
  static UpdateOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get id => $_getIZ(1);
  @$pb.TagNumber(2)
  set id($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
