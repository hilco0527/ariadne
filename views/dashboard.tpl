% rebase('layout.tpl')
% import json

<header class="container-fluid">
    <hgroup style="display: flex; align-items: flex-start; gap: 1rem; width: 100%; margin-bottom: 0rem;">
        <a href="/" style="display: flex; align-items: center; color: var(--pico-color); text-decoration: none; margin-right: 0.5rem;">
            <img src="/static/arrow-left.svg" alt="Back" width="24" height="24">
        </a>
        <div style="display: flex; flex-direction: row; align-items: baseline; gap: 1rem;">
            <h3 style="margin-bottom: 0;">{{incident['title']}}</h3>
            <small>発生日時：{{format_date(incident['date'])}}</small>
        </div>
        <img src="/static/settings.svg" alt="Incident Settings" width="24" height="24" 
             onclick="document.getElementById('edit-incident-modal').showModal()" 
             style="cursor: pointer; margin-left: auto;">
    </hgroup>
</header>
<main class="container-fluid">
    <dialog id="edit-incident-modal">
        <article>
            <header>
                <button aria-label="Close" rel="prev" onclick="this.closest('dialog').close()"></button>
                <h3>インシデント設定</h3>
            </header>
            <form action="/incidents/{{incident['id']}}/update" method="POST">
                <label>
                    タイトル
                    <input type="text" name="title" value="{{incident['title']}}" autofocus>
                </label>
                <label>
                    発生日時
                    <input type="datetime-local" name="date" value="{{incident['date']}}">
                </label>
                <button type="submit">更新</button>
            </form>
        </article>
    </dialog>

    <div style="position: relative;">
        <svg id="connections" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 1;"></svg>

        <div class="grid" style="position: relative; display: grid; grid-template-columns: repeat(4, 1fr); align-items: start; gap: 0.2rem;">
            <!-- CAUSE -->
            <div class="column" data-type="CAUSE">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.2rem; border-bottom: 2px solid var(--pico-primary-background); padding-bottom: 0.2rem;">
                    <h6 style="margin: 0; border: none;">原因</h6>
                    <img src="/static/plus.svg" alt="Add Item" width="16" height="16" 
                         onclick="openItemModal('CAUSE')" 
                         style="cursor: pointer;">
                </div>
                <div class="items-container">
                    % for item in [i for i in items if i['type'] == 'CAUSE']:
                        % include('views/item_card.tpl', item=item, format_date=format_date)
                    % end
                </div>
            </div>

            <!-- EVENT -->
            <div class="column" data-type="EVENT">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.2rem; border-bottom: 2px solid var(--pico-primary-background); padding-bottom: 0.2rem;">
                    <h6 style="margin: 0; border: none;">事象</h6>
                    <img src="/static/plus.svg" alt="Add Item" width="16" height="16" 
                         onclick="openItemModal('EVENT')" 
                         style="cursor: pointer;">
                </div>
                <div class="items-container">
                    % for item in [i for i in items if i['type'] == 'EVENT']:
                        % include('views/item_card.tpl', item=item, format_date=format_date)
                    % end
                </div>
            </div>

            <!-- IMPACT -->
            <div class="column" data-type="IMPACT">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.2rem; border-bottom: 2px solid var(--pico-primary-background); padding-bottom: 0.2rem;">
                    <h6 style="margin: 0; border: none;">影響</h6>
                    <img src="/static/plus.svg" alt="Add Item" width="16" height="16" 
                         onclick="openItemModal('IMPACT')" 
                         style="cursor: pointer;">
                </div>
                <div class="items-container">
                    % for item in [i for i in items if i['type'] == 'IMPACT']:
                        % include('views/item_card.tpl', item=item, format_date=format_date)
                    % end
                </div>
            </div>

            <!-- RESPONSE -->
            <div class="column" data-type="RESPONSE">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.2rem; border-bottom: 2px solid var(--pico-primary-background); padding-bottom: 0.2rem;">
                    <h6 style="margin: 0; border: none;">対応</h6>
                    <img src="/static/plus.svg" alt="Add Item" width="16" height="16" 
                         onclick="openItemModal('RESPONSE')" 
                         style="cursor: pointer;">
                </div>
                <div class="items-container">
                    % for item in [i for i in items if i['type'] == 'RESPONSE']:
                        % include('views/item_card.tpl', item=item, format_date=format_date)
                    % end
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Item Modal -->
<dialog id="item-modal">
    <article>
        <header>
            <button aria-label="Close" rel="prev" onclick="this.closest('dialog').close()"></button>
            <h3 id="modal-title">アイテム作成</h3>
        </header>
        <form id="item-form" method="POST">
            <input type="hidden" name="type" id="item-type">
            <input type="hidden" name="updated_at" id="item-updated-at">
            
            <label>ID <input type="number" name="display_id" id="item-display-id" min="1"></label>
            <label>タイトル <input type="text" name="title" id="item-title"></label>

            <div id="field-rank" style="display:none;">
                <label>ランク
                    <select name="rank" id="item-rank">
                        <option value="">-</option>
                        <option value="A">A</option>
                        <option value="B">B</option>
                        <option value="C">C</option>
                    </select>
                </label>
            </div>
            
            <label>ステータス
                <select name="status" id="item-status">
                    <option value="OPEN">Open</option>
                    <option value="IN_PROGRESS">実施中</option>
                    <option value="COMPLETED">完了</option>
                    <option value="CLOSED">Closed</option>
                    <option value="NOT_STARTED">未着手</option>
                </select>
            </label>

            <div id="field-occurred-at">
                <label>発生日時 <input type="datetime-local" name="occurred_at" id="item-occurred-at"></label>
            </div>
            <div id="field-response" style="display:none;">
                <label>期限 <input type="datetime-local" name="deadline" id="item-deadline"></label>
                <label>開始日時 <input type="datetime-local" name="start_at" id="item-start-at"></label>
                <label>終了日時 <input type="datetime-local" name="end_at" id="item-end-at"></label>
                <label>担当者 <input type="text" name="assignee" id="item-assignee"></label>
            </div>

            <label>システム名 <input type="text" name="system_name" id="item-system-name"></label>
            <label>説明 <textarea name="description" id="item-description"></textarea></label>
            
            <div id="field-full-scale-response" style="display:none;">
                <label>本格対応 <textarea name="full_scale_response" id="item-full-scale-response"></textarea></label>
            </div>

            <div style="display: flex; justify-content: space-between; margin-top: 1rem;">
                <button type="button" id="delete-btn" style="background-color: #ef4444; border-color: #ef4444; color: white; display:none; width: auto; margin-bottom: 0;" onclick="deleteItem()">削除</button>
                <button type="submit" style="width: auto; margin-bottom: 0; margin-left: auto !important;">保存</button>
            </div>
        </form>
    </article>
</dialog>

<dialog id="connect-modal">
    <article>
        <header>
            <button aria-label="Close" rel="prev" onclick="this.closest('dialog').close()"></button>
            <h3>関係線の設定</h3>
        </header>
        <form id="connect-form" onsubmit="submitConnections(event)">
            <input type="hidden" id="connect-source-id">
            <input type="hidden" id="connect-direction">
            <div id="connect-candidates" style="max-height: 300px; overflow-y: auto;">
                <!-- Candidates will be injected here -->
            </div>
            <button type="submit" id="connect-submit-btn" style="margin-top: 1rem;">更新</button>
        </form>
    </article>
</dialog>

<script>
    const relationships = {{!json.dumps([dict(r) for r in relationships])}};
    const items = {{!json.dumps([dict(i) for i in items])}};
    const incidentId = {{incident['id']}};
    
    // server-side error injection
    % if defined('error'):
        const serverError = "{{error}}";
    % else:
        const serverError = null;
    % end
    
    % if defined('preserved_item'):
        const preservedItem = {{!json.dumps(preserved_item)}};
    % else:
        const preservedItem = null;
    % end

    function openItemModal(type, itemOrId = null) {
        const modal = document.getElementById('item-modal');
        const form = document.getElementById('item-form');
        const modalTitle = document.getElementById('modal-title');
        const deleteBtn = document.getElementById('delete-btn');
        const statusSelect = document.getElementById('item-status');

        document.getElementById('item-type').value = type;
        
        // Dynamically set status options
        statusSelect.innerHTML = '';
        if (type === 'RESPONSE') {
            const options = [
                { val: 'NOT_STARTED', text: '未着手' },
                { val: 'IN_PROGRESS', text: '実施中' },
                { val: 'COMPLETED', text: '完了' }
            ];
            options.forEach(opt => {
                const el = document.createElement('option');
                el.value = opt.val;
                el.innerText = opt.text;
                statusSelect.appendChild(el);
            });
        } else {
            const options = [
                { val: 'OPEN', text: 'Open' },
                { val: 'CLOSED', text: 'Closed' }
            ];
            options.forEach(opt => {
                const el = document.createElement('option');
                el.value = opt.val;
                el.innerText = opt.text;
                statusSelect.appendChild(el);
            });
        }
        
        let item = null;
        if (typeof itemOrId === 'number') {
            item = items.find(i => i.id === itemOrId);
        } else {
            item = itemOrId;
        }
        
        // Reset/Set fields
        if (item) {
            modalTitle.innerText = 'アイテム編集';
            form.action = '/items/' + item.id;
            document.getElementById('item-title').value = item.title;
            document.getElementById('item-display-id').value = item.display_id || '';
            // Ensure the value exists in options, otherwise add it or handle gracefullly?
            // Assuming current data fits the new model, but old data might have 'OPEN' for Response if migrated?
            // For now, let's assume strict separation. If 'OPEN' is on Response, it might not be selected?
            // Let's just set the value.
            statusSelect.value = item.status;
            
            document.getElementById('item-system-name').value = item.system_name || '';
            document.getElementById('item-description').value = item.description || '';
            document.getElementById('item-full-scale-response').value = item.full_scale_response || '';
            document.getElementById('item-occurred-at').value = item.occurred_at || '';
            document.getElementById('item-rank').value = item.rank || '';
            document.getElementById('item-deadline').value = item.deadline || '';
            document.getElementById('item-deadline').value = item.deadline || '';
            document.getElementById('item-start-at').value = item.start_at || '';
            document.getElementById('item-end-at').value = item.end_at || '';
            document.getElementById('item-assignee').value = item.assignee || '';
            document.getElementById('item-end-at').value = item.end_at || '';
            document.getElementById('item-assignee').value = item.assignee || '';
            document.getElementById('item-updated-at').value = item.updated_at || '';
            
            deleteBtn.style.display = 'block';
            deleteBtn.dataset.id = item.id;
        } else {
            modalTitle.innerText = '新規アイテム';
            form.action = '/incidents/' + incidentId + '/items';
            // Manually clear fields instead of form.reset() to preserve type
            document.getElementById('item-title').value = '';
            document.getElementById('item-display-id').value = '';
            
            // Fetch next ID
            fetch(`/incidents/${incidentId}/next_id?type=${type}`)
                .then(res => res.text())
                .then(nextId => {
                    document.getElementById('item-display-id').value = nextId;
                });
            
            // Set default status
            if (type === 'RESPONSE') {
                statusSelect.value = 'NOT_STARTED';
            } else {
                statusSelect.value = 'OPEN';
            }

            document.getElementById('item-system-name').value = '';
            document.getElementById('item-description').value = '';
            document.getElementById('item-full-scale-response').value = '';
            document.getElementById('item-rank').value = '';
            document.getElementById('item-assignee').value = '';
            deleteBtn.style.display = 'none';

            // Set default dates
            // const now = new Date();
            // now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            // const nowStr = now.toISOString().slice(0, 16);

            document.getElementById('item-occurred-at').value = '';
            document.getElementById('item-deadline').value = '';
            document.getElementById('item-start-at').value = '';
            document.getElementById('item-end-at').value = '';
            document.getElementById('item-updated-at').value = '';
            document.getElementById('item-updated-at').value = '';
        }

        // Show/Hide fields based on type
        document.getElementById('field-occurred-at').style.display = (type !== 'RESPONSE') ? 'block' : 'none';
        document.getElementById('field-full-scale-response').style.display = (type === 'CAUSE') ? 'block' : 'none';
        document.getElementById('field-rank').style.display = (type === 'IMPACT') ? 'block' : 'none';
        document.getElementById('field-response').style.display = (type === 'RESPONSE') ? 'block' : 'none';

        modal.showModal();
        document.getElementById('item-title').focus();
    }

    function deleteItem() {
        const id = document.getElementById('delete-btn').dataset.id;
        if(confirm('このアイテムを削除しますか？')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/items/' + id;
            const methodInput = document.createElement('input');
            methodInput.type = 'hidden';
            methodInput.name = '_method';
            methodInput.value = 'DELETE';
            form.appendChild(methodInput);
            document.body.appendChild(form);
            form.submit();
        }
    }

    function openConnectModal(itemId, type, side) {
        const modal = document.getElementById('connect-modal');
        document.getElementById('connect-source-id').value = itemId;
        const container = document.getElementById('connect-candidates');
        container.innerHTML = '';

        let targetTypes = [];
        let direction = ''; // 'forward' or 'backward' relative to source

        if (side === 'right') {
            direction = 'forward';
            if (type === 'CAUSE') targetTypes = ['EVENT'];
            else if (type === 'EVENT') targetTypes = ['IMPACT'];
            else if (type === 'IMPACT') targetTypes = ['RESPONSE'];
        } else {
            direction = 'backward';
            if (type === 'EVENT') targetTypes = ['CAUSE'];
            else if (type === 'IMPACT') targetTypes = ['EVENT'];
            else if (type === 'RESPONSE') targetTypes = ['IMPACT'];
        }
        
        document.getElementById('connect-direction').value = direction;

        const candidates = items.filter(i => targetTypes.includes(i.type));

        if (candidates.length === 0) {
            container.innerHTML = '<p>接続可能なアイテムがありませんでした。</p>';
            document.getElementById('connect-submit-btn').style.display = 'none';
        } else {
            document.getElementById('connect-submit-btn').style.display = 'block';
            candidates.forEach(c => {
                const label = document.createElement('label');
                label.style.display = 'block';
                label.style.padding = '0.5rem';
                label.style.borderBottom = '1px solid var(--pico-muted-border-color)';
                
                const input = document.createElement('input');
                input.type = 'checkbox';
                input.value = c.id;
                input.className = 'candidate-checkbox';
                
                // Check if connected
                let isConnected = false;
                if (direction === 'forward') {
                    isConnected = relationships.some(r => r.from_item_id === itemId && r.to_item_id === c.id);
                } else {
                    isConnected = relationships.some(r => r.from_item_id === c.id && r.to_item_id === itemId);
                }
                if (isConnected) input.checked = true;
                
                label.appendChild(input);
                const typeLabels = {
                    'CAUSE': '原因',
                    'EVENT': '事象',
                    'IMPACT': '影響',
                    'RESPONSE': '対応'
                };
                const displayId = c.display_id ? String(c.display_id).padStart(3, '0') : '---';
                label.appendChild(document.createTextNode(` [${typeLabels[c.type] || c.type}] ${displayId} ${c.title}`));
                container.appendChild(label);
            });
        }

        modal.showModal();
        
        // Focus logic
        const firstCheckbox = container.querySelector('input[type="checkbox"]');
        if (firstCheckbox) {
            firstCheckbox.focus();
        } else {
            // Focus close button if no checkboxes and no submit button
            const closeBtn = modal.querySelector('header button');
            if(closeBtn) closeBtn.focus();
        }

        event.stopPropagation();
    }
    
    function submitConnections(e) {
        e.preventDefault();
        const sourceId = parseInt(document.getElementById('connect-source-id').value);
        const direction = document.getElementById('connect-direction').value;
        const checkboxes = document.querySelectorAll('.candidate-checkbox');
        
        const addIds = [];
        const removeIds = [];
        
        checkboxes.forEach(cb => {
            const targetId = parseInt(cb.value);
            // Check original state to determine add/remove
            let wasConnected = false;
            if (direction === 'forward') {
                wasConnected = relationships.some(r => r.from_item_id === sourceId && r.to_item_id === targetId);
            } else {
                wasConnected = relationships.some(r => r.from_item_id === targetId && r.to_item_id === sourceId);
            }
            
            if (cb.checked && !wasConnected) {
                addIds.push(targetId);
            } else if (!cb.checked && wasConnected) {
                removeIds.push(targetId);
            }
        });
        
        fetch('/relationships/sync', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                source_id: sourceId,
                direction: direction,
                add_ids: addIds,
                remove_ids: removeIds
            })
        }).then(() => window.location.reload());
    }

    // Drawing lines
    function drawLines() {
        const svg = document.getElementById('connections');
        svg.innerHTML = '';
        const containerRect = document.querySelector('.grid').getBoundingClientRect();
        
        // Resize SVG to match container
        svg.style.height = document.querySelector('.grid').scrollHeight + 'px';

        relationships.forEach(rel => {
            const fromEl = document.getElementById('item-' + rel.from_item_id);
            const toEl = document.getElementById('item-' + rel.to_item_id);

            if (fromEl && toEl) {
                const fromRect = fromEl.getBoundingClientRect();
                const toRect = toEl.getBoundingClientRect();

                // Calculate relative coordinates
                // Draw from Right of From to Left of To
                const x1 = fromRect.right - containerRect.left;
                const y1 = fromRect.top + fromRect.height / 2 - containerRect.top;
                const x2 = toRect.left - containerRect.left;
                const y2 = toRect.top + toRect.height / 2 - containerRect.top;

                const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
                line.setAttribute('x1', x1);
                line.setAttribute('y1', y1);
                line.setAttribute('x2', x2);
                line.setAttribute('y2', y2);
                line.setAttribute('class', 'connection-line');
                line.setAttribute('stroke', '#a1a1aa');
                line.setAttribute('stroke-width', '2');

                line.setAttribute('pointer-events', 'none');
                // line.onclick = () => deleteRelationship(rel.id); // Removed interactivity
                
                line.setAttribute('data-from', rel.from_item_id);
                line.setAttribute('data-to', rel.to_item_id);
                
                svg.appendChild(line);
            }
        });
    }



    window.addEventListener('load', () => {
        drawLines();

        if (serverError && preservedItem) {
            alert(serverError);
            // We need to mix preservedItem (user form data) with the fresh updated_at from 'items'
            // Find the fresh item to get the valid updated_at
            const freshItem = items.find(i => i.id === preservedItem.id);
            if (freshItem) {
                // preservedItem.updated_at = freshItem.updated_at; // Removed to prevent auto-overwrite on second save
                // We use openItemModal passing the preservedItem which has user's text + OLD token
                openItemModal(preservedItem.type, preservedItem);
            }
        }
        
        // Add hover listeners
        document.addEventListener('mouseover', function(e) {
            const card = e.target.closest('.item-card');
            if (card) {
                const itemId = card.id.replace('item-', '');
                const lines = document.querySelectorAll('.connection-line');
                lines.forEach(line => {
                    if (line.dataset.from === itemId || line.dataset.to === itemId) {
                        line.classList.add('active');
                        // Move to top to ensure visibility over other lines
                        line.parentNode.appendChild(line); 
                    }
                });
            }
        });
        
        document.addEventListener('mouseout', function(e) {
            const card = e.target.closest('.item-card');
            if (card) {
                const lines = document.querySelectorAll('.connection-line');
                lines.forEach(line => line.classList.remove('active'));
            }
        });
    });
    window.addEventListener('resize', drawLines);
</script>

<style>
    .connection-line {
        transition: stroke 0.2s, stroke-width 0.2s;
    }
    .connection-line.active {
        stroke: #2563eb;
        stroke-width: 3;
        z-index: 10;
    }
    #item-form * {
        margin: 0 !important;
    }
</style>
