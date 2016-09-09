Pod::Spec.new do |s|
  s.name             = 'Colorblinds'
  s.version          = '1.0.8'
  s.summary          = 'Colorblinds is an easy to use library so simulate color blindness in your app.'

  s.description      = <<-DESC
Colorblinds is a easy to use library to simulate color blindness within your app. The feature can be easily activated with a 3-tap gesture.
                       DESC

  s.homepage         = 'https://github.com/jordidekock/Colorblinds'
  s.screenshots     = 'https://github.com/jordidekock/Colorblinds/blob/master/screen1.PNG, 'https://github.com/jordidekock/Colorblinds/blob/master/screen2.PNG'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jordi de Kock' => 'jordidekock@gmail.com' }
  s.source           = { :git => 'https://github.com/jordidekock/Colorblinds.git', :tag => 'v1.0.8' }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*'

end
