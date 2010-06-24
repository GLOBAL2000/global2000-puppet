import "gnome_panel.pp"
import "gdm.pp"

class corporate_identity {
  tag "systemstart"
  include "gnome_panel::${lsbdistcodename}"
  include "gdm::${lsbdistcodename}"
      
}


