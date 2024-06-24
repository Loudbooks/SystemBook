use dbus::ffidisp::Connection;
use dbus::Message;
use systemctl::Unit;

use crate::process::Process;

pub fn gather_processes(connection: &Connection) -> Vec<Process> {
    let msg = Message::new_method_call(
        "org.freedesktop.systemd1",
        "/org/freedesktop/systemd1",
        "org.freedesktop.systemd1.Manager",
        "ListUnits",
    ).expect("Failed to create method call");

    let reply = connection.send_with_reply_and_block(msg, 2000).expect("Failed to get reply");

    let units: Vec<(String, String)> = reply.read1().expect("Failed to read reply");
    
    let mut failed_units = 0;
    let processes: Vec<Process> = units
        .into_iter()
        .filter(|(name, _)| name.ends_with(".service"))
        .filter_map(|(name, _)| {
            Unit::from_systemctl(&name)
                .map_err(|err| {
                    eprintln!("Failed to create unit {}: {:?}", name, err);
                    failed_units += 1;
                })
                .ok()
        })
        .map(Process::from_unit)
        .collect();
    
    if failed_units > 0 {
        eprintln!("Failed to create {} units", failed_units);
    }

    processes
}