#!/usr/bin/ruby
#Chastel - This tools attempts to hunt Gevaudan (CVE-2018-1112 and CVE-2018-1088).
#Mauro Eldritch (plaguedoktor) @ Eldritch SEC & INT

#[Config]
require 'colorize'
#Clear screen
system('clear')
#Get gluster version and shared storage configuration to determine if vulnerable
$version = `gluster --version`.to_s
$enabled_shared_storage = `gluster volume get gluster_shared_storage cluster.enable-shared-storage | awk '{print $2}'`.to_s

#[Main]
def main()
	puts "Chastel - GEVAUDAN Detection Tool\nMauro Eldritch (@plaguedoktor) @ Eldritch SEC & INT\n\n".blue
	if $version.include? "3.8.8"
		puts "[!] Vulnerable Gluster version: 3.8.8.".yellow
		puts "\t[-] Solution: Run 'apt upgrade' to get latest version.".blue
	else
		puts "[*] Gluster version not listed as vulnerable.".green
	end
	if $enabled_shared_storage.include? "enable"
		puts "[!] Vulnerable Option gluster_shared_storage set to true.".red
		puts "\t[-] Solution: Run 'gluster volume set all cluster.enable-shared-storage disable'.".blue
	else
		puts "[*] Vulnerable Option gluster_shared_storage set to false.".green
	end
	if File.symlink?("/etc/cron.d/glusterfs_snap_cron_tasks")
		puts "[!] glusterfs_snap_cron_tasks is a symlink, and can be exploited to scale privileges.".red
	else
		puts "[*] glusterfs_snap_cron_tasks does not exists, or is not a symlink.".green
	end
end

#[Call]
main()