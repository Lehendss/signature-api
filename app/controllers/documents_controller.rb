class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :signature]

  def create
    @document = Document.create!(document_params.merge(status: 'pending'))
    render json: @document, status: :created
  end

  def show
    render json: @document
  end

  def signature
    client = SignerClient.new
    reply = client.sign_pdf(
      s3_url:     @document.s3_url,
      output_key: @document.s3_key_signed
    )

    if reply.success
      @document.update!(signed_url: reply.signed_url, status: 'signed')
      render json: @document
    else
      render json: { error: reply_error }, status: :unprocessable_entity
    end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.required(:document).permit(:name, :s3_url, :s3_key_signed)
  end

end
