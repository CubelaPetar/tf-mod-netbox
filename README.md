# TF-Mod-Netbox

Terraform/OpenTofu module to manage Netbox configuration via IaC.

## Usage

The module is split into sub-modules which handle different sections of Netbox config indenpendetly.

That way you can start using this module even on pre-existing installations and slowly migrate to full managed ones.

Each sub-module has a README.md file describing what the module handles and a sample config data in `example/data.tfvars` .

Currently you can manage:

- [x] Organization
- [x] Racks
- [x] Devices
- [ ] Connections
- [ ] Wireless
- [x] IPAM
- [ ] VPN
- [x] Virtualization
- [ ] Power
- [ ] Provisioning
- [x] Customization
- [ ] Operations

## Dependancies

This module has a dependency on the ```e-breuninger/netbox``` provider.

## License

For licensing please review the LICENSE.md of the repo and for each sub-modules.

## Author

Denis-Florin Rendler <connect {at} rendler.net>