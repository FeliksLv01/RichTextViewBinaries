Pod::Spec.new do |s|
  s.name = 'RichTextViewMathBinary'
  s.version = '2.5.0.2'
  s.summary = 'Binary iosMath distribution for RichTextView'
  s.homepage = 'https://github.com/FeliksLv01/RichTextViewBinaries'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'FeliksLv01' => 'felikslv@163.com' }
  s.source = {
    :http => "https://github.com/FeliksLv01/RichTextViewBinaries/releases/download/iosMath-#{s.version}/iosMath.xcframework.zip",
    :sha256 => 'c7850946f56d479fd3bb0ec0842d1ed3622b26927d8f1016f950e9ccd2a271c7'
  }
  s.ios.deployment_target = '15.0'
  s.vendored_frameworks = 'iosMath.xcframework'
end
