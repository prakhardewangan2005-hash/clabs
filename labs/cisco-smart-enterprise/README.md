# Cisco Smart Enterprise Network + Security Lab (Containerlab)

Enterprise-style lab aligned with Cisco Account Systems Engineering work:
- Segmented departments (Sales/Ops/IT/Mgmt/Services)
- Routed TCP/IP gateways (L3 forwarding)
- ACL-style security policies (least privilege)
- Repeatable validation via test cases

## Quick Start
> Prereqs: Docker + containerlab installed.

```bash
containerlab deploy -t topology.clab.yml
bash scripts/setup.sh
bash scripts/test.sh

