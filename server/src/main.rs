use tokio::net::TcpListener;
use crate::websocket::websocket_listener::BasicListener;
use crate::websocket::websocket_server::WebsocketServer;

mod websocket;
mod collectors;
mod data;

#[tokio::main]
async fn main() {
    let addr = "127.0.0.1:9002";
    let listener = TcpListener::bind(&addr).await.expect("Failed to bind to address");

    println!("Listening on: {}", addr);
    
    let basic_listener = Box::new(BasicListener {});

    while let Ok((stream, _)) = listener.accept().await {
        let mut ws_server = WebsocketServer::new(
            tokio_tungstenite::accept_async(stream)
                .await
                .expect("Failed to accept connection"), &basic_listener);

        ws_server.listen().await;
    }
}