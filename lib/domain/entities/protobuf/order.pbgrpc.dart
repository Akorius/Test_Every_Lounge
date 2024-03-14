//
//  Generated code. Do not modify.
//  source: order.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'order.pb.dart' as $0;

export 'order.pb.dart';

@$pb.GrpcServiceName('OrderHandler')
class OrderHandlerClient extends $grpc.Client {
  static final _$updateOrder = $grpc.ClientMethod<$0.UpdateOrderRequest, $0.Order>(
      '/OrderHandler/UpdateOrder',
      ($0.UpdateOrderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Order.fromBuffer(value));

  OrderHandlerClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.Order> updateOrder($0.UpdateOrderRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$updateOrder, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('OrderHandler')
abstract class OrderHandlerServiceBase extends $grpc.Service {
  $core.String get $name => 'OrderHandler';

  OrderHandlerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.UpdateOrderRequest, $0.Order>(
        'UpdateOrder',
        updateOrder_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.UpdateOrderRequest.fromBuffer(value),
        ($0.Order value) => value.writeToBuffer()));
  }

  $async.Stream<$0.Order> updateOrder_Pre($grpc.ServiceCall call, $async.Future<$0.UpdateOrderRequest> request) async* {
    yield* updateOrder(call, await request);
  }

  $async.Stream<$0.Order> updateOrder($grpc.ServiceCall call, $0.UpdateOrderRequest request);
}
