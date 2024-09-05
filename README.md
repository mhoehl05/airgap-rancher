Open tunnel for Filetransfer

az network bastion tunnel --name "bastion-rancher-demo" --resource-group "rg-rancher-demo" --target-resource-id "/subscriptions/a5cb6e26-be1e-4c11-92b6-639250a3e447/resourceGroups/rg-rancher-demo/providers/Microsoft.Compute/virtualMachines/vm-master-rancher-demo" --resource-port "22" --port "22"
scp -P 22 "C:\Users\mhoehl\Desktop\projekte\schulungen\Rancher\airgap-rancher\transfer_test.txt" adm_ubuntu@127.0.0.1:/home/adm_ubuntu/

apt-rdepends <package>|grep -v "^ " |grep -v "^libc-dev$"
sudo dpkg -i *.deb

az network vnet list \
  --resource-group rg-rancher-demo \
  --query "[].{Name: name, Subnet: subnets[0].name}"
