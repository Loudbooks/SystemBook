use std::fs::File;
use std::io;
use std::io::Read;
use procfs::process::Process;
use std::time::{SystemTime, UNIX_EPOCH};
use procfs::WithCurrentSystemInfo;

fn get_uptime() -> io::Result<f64> {
    let mut file = File::open("/proc/uptime")?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    let uptime: f64 = contents.split_whitespace().next().unwrap().parse().unwrap();
    Ok(uptime)
}

pub fn get_process_runtime(pid: i32) -> Option<String> {
    if let Ok(process) = Process::new(pid) {
        if let Ok(start_time) = process.stat().unwrap().starttime().get() {
            if let Ok(uptime) = get_uptime() {
                let boot_time = SystemTime::now() - std::time::Duration::from_secs_f64(uptime);
                let boot_time_secs = boot_time
                    .duration_since(UNIX_EPOCH)
                    .unwrap_or_default()
                    .as_secs();

                let process_start_time = boot_time_secs + (start_time.timestamp() as u64 / procfs::ticks_per_second());

                let runtime = SystemTime::now()
                    .duration_since(UNIX_EPOCH)
                    .unwrap_or_default()
                    .as_secs()
                    - process_start_time;

                return Some(format_runtime(runtime));
            }
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
