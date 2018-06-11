# GEVAUDAN

Gluster Environment Vulnerable AUthentication Data Access & Nuke

## Getting Started

Gevaudan is a Red Hat GlusterFS exploit for CVEs 2018-1088 & 2018-1112.
Available in both standalone and metasploit module formats.

### Running

Standalone:

```
ruby gevaudan.rb
```

Metasploit:

```
sudo mkdir -p $HOME/.msf4/modules/exploits/unix
mv metasploit/gluster_shared_storage.rb $HOME/.msf4/modules/exploits/unix/
msfconsole
```
