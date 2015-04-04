require "spec_helper"

RSpec.describe Carrierwave::Base64::Base64StringIO do
  context "correct video data" do
    let(:video_data) { "data:video/mov;base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q==" }
    subject { described_class.new video_data }

    it "determines the video format from the Dara URI scheme" do
      expect(subject.video_format).to eql("mov")
    end

    it "should respond to :original_filename" do
      expect(subject.original_filename).to eql("video.mov")
    end
  end

  context "incorrect video data" do
    it "raises an ArgumentError if Data URI scheme format is missing" do
      expect do
        described_class.new("/9j/4AAQSkZJRgABAQEASABIAADKdhH//2Q==")
      end.to raise_error(Carrierwave::Base64::Base64StringIO::ArgumentError)
    end
  end
end
