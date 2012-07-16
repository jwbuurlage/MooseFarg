$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Moose Farg'
  app.version = '1.1'
  app.short_version = '1.1'
  app.frameworks += ['QuartzCore', 'CoreImage', 'Twitter', 'MessageUI']
  # app.codesign_certificate = 'iPhone Developer: Jan-Willem Buurlage (62RNYAPSGP)'
  # app.provisioning_profile = '/Users/Huis/Library/MobileDevice/Provisioning Profiles/35BD6182-1D80-45DA-BAD8-71433B3D12C3.mobileprovision'	
  app.codesign_certificate = 'iPhone Distribution: Harm Buurlage'
  app.provisioning_profile = '/Users/Huis/Library/MobileDevice/Provisioning Profiles/9E73EB2C-D351-4C6B-AC62-A3C8978E93DE.mobileprovision'  
  app.icons = ['icon.png', 'icon@2x.png']
  app.identifier = "nl.byn.moosefarg"
  app.prerendered_icon = true
end
