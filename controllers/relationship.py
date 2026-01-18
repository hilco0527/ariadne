from bottle import route, request, redirect
from models.relationship import RelationshipModel
from models.item import ItemModel

@route('/relationships/sync', method='POST')
def sync_relationships():
    data = request.json
    if not data:
        return "Invalid JSON", 400
        
    source_id = data.get('source_id')
    direction = data.get('direction') 
    
    if not source_id:
        return "Missing source_id", 400

    add_ids = data.get('add_ids', [])
    remove_ids = data.get('remove_ids', [])
    
    if direction == 'forward':
        for tid in add_ids:
            RelationshipModel.add(source_id, tid)
        for tid in remove_ids:
            RelationshipModel.remove(source_id, tid)
            
    elif direction == 'backward':
        for fid in add_ids:
             RelationshipModel.add(fid, source_id)
        for fid in remove_ids:
            RelationshipModel.remove(fid, source_id)

    RelationshipModel.commit()
    return "OK"

@route('/relationships', method='POST')
def create_relationship():
    from_id = request.forms.get('from_item_id')
    to_id = request.forms.get('to_item_id')
    
    if from_id and to_id:
        RelationshipModel.create(from_id, to_id)
        item = ItemModel.get(from_id)
        redirect(f'/incidents/{item["incident_id"]}')
        
    return "OK"

@route('/relationships/<id:int>', method='DELETE')
def delete_relationship(id):
    RelationshipModel.delete(id)
    return "OK"
