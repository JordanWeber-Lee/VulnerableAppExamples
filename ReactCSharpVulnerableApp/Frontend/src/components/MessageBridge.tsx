import React, { useEffect, useState } from 'react';

function MessageBridge() {
  const [balance, setBalance] = useState(0);

  useEffect(() => {
    const handleMessage = (event: MessageEvent) => {
      const data = event.data;
      if (data && data.type === 'applyCredit') {
        setBalance((current) => current + Number(data.amount));
        localStorage.setItem('accountBalance', String(data.amount));
      }
    };

    window.addEventListener('message', handleMessage);
    return () => window.removeEventListener('message', handleMessage);
  }, []);

  return (
    <div className="message-bridge">
      <h2>Account Balance</h2>
      <span>{balance}</span>
    </div>
  );
}

export default MessageBridge;
