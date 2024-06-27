use async_trait::async_trait;
use futures_util::{SinkExt, StreamExt};
use tokio::net::TcpStream;
use tokio_tungstenite::tungstenite::Message;
use tokio_tungstenite::WebSocketStream;

pub(crate) struct WebsocketServer<'a> {
    stream: WebSocketStream<TcpStream>,
    listener: &'a Box<dyn WebsocketListener + 'a>
}

#[async_trait]
pub trait WebsocketListener {
    async fn handle_message(&self, message: &Message) -> String;
}

impl<'a> WebsocketServer<'a> {
    pub(crate) fn new(stream: WebSocketStream<TcpStream>, listener: &'a Box<dyn WebsocketListener + 'a>) -> Self {
        WebsocketServer {
            stream,
            listener,
        }
    }

    pub(crate) async fn send_message(&mut self, message: String) {
        let write = &mut self.stream;
        match write.send(Message::Text(message)).await {
            Ok(_) => {}
            Err(e) => {println!("Failed to send message: {:?}", e); eprintln!("Failed to send message: {:?}", e)}
        }
    }

    pub(crate) async fn listen(&mut self) {
        while let Some(Ok(message)) = &self.stream.next().await {
            if message.is_text() || message.is_binary() {
                let listener = &mut self.listener.as_ref();
                self.send_message(listener.handle_message(message).await).await;
            }
        }
    }
}