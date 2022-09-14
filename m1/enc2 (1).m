prompt='Enter the path of the image::     ';
path=input(prompt,'s');
f=imread(path);
imwrite(f,'newImage.bmp');
g=imread('newImage.bmp');
g1=g;
subplot(1,3,1), imshow(g), title('Original Image');

% prompt='Enter a value in between 150-250::    ';
% val=input(prompt,'s');
% if (val<=149)
%     error('insert a value in proper range!!');
% elseif (val>251)
% 	error('insert a value in proper range!!');
% end

[r,c]=size(g);

%encryption
g(1)=bitxor(g(1),170);
for i=2:r*c
  g(i)=bitxor(g(i),g(i-1));
end

subplot(1,3,2), imshow(g), title('Encrypted Image');

%decryption


g2=g;
g2(1)=bitxor(g(1),170);
for i=2:r*c
  g2(i)=bitxor(g(i),g(i-1));
end

subplot(1,3,3), imshow(g2), title('Decrypted Image');


%comparison
if(g2==g1)
	fprintf('\n\n Bingo!!!! \n');
else
	for i=1:r*c
		if(g1(i)~=g2(i))
			fprintf('\n %d th pixel     %d --------> %d \n',i,g1(i),g2(i) );
		end
	end
end
