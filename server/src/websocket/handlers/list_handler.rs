use std::sync::{Arc, Mutex};
use std::time::Duration;
use dbus::ffidisp::Connection;
use crate::collectors::dbus_collector::gather_processes;
use crate::data::list_dto::ListDTO;
use crate::data::process::Process;

#[derive(Debug, Clone)]
pub(crate) struct ListHandler {
    pub last_checked: Arc<Mutex<u64>>,
    pub list: Arc<Mutex<Vec<Process>>>,
    pub connection: Arc<Mutex<Connection>>,
}

unsafe impl Sync for ListHandler {}
unsafe impl Send for ListHandler {}

impl ListHandler {
    pub fn new() -> Self {
        let connection = Connection::new_system().expect("Failed to connect to D-Bus");
        let last_checked = tokio::time::Instant::now().elapsed().as_secs();
        let list = Vec::new();

        let response = ListHandler {
            last_checked: Arc::new(Mutex::new(last_checked)),
            list: Arc::new(Mutex::new(list)),
            connection: Arc::new(Mutex::new(connection)),
        };

        response
    }

    pub fn get_list(&self) -> serde_json::Value {
        let dto = ListDTO {
            checked: self.last_checked.clone().lock().unwrap().clone(),
            processes: self.list.clone().lock().unwrap().clone(),
        };

        serde_json::to_value(&dto).unwrap_or(serde_json::Value::Null)
    }

    pub async fn begin_listening(&mut self) {
        let mut interval = tokio::time::interval(Duration::from_secs(60));

        loop {
            interval.tick().await;

            let processes = gather_processes(&self.connection.lock().unwrap()).unwrap_or_default();

            self.last_checked = Arc::new(Mutex::new(tokio::time::Instant::now().elapsed().as_secs()));
            self.list = Arc::new(Mutex::new(processes));
        }
    }
}
