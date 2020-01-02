Vagrant.configure("2") do |config|
  conf = JSON.parse(File.read("config.json"))
  
  
  config.vm.box = "ubuntu/bionic64"
  
  config.vm.network "private_network", ip: conf["start_ip"]
  config.vm.network :forwarded_port, guest: 80, host: 80
  conf["forwarded_ports"].each do |port|
    config.vm.network "forwarded_port", guest: port["guest_port"],
      host: port["host_port"], protocol: port["protocol"], auto_correct: true
  end
  
  config.vm.hostname = "decr"
  if Vagrant.has_plugin?("vagrant-hostsupdater")
    config.hostsupdater.aliases = {conf["start_ip"] => [conf["start_host"], "www."+conf["start_host"]]}

    conf["instances"].each do |site|
        config.hostsupdater.aliases[site["ip"]] = [site["host"], "www."+site["host"]]
    end
  end
  
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", conf["memory"]]
	config.vm.synced_folder "./resources/", "/var/vg_res/", create: true
	
    conf["instances"].each do |site|
	  config.vm.network :private_network, ip: site["ip"]
      case site["catalog_type"]
      when "nfs"
        config.vm.synced_folder "./sites/" + site["path"], "/var/www/" + site["path"], type: "nfs", create: true
        config.nfs.map_uid = Process.uid
        config.nfs.map_gid = Process.gid
      else
        config.vm.synced_folder "./sites/" + site["path"], "/var/www/" + site["path"], create: true
      end
    end
  end
  
  vars = "START_ip='" + conf["start_ip"] + "'\n" +
		 "START_host='" + conf["start_host"] + "'\n" +
		 "declare -A USERS\n" +
		 "declare -A SITES_host\n" +
		 "declare -A SITES_path\n" +
		 "declare -A SITES_php\n" +
		 "declare -A SITES_drup\n" +
		 "declare -A SITES_drup_ver\n" +
		 "declare -A SITES_user"
  conf["instances"].each do |site|
	vars += "\n" + "SITES_host['" + site['ip'] + "']='" + site['host'] + "'\n" +
			"SITES_path['" + site['ip'] + "']='" + site['path'] + "'\n" +
			"SITES_php['" + site['ip'] + "']='" + site['php_ver'] + "'\n" +
			"SITES_drup['" + site['ip'] + "']='" + site['name'] + "'\n" +
			"SITES_drup_ver['" + site['ip'] + "']='" + site['drup_ver'] + "'\n" +
			"SITES_user['" + site['ip'] + "']='" + site['user']['login'] + "'\n" +
			"USERS['" + site['user']['login'] + "']='" + site['user']['pass']+"'"
  end
  
  initial = File.read("resources/initial.sh")
  config.vm.provision "shell" do |s|
    s.binary = true
    s.inline = %Q(#!/usr/bin/env bash
	  sudo -i
      #{vars}
      #{initial})
  end
  config.vm.boot_timeout = 1200
end
