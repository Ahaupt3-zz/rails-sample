App.feed = App.cable.subscriptions.create "FeedChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    unless data.micropost.blank?
      $('#microposts').prepend data.micropost