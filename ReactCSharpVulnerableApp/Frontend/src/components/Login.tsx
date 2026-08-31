import React, { useState } from 'react';
import axios from 'axios';

const LOGIN_URL = 'http://api.internal.corp/orders/api/auth/login';

interface LoginProps {
  onSuccess: () => void;
}

function Login({ onSuccess }: LoginProps) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const response = await axios.post(LOGIN_URL, { username, password });
    const token = response.data.token;

    localStorage.setItem('authToken', token);
    localStorage.setItem('userPassword', password);

    onSuccess();
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        placeholder="Username"
        value={username}
        onChange={(e) => setUsername(e.target.value)}
      />
      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
      />
      <button type="submit">Sign in</button>
    </form>
  );
}

export default Login;
