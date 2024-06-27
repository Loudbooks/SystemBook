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
        let memory = unit.memory.unwrap_or("None".to_string());
        let cpu = unit.cpu.unwrap_or("None".to_string());
        let time = runtime_collector::get_process_runtime(unit.pid.unwrap_or(0) as i32).unwrap_or("None".to_string());

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
}
