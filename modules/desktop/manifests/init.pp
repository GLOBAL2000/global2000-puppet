class desktop {
  include apps
  include fonts
  include citrix
  include grafikkarte
  include skype
  include window_manager
  include googleearth
  
  class apps {
    package { [mplayer, gnome-mplayer, vlc, acroread, adobe-flashplugin, thunderbird, adblock-plus, gnomebaker, gwibber, opera, gftp, inkscape, "openoffice.org-base", audacity, nautilus-image-converter]:
      ensure => present,
    }

    # Specials von Leuten
    package { [dia, freemind, scribus, planner]:
      ensure => present,
    }

    # Google Stuff
    package { [google-gadgets-common, google-gadgets-gst, google-gadgets-gtk]:
      ensure => latest,
    }
    
    package { ["openoffice.org-l10n-de", "openoffice.org-help-de", "openoffice.org-thesaurus-en-us", "openoffice.org-thesaurus-it", thunderbird-locale-de, gimp-help-de, evolution-documentation-de, gnome-user-guide-de, aspell-de, aspell-de-alt, aspell-es, aspell-fr, aspell-en, aspell-it, hunspell-de-at, hunspell-de-ch, hunspell-de-de, hunspell-en-us, myspell-es, myspell-it, hunspell-fr]:
      ensure => latest,
    }

    exec { "for i in application/pdf application/vnd.adobe.xfdf application/vnd.fdf application/vnd.adobe.xdp+xml application/vnd.adobe.pdx application/fdf application/xdp application/xfdf application/pdx; do xdg-mime default \"acroread.desktop\" \"\$i\";done":
      onlyif => "test `/opt/Adobe/Reader9/Reader/intellinux/bin/xdg-mime query default application/pdf` != 'acroread.desktop'",
      require => Package["acroread"],
      path => "/opt/Adobe/Reader9/Reader/intellinux/bin:/usr/bin:/usr/sbin:/bin",
    }
    
    package {
      "sun-java6-plugin":
        ensure => present,
        responsefile => "/etc/global2000-preseed.txt",
        require => File["/etc/global2000-preseed.txt"],
    }

    package {
      "non-free-codecs":
        ensure => present,
        require => File["/etc/apt/preferences"],
    }
    
    package {
      ["gstreamer0.10-plugins-ugly", "gstreamer0.10-plugins-ugly-multiverse", "gstreamer0.10-plugins-bad", "gstreamer0.10-plugins-bad-multiverse", "gstreamer0.10-ffmpeg", "libavcodec52", "libavformat52", "libpostproc51", "libswscale0", "gstreamer0.10-pitfdll", "libmp4v2-0"]:
        ensure => present,
    }

    gconf-system {
      "/desktop/gnome/url-handlers/mailto/command":
        ensure => "mozilla-thunderbird %s",
        preference => mandatory,
    }

  }

  class window_manager {
    gconf-system {
      "/desktop/gnome/session/required_components/windowmanager":
        ensure => "metacity",
    }
  }

  class fonts {
    file {
      "/etc/apt/preferences":
        tag => "debootstrap",
        content => "Package: ttf-mscorefonts-installer\nPin: version *\nPin-Priority: -1\n"
    }    

    get_by_rsync { "fonts/fonts-global2000/":
      destination => "/usr/local/share/fonts/global2000/",
    }

    get_by_rsync { "fonts/fonts-msttcorefonts/":
      destination => "/usr/local/share/fonts/msttcorefonts/",
    }
    
    file {
      "/etc/fonts/conf.d/10-hinting-full.conf":
        ensure => "/etc/fonts/conf.avail/10-hinting-full.conf"
    }
    
    file {
      "/etc/fonts/conf.d/10-hinting-slight.conf":
        ensure => absent,
    }
    
    gconf-system {
      "/desktop/gnome/font_rendering/hinting":
        ensure => full,
        preference => mandatory,
    }
    
    
  }
}

