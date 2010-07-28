MAILDIR=<%= listcaptor_home %>/maildir
UMASK=037
YEAR=`date +%Y`

:0
* ^TO\/(<%= listcaptor_normal_lists.join("|") -%>)
.$MATCH/
:0
* ^TO\/(<%= listcaptor_yearly_lists.join("|") -%>)
{
	YEARFOLDER=.$MATCH.$YEAR
	DUMMY=`test -d $YEARFOLDER || /usr/bin/maildirmake.dovecot $HOME/maildir/$YEARFOLDER && chmod -R g+rX $HOME/maildir/$YEARFOLDER && ln -sf $YEARFOLDER $HOME/maildir/.$MATCH.aktuell`
	:0
	$YEARFOLDER/
}
