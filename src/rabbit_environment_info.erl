%% Copyright (c) 2007-2017 Pivotal Software, Inc.
%% You may use this code for any purpose.

-module(rabbit_environment_info).

-behaviour(application).

-export([start/2, stop/1]).

start(normal, []) ->
    rabbit_environment_info_sup:start_link().

stop(_State) ->
    ok.
