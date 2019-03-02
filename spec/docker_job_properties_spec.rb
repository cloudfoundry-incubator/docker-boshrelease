# frozen_string_literal: true

require 'rspec'
require 'spec_helper'
require 'tempfile'
require 'open3'

describe 'docker job_properties.sh' do
  context "when http proxy settings have '$' in their passwords" do
    let(:properties) do
      {
        'env' => {
          'http_proxy'  => "http://user:pa$word@127.0.0.1:1234",
          'https_proxy' => "https://user:pa$word@127.0.0.1:1234",
        }
      }
    end

    it "does not try to interpolate it in bash" do
      script = compiled_template('docker', 'bin/job_properties.sh', properties, {})
      expect(script).to include("HTTP_PROXY='#{properties['env']['http_proxy']}'")
      expect(script).to include("http_proxy='#{properties['env']['http_proxy']}'")
      expect(script).to include("HTTPS_PROXY='#{properties['env']['https_proxy']}'")
      expect(script).to include("https_proxy='#{properties['env']['https_proxy']}'")

      file = Tempfile.new('job_properties.sh')
      begin
        # Faking a few BOSH-enforced environment vars...
        file.write("JOB_DIR=/nonsense\n")
        file.write("LOG_DIR=/nonsense\n")
        file.write("RUN_DIR=/nonsense\n")
        file.write("JOB_NAME=docker\n")
        file.write("TMP_DIR=/tmp\n")

        file.write(script)
        file.rewind

        _, stderr, status = Open3.capture3("bash -uc 'source #{file.path}'")
        expect(status.success?).to be_truthy
        expect(stderr).to_not include("unbound variable")
      ensure
        file.close
        file.unlink
      end
    end
  end
end
