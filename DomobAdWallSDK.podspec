Pod::Spec.new do |s|
    s.name = 'DomobAdWallSDK'
    s.version = '1.0.5'
    s.license = 'Domob'
    s.summary = 'iOS SDK for Domob AdWall'
    s.homepage = 'http://www.domob.cn/'
    s.author = { 'Domob' => 'support@domob.com' }
    s.source = { :git => 'https://github.com/gaoyz/DomobAdWallSDK.git', :tag => '1.0.5' }
    s.description = "iOS SDK for Domob AdWall"
    s.platform = :ios
    s.source_files = '*.h','Header/*.h','Header/UI/*.h','Classes/Contollers/*.h','Classes/Controls/*.h','Classes/Controls/HMSegmentedControl/*.h','Classes/Controls/SDWebImage/*.h','Classes/Utils/*.h'
    s.preserve_paths = '*.a'
    s.libraries = 'DomobAdWallCoreSDK'
    s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/DomobAdWallSDK"' }
    s.frameworks = 'CFNetwork', 'CoreTelephony', 'MessageUI', 'Security', 'SystemConfiguration', 'CoreGraphics'
    s.weak_frameworks = 'AdSupport', 'StoreKit'
    s.resources = 'DMAdWallBundle.bundle'
end