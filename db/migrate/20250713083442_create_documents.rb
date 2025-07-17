class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :s3_url
      t.string :s3_key_signed
      t.string :signed_url
      t.string :status

      t.timestamps
    end
  end
end
