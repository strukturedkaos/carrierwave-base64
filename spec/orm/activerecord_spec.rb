require "spec_helper"

require "carrierwave/base64/orm/activerecord"

RSpec.describe Carrierwave::Base64::ActiveRecord do
  describe ".mount_base64_uploader" do
    let(:uploader) { Class.new CarrierWave::Uploader::Base }

    subject do
      Post.mount_base64_uploader(:video, uploader)
      Post.new
    end

    it "mounts the uploader on the video field" do
      expect(subject.video).to be_an_instance_of(uploader)
    end

    it "handles normal file uploads" do
      sham_rack_app = ShamRack.at('www.example.com').stub
      sham_rack_app.register_resource("/test.mov", file_path("fixtures", "test.mov"), "videos/mov")
      subject[:video] = "test.mov"
      subject.save!
      subject.reload
      expect(subject.video.current_path).to eq file_path("../uploads", "test.mov")
    end

    it "handles data-urls" do
      subject.video = File.read(file_path("fixtures", "base64_video.fixture")).strip
      subject.save!
      subject.reload
      expect(subject.video.current_path).to eq file_path("../uploads", "video.mov")
    end
  end
end
