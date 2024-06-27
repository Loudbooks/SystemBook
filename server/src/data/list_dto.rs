use serde::Serialize;
use crate::data::process::Process;

#[derive(Debug, Clone, Serialize)]
pub struct ListDTO {
    pub checked: u64,
    pub processes: Vec<Process>,
}