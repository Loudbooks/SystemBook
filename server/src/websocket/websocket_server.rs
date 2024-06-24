use async_trait::async_trait;
use futures_util::{SinkExt, StreamExt};
use tokio::net::TcpStream;
use tokio_tungstenite::tungstenite::Message;
use tokio_tungstenite::WebSocketStream;

pub(crate) struct WebsocketServer {
    stream: WebSocketStream<TcpStream>,
    listener: Box<dyn WebsocketListener>
}

#[async_trait]
pub trait WebsocketListener {
    async fn handle_message(&self, message: &Message) -> String;
}

impl WebsocketServer {
    pub(crate) async fn new(stream: TcpStream, listener: Box<dyn WebsocketListener>) -> Box<WebsocketServer> {
        let ws_stream = tokio_tungstenite::accept_async(stream).await.expect("Error during the websocket handshake");


        Box::new(WebsocketServer {
            stream: ws_stream,
            listener
        })
    }

    pub(crate) async fn send_message(&mut self, message: String) {
        let write = &mut self.stream;
        write.send(Message::Text(message)).await.expect("Failed to send message");
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