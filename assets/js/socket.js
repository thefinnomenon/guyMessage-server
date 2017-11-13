import {Socket, Presence} from "phoenix" // import Presence
let socket = new Socket("/socket", {
  params: {user_id: "7488a646-e31f-11e4-aace-600308960662"}})
socket.connect()
let channel = socket.channel("conversation:1", {})
let message = $('#message-input')
let chatMessages = document.getElementById("chat-messages")
// Added variables
let presences = {}
let onlineUsers = document.getElementById("online-users")
// Added block
let listUsers = (user) => {
  return {
    user: user
  }
}
// Added block
let renderUsers = (presences) => {
  onlineUsers.innerHTML = Presence.list(presences, listUsers)
  .map(presence => `
    <li>${presence.user}</li>`).join("")
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
// Added block
channel.on('presence_state', state => {
  presences = Presence.syncState(presences, state)
  renderUsers(presences)
});
// Added block
channel.on('presence_diff', diff => {
  presences = Presence.syncDiff(presences, diff)
  renderUsers(presences)
});
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
export default socket