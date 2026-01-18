from bottle import route, static_file

@route('/static/<filename>')
def send_static(filename):
    return static_file(filename, root='./static')
