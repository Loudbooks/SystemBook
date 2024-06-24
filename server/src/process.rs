use serde::Serialize;
use systemctl::{AutoStartStatus, Unit};

#[derive(Serialize, Debug)]
pub struct Process {
    pub pid: u64,
    pub description: String,
    pub name: String,
    pub running: bool,
    pub enabled: bool,
    pub memory_usage: String,
    pub cpu: String
}

impl Process {
    pub fn from_unit(unit: Unit) -> Self {
        let pid = unit.pid.unwrap_or(0);
        let name = unit.name.clone();
        let description = unit.description.clone().unwrap_or("No Description Provided".to_string());
        let enabled = unit.auto_start == AutoStartStatus::Enabled;
        let running = unit.is_active().unwrap_or(false);
        let memory_usage = unit.memory.unwrap_or("None".to_string());
        let cpu = unit.cpu.unwrap_or("None".to_string());

        Self {
            pid,
            name,
            description,
            running,
            enabled,
            memory_usage,
            cpu
        }
    }
}