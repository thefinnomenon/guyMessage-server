import {Socket, Presence} from "phoenix"

let socket = new Socket("/socket", {
  params: {token: window.userToken}
})

socket.connect()
let channel = socket.channel("conversation:lobby", {})
let message = $('#message-input')
let chatMessages = document.getElementById("chat-messages")
let presences = {}
let onlineUsers = document.getElementById("online-users")
let conversationsList = document.getElementById("conversations")

let listUsers = (user) => {
  return {
    user,
    username: presences[user].user.username
  }
}

let renderUsers = (presences) => {
  onlineUsers.innerHTML = Presence.list(presences, listUsers)
  .map(presence => `
    <li><a href="" onclick="return gotoConvo(${presence.user})">${presence.username}</a></li>`).join("")
}

let renderConversations = (conversations) => {
  conversationsList.innerHTML = conversations
  .map(conversation => `
    <li><a href="" onclick="return gotoConvo('${conversation.id}')">${conversation.id}</a></li>`).join("")
}

function gotoConvo(user_id) {
  console.log(user_id);
  return false;
}

message.focus();
message.on('keypress', event => {
  if(event.keyCode == 13) {
    channel.push('message:new', {message: message.val()})
    message.val("")
  }
});

channel.on('message:new', payload => {
  let template = document.createElement("div");
  template.innerHTML = `<b>${payload.user}</b>: ${payload.message}<br>`
  chatMessages.appendChild(template);
  chatMessages.scrollTop = chatMessages.scrollHeight;
});

channel.on('presence_state', state => {
  presences = Presence.syncState(presences, state)
  renderUsers(presences)
});

channel.on('presence_diff', diff => {
  presences = Presence.syncDiff(presences, diff)
  renderUsers(presences)
});

channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp)
    channel.push('get_conversations', {})
    .receive("ok", resp => {
      console.log(resp)
      renderConversations(resp.conversations)
    })
    .receive("error", resp => {
      console.log(resp)
    })
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket