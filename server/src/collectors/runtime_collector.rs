use procfs::process::Process;
use std::time::{SystemTime, UNIX_EPOCH};

pub fn get_process_runtime(pid: i32) -> Option<String> {
    if let Ok(process) = Process::new(pid) {
        if let Ok(start_time) = process.stat.starttime() {
            let uptime = procfs::kernel::uptime().unwrap_or_default().0;
            let boot_time = SystemTime::now() - uptime;
            let boot_time_secs = boot_time
                .duration_since(UNIX_EPOCH)
                .unwrap_or_default()
                .as_secs();

            let process_start_time = boot_time_secs + (start_time / procfs::ticks_per_second() as u64);

            let runtime = SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap_or_default()
                .as_secs()
                - process_start_time;

            return Some(format_runtime(runtime));
        }
    }
    None
}

fn format_runtime(runtime: u64) -> String {
    let days = runtime / 86400;
    let hours = (runtime % 86400) / 3600;
    let minutes = (runtime % 3600) / 60;

    if days > 0 {
        format!("{} days, {} hours", days, hours)
    } else if hours > 0 {
        format!("{} hours", hours)
    } else {
        format!("{} minutes", minutes)
    }
}
