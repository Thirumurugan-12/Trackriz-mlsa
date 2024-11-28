from flask import Flask, request, jsonify
import uuid

app = Flask(__name__)

# In-memory storage for invoices
invoices = {}

@app.route('/invoice', methods=['POST'])
def add_invoice():
    invoice_id = request.json.get('id', str(uuid.uuid4()))
    price = request.json.get('price')
    if not invoice_id or not price:
        return jsonify({'error': 'Invalid data'}), 400
    invoices[invoice_id] = price
    return jsonify({'success': True}), 200

@app.route('/invoice/<invoice_id>', methods=['GET'])
def get_invoice(invoice_id):
    price = invoices.get(invoice_id)
    if price is None:
        return jsonify({'error': 'Invoice not found'}), 404
    return jsonify({'id': invoice_id, 'price': price}), 200

if __name__ == '__main__':
    app.run(debug=True)