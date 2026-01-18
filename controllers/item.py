from bottle import route, request, redirect, response, template
from models.item import ItemModel
from models.incident import IncidentModel
from models.relationship import RelationshipModel
from utils.helpers import format_date

ITEM_FIELDS = [
    'title', 'status', 'system_name', 'description', 'occurred_at',
    'rank', 'deadline', 'assignee', 'start_at', 'end_at',
    'full_scale_response', 'display_id'
]

@route('/incidents/<id:int>/items', method='POST')
def create_item(id):
    type_ = request.forms.get('type')
    data = {field: request.forms.get(field) for field in ITEM_FIELDS}

    display_id = data.get('display_id')
    if display_id:
        try:
            display_id_int = int(display_id)
            if display_id_int < 1:
                response.status = 400
                return "ID must be 1 or greater"
        except ValueError:
            response.status = 400
            return "Invalid ID format"
            
    ItemModel.create(id, type_, **data)
    redirect(f'/incidents/{id}')

@route('/items/<id:int>', method='POST')
def update_item(id):
    if request.forms.get('_method') == 'DELETE':
        return delete_item(id)

    data = {field: request.forms.get(field) for field in ITEM_FIELDS}
    display_id = data.get('display_id')
    
    if display_id:
        try:
            display_id_int = int(display_id)
            if display_id_int < 1:
                response.status = 400
                return "ID must be 1 or greater"
        except ValueError:
            response.status = 400
            return "Invalid ID format"
            
    form_updated_at = request.forms.get('updated_at')

    # Optimistic Locking Check
    current_item = ItemModel.get(id)
    if not current_item:
        return "Item not found", 404
        
    db_updated_at = current_item['updated_at']
    incident_id = current_item['incident_id']
    
    if db_updated_at and form_updated_at and db_updated_at != form_updated_at:
        incident = IncidentModel.get(incident_id)
        items = ItemModel.get_by_incident(incident_id)
        relationships = RelationshipModel.get_by_incident(incident_id)
        
        preserved_item = {
            'id': id,
            'type': request.forms.get('type') or 'CAUSE', 
            **data
        }
        
        return template('dashboard', 
                        incident=incident, 
                        items=items, 
                        relationships=relationships, 
                        format_date=format_date,
                        error="更新に失敗しました: アイテムは更新されています。",
                        preserved_item=preserved_item,
                        open_modal_id=id)

    ItemModel.update(id, **data)
    
    redirect(f'/incidents/{incident_id}')

def delete_item(id):
    item = ItemModel.get(id)
    if item:
        incident_id = item['incident_id']
        ItemModel.delete(id)
        redirect(f'/incidents/{incident_id}')
    else:
        return "Item not found", 404
