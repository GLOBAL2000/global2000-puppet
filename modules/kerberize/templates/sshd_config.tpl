Port 22
Protocol 2

RSAAuthentication no
PubkeyAuthentication no
ChallengeResponseAuthentication no
<% if allow_ssh_password_login -%>
PasswordAuthentication yes
UsePAM yes
<% else -%>
PasswordAuthentication no
UsePAM no
<% end -%>

X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server

# GSSAPI options
GSSAPIAuthentication yes
GSSAPIKeyExchange yes
GSSAPICleanupCredentials yes
