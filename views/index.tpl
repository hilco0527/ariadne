% rebase('layout.tpl')

<header class="container-fluid">
    <hgroup style="display: flex; align-items: center; gap: 1rem; width: 100%; margin-bottom: 0rem;">
        <h3 class="brand" style="margin-bottom: 0;">インシデント対応ボード - Ariadne -</h3>
        <img src="/static/plus.svg" alt="New Incident" width="24" height="24" 
             onclick="document.getElementById('new-incident-modal').showModal()" 
             style="cursor: pointer; margin-left: auto;">
    </hgroup>
</header>
<main class="container-fluid">
    <div class="grid">
        <div>
            <input type="search" name="q" placeholder="検索" style="margin-bottom: 0.2rem;"
                   value="{{query or ''}}"
                   hx-get="/" 
                   hx-trigger="input changed delay:500ms" 
                   hx-target="#incident-list"
                   hx-select="#incident-list"
                   hx-push-url="true">
        </div>
    </div>

    <div id="incident-list">
        <table role="grid">
            <thead>
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col">発生日時</th>
                    <th scope="col">タイトル</th>
                </tr>
            </thead>
            <tbody>
                % for incident in incidents:
                <tr onclick="window.location.href='/incidents/{{incident['id']}}'" style="cursor: pointer;">
                    <td>#{{incident['id']}}</td>
                    <td>{{format_date(incident['date'])}}</td>
                    <td><strong>{{incident['title']}}</strong></td>
                </tr>
                % end
            </tbody>
        </table>
    </div>
    <nav>
        <ul>
            % current_block = (page - 1) // 10
            % start_page = current_block * 10 + 1
            % end_page = min(start_page + 9, total_pages)

            % if start_page > 1:
            <li><a href="/?page={{max(1, page - 10)}}&q={{query or ''}}"><<</a></li>
            % end
            
            % for p in range(start_page, end_page + 1):
            <li><a href="/?page={{p}}&q={{query or ''}}" {{!'aria-current="page"' if p == page else ''}}>{{p}}</a></li>
            % end

            % if end_page < total_pages:
            <li><a href="/?page={{min(total_pages, page + 10)}}&q={{query or ''}}">>></a></li>
            % end
        </ul>
    </nav>
</main>

<dialog id="new-incident-modal">
    <article>
        <header>
            <button aria-label="Close" rel="prev" onclick="this.closest('dialog').close()"></button>
            <h3>新規インシデント</h3>
        </header>
        <form action="/incidents" method="POST">
            <label>
                タイトル
                <input type="text" name="title" autofocus>
            </label>
            <label>
                発生日時
                <input type="datetime-local" name="date" id="new-incident-date">
            </label>
            <button type="submit">作成</button>
        </form>
    </article>
</dialog>
<script>
    // Set default date to current time - REMOVED per user request
    // const now = new Date();
    // now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    // document.getElementById('new-incident-date').value = now.toISOString().slice(0, 16);
</script>
