{
  boot.kernel.sysctl = {
    "kernel.dmesg_restrict" = true;
    "kernel.perf_event_paranoid" = 3;
    "kernel.unprivileged_bpf_disabled" = true;
    "kernel.kptr_restrict" = 2;
    "fs.suid_dumpable" = false;
  };
}
