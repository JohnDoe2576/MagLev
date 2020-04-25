function [varargout] = GenMagLevData(varargin)

% This code generates data for a magnetic leviation system 
% given in the "NN_control.pdf" paper by Martin T. Hagan.
% Input signal to this system is the current through the 
% electromagnet. This is given by an Amplitude modulated 
% Pseudo Random Sequence (APRBS). This APRBS is obtained 
% using 'skyline' function. This is a signal with randomly 
% distributed amplitudes and randomly distributed delays for 
% shifts in these amplitudes. The shift in these amplitudes 
% occur between randomly between 'MinDelay' & 'MaxDelay'.
% 
% The equation given in paper does not accommodate for 
% zero-crossings (an un-phycical scenario). In this code, 
% the ODE solver stops when there is a zero-crossing. It 
% It then regenerates the signal from this point to end 
% of time samples. The ODE45 solver then accordingly 
% integrates from this particular time to the next 
% zero-crossing or final time, whichever comes first. 
% 
% Regeneration of signal can cause changes in 'MinDelay' 
% of the final signal. Such situations are appropriately 
% handled.
% 
% Inputs: 
%       1. Simulation parameters: dt, t_start, t_end
%       2. Initial conditions
%       3. System parameters: g, alfa, beta, M
%       4. Input signal parameters: MinDelay & MaxDelay
%       5. Actuator limits: MinVolt, MaxVolt

% Extract parameters
Sys = varargin{1};
Sim = varargin{2};
Excite = varargin{3};

% System parameters
parms = Sys.parms;
y0 = Sys.Yo;

Tspan = Sim.Tstart:Sim.dt:Sim.Tend;
if isrow(Tspan)
        Tspan = Tspan.';
end

% Pre-initialize arrays
t_vec = zeros(length(Tspan), 1);
u_vec = zeros(length(Tspan), 1);
y_vec = zeros(length(Tspan), 2);

% Create APRBS signal using 'skyline' function
u = Excite.Fnc('skyline', Sim, Excite).';

% Options for ODE45 solver
options = odeset('Events',@events);

start_idx = 1; t_final = 0.0; iter = 0;
while t_final < Sim.Tend
        % Solve till zero crossing
        [t_, y_, te, ~, ~] = ode45(@( t, y ) MagLevODE( t, y,...
                parms, Tspan, u ), Tspan, y0, options );
        % Check if the time for zero crossing is empty?
        if ~isempty( te )
                % If not, Nt is the (last-1) index of time array from ode45
                Nt = length( t_ ) - 1;
                % Check for amplitude shift in last mn_width samples 
                % of u (input vector). This is to ensure minimum delay 
                % during amplitude shifts
                a = find( logical( diff( u( Nt - min( Nt, round( Excite.TauUmin / ...
                                         Sim.dt ) ) + 1:Nt ) ) ) );
                if ~isempty( a )
                        % If there are any amplitude shifts, new APRBS signal 
                        % is generated right after the previous sample till 
                        % 't_end' number of samples
                        Nt = Nt - a( end ) - 2;
                end
%                 iter = iter + 1;
        else
                Nt = length(t_);
        end

        % t_, u_ & y_ are re-generated from index of 1 in each 
        % iteration by the ode45 solver. Hence the index needs 
        % to be appropriately updated. Such an updation is done 
        % so that arrays of t_vec, u_vec and y_vec can be 
        % pre-initialized
        stop_idx = start_idx + Nt - 1;
        % Saving time, input and output till the zero-crossing
        t_vec( start_idx:stop_idx ) = t_( 1:Nt );
        y_vec( start_idx:stop_idx,: ) = y_( 1:Nt,: );
        u_vec( start_idx:stop_idx ) = u( 1:Nt );
        start_idx = stop_idx + 1;
        % Updating time, ICs and input (u) for ode solver
        sim_.Tstart = t_(Nt) + Sim.dt; sim_.dt = Sim.dt; sim_.Tend = Sim.Tend;
        Tspan = ( sim_.Tstart:sim_.dt:sim_.Tend ).';
        y0 = y_vec(Nt,:).';
        if ~isempty(Tspan)
                u = Excite.Fnc('skyline', sim_, Excite).';
        end
        t_final = t_(end);
end
% disp(iter);

varargout{1} = t_vec;
varargout{2} = u_vec;
varargout{3} = y_vec;
end

function [value,isterminal,direction] = events(t, y)
        % Locate the time when height passes through zero 
        % in a decreasing direction and stop integration.
        value = y(1);     % detect height = 0
        isterminal = 1;   % stop the integration
        direction = -1;   % negative direction
end

function [dydt] = MagLevODE(t, y, parms, t_span, u)
        % Extract parameters
        g = parms.g; alfa = parms.alfa; beta = parms.beta; M = parms.M;
        % Interpolate value of 'u' to required time for ode45 operation
        int_u = interp1(t_span, u, t);
        % Second order ODE separated into 2 first-order ODEs
        dydt = [y( 2 );...
                    -g + ( ( alfa / M )*( int_u * int_u * sign( int_u ) / y( 1 ) ) ) ...
                                                        - ( ( beta / M ) * y( 2 ) ) ];
end