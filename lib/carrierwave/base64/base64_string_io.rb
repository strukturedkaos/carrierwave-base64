module Carrierwave
  module Base64
    class Base64StringIO < StringIO
      class ArgumentError < StandardError; end

      attr_accessor :video_format

      def initialize(encoded_video)
        description, encoded_bytes = encoded_video.split(",")

        raise ArgumentError unless encoded_bytes

        @video_format = get_video_format description
        bytes = ::Base64.decode64 encoded_bytes

        super bytes
      end

      def original_filename
        File.basename("video.#{@video_format}")
      end

      private

      def get_video_format(description)
        regex = /\Adata:video\/(\w+);base64\z/i
        regex.match(description).try(:[], 1)
      end
    end
  end
end
