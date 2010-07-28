class mailserver::listcaptor {
  $listcaptor_home = "/var/mail/listcaptor"
  
  user {
    listcaptor:
      ensure  => present,
      home => $listcaptor_home,
      managehome => true,
      gid => 100,
  }
  
  maildirmake {
    $listcaptor_top_dirs:
      home => $listcaptor_home,
      owner => "listcaptor", group => "users", mode => "750",
  }

  maildirmake {
    $listcaptor_normal_lists:
      home => $listcaptor_home,
      owner => "listcaptor", group => "users", mode => "750",
  }

  maildirmake {
    $listcaptor_yearly_lists:
      home => $listcaptor_home,
      owner => "listcaptor", group => "users", mode => "750",
  }

  file {
    "$listcaptor_home/.procmailrc":
      content => template("mailserver/listcaptor-procmailrc.tpl"),
      owner => "listcaptor", group => "users", mode => "644",
  }
    
              
}
