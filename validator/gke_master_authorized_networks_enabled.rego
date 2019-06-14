#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package templates.gcp.GCPGKEMasterAuthorizedNetworksEnabledConstraintV1

import data.validator.gcp.lib as lib

deny[{
	"msg": message,
	"details": metadata,
}] {
	constraint := input.constraint
	asset := input.asset
	asset.asset_type == "container.googleapis.com/Cluster"

	cluster := asset.resource.data
	master_auth_network_disabled(cluster)

	message := sprintf("Master authorized networks is not being used in cluster %v.", [asset.name])
	metadata := {"resource": asset.name}
}

###########################
# Rule Utilities
###########################
master_auth_network_disabled(cluster) {
	master_auth_network_config := lib.get_default(cluster, "masterAuthorizedNetworksConfig", {})
	enabled := lib.get_default(master_auth_network_config, "enabled", false)
	enabled == false
}