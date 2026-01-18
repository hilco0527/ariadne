<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ariadne</title>
    <link rel="icon" type="image/x-icon" href="/favicon.ico">
    <link rel="stylesheet" href="/static/pico.classless.zinc.min.css">
    <script src="/static/htmx.min.js"></script>
    <script src="/static/_hyperscript.min.js"></script>
    <style>
        :root {
            --primary: #0284c7;
            --primary-hover: #0369a1;
        }
        body {
            padding-top: 0;
            font-size: 0.7rem;
            background-color: #f4f4f5;
            min-height: 100vh;
        }
        header {
            padding: 1rem 0;
            border-bottom: 1px solid var(--pico-muted-border-color);
            margin-bottom: 0rem;
        }
        .container-fluid {
            max-width: 100%;
            padding-left: 0.2rem;
            padding-right: 0.2rem;
            padding-top: 0.2rem;
            padding-bottom: 0rem;
        }
        .nav-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .brand {
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
            color: var(--pico-color);
        }
        /* Custom styles */
        .card {
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid var(--pico-muted-border-color);
            border-radius: var(--pico-border-radius);
            background: var(--pico-card-background-color);
        }
        .badge {
            padding: 0.25rem 0.5rem;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: bold;
            color: white;
        }
        .badge.OPEN { background-color: #ef4444; }
        .badge.CLOSED { background-color: #6b7280; }
        .badge.IN_PROGRESS { background-color: #3b82f6; }
        .badge.NOT_STARTED { background-color: #ef4444; }
        .badge.COMPLETED { background-color: #6b7280; }
        
        .rank-badge {
            display: inline-block;
            width: 1.5rem;
            height: 1.5rem;
            line-height: 1.5rem;
            text-align: center;
            border-radius: 50%;
            color: white;
            font-weight: bold;
            font-size: 0.8rem;
        }
        .rank-A { background-color: #dc2626; }
        .rank-B { background-color: #f97316; }
        .rank-C { background-color: #eab308; }

        /* Modal styles override */
        dialog article {
            max-width: 600px;
        }
        
        /* Dashboard Column Styles */
        .column {
            background: var(--pico-background-color);
            padding: 0.5rem;
            border-radius: var(--pico-border-radius);
            min-height: 85vh;
            border: 1px solid var(--pico-muted-border-color);
            min-width: 0;
        }
        .column h4 {
            text-align: center;
            margin-bottom: 1rem;
            border-bottom: 2px solid var(--pico-primary-background);
            padding-bottom: 0.5rem;
        }
        .items-container {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
    </style>
</head>
<body>
    {{!base}}
    <script>
        // Global Modal Scroll Lock
        // Observes all dialog elements for the 'open' attribute change.
        const observer = new MutationObserver((mutations) => {
            mutations.forEach((mutation) => {
                if (mutation.attributeName === 'open') {
                    const dialog = mutation.target;
                    const anyOpen = document.querySelector('dialog[open]');
                    if (anyOpen) {
                        document.documentElement.style.overflow = 'hidden';
                    } else {
                        document.documentElement.style.overflow = '';
                    }
                }
            });
        });

        // Start observing existing dialogs and any future ones
        // We need to observe the document for added nodes to attach observers to new dialogs if they are dynamically added?
        // Actually, simpler: just observe standard dialogs. If they are in DOM at load, we attach.
        // If htmx swaps in a dialog, we might miss it if we only attach once. 
        // Better: Use a delegate approach or observe the whole body for subtree modifications? 
        // Subtree on body is expensive. 
        // Alternative: Listen to 'show' and 'close' events? Standard <dialog> doesn't bubble 'close' comfortably in all cases? 
        // Actually 'close' event exists. 'cancel' exists.
        // But 'showModal()' doesn't trigger a standard event that bubbles nicely?
        // The 'open' attribute is reliable. 
        
        // Let's stick to observing attributes on known dialogs. HTMX might add new ones.
        // So we should ideally run logic when new content is added.
        
        function attachDialogObservers() {
             document.querySelectorAll('dialog').forEach(dialog => {
                // Check if already observed? MutationObserver doesn't have a check.
                // But duplicate observation with same observer is ignored if options same? No.
                // So we need a flag.
                if (!dialog.dataset.scrollLockObserved) {
                    observer.observe(dialog, { attributes: true, attributeFilter: ['open'] });
                    dialog.dataset.scrollLockObserved = 'true';
                }
             });
        }

        // Attach to initial dialogs
        attachDialogObservers();

        // If using HTMX, new dialogs might arrive.
        document.body.addEventListener('htmx:load', () => {
            attachDialogObservers();
        });
        
        // Also handle the case where a dialog might be open by default (rare but possible)
        if (document.querySelector('dialog[open]')) {
            document.documentElement.style.overflow = 'hidden';
        }
    </script>
</body>
</html>
