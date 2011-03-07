# TestUtilities for TIDSSKRIFTER prosjekt

$normalUsername = ENV['USERNAME'] # 'thomasfl'
if(ENV['SECRET'] == nil )
  puts "Sett variablen SECRET med et passord som er gyldig i ldap serveren."
  puts "ex. export SECRET='passord'"
  exit(0)
end
$normalPassword = ENV['SECRET']


module TestUtilsMixIn

  # Fire up the browser
  if((not($test_url))) then
    $test_url = 'http://localhost:3000'
  end

  if($browser == nil) then
    case PLATFORM
    when /darwin/
      require 'safariwatir'
      $browser = Watir::Safari.new
    when /win32|mingw/
      require 'watir'
      $browser = Watir::IE.new()
    when /java/
      require 'celerity'
      $browser = Celerity::Browser.new
    when /linux/
      require 'firewatir'
      $browser = FireWatir::Firefox.new
    else
      raise "This platform is not supported (#{PLATFORM})"
    end

  end



end

