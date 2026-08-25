%% Load in a single dicom file
I = dicomread('/MATLAB Drive/1340/L2-922021/pigdicom/1.3.12.2.1107.5.2.31.30831.20130403190751299695434.dcm');

figure(1)
subplot(1,2,1);
imshow(I,[min(I(:)), max(I(:))])

subplot(1,2,2);
fReal = (fftshift(fft2(I)));
fAbs = abs(fftshift(fft2(I)));
imshow(fAbs,[min(fAbs(:)), max(fAbs(:))])


%% Read entire stack
dicomlist = dir(['/MATLAB Drive/1340/L2-922021/pigdicom/','*.dcm']);
I_stack = zeros([size(I),numel(dicomlist)]);

for cnt = 1 : numel(dicomlist)
% for cnt = numel(dicomlist):-1:1
    I_stack(:,:,cnt) = flipud(dicomread(['/MATLAB Drive/1340/L2-922021/pigdicom/',dicomlist(cnt).name]));  
end

Islice = squeeze(I_stack(:, 256/2,:));
imshow(Islice',[min(Islice(:)), max(Islice(:))]);

%% Write vtk volume out
filename = "pigdicomstack_flippedZ.vtk";
Spacing = [1.5, 1.5, 4.5];
% write_vtk_Volume(I_stack, Spacing, filename);

array = I_stack;

[nx, ny, nz] = size(array);
fid = fopen(filename, 'wt');
fprintf(fid, '# vtk DataFile Version 2.0\n');
fprintf(fid, 'Comment goes here\n');
fprintf(fid, 'ASCII\n');
fprintf(fid, '\n');
fprintf(fid, 'DATASET STRUCTURED_POINTS\n');
fprintf(fid, 'DIMENSIONS    %d   %d   %d\n', nx, ny, nz);
fprintf(fid, '\n');
fprintf(fid, 'ORIGIN    0.000   0.000   0.000\n');
fprintf(fid, 'SPACING   %d   %d  %d \n', Spacing(1),Spacing(2),Spacing(3));
fprintf(fid, '\n');
fprintf(fid, 'POINT_DATA   %d\n', nx*ny*nz);
fprintf(fid, 'SCALARS scalars double\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
fprintf(fid, '\n');
for a=1:nz
    for b=1:ny
        for c=1:nx
            fprintf(fid, '%d ', array(c,b,a));
        end
        fprintf(fid, '\n');
    end
end
fclose(fid);