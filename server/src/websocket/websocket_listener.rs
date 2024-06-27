use async_once::AsyncOnce;
use async_trait::async_trait;
use lazy_static::lazy_static;
use tokio_tungstenite::tungstenite::Message;

use crate::websocket::handlers::list_handler::ListHandler;
use crate::websocket::websocket_server::WebsocketListener;

pub struct BasicListener {}

lazy_static! {
    static ref LIST_HANDLER: AsyncOnce<ListHandler> = AsyncOnce::new(async {
        let listener = ListHandler::new();
        let mut async_listener = listener.clone();
        async_listener.gather_processes().await;
        
        tokio::spawn(async move {
            async_listener.begin_listening().await;
        });
        
        listener
    });
}

#[async_trait]  
impl WebsocketListener for BasicListener {
    async fn handle_message(&self, message: &Message) -> String {
        let message = message.to_text().map_err(|err| {
            eprintln!("Failed to convert message to text: {:?}", err);
        }).unwrap_or_default();
        
        match message {
            "LIST" => {
                println!("Respondg with: {:?}", LIST_HANDLER.get().await.get_list());
                serde_json::to_string(&LIST_HANDLER.get().await.get_list()).unwrap_or_default()
            }
            _ => {
                "Invalid Command".to_string()
            }
        }
    }
}


