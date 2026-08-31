import React, { useEffect, useState } from 'react';

function OrderNotes() {
  const [note, setNote] = useState('');

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    const incoming = params.get('note');
    if (incoming) {
      setNote(incoming);
    }
  }, []);

  return (
    <div className="order-notes">
      <h2>Order Notes</h2>
      <input
        type="text"
        value={note}
        onChange={(e) => setNote(e.target.value)}
      />
      <div
        className="note-preview"
        dangerouslySetInnerHTML={{ __html: note }}
      />
    </div>
  );
}

export default OrderNotes;
