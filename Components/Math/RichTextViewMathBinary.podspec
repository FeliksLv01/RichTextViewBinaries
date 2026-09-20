Pod::Spec.new do |s|
  s.name = 'RichTextViewMathBinary'
  s.version = '2.5.0.1'
  s.summary = 'Binary iosMath distribution for RichTextView'
  s.homepage = 'https://github.com/FeliksLv01/RichTextViewBinaries'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'FeliksLv01' => 'felikslv@163.com' }
  s.source = {
    :http => "https://github.com/FeliksLv01/RichTextViewBinaries/releases/download/iosMath-#{s.version}/iosMath.xcframework.zip",
    :sha256 => '7df8ca162ecdfdedf2ee25e68b737ec9777b7a92aaa7a529fe856e1f12c9e55d'
  }
  s.ios.deployment_target = '15.0'
  s.vendored_frameworks = 'iosMath.xcframework'
end
