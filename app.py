from bottle import run
import core.database
import controllers.incident
import controllers.item
import controllers.relationship
import controllers.static

run(host='localhost', port=80, debug=True, reloader=True)
