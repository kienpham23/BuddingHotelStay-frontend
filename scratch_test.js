import http from 'http';

http.get('http://localhost:8088/api/rooms?size=1000', (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    try {
      const parsed = JSON.parse(data);
      const content = parsed.content || parsed;
      const testRooms = content.filter(r => r.name.includes('Test Chống Spam') || r.name.includes('Trùng Tọa Độ'));
      console.log('--- TEST ROOMS FOUND ---');
      console.log(JSON.stringify(testRooms, null, 2));
    } catch (e) {
      console.error('PARSE ERROR:', e.message);
    }
  });
}).on('error', (err) => {
  console.error('ERROR:', err.message);
});
