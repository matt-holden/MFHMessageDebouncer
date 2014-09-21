#
# Be sure to run `pod lib lint MFHMessageDebouncer.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MFHMessageDebouncer"
  s.version          = "0.1.2"
  s.summary          = "Message debouncing in a syntactically sweet fashion"
  s.description      = <<-DESC
                       [[myObject debounceWithDelay:5] doSomething:@1];
                       [[myObject debounceWithDelay:5] doSomething:@2];
                       [[myObject debounceWithDelay:5] doSomething:@3];

                       // ^ my Object only receive the final message send in this sequence,
                       // receiving `@3` for the `doSomething` argument.

                       DESC
  s.homepage         = "https://github.com/matt-holden/MFHMessageDebouncer"
  s.license          = 'MIT'
  s.author           = { "Matthew Holden" => "matthew.holden@mindbodyonline.com" }
  s.source           = { :git => "https://github.com/matt-holden/MFHMessageDebouncer.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/@MFHolden'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  #s.resource_bundles = {
    #'MFHMessageDebouncer' => ['Pod/Assets/*.png']
  #}

  # intentional breakage:
  # notice that the public_header_files key is wrong?
  s.public_header_files = 'Pod/Classes/MFHMessageDebouncer.h'
  s.frameworks = 'Foundation'
end
