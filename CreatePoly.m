function [string_poly, coeffs] = CreatePoly(order)

coeffs = cell(1,order+2);

% Set coefficients
for i = 1:order*2+2
    coeffs{i} = char(96+i);
end

if(order*2+2) >= 10
    coeffs{9} = char(96+order*2+2+1);
    coeffs{10} = char(96+order*2+2+2);
elseif (order*2+2) >= 9
    coeffs{9} = char(96+order*2+2+1);
end



% x equation
string_poly = "";
for i = 1:order+1
    string_poly = string_poly + coeffs{i} + "*x^" + string(i-1) + " + ";
end

% y equation
for i = order+2:order*2+2
    string_poly = string_poly + coeffs{i} + "*y^" + string(i-1) + " + ";
end

string_poly = convertStringsToChars(string_poly);
string_poly = string_poly(:,1:end-3);