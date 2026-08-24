import fs from 'fs';

try {
  const files = fs.readdirSync('D:\\anhduan');
  console.log('--- FILES IN D:\\anhduan ---');
  files.forEach(file => {
    console.log(file);
  });
} catch (err) {
  console.error('Lỗi khi đọc thư mục:', err.message);
}
