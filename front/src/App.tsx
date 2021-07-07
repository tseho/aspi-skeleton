import React from 'react';
import { useQuery } from 'react-query';
import logo from './logo.svg';
import './App.css';

function App() {
  const { isLoading, data } = useQuery('message', () =>
    fetch(process.env.REACT_APP_API_BASEURL + '/hello')
      .then(res => res.json())
  );
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          {isLoading ? 'Loading ...' : data?.message || 'Failed'}
        </p>
      </header>
    </div>
  );
}

export default App;
