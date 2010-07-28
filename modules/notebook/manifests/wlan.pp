class notebook::wlan {

  case $g2_wlan {
    bcm4312: {
      package { 
        "b43-fwcutter":
          ensure => latest,
          responsefile => "/etc/global2000-preseed.txt",
          require => File["/etc/global2000-preseed.txt"], 
      }
    }
  }
}
