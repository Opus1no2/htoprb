# frozen_string_literal: true

require_relative 'lib/htoprb/version'

Gem::Specification.new do |spec|
  spec.name = 'htoprb'
  spec.version = Htoprb::VERSION
  spec.authors = ['Opus1no2']
  spec.email = ['travis@travistillotson.com']

  spec.summary = 'htop clone'
  spec.description = 'htop ruby clone'
  spec.homepage = 'https://github.com/Opus1no2/htoprb'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.2'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Opus1no2/htoprb'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.executables << 'htoprb'
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'rubocop', '1.43.0'

  spec.add_dependency 'curses', '1.4.4'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
