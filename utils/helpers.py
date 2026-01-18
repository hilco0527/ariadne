from datetime import datetime

def format_date(value):
    if not value: return ''
    try:
        # Assuming input is 'YYYY-MM-DDTHH:MM' or 'YYYY-MM-DD HH:MM'
        dt = datetime.fromisoformat(value.replace(' ', 'T'))
        return dt.strftime('%Y/%m/%d %H:%M')
    except:
        return value
