% import json
<div class="card item-card" id="item-{{item['id']}}" 
     style="position: relative; cursor: pointer; z-index: 2; background-color: #fcfcfc; width: 100%; box-sizing: border-box; margin: 0; padding: 0.2rem;"
     onclick="openItemModal('{{item['type']}}', {{item['id']}})">
    
    <!-- Connection Handles -->
    % if item['type'] != 'CAUSE':
    <div class="connect-handle left" onclick="openConnectModal({{item['id']}}, '{{item['type']}}', 'left')">
        <img src="/static/plus.svg" width="16" height="16" draggable="false">
    </div>
    % end
    % if item['type'] != 'RESPONSE':
    <div class="connect-handle right" onclick="openConnectModal({{item['id']}}, '{{item['type']}}', 'right')">
        <img src="/static/plus.svg" width="16" height="16" draggable="false">
    </div>
    % end

    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0rem;">
        <div style="font-weight: bold; font-size: 0.75rem; margin-right: 0rem;">
            % if item['display_id']:
            <span style="font-weight: normal; color: var(--pico-muted-color); margin-right: 0.2rem;">{{'{:03}'.format(item['display_id'])}}</span>
            % end
            {{item['title']}}
        </div>
        <div style="display: flex; gap: 0.2rem; flex-shrink: 0;">
            % if item['type'] == 'IMPACT' and item['rank']:
            <span class="rank-badge rank-{{item['rank']}}" style="width: 0.7rem; height: 0.7rem; line-height: 0.7rem; font-size: 0.45rem;">{{item['rank']}}</span>
            % end
            % status_map = {'OPEN': 'Open', 'IN_PROGRESS': '実施中', 'COMPLETED': '完了', 'CLOSED': 'Closed', 'NOT_STARTED': '未着手'}
            <span class="badge {{item['status']}}" style="font-size: 0.45rem; padding: 0rem 0.2rem;">{{status_map.get(item['status'], item['status'])}}</span>
        </div>
    </div>

    <div style="margin-bottom: 0.1rem; font-size: 0.65rem; color: var(--pico-muted-color);">
        % if item['type'] == 'RESPONSE':
            期限: {{format_date(item['deadline']) or '-'}}<br>
            開始: {{format_date(item['start_at']) or '-'}}<br>
            終了: {{format_date(item['end_at']) or '-'}}<br>
            担当者: {{item['assignee'] or '-'}}
        % else:
            発生日時：{{format_date(item['occurred_at']) or '-'}}
        % end
    </div>
    
    <div style="margin-bottom: 0.1rem; font-size: 0.65rem; color: var(--pico-muted-color);">
        システム：{{item['system_name'] or '-'}}
    </div>

    % if item['description']:
    <hr style="margin: 0.2rem 0; border-color: var(--pico-muted-border-color);">
    <div style="font-size: 0.5rem; white-space: pre-wrap; word-break: break-all; text-align: left;">{{item['description']}}</div>
    % end

    % if item['full_scale_response']:
    <hr style="margin: 0.2rem 0; border-color: var(--pico-muted-border-color);">
    <b style="font-size: 0.5rem;">本格対応</b>
    <div style="font-size: 0.5rem; white-space: pre-wrap; word-break: break-all; text-align: left;">{{item['full_scale_response']}}</div>
    % end

    <style>
        .connect-handle {
            position: absolute;
            top: 50%;
            width: 20px;
            height: 20px;
            transform: translateY(-50%);
            cursor: pointer;
            opacity: 0;
            transition: opacity 0.2s;
            z-index: 10;
            background-color: white;
            border-radius: 50%;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            user-select: none;
        }
        .item-card:hover .connect-handle {
            opacity: 1;
        }
        .connect-handle.left { 
            left: -10px; 
        }
        .connect-handle.right { 
            right: -10px; 
        }
        .connect-handle:hover {
            transform: translateY(-50%) scale(1.1);
            background-color: #0284c7;
        }
        .connect-handle:hover img {
            filter: invert(1) brightness(2);
        }
    </style>
</div>
