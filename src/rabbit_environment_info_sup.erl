%% Copyright (c) 2007-2017 Pivotal Software, Inc.
%% You may use this code for any purpose.

-module(rabbit_environment_info_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).

print_arguments(Title, Proplist) ->
  [Title, "\n"] ++ lists:map(
              fun(Elem) ->
                case Elem of
                    {Key, [Subkey, Value]} ->
                        io_lib:format("~s.~s=~p~n",[Key, Subkey, Value]);
                    {Key, Value} ->
                      case io_lib:printable_list(Value) of
                        true ->
                            io_lib:format("~p=~s~n",[Key, Value]);
                        false ->
                            io_lib:format("~p=~p~n",[Key, Value])
                      end;
                    Value -> io_lib:format("~p~n",[Value])
                end
              end, Proplist) ++ [ "-------------------\n"].

start_link() ->
    RabbitmqEnv =
      print_arguments("Init Args", init:get_arguments()) ++
      print_arguments("Node info", [
        {node, erlang:node()},
        {cookie, erlang:get_cookie()}
      ]) ++
      print_arguments("Operating System Environment", os:getenv()) ,
    lager:error("RabbitMQ Environment: ~s~n", [RabbitmqEnv]),
    supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = []).

init([]) ->
    {ok, {{one_for_one, 3, 10}, []}}.
