class grafikkarte {
  tag "systemstart"

  case $g2_grafikkarte {
    
    radeon: {
      package {
        "xorg-driver-fglrx":
          ensure => latest,
      }
      
      file {
        "/etc/X11/xorg.conf":
          source => "puppet:///desktop/xorg-$g2_grafikkarte.conf",
      }  
    }

    nvidia: {
      package {
        "nvidia-graka":
          name => "nvidia-glx-173",
          ensure => latest,
      }
      
      file {
        "/etc/X11/xorg.conf":
          require => Package["nvidia-graka"],
          source => "puppet:///desktop/xorg-$g2_grafikkarte.conf",
      }  
    }

    intel: {
      file {
        "/etc/X11/xorg.conf":
          ensure => absent,
      }  
    }    
  }

}
