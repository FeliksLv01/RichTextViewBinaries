Pod::Spec.new do |s|
  s.name = 'RichTextViewMathBinary'
  s.version = '2.5.0.1'
  s.summary = 'Binary iosMath distribution for RichTextView'
  s.homepage = 'https://github.com/FeliksLv01/RichTextViewBinaries'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'FeliksLv01' => 'felikslv@163.com' }
  s.source = {
    :http => "https://github.com/FeliksLv01/RichTextViewBinaries/releases/download/iosMath-#{s.version}/iosMath.xcframework.zip",
    :sha256 => '71b31789af1911f47e820d0c00367bf98837ce462217a93c5a07b7ecaa49a260'
  }
  s.ios.deployment_target = '15.0'
  s.vendored_frameworks = 'iosMath.xcframework'
end
