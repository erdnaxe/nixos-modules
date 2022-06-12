[
  ##############################
  # Prometheus self-monitoring #
  ##############################

  {
    alert = "PrometheusJobMissing";
    expr = "absent(up{job=\"prometheus\"})";
    for = "0m";
    labels.severity = "warning";
    annotations.summary = "Prometheus job missing";
  }

  {
    alert = "PrometheusTargetMissing";
    expr = "up == 0";
    for = "0m";
    labels.severity = "critical";
    annotations.summary = "Prometheus target missing";
  }

  {
    alert = "PrometheusConfigurationReloadFailure";
    expr = "prometheus_config_last_reload_successful != 1";
    for = "0m";
    labels.severity = "warning";
    annotations.summary = "Prometheus configuration reload failure";
  }

  {
    alert = "PrometheusTooManyRestarts";
    expr = "changes(process_start_time_seconds{job=~\"prometheus|pushgateway|alertmanager\"}[15m]) > 2";
    for = "0m";
    labels.severity = "warning";
    annotations.summary = "Prometheus too many restarts";
  }

  {
    alert = "PrometheusRuleEvaluationFailures";
    expr = "increase(prometheus_rule_evaluation_failures_total[3m]) > 0";
    for = "0m";
    labels.severity = "critical";
    annotations.summary = "Prometheus rule evaluation failures";
  }

  {
    alert = "PrometheusTargetEmpty";
    expr = "prometheus_sd_discovered_targets == 0";
    for = "0m";
    labels.severity = "critical";
    annotations.summary = "Prometheus target empty";
  }

  # This already happened in 2021 at Crans
  {
    alert = "PrometheusTsdbCompactionsFailed";
    expr = "increase(prometheus_tsdb_compactions_failed_total[1m]) > 0";
    for = "0m";
    labels.severity = "critical";
    annotations.summary = "Prometheus TSDB compactions failed";
  }

  #####################
  # Host and hardware #
  #####################

  # Alert for out of memory
  # Do not take into account memory not used by apps
  {
    alert = "HostOutOfMemory";
    expr = "(node_memory_MemFree_bytes + node_memory_Cached_bytes + node_memory_Buffers_bytes + node_memory_PageTables_bytes + node_memory_VmallocUsed_bytes + node_memory_SwapCached_bytes + node_memory_Slab_bytes) / node_memory_MemTotal_bytes * 100 < 10";
    for = "2m";
    labels.severity = "warning";
    annotations.summary = "Almost out of memory";
  }

  {
    alert = "HostUnusualDiskReadRate";
    expr = "sum by (instance) (rate(node_disk_read_bytes_total[2m])) / 1024 / 1024 > 50";
    for = "5m";
    labels.severity = "warning";
    annotations.summary = "Host unusual disk read rate";
  }

  {
    alert = "HostUnusualDiskWriteRate";
    expr = "sum by (instance) (rate(node_disk_written_bytes_total[2m])) / 1024 / 1024 > 50";
    for = "2m";
    labels.severity = "warning";
    annotations.summary = "Host unusual disk write rate";
  }

  {
    alert = "HostOutOfDiskSpace";
    expr = "(node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes < 10 and ON (instance, device, mountpoint) node_filesystem_readonly == 0";
    for = "2m";
    labels.severity = "warning";
    annotations.summary = "Almost out of free disk space";
  }

  {
    alert = "HostDiskWillFillIn24Hours";
    expr = "(node_filesystem_avail_bytes * 100) / node_filesystem_size_bytes < 10 and ON (instance, device, mountpoint) predict_linear(node_filesystem_avail_bytes{fstype!~\"tmpfs\"}[1h], 24 * 3600) < 0 and ON (instance, device, mountpoint) node_filesystem_readonly == 0";
    for = "2m";
    labels.severity = "warning";
    annotations.summary = "Host disk will fill in 24 hours";
  }

  {
    alert = "HostOutOfInodes";
    expr = "node_filesystem_files_free{fstype=\"ext4\"} / node_filesystem_files{fstype=\"ext4\"} * 100 < 10";
    for = "5m";
    labels.severity = "warning";
    annotations.summary = "Almost out of inodes";
  }

  {
    alert = "HostHighCpuLoad";
    expr = "node_load5 > 9";
    for = "10m";
    labels.severity = "warning";
    annotations.summary = "Load is high";
  }

  {
    alert = "HostSystemdServiceCrashed";
    expr = "node_systemd_unit_state{state=\"failed\"} == 1";
    for = "0m";
    labels.severity = "warning";
    annotations.summary = "An unit failed";
  }

  {
    alert = "HostPhysicalComponentTooHot";
    expr = "node_hwmon_temp_celsius > 75";
    for = "5m";
    labels.severity = "warning";
    annotations.summary = "Host physical component too hot";
  }

  {
    alert = "HostNodeOvertemperatureAlarm";
    expr = "node_hwmon_temp_crit_alarm_celsius == 1";
    for = "0m";
    labels.severity = "critical";
    annotations.summary = "Host node overtemperature alarm";
  }

  {
    alert = "HostRaidDiskFailure";
    expr = "node_md_disks{state=\"failed\"} > 0";
    for = "2m";
    labels.severity = "warning";
    annotations.summary = "Missing RAID disk(s)";
  }

  {
    alert = "HostOomKillDetected";
    expr = "increase(node_vmstat_oom_kill[1m]) > 0";
    for = "0m";
    labels.severity = "warning";
    annotations.summary = "Host OOM kill detected";
  }

  {
    alert = "HostEdacCorrectableErrorsDetected";
    expr = "increase(node_edac_correctable_errors_total[1m]) > 0";
    for = "0m";
    labels.severity = "info";
    annotations.summary = "Host EDAC correctable errors detected";
  }

  {
    alert = "HostEdacUncorrectableErrorsDetected";
    expr = "node_edac_uncorrectable_errors_total > 0";
    for = "0m";
    labels.severity = "warning";
    annotations.summary = "Host EDAC uncorrectable errors detected";
  }

  # This happend in June 2021 at Crans
  {
    alert = "HostConntrackLimit";
    expr = "node_nf_conntrack_entries / node_nf_conntrack_entries_limit > 0.8";
    for = "5m";
    labels.severity = "warning";
    annotations.summary = "Host conntrack limit";
  }

  ############
  # Blackbox #
  ############

  {
    alert = "BlackboxProbeFailed";
    expr = "probe_success == 0";
    for = "0m";
    labels.severity = "critical";
    annotations.summary = "Blackbox probe failed";
  }

  {
    alert = "BlackboxSlowProbe";
    expr = "avg_over_time(probe_duration_seconds[1m]) > 1";
    for = "1m";
    labels.severity = "warning";
    annotations.summary = "Blackbox slow probe";
  }

  {
    alert = "BlackboxSslCertificateWillExpireSoon";
    expr = "probe_ssl_earliest_cert_expiry - time() < 86400";
    for = "0m";
    labels.severity = "warning";
    annotations.summary = "Blackbox SSL certificate will expire in one day";
  }
]

