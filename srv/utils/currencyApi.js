exports.convert = async (amount, from, to = 'USD') => {
  if (from === to) return amount;
  try {
    const res = await fetch(`https://api.exchangerate-api.com/v4/latest/${from}`);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);

    const data = await res.json();
    const rate = data?.rates?.[to];

    return amount * rate;
  } catch (err) {
    console.error('Currency API error:', err.message);
  }
};
