import React, { useState } from 'react';
import Login from './components/Login';
import OrderNotes from './components/OrderNotes';
import ReportRunner from './components/ReportRunner';
import MessageBridge from './components/MessageBridge';

function App() {
  const [loggedIn, setLoggedIn] = useState(false);

  return (
    <div className="app">
      <h1>Orders Dashboard</h1>
      {!loggedIn ? (
        <Login onSuccess={() => setLoggedIn(true)} />
      ) : (
        <div>
          <OrderNotes />
          <ReportRunner />
          <MessageBridge />
        </div>
      )}
    </div>
  );
}

export default App;
