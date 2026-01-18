from bottle import route, static_file

@route('/static/<filename>')
def send_static(filename):
    return static_file(filename, root='./static', headers={'Cache-Control': 'max-age=3600'})

@route('/favicon.ico')
def favicon():
    return static_file('favicon.ico', root='./static', headers={'Cache-Control': 'max-age=3600'})
