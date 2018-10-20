function varargout = guiFourier(varargin)
% GUIFOURIER MATLAB code for guiFourier.fig
%      GUIFOURIER, by itself, creates a new GUIFOURIER or raises the existing
%      singleton*.
%
%      H = GUIFOURIER returns the handle to a new GUIFOURIER or the handle to
%      the existing singleton*.
%   
%      GUIFOURIER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFOURIER.M with the given input arguments.
%
%      GUIFOURIER('Property','Value',...) creates a new GUIFOURIER or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiFourier_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiFourier_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiFourier

% Last Modified by GUIDE v2.5 20-Oct-2018 22:20:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiFourier_OpeningFcn, ...
                   'gui_OutputFcn',  @guiFourier_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before guiFourier is made visible.
function guiFourier_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiFourier (see VARARGIN)

% Choose default command line output for guiFourier
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% define default values of global variables
global img kernel;

addpath('./im_utils');

% --- Outputs from this function are returned to the command line.
function varargout = guiFourier_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes on slider movement.
function K_slider_Callback(hObject, eventdata, handles)
% hObject    handle to K_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function K_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to K_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function gamma_slider_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function gamma_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function R_slider_Callback(hObject, eventdata, handles)
% hObject    handle to R_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function R_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function scale_fact_Callback(hObject, eventdata, handles)
% hObject    handle to scale_fact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.sf_txt, 'String', strcat('Scale Factor (where applicable): ',num2str(get(handles.scale_fact,'Value'))));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function scale_fact_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scale_fact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global resIm;
[filename,user_canceled] = imsave();
if user_canceled == 0
    imwrite(resIm, filename);
end

% --- Executes on button press in original_button.
function original_button_Callback(hObject, eventdata, handles)
% hObject    handle to original_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img resIm;
resIm = img;
imshow(resIm, 'Parent', handles.image_axes);

% --- Executes on button press in gammaButton.
function gammaButton_Callback(hObject, eventdata, handles)
% hObject    handle to gammaButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img img_fft kernel_fft laplacian_fft resIm img_gt;

gamma = get(handles.gamma_slider, 'Value');

laplacian = [0 -1 0; -1 4 -1; 0 -1 0];
[x, laplacian_fft] = pad2im(laplacian, img);

invF = img_fft.*conj(kernel_fft)./(abs(kernel_fft).^2 + gamma*laplacian_fft);
invF(:, :, 1) = ifft2(invF(:, :, 1));
invF(:, :, 2) = ifft2(invF(:, :, 2));
invF(:, :, 3) = ifft2(invF(:, :, 3));

sf = get(handles.scale_fact, 'Value');
resIm = abs(invF*sf);

set(handles.acc_txt, 'String', strcat('SSIM: ',num2str(ssim(resIm,img_gt)),'    PSNR: ',num2str(psnr(resIm,img_gt))));
set(handles.gamma_txt, 'String', strcat('gamma: ',num2str(gamma)));
imshow(resIm, 'Parent', handles.image_axes);

% --- Executes on button press in KButton.
function KButton_Callback(hObject, eventdata, handles)
% hObject    handle to KButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_fft kernel_fft resIm img_gt;

K = get(handles.K_slider, 'Value');

invF = img_fft.*conj(kernel_fft)./(abs(kernel_fft).^2 + K);
invF(:, :, 1) = ifft2(invF(:, :, 1));
invF(:, :, 2) = ifft2(invF(:, :, 2));
invF(:, :, 3) = ifft2(invF(:, :, 3));

sf = get(handles.scale_fact, 'Value');
resIm = abs(invF*sf);

set(handles.acc_txt, 'String', strcat('SSIM: ',num2str(ssim(resIm,img_gt)),'    PSNR: ',num2str(psnr(resIm,img_gt))));
set(handles.K_txt, 'String', strcat('K: ',num2str(K)));
imshow(resIm, 'Parent', handles.image_axes);

% --- Executes on button press in truncInvButton.
function truncInvButton_Callback(hObject, eventdata, handles)
% hObject    handle to truncInvButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img kernel img_fft kernel_fft resIm img_gt;

r = get(handles.R_slider, 'Value');
[h_i, w_i, d_i] = size(img);
c_mask = circle_gen(min(h_i, w_i), r);

invF = img_fft./kernel_fft;

invF(:, :, 1) = fftshift(invF(:, :, 1));
invF(:, :, 2) = fftshift(invF(:, :, 2));
invF(:, :, 3) = fftshift(invF(:, :, 3));

invF = invF.*repmat(c_mask,[1 1 3]);

invF(:, :, 1) = ifft2(ifftshift(invF(:, :, 1)));
invF(:, :, 2) = ifft2(ifftshift(invF(:, :, 2)));
invF(:, :, 3) = ifft2(ifftshift(invF(:, :, 3)));

sf = get(handles.scale_fact, 'Value');
resIm = abs(invF*sf);

set(handles.acc_txt, 'String', strcat('SSIM: ',num2str(ssim(resIm,img_gt)),'    PSNR: ',num2str(psnr(resIm,img_gt))));
set(handles.R_txt, 'String', strcat('r: ',num2str(r)));
imshow(resIm, 'Parent', handles.image_axes);

% --- Executes on button press in fullInverseButton.
function fullInverseButton_Callback(hObject, eventdata, handles)
% hObject    handle to fullInverseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_fft kernel_fft resIm img_gt;

invF = img_fft./kernel_fft;
invF(:, :, 1) = ifft2(invF(:, :, 1));
invF(:, :, 2) = ifft2(invF(:, :, 2));
invF(:, :, 3) = ifft2(invF(:, :, 3));

sf = get(handles.scale_fact, 'Value');
resIm = abs(invF*sf);

set(handles.acc_txt, 'String', strcat('SSIM: ',num2str(ssim(resIm,img_gt)),'    PSNR: ',num2str(psnr(resIm,img_gt))));
imshow(resIm, 'Parent', handles.image_axes);

% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img img_fft kernel kernel_fft kernel_unp;
[filename,user_canceled] = imgetfile();
if user_canceled == 0
    read = im2double(imread(filename));
    if length(size(read))==2
        read = repmat(read, [1, 1, 3]);
    end
    
    img  = read;
    img_fft(:,:,1) = fft2(img(:, :, 1));
    img_fft(:,:,2) = fft2(img(:, :, 2));
    img_fft(:,:,3) = fft2(img(:, :, 3));
    
    [kernel, kernel_fft] = pad2im(kernel_unp, img);
    
    imshow(img, 'Parent', handles.image_axes);
end

% --- Executes on button press in kernelButton.
function kernelButton_Callback(hObject, eventdata, handles)
% hObject    handle to kernelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img kernel kernel_fft kernel_unp;
[filename,user_canceled] = imgetfile();
if user_canceled == 0
    read = imread(filename);
    kernel_unp = im2double(read);
    
    [kernel, kernel_fft] = pad2im(kernel_unp, img);
    imshow(kernel_unp, 'Parent', handles.kernel_axes);
end


% --- Executes on button press in loadGT.
function loadGT_Callback(hObject, eventdata, handles)
% hObject    handle to loadGT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_gt;
[filename,user_canceled] = imgetfile();
if user_canceled == 0
    read = im2double(imread(filename));
    if length(size(read))==2
        read = repmat(read, [1, 1, 3]);
    end
    img_gt = read;
    imshow((img_gt), 'Parent', handles.gt_axes);
end
