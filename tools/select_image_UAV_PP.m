function varargout = select_image(varargin)
% SELECT_IMAGE MATLAB code for select_image.fig
%      SELECT_IMAGE, by itself, creates a new SELECT_IMAGE or raises the existing
%      singleton*.
%
%      H = SELECT_IMAGE returns the handle to a new SELECT_IMAGE or the handle to
%      the existing singleton*.
%
%      SELECT_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT_IMAGE.M with the given input arguments.
%
%      SELECT_IMAGE('Property','Value',...) creates a new SELECT_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_image_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select_image

% Last Modified by GUIDE v2.5 28-Nov-2017 16:32:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_image_OpeningFcn, ...
                   'gui_OutputFcn',  @select_image_OutputFcn, ...
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


% --- Executes just before select_image is made visible.
function select_image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select_image (see VARARGIN)

% Choose default command line output for select_image
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(hObject,'toolbar','figure')
global i
global flag
i = 1;   % 第几张图片
global k
k = 1;   % 存储的第几张
global src
src = uigetdir('H:\Data\UAV-Bottle\UAV-Bottle-V3.0.0\RAW\1_Sand\Cut','源目录');
global dst
dst = uigetdir('H:\Data\UAV-Bottle\UAV-Bottle-V3.0.0\RAW\test','目标目录');

set(handles.text_src,'string',src,'FontSize',12);
set(handles.text_dst,'string',dst,'FontSize',12);

global img_list
img_list = dir(strcat(src,'\*.jpg'));
global img_num
img_num = length(img_list);
img_name = img_list(i).name;
img_path_name = [src , '\', img_name];
global img
img = imread(img_path_name);
imshow(img)
flag = zeros(1,img_num);   % 初始化flag
display_string = [num2str(i), '/', num2str(img_num), '   No.', num2str(k)];
set(handles.text_processing,'string',display_string,'FontSize',12);

% UIWAIT makes select_image wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = select_image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i
global k
global img_list
global img_num
global img
global dst
global src
global save_path
global flag


save_path = [dst, '\', num2str(i,'%06d'),'.jpg'];
imwrite(img, save_path);
fprintf('Save %s \n', save_path)
flag(i) = 1 ;     % 保留的flag


i = i + 1;
k = k + 1;
if i <= img_num
    % 显示下一张图片
    img_name = img_list(i).name;
    img_path_name = [src , '\', img_name];
    img = imread(img_path_name);
    imshow(img)

    display_string = [num2str(i), '/', num2str(img_num), '   No.', num2str(k)];
    set(handles.text_processing,'string',display_string,'FontSize',12);
end

% --- Executes on button press in pushbutton_remove.
function pushbutton_remove_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i
global k
global img_list
global img_num
global img
global src
global flag


flag(i) = 2;    % 移除的flag
i = i + 1;
if i <= img_num
    % 显示下一张图片
    img_name = img_list(i).name;
    img_path_name = [src , '\', img_name];
    img = imread(img_path_name);
    imshow(img)
    fprintf('Remove %s \n', img_path_name)
    display_string = [num2str(i), '/', num2str(img_num), '   No.', num2str(k)];
    set(handles.text_processing,'string',display_string,'FontSize',12);
end


% --- Executes on button press in pushbutton_backout.
function pushbutton_backout_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_backout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i
global k
global img_list
global img_num
global img
global dst
global src
global save_path
global flag

fprintf('Backout\n')
backout_path = [dst, '\', num2str(i - 1,'%06d'),'.jpg'];

if i > 1
    if(flag(i - 1) == 1)
        delete(backout_path)   % 删除刚刚保存的图片
        i = i - 1;
        k = k - 1;
    elseif(flag(i - 1) == 2)
        i = i - 1;
    end
end

if i == 1
    fprintf('撤销完毕!!!!!\n')
end
% 显示下一张图片
img_name = img_list(i).name;
img_path_name = [src , '\', img_name];
img = imread(img_path_name);
imshow(img)
display_string = [num2str(i), '/', num2str(img_num), '   No.', num2str(k)];
set(handles.text_processing,'string',display_string,'FontSize',12);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key  
    case 'f'
        pushbutton_save_Callback(hObject, eventdata, handles)
    case 'j'
        pushbutton_remove_Callback(hObject, eventdata, handles)
    case 'space'
        pushbutton_backout_Callback(hObject, eventdata, handles)
    otherwise
end
