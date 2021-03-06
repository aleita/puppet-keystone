# == Class: keystone::policy
#
# Configure the keystone policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for keystone
#   Example :
#     {
#       'keystone-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'keystone-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the nova policy.json file
#   Defaults to /etc/keystone/policy.json
#
class keystone::policy (
  $policies    = {},
  $policy_path = '/etc/keystone/policy.json',
) {

  include keystone::deps
  include keystone::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::keystone::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'keystone_config': policy_file => $policy_path }

}
