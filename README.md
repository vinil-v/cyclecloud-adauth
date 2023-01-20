# cyclecloud-adauth
This Project installs and configures Active directory based user authentication for CycleCloud based HPC Cluster.

It is recommended that user access be managed through a directory service such as LDAP, Active Directory, or NIS for enterprise production clusters. 


**Pre-Requisites:**
1. [CycleCloud](https://learn.microsoft.com/en-us/azure/cyclecloud/qs-install-marketplace?view=cyclecloud-8) must be installed and running (CycleCloud 8.0 or later).
2. [Windows Active Directory](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-) must be configured and running. 
3. Active Directory should be reachable to all the nodes in the cluster and required ports should be opened for authentication. 
4. Supported OS version : CentOS 7 / RHEL7 / Alma Linux 8 / Ubuntu 18.04

**Configuring the Project**
1. Open a terminal session in CycleCloud server with the CycleCloud CLI enabled.
2. Clone the cyclecloud-adauth repo
``` bash
$ git clone https://github.com/vinil-v/cyclecloud-adauth.git
```
3. Swtich to `cyclecloud-adauth` project directory and upload the project to cyclecloud locker.
``` bash
$ cd cyclecloud-adauth/
$ cyclecloud project upload <locker name>
```

4. Import the required template (Slurm/ OpenPBS or Gridenigne).
``` bash
cyclecloud import_template -f templates/slurm_with_ad.txt
```

**Configuring AD Login in CycleCloud Portal**

The following parameter

![Alt text](https://github.com/vinil-v/cyclecloud-adauth/blob/main/images/ad-screenshot.png?raw=true)

