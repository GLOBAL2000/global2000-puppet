class andis-admintools {
import "testuser"
  
  package { mc: ensure => latest }
  package { [htop,strace,screen,inotify-tools,debconf-utils,rlwrap,zsh,multitail,rdiff-backup,rsync]: ensure => latest }

  package {
    "emacs":
      name => $operatingsystemrelease ? {
        "9.10" => "emacs23",
        "10.04" => "emacs23",
        "squeeze/sid" => "emacs23-nox",
        /(5.0.*)/ => "emacs22-nox",
        default => "emacs-nox",
      },
      ensure => latest,
  }

  package {
    ["ruby-elisp"]:
      ensure => latest,
  }

  package {
    ["git-core","tig"]:
      ensure => latest,
      tag => "systemstart",
  }

  file {
    "/etc/screenrc":
      source => "puppet:///andis-admintools/dot-screenrc",
  }
  
  file {
    "/root/.mc":
      source => "puppet:///andis-admintools/dot-midnight-commander",
      recurse => true,
      ensure => present,
      replace => false,
      require => Package["mc"],
  }
  
  file {
    "/etc/zsh/zshrc":
      source => "puppet:///andis-admintools/dot-zshrc",
      tag => "debootstrap",
  }

  file {
    "/root/.emacs":
      source => "puppet:///andis-admintools/dot-emacs",
  }
  
}
