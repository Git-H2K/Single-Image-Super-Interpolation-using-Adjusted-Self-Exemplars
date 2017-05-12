filename = 'lena512.tif';

HR_img = imread(filename);
Ori_img_Color = HR_img;
HR_img = rgb2ycbcr(HR_img);   

Pad=2;
Scale=2;
Degree=2;

HR_img = HR_img(:,:,1);
HR_size = size(HR_img(:,:,1));

% adjusting Image size 
Adj_HR_size = ceil(HR_size/Scale)*Scale;
Adj_HR_size = [Adj_HR_size,1];
Adj_HR_img = zeros(Adj_HR_size);
Adj_HR_img(1:HR_size(1),1:HR_size(2),:) = HR_img;

for i = HR_size(1):Adj_HR_size(1)
    Adj_HR_img(i,1:HR_size(2),:) = HR_img(end,:,:);
end
for i = HR_size(2):Adj_HR_size(2)
    Adj_HR_img(:,i,:) = Adj_HR_img(:,HR_size(2),:);
end

HR_img = double(Adj_HR_img);
LR_img = imresize(HR_img,0.5);
Feed_img=LR_img;

% gradient operaotr
hdx = [1,-1];
hdy = [1;-1];
hdx2 = [2,-1;-1,0];
hdy2 = [-1,0;2,-1];

% Threshold
Thr1=25;
Thr2=25;

% main
for i=1:3
    i
    Out_D = class_IMG(Thr1,Pad,Scale,Degree,LR_img,Feed_img,hdx,hdy);
    Out_img = test_IMG(Thr1,Pad,Scale,Degree,LR_img,Out_D,hdx,hdy);

    Out_D2 = class_IMG(Thr2,Pad,Scale,Degree,LR_img,Feed_img,hdx2,hdy2);
    Out_img2 = test_IMG(Thr2,Pad,Scale,Degree,LR_img,Out_D2,hdx2,hdy2);

    % Ensemble        
    Feed_img= (Out_img2 + Out_img)/2;   
    Degree=Degree+2;
end

Bicubic_img= imresize(LR_img,2, 'bicubic');
PSNR_Bic=psnr(Bicubic_img,HR_img,255)

PSNR_ours=psnr(Feed_img,HR_img,255)