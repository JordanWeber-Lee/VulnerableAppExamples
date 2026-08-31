import React, { useState } from 'react';

function ReportRunner() {
  const [formula, setFormula] = useState('order.total * 1.08');
  const [result, setResult] = useState<string>('');

  const runFormula = () => {
    const order = { total: 100, quantity: 3 };
    const computed = eval(formula);
    setResult(String(computed));
  };

  return (
    <div className="report-runner">
      <h2>Report Formula</h2>
      <input
        type="text"
        value={formula}
        onChange={(e) => setFormula(e.target.value)}
      />
      <button onClick={runFormula}>Run</button>
      <span className="result">{result}</span>
    </div>
  );
}

export default ReportRunner;
