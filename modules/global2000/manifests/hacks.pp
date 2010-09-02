class hacks::karmic {
  # Hässlicher hässlicher hack der noch weg muss!!!
  exec {
    "repair grub":
      tag => ["debootstrap", "hack"],
      command => "sed --in-place -e 's/\\(^\s*echo \"search --no-floppy --fs-uuid --set \${fs_uuid}\"\\)/true #\\1/' /usr/lib/grub/grub-mkconfig_lib",
      unless => "grep --quiet '^true #\s*echo \"search --no-floppy' /usr/lib/grub/grub-mkconfig_lib",
      notify => Exec["update-grub"],
  }
  
  exec {
    "update-grub":
      tag => ["debootstrap", "hack"],
      onlyif => "grep --quiet 'search --no-floppy' /boot/grub/grub.cfg",
  }
      

}

class hacks::lucid {

}
