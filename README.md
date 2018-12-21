# GEVAUDAN

Gluster Environment Vulnerable AUthentication Data Access & Nuke.

## Getting Started

Gevaudan is a Red Hat GlusterFS exploit for CVEs 2018-1088 & 2018-1112.
Available in both standalone and metasploit module formats.

## Presentations
|#| Date | Conference |  Link to Video | Link to Slides |
|---|---|---|---|---|
|1|11-AGO-2018|DEFCON 26 Data Duplication Village| https://www.youtube.com/watch?v=8IyJjRVTMAk | https://drive.google.com/open?id=1O1Bk4iXlsmO8cq9aCvAv_TFIvsL-d2YzUZga5k_f_Xg |

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
