use procfs::process::Process;
use std::time::{SystemTime, UNIX_EPOCH};
use procfs::WithCurrentSystemInfo;

pub fn get_process_runtime(pid: i32) -> Option<String> {
    if let Ok(process) = Process::new(pid) {
        if let Ok(start_time) = process.stat().unwrap().starttime().get() {
           	let start = SystemTime::now();
            let since_the_epoch = start
               .duration_since(UNIX_EPOCH)
               .expect("Time went backwards")
               .as_secs();
               
           let runtime = since_the_epoch - (start_time.timestamp() as u64); 
               
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
