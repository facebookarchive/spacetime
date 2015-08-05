Pod::Spec.new do |spec|
  spec.name         = 'spacetime'
  spec.version      = '0.0.1'
  spec.license      =  { :type => 'BSD' }
  spec.homepage     = 'https://github.com/facebookexperimental/spacetime'
  spec.authors      = { 'Grant Paul' => 'shimmer@grantpaul.com' }
  spec.summary      = 'Experimental library for transforming parts of layers.'
  spec.source       = { :git => 'https://github.com/facebookexperimental/spacetime.git', :tag => '0.0.1' }
  spec.source_files = 'spacetime/STCMesh{View,Layer}.{h,m}'
  spec.requires_arc = true
  
  spec.ios.deployment_target = '6.0'
end
