Pod::Spec.new do |s|
  s.name      = 'BDBPopupViewController'
  s.version   = '1.1'
  s.license   = 'MIT'
  s.summary   = 'A UIViewController category for presenting custom view controllers modally.'
  s.homepage  = 'https://github.com/bdbergeron/BDBPopupViewController'
  s.authors   = { 'Bradley David Bergeron' => 'brad@bradbergeron.com' }
  s.source    = { :git => 'https://github.com/bdbergeron/BDBPopupViewController.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.platform = :ios, '6.0'
  
  s.source_files = 'BDBPopupViewController/*.{h,m}'  

  s.dependency 'AHEasing', '~> 1.2'
end
