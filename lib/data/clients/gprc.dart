import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/entities/protobuf/order.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class Grpc {
  final ClientChannel channel = ClientChannel(
    production ? ApiClient.prodHost : ApiClient.devHost,
    port: production ? 50051 : 50054,
    options: const ChannelOptions(
      credentials: production ? ChannelCredentials.secure() : ChannelCredentials.insecure(),
    ),
  );
}

class OrderGrpcService {
  final Grpc _grpc = getIt();

  Stream<Order> orderStream(UpdateOrderRequest request) {
    return OrderHandlerClient(_grpc.channel).updateOrder(request);
  }
}
