
function varargout = ImageEditor(varargin)
% IMAGEEDITOR MATLAB code for ImageEditor.fig
%      IMAGEEDITOR, by itself, creates a new IMAGEEDITOR or raises the
%      existing singleton*.
%
%      H = IMAGEEDITOR returns the handle to a new IMAGEEDITOR or the
%      handle to the existing singleton*.
%
%      IMAGEEDITOR('CALLBACK',hObject,eventData,handles,...) calls the
%      local function named CALLBACK in IMAGEEDITOR.M with the given input
%      arguments.
%
%      IMAGEEDITOR('Property','Value',...) creates a new IMAGEEDITOR or
%      raises the existing singleton*.  Starting from the left, property
%      value pairs are applied to the GUI before ImageEditor_OpeningFcn
%      gets called.  An unrecognized property name or invalid value makes
%      property application stop.  All inputs are passed to
%      ImageEditor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageEditor

% Last Modified by GUIDE v2.5 03-Sep-2018 01:23:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageEditor_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageEditor_OutputFcn, ...
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


% --- Executes just before ImageEditor is made visible.
function ImageEditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn. hObject    handle to
% figure eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) varargin
% command line arguments to ImageEditor (see VARARGIN)

% Choose default command line output for ImageEditor
handles.output = hObject;
axes(handles.axes1); % set imshow output to axis1

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageEditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% define default values of global variables
global curr_im images_list list_end filename;
images_list = {};
list_end = 1;
images_list{list_end} = zeros(800,800,3); %blank image
curr_im = images_list{list_end}; %set current image to end of list
imshow(curr_im);
filename = ""; % set default value of filename to "" in order to check later from unloaded state

% --- Outputs from this function are returned to the command line.
function varargout = ImageEditor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT); hObject
% handle to figure eventdata  reserved - to be defined in a future version
% of MATLAB handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in eqHistButton.
function eqHistButton_Callback(hObject, eventdata, handles)
% hObject    handle to eqHistButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global curr_im images_list list_end;

hsv = rgb2hsv(curr_im);
I = round(255*hsv(:,:,3));

[rows,cols] = size(I);
tot = rows*cols;

%create a list out of intensity values, initialize pdf and cdf arrays
k = I(:);
pdf_var = zeros(256);
cdf_var = zeros(256);

%calculate pmf
for i=1:tot
    pdf_var(k(i)+1)=pdf_var(k(i)+1)+1;
end

%calculate "cmf"
sum=0;
for i=1:256
    sum = sum + pdf_var(i);
    cdf_var(i) = sum;
end

%calculate actual cdf
cdf_var = cdf_var/tot;

%map intensity values to image's intensity map
for i=1:rows
    for j=1:cols
        hsv(i,j,3) = cdf_var(I(i,j)+1);
    end
end

%save image and display
curr_im = hsv2rgb(hsv);

list_end = list_end + 1;
images_list{list_end} = curr_im;
imshow(curr_im);

% --- Executes on button press in gammaButton.
function gammaButton_Callback(hObject, eventdata, handles)
% hObject    handle to gammaButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global curr_im images_list list_end;

gamma = get(handles.gammaSlider, 'Value');
hsv = rgb2hsv(curr_im);
I = hsv(:,:,3);
hsv(:,:,3) = im2double(I.^(10^gamma));

%save image and display
curr_im = hsv2rgb(hsv);

list_end = list_end + 1;
images_list{list_end} = curr_im;
imshow(curr_im);

% --- Executes on slider movement.
function gammaSlider_Callback(hObject, eventdata, handles)
% hObject    handle to gammaSlider (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider


% --- Executes during object creation, after setting all properties.
function gammaSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaSlider (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in logButton.
function logButton_Callback(hObject, eventdata, handles)
% hObject    handle to logButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global curr_im images_list list_end;

% Take logarithm of intensity values(in 0-255), and normalize.
hsv = rgb2hsv(curr_im);
I = round(hsv(:,:,3).*255);
hsv(:,:,3) = log(I+1)/log(256); % added one to start log from log(1) = 0
disp(hsv(:,:,3))

%save image and display
curr_im = hsv2rgb(hsv);

list_end = list_end + 1;
images_list{list_end} = curr_im;
imshow(curr_im);


% --- Executes on button press in blurButton.
function blurButton_Callback(hObject, eventdata, handles)
% hObject    handle to blurButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global curr_im images_list list_end;

hsv = rgb2hsv(curr_im);

%send to blur function, using the slider-extracted value. Set intensity
%map using the function result.
filterlengthby2 = round(get(handles.blurSlider, 'Value'));
k = applyfilter(filterlengthby2,"");
hsv(:,:,3) = k;

%save image and display
disp(hsv(:,:,3))
curr_im = hsv2rgb(hsv);

list_end = list_end + 1;
images_list{list_end} = curr_im;
imshow(curr_im);


% --- Executes on slider movement.
function blurSlider_Callback(hObject, eventdata, handles)
% hObject    handle to blurSlider (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider


% --- Executes during object creation, after setting all properties.
function blurSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blurSlider (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in sharpenButton.
function sharpenButton_Callback(hObject, eventdata, handles)
% hObject    handle to sharpenButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global curr_im images_list list_end;

hsv = rgb2hsv(curr_im);

%Take sharpen size from slider, send to the "blur" function to sharpen.
%Normalize to 0-1 range after the process
sharpen_size = round(get(handles.sharpenSlider, 'Value'));
k = applyfilter(sharpen_size,"sharpen");
hsv(:,:,3) = mat2gray(mat2gray(k)+hsv(:,:,3));
disp(hsv(:,:,3))
curr_im = hsv2rgb(hsv);

list_end = list_end + 1;
images_list{list_end} = curr_im;
imshow(curr_im);

% --- Executes on slider movement.
function sharpenSlider_Callback(hObject, eventdata, handles)
% hObject    handle to sharpenSlider (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider


% --- Executes during object creation, after setting all properties.
function sharpenSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sharpenSlider (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in negateButton.
function negateButton_Callback(hObject, eventdata, handles)
% hObject    handle to negateButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global curr_im images_list list_end;

%negate image
curr_im = 1 - curr_im;

%save image and display
list_end = list_end + 1;
images_list{list_end+1} = curr_im;
imshow(curr_im);


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO) eventdata  reserved - to be defined
% in a future version of MATLAB handles    empty - handles not created
% until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global curr_im images_list list_end filename;

[filename,user_canceled] = imgetfile();
if user_canceled == 0
    %if file is loaded, then display
    list_end=1; %set as first image on load
    read = im2double(imread(filename));
    if length(size(read))==2
        read = repmat(read, [1, 1, 3]);
    end
    images_list{list_end} = read;
    curr_im = images_list{list_end};
    
    imshow(curr_im);
end
    
% --- Executes on button press in undoButton.
function undoButton_Callback(hObject, eventdata, handles)
% hObject    handle to undoButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global curr_im images_list list_end;

%roll back to previous image and if start reached, stop rolling back
if list_end ~= 1
    list_end = list_end - 1;
    curr_im = images_list{list_end};
    imshow(curr_im);
end

% --- Executes on button press in undoAllButton.
function undoAllButton_Callback(hObject, eventdata, handles)
% hObject    handle to undoAllButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

%roll back to first image in list
global curr_im images_list list_end; 
list_end = 1;
curr_im = images_list{list_end};
imshow(curr_im);


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global curr_im filename;
if filename~=""
    % if a file has been loaded, write the image to the source
    imwrite(curr_im, filename);
end

function res =  applyfilter(filterlengthby2,a)
global curr_im;

%get grayscale image with dims
hsv = rgb2hsv(curr_im);
I = hsv(:,:,3);
[rows,cols] = size(I);

for i=1:rows
    for j=1:cols
        %make area of application of filter
        A = I(max(1,i-filterlengthby2):min(rows,i+filterlengthby2),max(1,j-filterlengthby2):min(cols,j+filterlengthby2));
        
        %if sharpen, then use a suitable filter
        if a=="sharpen"
            p = (2*filterlengthby2+1)^2;
            hsv(i,j,3) = (p*I(i,j)-sum(A(:)))/p;
        else
        %else blur with mean filter
            hsv(i,j,3) = mean(A(:));
        end
    end
end

res = hsv(:,:,3);


% --- Executes on button press in graybutton.
function graybutton_Callback(hObject, eventdata, handles)
% hObject    handle to graybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curr_im images_list list_end;

%select intensity map from image
curr_im = repmat(rgb2gray(curr_im), [1, 1, 3]);

list_end = list_end + 1;
images_list{list_end} = curr_im;
imshow(curr_im);


% --- Executes on button press in redoButton.
function redoButton_Callback(hObject, eventdata, handles)
% hObject    handle to redoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global curr_im images_list list_end;
k = "";
try 
    k = images_list{list_end+1};
catch
    msgbox("Can't redo, no further images stored.");
    return
end

list_end = list_end + 1;
curr_im = images_list{list_end};
imshow(curr_im);
