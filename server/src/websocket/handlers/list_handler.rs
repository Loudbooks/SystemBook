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
    	println!("About to send: {:?}", self.list.lock().unwrap().clone());

    
        let dto = ListDTO {
            checked: self.last_checked.lock().unwrap().clone(),
            processes: self.list.lock().unwrap().clone(),
        };

        serde_json::to_value(&dto).unwrap()
    }

    pub async fn begin_listening(&mut self) {
        let mut interval = tokio::time::interval(Duration::from_secs(60));

        loop {
            interval.tick().await;
            let processes = gather_processes(&self.connection.lock().unwrap()).unwrap_or_default();

			println!("Debug1");

            let mut last_checked_state = self.last_checked.lock().unwrap();
            			println!("Debug2");
            *last_checked_state = tokio::time::Instant::now().elapsed().as_secs();
			println!("Debug3");

			let mut list_state = self.list.lock().unwrap();
						println!("Debug4");
            *list_state = processes;
            println!("debug5");

            println!("Set list");
            println!("debug6");
        }
    }

    
}
