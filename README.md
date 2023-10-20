# proxmox-vyos-router
This is a Terraform module for deploying VyOS virtual machines in Proxmox.  The Proxmox provider for Terraform can create new virtual machines by cloning existing machine templates.  Below are the manual steps needed to create the initial VyOS template.

## Creating the VyOS virtual machine template
- From your Proxmox ISO storage, download the latest rolling release ISO from `https://github.com/vyos/vyos-rolling-nightly-builds/releases`
- Create a new VM with the following specs:
  OS:
    ISO Image: <the .iso file you downloaded>
  System:
    Graphics card: SPICE
    Machine: q35
    BIOS: SeaBIOS
    SCSI Controller: VirtIO SCSI Single
    Qemu Agent: false
    Add TPM: false
  Disks:
    scsi0:
      Disk size: 2GB
      Storage: <your NAS storage>
      SSD emulation: true
      Discard: true
  CPU:
    Type: x86-64-v2-AES
    Cores: 1
  Memory:
    Memory (MiB): 1024
- Boot the machine and login
  username: vyos
  password: vyos
- Run `install image` and take the default responses on the prompts to install VyOS to the virtual machine's harddrive (for now, set the vyos user's password to "vyos").  Type `poweroff` to shutdown the system when the installation is finshed.
- Under `Hardware`, add a second network device (NIC) and remove the CD-ROM drive
- Boot the VM again, login as the vyos user, and run these commands to enable SSH:
```
configure
set interfaces ethernet eth0 address dhcp
set service ssh port 22
set system login user vyos authentication public-keys vyos type ssh-rsa
set system login user vyos authentication public-key vyos key <public key hash without comment>
commit
save
```
- Now run `ip a` to see the IP address eth0 was assigned via DHCP
- Verify you can now login without a password using:
```
ssh -i <path to private vyos key> vyos@<ip from previous steps>
```
- Assuming that works, get back on the virtual machine's console and disable password logins with:
```
set service ssh disable-password-authentication
commit
```
- Repeat the test above to confirm you can still login via ssh without a password.
- Save the configuration and shutdown the virtual machine with:
```
save
exit
poweroff
```
- Finally, convert the virtual machine to a template.
