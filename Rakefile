$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'MooseFarg'
  app.version = '1.0'
  app.frameworks += ['QuartzCore', 'CoreImage', 'Twitter', 'MessageUI']
  app.codesign_certificate = 'iPhone Developer: Jan-Willem Buurlage (62RNYAPSGP)'
  app.provisioning_profile = '/Users/Huis/Library/MobileDevice/Provisioning Profiles/35BD6182-1D80-45DA-BAD8-71433B3D12C3.mobileprovision'	
  app.icons = ['icon.png', 'icon@2x.png']
  app.identifier = "nl.byn.moosefarg"
  app.prerendered_icon = true
end
