import http from 'http';

http.get('http://localhost:8088/api/rooms', (res) => {
  let data = '';
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    console.log('STATUS:', res.statusCode);
    console.log('BODY:', data.substring(0, 500));
  });
}).on('error', (err) => {
  console.error('ERROR:', err.message);
});
