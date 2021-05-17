You can test this module outside of a landingzone using

```bash
cd /tf/caf/examples/automation/100-simple-automation-account/standalone

terraform init

terraform [plan | apply | destroy]\
  -var-file ../configuration.tfvars


```

To test this deployment in the example landingzone. Make sure the launchpad has been deployed first

```bash

rover \
  -lz /tf/caf/landingzones/caf_example \
  -var-folder  /tf/caf/examples/automation/100-simple-automation-account/standalone \
  -level level1 \
  -a [plan | apply | destroy]

```