all:
	# если файлы существуют, удаляем
	if ls ./lib/domain/entities/protobuf/*pb*dart 1> /dev/null 2>&1; then rm -r ./lib/domain/entities/protobuf/*pb*dart; fi;
	# если папка не существует, создаём
	# if [ ! -d ./lib/generated ]; then	mkdir ./lib/generated; fi;
	# генерируем proto
	protoc --proto_path=proto proto/*.proto --dart_out=grpc:lib/domain/entities/protobuf --experimental_allow_proto3_optional
	protoc --proto_path=proto proto/google/protobuf/*.proto --dart_out=grpc:lib/domain/entities/protobuf