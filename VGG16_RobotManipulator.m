%% VS-050(DENSO)との接続
% Create CaoEngine object
cao = actxserver('CAO.CaoEngine');

% Get Workespaces object
ws = cao.Workspaces.Item(int32(0));

% Create Controller object
ctrl = ws.AddController('RC8', 'CaoProv.DENSO.RC8', '', 'Server=192.168.0.1');

% Create Robot Control
global rob;
rob = ctrl.AddRobot('arm');

% takearm
rob.Execute('Motor', [1,0]);
rob.Execute('takearm');
% Set Speed
rob.Speed(-1, 90);
% rob.Execute('ExtSpeed',[50,50,80]);
rob.Execute('ExtSpeed',[20,20,30]);

%% 電動ハンドモータ
% Create Robot Control
global caoExt;
caoExt = ctrl.AddExtension('Hand0');

% hand
caoExt.Execute('Motor', 1);

State = caoExt.Execute('get_BusyState');
while State~=0
    State = caoExt.Execute('get_BusyState');%チャックの動作チェック
end

state_org = caoExt.Execute('get_OrgState');
if state_org==0
    caoExt.Execute('Org');       %原点復帰
    State = caoExt.Execute('get_BusyState');
    while State~=0
        State = caoExt.Execute('get_BusyState');
    end
end
% 初期位置への移動
P1='(236,0,298,-180,0,90,-3)'; 
rob.Move(1,P1);
pause(0.2);
caoExt.Execute('UnChuck',2);



