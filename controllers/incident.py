from bottle import route, request, redirect, template, response
from models.incident import IncidentModel
from models.item import ItemModel
from models.relationship import RelationshipModel
from utils.helpers import format_date

@route('/')
def index():
    query = request.query.q
    page = int(request.query.page or 1)
    per_page = 15
    offset = (page - 1) * per_page

    incidents = IncidentModel.get_all(query, per_page, offset)
    total_count = IncidentModel.count(query)
    
    total_pages = (total_count + per_page - 1) // per_page
    
    return template('index', incidents=incidents, page=page, total_pages=total_pages, query=query, format_date=format_date)

@route('/incidents', method='POST')
def create_incident():
    title = request.forms.get('title')
    date = request.forms.get('date')
    
    if not date:
        date = '' 
        
    new_id = IncidentModel.create(title, date)
    redirect(f'/incidents/{new_id}')

@route('/incidents/<id:int>/update', method='POST')
def update_incident(id):
    title = request.forms.get('title')
    date = request.forms.get('date')
    
    IncidentModel.update(id, title, date)
    redirect(f'/incidents/{id}')

@route('/incidents/<id:int>')
def dashboard(id):
    incident = IncidentModel.get(id)
    if not incident:
        return "Incident not found"
    
    items = ItemModel.get_by_incident(id)
    relationships = RelationshipModel.get_by_incident(id)
    
    return template('dashboard', incident=incident, items=items, relationships=relationships, format_date=format_date)

@route('/incidents/<id:int>/next_id')
def get_next_id(id):
    type_ = request.query.type
    if not type_:
        return "Missing type", 400
    
    return str(ItemModel.get_next_display_id(id, type_))
