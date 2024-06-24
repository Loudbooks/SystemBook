use dbus::ffidisp::Connection;
use rocket::{get, launch, routes};
use rocket::serde::json::Json;
use crate::process::Process;

mod dbus_collector;
mod process;
mod websocket;

#[get("/")]
fn index() -> Json<Vec<Process>> {
    let connection = Connection::new_system().expect("Failed to connect to D-Bus");

    let start = std::time::Instant::now();
    let processes = dbus_collector::gather_processes(&connection);
    
    println!("Gathered {} processes in {:?}", processes.len(), start.elapsed());
    
    println!("{:?}", Json(processes));

    Json(processes)
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index])
}
