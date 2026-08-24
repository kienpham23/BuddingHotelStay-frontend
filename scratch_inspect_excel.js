import XLSX from 'xlsx';

const workbook = XLSX.readFile('spam_test_rooms.xlsx');
const sheet = workbook.Sheets[workbook.SheetNames[0]];
const rows = XLSX.utils.sheet_to_json(sheet, { header: 1 });

console.log('--- EXCEL ROWS ---');
rows.forEach((row, idx) => {
  console.log(`Row ${idx}:`, row);
});
