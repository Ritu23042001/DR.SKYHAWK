%Taking input of the image
fprintf('\n Inserted Image Should Be In .bmp Or .jpg Or .png File Format. .gif Images Are Strictly Phohibited! \n \n');
prompt = 'Enter The Path of The Image::  ';
path = input(prompt,'s');
s1 = imread(path);
imwrite(s1, 'convertedImage.bmp');
s=imread('convertedImage.bmp');




%reading the message 
    prompt = 'Enter Your Message::  ';	
    message = input(prompt,'s');
    message = strtrim(message); %trim extra 0's
    digest=md5(message);
    fprintf('\n\n The Message Digest of The Entered Message Is::  ');
    disp(digest);
    fileID=fopen('Digest.txt','w');
    formatSpec='%s %d \n';
    fprintf(fileID,formatSpec,digest);
    fclose(fileID);
    
    
    
    
    

    %checking and Validation
    lengthOfMessage=length(message);
    if(lengthOfMessage>255)
        error('Message Is Too Large! Please Insert Less Number Of Characters.');
    elseif(lengthOfMessage==0)
        error('No Message Is Found To Hide! Please Insert Your Message.');
    end
    
    
    
    
%calculating message attributes
   lengthOfMessageInBits=lengthOfMessage*8;
   fprintf('\n No Of Characters Present In The Mseeage Is     %d \n',lengthOfMessage);
   
   
  
   %converting message into stream of bits
    AsciiCode = uint8(message); %Message in Ascii int form
    binaryString =(dec2bin(AsciiCode,8));
    binaryString = binaryString(:);

    lengthOfBinaryString = length(binaryString);
    b = zeros(lengthOfBinaryString,1); %b is a vector of bits

    for k = 1:lengthOfBinaryString
        if(binaryString(k) == '1')
            b(k) = 1;
        else
            b(k) = 0;
        end
    end
    b1=reshape(b,1,lengthOfMessage*8);
    fprintf('\n\n Showing The Message In A Stream of bits \n');
    disp(b1);
    fprintf('\n\n Showing The Message In An Array of bits \n');
    newb1=reshape(b1,lengthOfMessage,8);
    disp(newb1);
    
    
    
      
    %encrption
    if(mod(lengthOfMessageInBits,64)==0)
        noOfEncNeeded=lengthOfMessageInBits/64;
    else
        noOfEncNeeded=floor(lengthOfMessageInBits/64)+1;
    end
    fprintf('\n\n Number Of Encryption Needed is %d : \n',noOfEncNeeded);
    fprintf('\n\n No Of Pixels Needed To Hide The Message Is:     %d \n',(noOfEncNeeded*64));
    
    storeArray=zeros(1,noOfEncNeeded*64);
    encArray=storeArray;
    keyArray=zeros(1,noOfEncNeeded*64);
    
    counter=1;
    for i=1:noOfEncNeeded*64
        if(counter<=lengthOfMessageInBits)
            storeArray(i)=b1(i);
            counter=counter+1;
        end
    end
    fprintf('\n\n Showing The Stuffed Message In A Stream Of Bits:: \n');
    disp(storeArray);
    
    
    index=0;
    for i=1:noOfEncNeeded
        [encMessage,key]=DES(storeArray((index*64)+1:64*(index+1)),'ENC');
            encArray((index*64)+1:64*(index+1))=encMessage(1:64);
            keyArray((index*64)+1:64*(index+1))=key(1:64);
            index=index+1;
    end
    fprintf('\n\n Showing the encrypted message in a stream of bits::  \n');
    disp(encArray);
    fprintf('\n\n Showing the encryption Key in a stream of bits::  \n');
    disp(keyArray);
    
    
    
    
    %Shows the messege in encrypted version
    encArray1=zeros(1,noOfEncNeeded*64);
    encArray1(1:noOfEncNeeded*64)=encArray(1:noOfEncNeeded*64);
    encArray1=reshape(encArray1,(noOfEncNeeded*8),8);
    binval=[128 64 32 16 8 4 2 1];
    encArray1=transpose(encArray1);
    encString=binval*encArray1;
    encString1=char(encString);
    fprintf('\n \n Shows the Message In Original Version: \n');
    disp(message);
    fprintf('\n \n Shows the Message In Encrypted Version: \n');
    disp(encString1);
    
    
    
       
      
   %converting the length of message into stream of bits
    binaryStringOfLength =(dec2bin(lengthOfMessage,8));

    lengthOfBinaryStringOfLength = length(binaryStringOfLength);
    b2 = zeros(1,lengthOfBinaryStringOfLength); %b is a vector of bits

    for k = 1:lengthOfBinaryStringOfLength
        if(binaryStringOfLength(k) == '1')
            b2(k) = 1;
        else
            b2(k) = 0;
        end
    end
    fprintf('\n\n Showing the Length of Message in a stream of bits \n');
    disp(b2);
    
    
    
    
%reading the image as input
copyOfS=s;
oldc=s;
%fprintf('\n Showing the image in original format \n');
%disp(s);
%[]=size(s);
[heightOfImage, widthOfImage]=size(s);
%fprintf('\n Showing the image in a stream of pixels \n');
%disp(s);




%Creates target pixels for message
fprintf('\n\n Showing The Target Pixels Of The Image For Message Embedding \n');
k=0;
newArray=zeros(1,noOfEncNeeded*64);%initializing newArray
counter=1;
for i=1:heightOfImage
    for j=1:widthOfImage
        k=k+1;
        if(k>54 && k<=(54+(noOfEncNeeded*64)))
            fprintf('%d...%d th pixel----> %d \n' ,counter,k,s(i,j));
            newArray(counter)=s(i,j);%creating an array of the target pixels
            counter=counter+1;
        end
    end
end
%len=length(s);
%disp(len);




%Creates target pixels for message length
fprintf('\n\n Showing The Target Pixels For The Message Length Embedding \n');
k1=1;
newArrayForLength=zeros(1,8); %initializing newArrayForLength
for i=heightOfImage:-1:1
    for j=widthOfImage:-1:1
        if(k1<=8)
            fprintf('%ld th pixel-----> %d...\n',((heightOfImage*widthOfImage)-k1+1) ,s(i,j));
            newArrayForLength(k1)=s(i,j);    %creating an array of the target pixels
            k1=k1+1;
        end
    end
end




%Creates target pixels for Key Insertion
fprintf('\n\n Showing The Target Pixels for The Key Embedding \n');
k1=0;
counter=1;
newArrayForKey=zeros(1,noOfEncNeeded*64); %initializing newArrayForLength
for i=heightOfImage:-1:1
    for j=widthOfImage:-1:1
        k1=k1+1;
        if(k1>8 && k1<=(8+noOfEncNeeded*64))
            fprintf('%d...%ld th pixel-----> %d...\n',counter,((heightOfImage*widthOfImage)-k1+1) ,s(i,j));
            newArrayForKey(counter)=s(i,j);    %creating an array of the target pixels
            counter=counter+1;
        end
    end
end



%Displayes target pixels for message and message length and Key
fprintf('\n\n Showing New Pixel Array For Message \n');
disp(newArray);
fprintf('\n\n Showing New Pixel Array For Message Length \n');
disp(newArrayForLength);
fprintf('\n\n Showing New Pixel Array For Key \n');
disp(newArrayForKey);




%LSB substitution for message
 lenOfNewArray1=length(newArray);
    for i = 1 : lenOfNewArray1
             LSB = mod(double(newArray(i)), 2);
             if (LSB == encArray(i))
                  newArray(i) =  newArray(i);
             else
                 if(LSB == 1)
                    newArray(i) = newArray(i) - 1;
                else
                    newArray(i) = newArray(i) + 1;
                 end
             end
    end
    fprintf('\n Showing New Pixel Array For Message After Substitution \n');
    disp(newArray);
    
    
    
    
    % LSB substitution for message length
    for i2 = 1 : 8
             LSB = mod(double(newArrayForLength(i2)), 2);
             if (LSB == b2(i2))
                  newArrayForLength(i2) =  newArrayForLength(i2);
             else
                 if(LSB == 1)
                    newArrayForLength(i2) = newArrayForLength(i2) - 1;
                 else
                    newArrayForLength(i2) = newArrayForLength(i2) + 1;
                 end
             end
    end
    fprintf('\n Showing New Pixel Array For Length After Substitution \n');
    disp(newArrayForLength);
    
    
    
    
 %LSB substitution for key
    for i = 1 : noOfEncNeeded*64
             LSB = mod(double(newArrayForKey(i)), 2);
             if (LSB == keyArray(i))
                  newArrayForKey(i) =  newArrayForKey(i);
             else
                 if(LSB == 1)
                    newArrayForKey(i) = newArrayForKey(i) - 1;
                else
                   newArrayForKey(i) = newArrayForKey(i) + 1;
                 end
             end
    end
    fprintf('\n\n Showing New Pixel Array For Key After Substitution \n');
    disp(newArrayForKey);
    

    
    
%inserting message values in the image
k3=0;
m3=1;
for i=1:heightOfImage
    for j=1:widthOfImage
        k3=k3+1;
        if(k3>54 && k3<=(54+(noOfEncNeeded*64)))
            copyOfS(i,j)=newArray(m3);
            m3=m3+1;
        end
    end
end




%inserting length of message values in the image
k4=1;
for i=heightOfImage:-1:1
    for j=widthOfImage:-1:1
        if(k4<=8)
            copyOfS(i,j)=newArrayForLength(k4);
            k4=k4+1;
        end
    end
end




%inserting key values in the image
k5=0;
counter=1;
for i=heightOfImage:-1:1
    for j=widthOfImage:-1:1
        k5=k5+1;
        if(k5>8 && k5<=(8+(noOfEncNeeded*64)))
            copyOfS(i,j)=newArrayForKey(counter);
            counter=counter+1;
        end
        
    end
end




%Writes the output Image
imwrite(copyOfS, 'hiddenmsgimage.bmp');




%compares pixels and shows differnces
counter=1;
subplot(1,3,1),imshow(s1), title('Original Image(Input-File)');
subplot(1,3,2),imshow(oldc), title('Converted Image(.bmp File)');
subplot(1,3,3),imshow(copyOfS), title('Stego-Image');
%[r1,c1]=size(c);
for i= 1:heightOfImage
    for j=1:widthOfImage
        if(oldc(i,j)~=copyOfS(i,j))
            fprintf('\n %d. Pixel(%d,%d) Previously  %d ------> AfterChange  %d' ,counter,i,j,oldc(i,j),copyOfS(i,j)); 
            counter=counter+1;
        end
    end
end
fprintf('\n\n Data Is Hidden Successfully!!! \n');




%Key value converting to hex code
key1=binaryVectorToHex(keyArray);
fprintf('\n\n Shows The DES Shared Secret Key In Hexadecimal format ::   ');
disp(key1);
fileID=fopen('Key.txt','w');
formatSpec='%s %d \n';
[nrows,ncols]=size(key1);
for row=1:nrows
    fprintf(fileID,formatSpec,key1{row,:});
end
fclose(fileID);


fileId=fopen('Key.txt','r');
msg=fscanf(fileId,'%s',inf);
%another type of histogram
% figure(3),subplot(1,3,1),hist(double(s1)),title('Original Image');
% figure(3),subplot(1,3,2),hist(double(oldc)),title('convertedImage');
% figure(3),subplot(1,3,3),hist(double(copyOfS)),title('Stego-Image');
