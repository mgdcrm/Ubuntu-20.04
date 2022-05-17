# Ubuntu-20.04

After install Ubuntu Server 20.04(LTS) X64 from following url <br>
http://ftp.ubuntu-tw.org/mirror/ubuntu-releases/20.04.1/ubuntu-20.04.1-live-server-amd64.iso <br>
on Hyper-V virtual machine.<br>
You can execute install.sh to do a quick setup.

Install.sh will install following application and setting
<ul>
    <li>Install the XRDP service so we can connect server with MSTSC.</li>
    <li>Modify policy to let administrator users can work with GUI when connect with xrdp.</li>
    <li>Change system timezone to Asia/Taipei.</li>
    <li>Installing Tweak Tool to let you can modify more NGOME GUI setting.</li>
    <li>Setting common firewall setting.</li>
    <li>Installing LAMP Server. (Apache、MySQL、PHP)</li>
</ul>

Hope you will like this script.
