import Player from "./player"

let Video = {

  init(socket, element) {
    if(!element) { return }

    let playerId = element.getAttribute("data-player-id");
    let videoId  = element.getAttribute("data-id");
    socket.connect()
    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket);
    })
  },

  onReady(videoId, socket) {
    let msgContainer = document.getElementById("msg-container");
    let msgInput     = document.getElementById("msg-input");
    let postButton   = document.getElementById("msg-submit");
    let vidChannel   = socket.channel(`videos:${videoId}`);

    postButton.addEventListener("click", (event) => {
      let payload = {body: msgInput.value, at: Player.getCurrentTime()}
      vidChannel.push("new_annotation", payload)
        .receive("error", e => console.log(e))
      msgInput.value = ""
    });

    vidChannel.on("new_annotation", (resp) => {
      vidChannel.params.last_seen_id = resp.id;
      this.renderAnnotation(msgContainer, resp);
    });

    msgContainer.addEventListener("click", (e) => {
      e.preventDefault();
      const seconds = e.target.getAttribute("data-seek") || e.target.parentNode.getAttribute("data-seek");
      if(!seconds) return;
      Player.seekTo(seconds)
    });

    vidChannel.join()
      .receive("ok", ({annotations}) => {
        const ids = annotations.map((an) => an.id);
        if (ids.length > 0) vidChannel.params.last_seen_id = Math.max(...ids);
        this.scheduleMessages(msgContainer, annotations)
      })
      .receive("error", reason => console.log("join failed", reason));
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    let template = document.createElement("div");
    template.innerHTML = `
    <a href"#" data-seek="${this.esc(at)}">
      [${this.formatTime(at)}]
      <b>${this.esc(user.username)}</b>: ${this.esc(body)}
    </a>
    `;
    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  },

  scheduleMessages(msgContainer, annotations) {
    setTimeout(() => {
      const ctime = Player.getCurrentTime();
      const remaining = this.renderAtTime(annotations, ctime, msgContainer);
      this.scheduleMessages(msgContainer, remaining);
    }, 1000);
  },

  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter((an) => {
      if (an.at > seconds) return true;
      this.renderAnnotation(msgContainer, an);
      return false;
    });
  },

  formatTime(at) {
    let date = new Date(null);
    date.setSeconds(at / 1000);
    return date.toISOString().substr(14, 5);
  },

  esc(str) {
    let div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  }
}


export default Video
