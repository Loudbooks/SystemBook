use serde::Serialize;
use systemctl::{AutoStartStatus, Unit};
use crate::collectors::runtime_collector;


#[derive(Serialize, Debug, Clone)]
pub struct Process {
    pub description: String,
    pub name: String,
    pub running: bool,
    pub enabled: bool,
    pub memory: String,
    pub time: String,
    pub cpu: String
}

impl Process {
    pub fn from_unit(unit: Unit) -> Self {
        let name = unit.name.clone();
        let description = unit.description.clone().unwrap_or("No Description Provided".to_string());
        let enabled = unit.auto_start == AutoStartStatus::Enabled;
        let running = unit.is_active().unwrap_or(false);

        if !running {
            return Self {
                name,
                description,
                running,
                enabled,
                memory: "None".to_string(),
                time: "None".to_string(),
                cpu: "None".to_string()
            }
        }

        let memory = unit.memory.unwrap_or("None".to_string());
        let cpu = match unit.cpu {
            None => {
                "None".to_string()
            }
            Some(cpu) => {
                Self::cleanup_cpu(cpu)
            }
        };
        let time = Self::cleanup_time(runtime_collector::get_process_runtime(unit.pid.unwrap_or(0) as i32).unwrap_or("None".to_string()));


        Self {
            name,
            description,
            running,
            enabled,
            memory,
            time,
            cpu
        }
    }

    fn cleanup_cpu(cpu: String) -> String {
        let cpu_str = if let Some(pos) = cpu.find('s') {
            if let Some(space_pos) = cpu[..pos].rfind(' ') {
                let seconds_str = &cpu[space_pos + 1..pos];
                let mut seconds: f64 = seconds_str.parse().map_or(0.0, |x| x);
                seconds = seconds.round();
                let new_time_str = format!("{} {:.0}s", &cpu[..space_pos + 1], seconds);
                new_time_str
            } else {
                cpu
            }
        } else {
            cpu
        };
        
        cpu_str.replace("min", "m,")
    }

    fn cleanup_time(time: String) -> String {
        return time.replace(" days", "d").replace(" day", "d").replace(" hours", "h").replace(" hour", "h").replace(" minutes", "m").replace(" minute", "m");
    }
}
