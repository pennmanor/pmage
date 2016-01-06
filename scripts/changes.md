# Changelog File

## Used to keep our thoughts organized.

### 06 Jan 2016
Discussed the various aspects of setting up FLDT to work with the PMage scripts

- Added `partitions.txt` as a generic guide for setting up partitions with FLDT
  `partitions.txt` file applies a mostly generic disk scheme
  Notably, the root partition is now sda3.
- `sda1` is a generic bootable partiton for 'recovery'.
- [Optional] Discuss some options for making it a true bootable recovery
  partition by using Buildroot as a basis.
- `postimage.sh` is an up-to-date script that will configure the device based
  upon the pmage needs. Specifically, preseeding the grub dconf selections.
