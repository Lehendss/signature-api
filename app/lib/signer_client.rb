require "grpc"
require_relative "../../lib/signer_pb"
require_relative "../../lib/signer_services_pb"
require "ostruct"

class SignerClient
  def initialize(host = ENV.fetch("SIGNER_HOST", "signer:50051"))
    @stub = Signer::Signer::Stub.new(host, :this_channel_is_insecure)
  end

  def sign_pdf(s3_url:, output_key:)
    req = Signer::SignRequest.new(s3_url: s3_url, output_key: output_key)
    @stub.sign_pdf(req)
  rescue GRPC::BadStatus => e
    Rails.logger.error("gRPC SignPdf error: #{e.message}")
    OpenStruct.new(success: false, signed_url: nil, error: e.message)
  end
end
