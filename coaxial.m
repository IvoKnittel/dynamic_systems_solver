
function  [t, ut, u0, uvaridx, u_names, voltage_select, adja_mat, R_mat, cap_mat, L_mat, current_select_matrix, current_names, current_select] = coaxial()

%a =  1e-3; %inner cond radius 
%b =  1e-2; %outer cond radius 
R_per_m = 5e-3;%1/(tau*sigma*d_skin)*(1/a+1/b);  5e-3 Ohm/m
L_per_m = 0.2e-6;%;(mu/tau)*ln(a/b); = 0.2 muH
G_per_m =1e9;%tau*omega*imag(eps)/ln(b/a);
C_per_m = 80e-12;%tau*real(eps) /ln(b/a);   = 80pF
len=0.3;
R = R_per_m/len;
L = L_per_m/len;
G = G_per_m/len;
C = C_per_m/len;
%Time delay 4 ns/m
%sigma
%d_skin= 1/sqrt(mu*sigma*omega/2)
%mu=mu0;
%eps=

%     4            1          2          3          5
%  Ut ---- L  R  ---- L  R  ---- L  R  ----  L  R  --   uout
%                |            |          |          |
% ...         C     G       C   G      C   G        | R=50   
%                |            |          |          |
%  0  ----------------------------------------------- 6 
                    
% Signal input
% --------------
dt=1e-11;
t = 0:dt:1e-9;
ut = ones(1,length(t));

% The device matrix
% -----------------
%                               source node                          
%                 1           2              3        4     5        6    
R_mat =       [[ NaN         NaN          NaN      NaN    NaN      NaN  ];  %1
               [  R          NaN          NaN      NaN    NaN      NaN  ];  %2
               [  Inf        R            NaN      NaN    NaN      NaN  ];  %3
               [  R          Inf          Inf      NaN    NaN      NaN  ];  %4in
               [  Inf        Inf          R        Inf    NaN      NaN  ];  %5out
               [  G          G            G        Inf    50      NaN  ]]; %6sink node     

%                               source node                          
%                 1           2              3        4     5        6    
L_mat =       [[ NaN         NaN          NaN      NaN    NaN      NaN  ];  %1
               [  L          NaN          NaN      NaN    NaN      NaN  ];  %2
               [  Inf        L            NaN      NaN    NaN      NaN  ];  %3
               [  L          Inf          Inf      NaN    NaN      NaN  ];  %4in
               [  1e3        Inf          L        Inf    NaN      NaN  ];  %5out
               [  Inf        Inf          Inf      Inf    0        NaN  ]]; %6sink node  

R_mat = mat_symm(R_mat);
L_mat = mat_symm(L_mat);

adja_mat =    {{ NaN         NaN            NaN      NaN      NaN      NaN}; %1
               {  0          NaN            NaN      NaN      NaN      NaN}; %2
               {  0           0             NaN      NaN      NaN      NaN}; %3
               {  0           0              0       NaN      NaN      NaN}; %4in
               {  0           0              0        0       NaN      NaN}; %5out
               {  0           0              0        0       0        NaN}};%6sink       
% external voltage of node, or NaN if voltage is variable         
u0      =       [NaN          NaN            NaN      ut(1)   NaN       0  ];
% index of the signal input
% -------------------------
uvaridx =        4;
% index of the ground input
% -------------------------
grd_idx =        6;  
% names of nodes for display
% -------------------------
u_names =      {'line1',  'line2',      'line3',  'signal'    ,'out',    'ground'};
voltage_select= [true      true          true       true       true       false ];   
num_nodes = size(adja_mat,1);

  cap_mat = [[NaN          NaN            NaN      NaN       NaN    NaN      ];
             [0            NaN            NaN      NaN       NaN    NaN      ];
             [0            0              NaN      NaN       NaN    NaN      ];
             [0            0              0        NaN       NaN    NaN      ];%in
             [0            0              0        0         NaN    NaN      ];%out
             [C            C              C        Inf       C      NaN      ]];%ground

% A constant voltage input we can regard as a charged capacitor connecting to ground
% with infinite capacity. Internal nodes have no capacity to ground.
cap_mat = mat_symm(cap_mat);
cap_diag = zeros(1,num_nodes);
cap_diag(~isnan(u0))=Inf;
cap_mat = cap_mat+diag(cap_diag);

current_select_matrix=zeros(num_nodes, num_nodes);
current_select_matrix(4,1)=1; % source
current_select_matrix(1,2)=2; % line1
current_select_matrix(2,3)=3; % line2
current_select_matrix(3,5)=4; % line3
current_select_matrix(5,6)=5; % terminal
current_names={'source','line1','line2', 'line3', 'terminal'};
current_select = logical([1 1 1 1 1]);

function mat = mat_symm(mat)
for j=1:size(mat,1)
     for k=1:size(mat,2)
        if isnan(mat(j,k))
           mat(j,k)=mat(k,j);
           if j==k
              mat(j,k)=0;
           end
        end
    end
end