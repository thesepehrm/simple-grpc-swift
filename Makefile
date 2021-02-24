
BIN_PATH=/opt/homebrew/bin
PROTOC_GEN_SWIFT=${BIN_PATH}/protoc-gen-swift
PROTOC_GEN_GRPC_SWIFT=${BIN_PATH}/protoc-gen-grpc-swift

MODEL_PATH=simple-grpc-swift/model

generate:
	protoc ${MODEL_PATH}/update.proto \
	--plugin=${PROTOC_GEN_SWIFT} \
	--swift_opt=Visibility=Public \
	--swift_out=${MODEL_PATH} \
	--plugin=${PROTOC_GEN_GRPC_SWIFT} \
	--grpc-swift_opt=Visibility=Public \
	--grpc-swift_out=${MODEL_PATH}
