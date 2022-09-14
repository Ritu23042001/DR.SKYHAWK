%reading the input
prompt='Enter The Path Of The Image::   ';
path=input(prompt,'s');
imageArray=imread(path);
[lenOfImage,widOfImage]=size(imageArray);
targetPixels=zeros(1,8);
index=1;
fprintf('\n Showing the Length Embeded Pixels \n');
k=0;
for i=lenOfImage:-1:1
	for j=widOfImage:-1:1
		k=k+1;
		if(k<=8)
			disp(imageArray(i,j));
			targetPixels(index)=imageArray(i,j);
			index=index+1;
		end
	end
end




fprintf('\n Showing The Contents of targetArray \n');
disp(targetPixels);




for i=1:8
	targetPixels(i)=mod(double(targetPixels(i)),2);
end
fprintf('\n Showing The Remainder Array \n');
disp(targetPixels);




binval=[128 64 32 16 8 4 2 1];
targetPixels=targetPixels(:);
lengthOfMessage=binval*targetPixels;
fprintf('\n Number of Characters Present In The Message is::  %d \n',lengthOfMessage);
fprintf('\n \n');




%calculating attributes
lengthOfMessageInBits=lengthOfMessage*8;
if(mod(lengthOfMessageInBits,64)==0)
        noOfDecNeeded=lengthOfMessageInBits/64;
    else
        noOfDecNeeded=floor(lengthOfMessageInBits/64)+1;
end
    fprintf('\n Number of Decryption Needed is %d : \n',noOfDecNeeded);




%calculating effected pixels for encrypted message
noOfEffectedPixels=noOfDecNeeded*64;
encArray=zeros(1,noOfDecNeeded*64);
k1=0;
index1=1;
for i=1:lenOfImage
    for j=1:widOfImage
        k1=k1+1;
        if(k1>54 && k1<=(54+noOfDecNeeded*64))
            encArray(index1)=imageArray(i,j);
            index1=index1+1;
        end
    end
end
fprintf('\n\n Displays The Effected Pixels Due To Encrypted Message \n');
disp(encArray);
for i=1:noOfDecNeeded*64
    encArray(i)=mod(double(encArray(i)),2);
end
fprintf('\n\n Displays The Encrypted Message \n');
disp(encArray);




%calculating effected pixels for encryption key
keyArray=zeros(1,noOfDecNeeded*64);
k1=0;
counter=1;
for i=lenOfImage:-1:1
    for j=widOfImage:-1:1
        k1=k1+1;
        if(k1>8 && k1<=(8+noOfDecNeeded*64))
            keyArray(counter)=imageArray(i,j);    %creating an array of the target pixels
            counter=counter+1;
        end
    end
end
fprintf('\n\n Showing The Effected Pixels Due To Key Embedding \n');
disp(keyArray);
for i=1:noOfDecNeeded*64
    keyArray(i)=mod(double(keyArray(i)),2);
end
fprintf('\n\n Displays The Actual Key \n');
disp(keyArray);

%comparisation
prompt='Enter the path of the key file::    ';
keyPath=input(prompt,'s');
fileId=fopen(keyPath,'r');
scannedKey=fscanf(fileId,'%s',inf);
fclose(fileId);
disp(scannedKey);
genKey=hexToBinaryVector(scannedKey);


% len=length(scannedKey);
% disp(len);
% key=zeros(1,(len/6));
% index=0;
% size=[((index*6)+1) ((index+1)*6)];
% a=fscanf(fileId,'%ld',size);
% disp(a);
% for i=1:(len/6)
%     key(i)=fscanf(fileId,'%d',size);
%     index=index+1;
% end


% lenOfGenKey=length(genKey);
% genKey=reshape(genKey,8,(lenOfGenKey/8));
% genKeyInAscii=binval*genKey;
% genKeyInAscii=char(genKeyInAscii);

%implementing RSA
% prompt='Enter The value of (N):     ';
% Pk=input(prompt,'s');
% prompt='Enter The public key (e):     ';
% e=input(prompt,'s');
% prompt='Enter The value of (Phi):     ';
% Phi=input(prompt,'s');
% prompt='Enter The value of (d):     ';
% d=input(prompt,'s');
% 
% 
% % % %Decryption
% x=length(genKeyInAscii);
% c=0;
% for j= 1:x
%     for i=0:122
%         if strcmp(M(j),char(i))
%             c(j)=i;
%         end
%     end
% end
% disp('ASCII Code of the entered Message:');
% disp(c); 
% message=zeros(1,x);
% for j= 1:x
%    message(j)= crypt(c(j),Pk,d); 
% end
% disp('Decrypted ASCII of Message:');
% disp(message);
% orgKey=char(message);
% disp(orgKey);
% genKey=hexToBinaryVector(orgKey);

if(genKey==keyArray)
    fprintf('They Are Same');
else
    error('You are a foooooool!');
end



%Decryption Starts Here
decArray=zeros(1,noOfDecNeeded*64);
    index=0;
    for i=1:noOfDecNeeded
        [decMessage]=DES(encArray((index*64)+1:64*(index+1)),'DEC',genKey((index*64)+1:64*(index+1)));
            decArray((index*64)+1:64*(index+1))=decMessage(1:64);
            index=index+1;
    end
    fprintf('\n Showing the decrypted message in a stream of bits::  \n');
    disp(decArray);



%Extraction of the message bits
retArray=zeros(1,lengthOfMessage*8);
retArray(1:lengthOfMessage*8)=decArray(1:lengthOfMessage*8);







 retArray=reshape(retArray,lengthOfMessage,8);
 fprintf('\n\n Showing The Message Array in Binary Form \n');
 disp(retArray);
 retArray=transpose(retArray);
 
 charArray=binval*retArray;
 charString=char(charArray);
 fprintf('\n Showing The Hidden Message \n');
 disp(charString);
 newDigest=md5(charString);
 fprintf('\n\n The Message Digest of The Retrieved Message Is:   ');
 disp(newDigest);
 prompt='Enter The Path of The Digest File::  ';
 dpath=input(prompt,'s');
 fileId=fopen(dpath,'r');
 oldDigest=fscanf(fileId,'%s',inf);
 fclose(fileId);
 fprintf('\n\n The Message Digest As Recieved Is:   ');
 disp(oldDigest);
 
 if(newDigest==oldDigest)
     fprintf('\n\n The Message Is Absolutely Ok!!');
 else
     error('Message Has Been Either Altared or Tampered!! ');
 end
			