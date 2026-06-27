import { Order, OrderItem, CustomerInfo, Product } from '../../../core/types';
import { formatDate } from '../../../core/utils/helpers';
import apiClient from '../../../core/api/apiClient';

const getCustomerInfo = (order: Order): CustomerInfo => {
  if (order.customerId && typeof order.customerId === 'object') {
    const customer = order.customerId as CustomerInfo;
    return {
      _id: customer._id || '-',
      username: customer.username || '-',
      phone: customer.phone || '-',
      address: customer.address || '-',
    };
  }
  return {
    _id: String(order.customerId) || '-',
    username: '-',
    phone: '-',
    address: '-',
  };
};

const getProductInfo = (item: OrderItem): { title: string, units: number } => {
  if (item.productId && typeof item.productId === 'object') {
    const product = item.productId as { title?: string, units?: number };
    return {
      title: product.title || '-',
      units: product.units || item.units || 1
    };
  }
  return {
    title: String(item.productId),
    units: item.units || 1
  };
};

const formatQuantityFull = (quantity: number, units: number): string => {
  if (units <= 1) return String(quantity);

  const packs = Math.floor(quantity / units);
  const rest = quantity % units;

  if (rest === 0) {
    return `${packs}×${units} = ${quantity}`;
  }
  return `${packs}×${units}+${rest} = ${quantity}`;
};

export const printOrder = async (order: Order) => {
  // Fetch missing product info
  const productCache: Record<string, { title: string; units: number }> = {};
  const productIdsToFetch: string[] = [];

  order.items.forEach((item) => {
    if (typeof item.productId === 'string') {
      productIdsToFetch.push(item.productId);
    }
  });

  if (productIdsToFetch.length > 0) {
    await Promise.all(
      productIdsToFetch.map(async (productId) => {
        try {
          const response = await apiClient.get<{ status: string; data: Product }>(`/products/${productId}`);
          if (response.data.status === 'success' && response.data.data) {
            productCache[productId] = {
              title: response.data.data.title,
              units: response.data.data.units || 1,
            };
          }
        } catch (err) {
          console.error(`Failed to fetch product ${productId}:`, err);
          productCache[productId] = { title: productId, units: 1 };
        }
      })
    );
  }

  const customer = getCustomerInfo(order);
  const timeOfCreation = formatDate(order.createdAt);
  const comment = order.comment || '';

  const itemsHtml = order.items.map((item) => {
    let title = '';
    let units = 1;

    if (item.productId && typeof item.productId === 'object') {
      const product = item.productId as { title?: string, units?: number };
      title = product.title || '-';
      units = product.units || item.units || 1;
    } else {
      const productId = String(item.productId);
      if (productCache[productId]) {
        title = productCache[productId].title;
        units = productCache[productId].units;
      } else {
        title = productId;
        units = item.units || 1;
      }
    }

    const formattedQuantity = formatQuantityFull(item.quantity, units);
    const subtotal = Number(item.quantity) * Number(item.price);

    return `
      <tr>
        <td class="td-product">${title}</td>
        <td class="td-center">${formattedQuantity}</td>
        <td class="td-right">${Number(item.price).toFixed(2)} DA</td>
        <td class="td-right"><strong>${subtotal.toFixed(2)} DA</strong></td>
      </tr>
    `;
  }).join('');

  const printContent = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Receipt - Order #${order._id.slice(-8)}</title>
      <style>
        @page { 
          size: auto; 
          margin: 0; 
        }
        body {
          font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
          color: #000;
          line-height: 1.5;
          padding: 15mm;
          margin: 0;
          background-color: #fff;
        }
        .print-container {
          max-width: 100%;
          margin: 0 auto;
        }
        
        /* Header */
        .header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin-bottom: 30px;
          padding-bottom: 15px;
          border-bottom: 3px solid #000;
        }
        .header-title {
          font-size: 32px;
          font-weight: 900;
          letter-spacing: 1px;
          text-transform: uppercase;
          margin: 0;
        }
        .header-meta {
          text-align: right;
          font-size: 14px;
        }
        .header-meta div {
          margin-bottom: 4px;
        }
        
        /* Info Grid */
        .info-section {
          display: flex;
          justify-content: space-between;
          margin-bottom: 25px;
        }
        .info-block {
          width: 48%;
        }
        .block-title {
          font-size: 13px;
          font-weight: bold;
          text-transform: uppercase;
          letter-spacing: 1px;
          border-bottom: 2px solid #000;
          padding-bottom: 4px;
          margin-bottom: 10px;
        }
        .info-row {
          display: flex;
          margin-bottom: 6px;
          font-size: 14px;
        }
        .info-label {
          font-weight: bold;
          width: 90px;
          flex-shrink: 0;
        }
        
        /* Comments */
        .comment-section {
          margin-bottom: 25px;
          padding: 15px;
          background-color: #f9f9f9;
          border-left: 4px solid #000;
          -webkit-print-color-adjust: exact;
          print-color-adjust: exact;
        }
        .comment-text {
          font-size: 14px;
          margin-top: 5px;
        }
        
        /* Table */
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 35px;
          margin-bottom: 25px;
          border-top: 3px solid #000;
          border-bottom: 3px solid #000;
        }
        th, td {
          padding: 14px 10px;
        }
        th {
          font-weight: bold;
          text-align: left;
          font-size: 13px;
          text-transform: uppercase;
          letter-spacing: 1px;
          border-bottom: 2px solid #000;
        }
        td {
          border-bottom: 1px solid #ddd;
        }
        tr:last-child td {
          border-bottom: none;
        }
        .td-product { 
          font-weight: 800; 
          font-size: 18px; 
        }
        .td-center, .th-center { text-align: center; }
        .td-center {
          font-size: 22px;
          font-weight: 900;
        }
        .td-right, .th-right { text-align: right; }
        .td-right {
          font-size: 16px;
        }
        
        /* Totals */
        .total-section {
          display: flex;
          justify-content: flex-end;
          align-items: baseline;
          padding-top: 15px;
        }
        .total-label {
          font-size: 16px;
          font-weight: bold;
          text-transform: uppercase;
          letter-spacing: 1px;
          margin-right: 20px;
        }
        .total-amount {
          font-size: 26px;
          font-weight: 900;
        }
      </style>
    </head>
    <body>
      <div class="print-container">
        <!-- Header -->
        <div class="header">
          <h1 class="header-title">ORDER RECEIPT</h1>
          <div class="header-meta">
            <div><strong>REF:</strong> #${order._id.slice(-8).toUpperCase()}</div>
            <div><strong>DATE:</strong> ${timeOfCreation}</div>
          </div>
        </div>
        
        <!-- Info Section -->
        <div class="info-section">
          <div class="info-block">
            <div class="block-title">CUSTOMER DETAILS</div>
            <div class="info-row">
              <span class="info-label">Name:</span>
              <span>${customer.username}</span>
            </div>
            <div class="info-row">
              <span class="info-label">ID:</span>
              <span>${customer._id}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Phone:</span>
              <span>${customer.phone}</span>
            </div>
            <div class="info-row">
              <span class="info-label">Address:</span>
              <span>${customer.address}</span>
            </div>
          </div>
          
          <div class="info-block">
            <div class="block-title">ORDER SUMMARY</div>
            <div class="info-row">
              <span class="info-label">Items:</span>
              <span>${order.items.length} unique item(s)</span>
            </div>
          </div>
        </div>

        <!-- Comments -->
        ${comment ? `
        <div class="comment-section">
          <div class="block-title" style="border: none; margin: 0;">ORDER NOTES</div>
          <div class="comment-text">${comment}</div>
        </div>
        ` : ''}

        <!-- Table -->
        <table>
          <thead>
            <tr>
              <th>Product</th>
              <th class="th-center">Quantity</th>
              <th class="th-right">Price</th>
              <th class="th-right">Subtotal</th>
            </tr>
          </thead>
          <tbody>
            ${itemsHtml}
          </tbody>
        </table>

        <!-- Totals -->
        <div class="total-section">
          <div class="total-label">Total Amount</div>
          <div class="total-amount">${Number(order.totalAmount ?? 0).toFixed(2)} DA</div>
        </div>
      </div>
    </body>
    </html>
  `;

  // Create an invisible iframe for printing
  const iframe = document.createElement('iframe');
  iframe.style.position = 'fixed';
  iframe.style.right = '0';
  iframe.style.bottom = '0';
  iframe.style.width = '0';
  iframe.style.height = '0';
  iframe.style.border = '0';
  document.body.appendChild(iframe);

  const doc = iframe.contentWindow?.document;
  if (doc) {
    doc.open();
    doc.write(printContent);
    doc.close();

    // Focus and print after a tiny delay for rendering
    setTimeout(() => {
      iframe.contentWindow?.focus();
      iframe.contentWindow?.print();

      // Cleanup the iframe after the print dialog is handled
      setTimeout(() => {
        if (document.body.contains(iframe)) {
          document.body.removeChild(iframe);
        }
      }, 1000);
    }, 250);
  } else {
    document.body.removeChild(iframe);
    alert('Failed to generate print document.');
  }
};
