require 'xcpretty'
require 'base64'

class BuildkiteFormatter < XCPretty::Simple
  KSDIFF_MATCHER = /^ksdiff \"(.*)\"\s\"(.*)\"/

  def pretty_format(text)
    if KSDIFF_MATCHER.match(text)
      if buildkite?
        upload_artifacts($1, $2)
        inline_artifacts($1, $2)
      else
        STDOUT.puts("\e[33mNot on Buildkite, would have uploaded: \n  #{$1}\n  #{$2}\e[0m")
      end
    end

    parser.parse(text)
  end

  def inline_artifacts(*artifacts)
    artifacts.each do |artifact|
      image_contents = Base64.encode64(File.read(artifact)).gsub("\n", '')
      image_name = Base64.encode64(File.basename(artifact)).gsub("\n", '')

      STDOUT.puts("\e]1337;File=name=#{image_name};inline=1:#{image_contents}\a")
    end
  end

  def upload_artifacts(*artifacts)
    artifacts.each do |artifact|
      Kernel.system('buildkite-agent', 'artifact', 'upload', artifact)
    end
  end

  def buildkite?
    !!ENV['BUILDKITE']
  end
end

BuildkiteFormatter
