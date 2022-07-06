# Header to be updated

plan puppet_agent::migrate_agent (
  TargetSpec $targets,
) {

  # Run the migration of ssldir
  $ssldir_move_result = run_task('puppet_agent::backup_ssldir',
                                  $targets,
                                  '_catch_errors' => true)

  # targets with successful ssldir move
  $ssldir_move_ok_targets = $ssldir_move_result.ok_set

  # Run the puppet.conf update task
  $puppet_conf_update_result = run_task('puppet_agent::update_serverlist',
                                  $ssldir_move_ok_targets,
                                  '_catch_errors' => true)

  # Targets with successful conf update
  $puppet_conf_update_ok_targets = $puppet_conf_update_result.ok_set

  # Failed targets with puppet.conf update
  $puppet_conf_update_failed_targets = $puppet_conf_update_result.error_set

  # Roleback ssldir change
  $ssldir_rollabck_result = run_task('puppet_agent::ssldir_rollback',
                                  $puppet_conf_update_failed_targets,
                                  '_catch_errors' => true)
  
  # Run the Agent
  # ...need to figure out how

}
