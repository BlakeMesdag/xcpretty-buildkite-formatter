require 'test_helper'

class BuildkiteFormatterTest < Minitest::Test
  def setup
    ENV['BUILDKITE_ARTIFACT_PATHS'] ||= File.expand_path('../tmp', __FILE__)
    @formatter = ::BuildkiteFormatter.new(false, false)
    @formatter.stubs(:buildkite?).returns(true)
  end

  def test_that_it_has_a_version_number
    refute_nil ::BuildkiteFormatter::VERSION
  end

  def test_uploads_artifacts
    Kernel.expects(:system).with('buildkite-agent', 'artifact', 'upload', 'some_file.png').returns
    Kernel.expects(:system).with('buildkite-agent', 'artifact', 'upload', 'some_other_file.png').returns

    @formatter.upload_artifacts('some_file.png', 'some_other_file.png')
  end

  def test_inlines_artifacts
    File.expects(:read).with('some_file.png').returns('some content')

    STDOUT.expects(:puts).with("\e]1337;File=name=c29tZV9maWxlLnBuZw==;inline=1:c29tZSBjb250ZW50\a")

    @formatter.inline_artifacts("some_file.png")
  end

  def test_pretty_format_uploads_artifacts
    @formatter.expects(:upload_artifacts).with("reference_file.png", "failed_file.png")
    @formatter.stubs(:inline_artifacts).returns(true)

    @formatter.pretty_format(ksdiff_text)
  end

  def test_pretty_format_inlines_artifacts_on_buildkite
    @formatter.stubs(:upload_artifacts).returns(true)
    @formatter.expects(:inline_artifacts).with("reference_file.png", "failed_file.png")

    @formatter.pretty_format(ksdiff_text)
  end

  def test_not_on_buildkite
    @formatter.unstub(:buildkite?)

    STDOUT.expects(:puts).with("\e[33mNot on Buildkite, would have uploaded: \n  reference_file.png\n  failed_file.png\e[0m")

    @formatter.pretty_format(ksdiff_text)
  end

  private

  def ksdiff_text
    @@ksdiff_text ||= File.read(File.expand_path('fixtures/ksdiff.txt', File.dirname(__FILE__)))
  end
end
