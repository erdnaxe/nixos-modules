{
  security.audit = {
    enable = true;
    rules = [
      # /etc/ logging
      "-w /etc/ -p wa -k audit_conf"
      # watch mounts
      "-a exit,always -S mount -S umount2 -k audit_mount"
      # strange x86 syscalls
      "-a exit,always -S ioperm -S modify_ldt -k audit_syscall"
    ];
  };

  boot.kernel.sysctl = {
    "dev.tty.ldisc_autoload" = false;
    "fs.protected_fifos" = 2;
    "fs.suid_dumpable" = false;
    "kernel.dmesg_restrict" = true;
    "kernel.perf_event_paranoid" = 3;
    "kernel.unprivileged_bpf_disabled" = true;
    "kernel.kptr_restrict" = 2;
    "net.core.bpf_jit_harden" = 2;
    "net.ipv4.conf.all.log_martians" = true;
  };
}
