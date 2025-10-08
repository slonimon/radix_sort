matrix = [1 0 1 1; 
          0 0 1 0; 
          1 1 0 1];

% Для одной строки
row = matrix(1, :); % [1 0 1 1]
row_str = num2str(row, '%d'); % '1 0 1 1'
row_str_no_spaces = strrep(row_str, ' ', ''); % '1011'
result = str2double(row_str_no_spaces); % 1011

% Или в одну строку
result = str2double(strrep(num2str(matrix(1, :), '%d'), ' ', ''));