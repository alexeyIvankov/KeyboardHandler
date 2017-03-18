

Pod::Spec.new do |s|


  s.name         = "KeyboardHandler"
  s.version      = "1.0.0"
  s.summary      = "KeyboardHandler framework"
  s.description  = "KeyboardHandler framework"
  s.homepage     = "http://EXAMPLE/KeyboardHandler"
  s.license      = "KeyboardHandler"
  s.author       = { "Ivankov Alexey" => "" }


	s.ios.deployment_target = "8.0"
	s.osx.deployment_target = "10.7"
	s.watchos.deployment_target = "2.0"
	s.tvos.deployment_target = "9.0"


  s.source       = { :git => 'https://github.com/alexeyIvankov/KeyboardHandler.git', :branch => 'master'  }

  s.source_files  = "KeyboardHandler/**/*.{swift, h}"
  s.xcconfig= {"HEADER_SEARCH_PATHS" => '$(PODS_ROOT)/KeyboardHandler'}


end
