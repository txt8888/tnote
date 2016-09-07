{CompositeDisposable} = require 'atom'

module.exports =
  activate: (state) ->
    atom.notifications.addInfo 'TNote is ready!'
    @subs = new CompositeDisposable
    @subs.add atom.commands.add 'atom-text-editor',
                                'tnote:insert-timestamp': (ev) =>
                                  @insertTimestamp ev.currentTarget.getModel()

  deactivate: ->
    @subs.dispose()

  insertTimestamp: (ed) ->
    weekdays = [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ]

    now      = new Date()
    year     = now.getFullYear()
    month    = @zerop(now.getMonth()+1)
    day      = @zerop(now.getDate())
    wday     = weekdays[now.getDay()]

    suffix   = (if (now.getHours() >= 12) then 'PM' else 'AM')
    hours    = @zerop(now.getHours() % 12 || 12)
    minutes  = @zerop(now.getMinutes())
    seconds  = @zerop(now.getSeconds())

    ed.setCursorBufferPosition(0)
    ed.insertText("=== #{year}/#{month}/#{day} (#{wday}) #{hours}:#{minutes}:#{seconds} #{suffix} ===\n\n\n")
    ed.moveUp(2)

  zerop: (value) ->
    return ('0' + value).slice(-2)
