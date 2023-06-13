-module(main).
-import(io,[fwrite/1]).
-export([start/0, seed/0, create_list/2, remove/2, find_smallest/1, selection_sort/1, quick_sort/1, split/1, split4/1,split8/1,split_help/3, merge/2, merge4/4, merge8/8, sel_sort/1, run_sort/0, run_sort2/0, parallel_selection_sort/1, parallel_selection_sort4/1, parallel_selection_sort8/1, parallel_quick_sort/1,parallel_quick_sort4/1,parallel_quick_sort8/1]).

start() ->
    seed(),
    List = create_list( 5000, 10000000 ),
    List2 = create_list( 100000, 10000000),
    { Time1, _ } = timer:tc( main, selection_sort, [List] ),
    io:format( "Normal selection sort took ~p seconds.~n", [Time1 / 1000000] ),
  
    { Time2, _ } = timer:tc( main, parallel_selection_sort, [List] ),
    io:format( "Parallel selection sort(2 processes) took ~p seconds.~n", [Time2 / 1000000] ),
  
    { Time3, _ } = timer:tc( main, parallel_selection_sort4, [List] ),
    io:format( "Parallel selection sort(4 processes) took ~p seconds.~n", [Time3 / 1000000] ),
  
    { Time4, _ } = timer:tc( main, parallel_selection_sort8, [List] ),
    io:format( "Parallel selection sort(8 processes) took ~p seconds.~n", [Time4 / 1000000] ),
  
    { Time5, _ } = timer:tc( main, quick_sort, [List2] ),
    io:format( "Normal quick sort took ~p seconds.~n", [Time5 / 1000000] ),
    { Time6, _ } = timer:tc( main, parallel_quick_sort, [List2] ),
    io:format( "Parallel quick sort(2 processes) took ~p seconds.~n", [Time6 / 1000000] ),
    { Time7, _ } = timer:tc( main, parallel_quick_sort4, [List2] ),
    io:format( "Parallel quick sort(4 processes) took ~p seconds.~n", [Time7 / 1000000] ),
    
    { Time8, _ } = timer:tc( main, parallel_quick_sort8, [List2] ),
    io:format( "Parallel quick sort(8 processes) took ~p seconds.~n", [Time8 / 1000000] ),
  
    { Time9, _ } = timer:tc( lists, sort, [List2] ),
    io:format( "Built in sort took ~p seconds.~n", [Time9 / 1000000] ),
  
    io:format( "End.~n" ).

%% seed( ) will seed the random number generator.

seed( ) ->
    rand:seed( exsss, { erlang:phash2( node( ) ), erlang:monotonic_time( ), erlang:unique_integer( ) } ).


%% create_list( Length, Max ) returns a list
%% with Length items in it, all of which are
%% random numbers between 1 and Max.

create_list( 0, _ ) -> [];

create_list( Length, Max ) ->
    [ rand:uniform( Max ) | create_list( Length - 1, Max ) ].


%% remove( Item, List ) returns the list
%% we get when we remove Item from List.

remove( _, [] ) -> [];

remove( H, [H|T] ) -> T;

remove( Item, [H|T] ) ->
    [ H | remove( Item, T )].


%% find_smallest( List ) will return the
%% value of the smallest thing in the list.

find_smallest( [X] ) -> X;
find_smallest( [H|T] ) ->
  S = find_smallest( T ),
  if
    H < S -> H;
    true -> S
  end.


%% selection_sort( List ) will return
%% a sorted version of List.

selection_sort( [] ) -> [];

selection_sort( [X] ) -> [X];

selection_sort( List ) ->
    S = find_smallest( List ),
    L = remove( S, List ),
    [S | selection_sort( L )].

%%quicksort
quick_sort([]) ->
    [];
quick_sort([Pivot|T]) ->
    quick_sort([A || A <- T, A < Pivot]) ++
    [Pivot] ++
    quick_sort([A || A <- T, A >= Pivot]).


%% split( List ) will return a tuple containing
%% two lists, the first half of List and the
%% second half of List.

split( List ) ->
    split_help( length(List) div 2, List, [] ).


%% split_help( N, Original, Front ) returns a 
%% tuple containing the first N items of Original
%% and the rest of Original. Front will be the 
%% first N items at the end.

split_help( 0, Original, Front ) ->
    { Front, Original };

split_help( N, [H|T], Front ) ->
    split_help( N - 1, T, [H | Front] ).

%% split4

split4( List ) ->
    {List1,List2} = split(List),
    {L1,L2} = split(List1),
    {L3,L4} = split(List2),
    {L1,L2,L3,L4}.
%% test: main:split4([1,2,3,4,5,6,7,8]).

%% split8
split8( List ) ->
    {S1,S2} = split(List),
    {S11,S12} = split(S1),
    {S21,S22} = split(S2), 
    {S111,S112} = split(S11),
    {S121,S122} = split(S12),
    {S211,S212} = split(S21),
    {S221,S222} = split(S22),
    {S111,S112,S121,S122,S211,S212,S221,S222}.
%% test: main:split8([1,2,3,4,5,6,7,8]).



%% merge( Sorted1, Sorted2 ) takes two sorted
%% lists and returns one list containing all 
%% the elements from both in order.

merge( [], List2 ) -> List2;

merge( List1, [] ) -> List1;

merge( [H1 | T1], [H2 | T2] ) when H1 < H2 ->
    [H1 | merge( T1, [H2 | T2])];

merge( [H1 | T1], [H2 | T2] ) ->
    [H2 | merge( [H1 | T1], T2 )].

%%merge4
merge4(L1,L2,L3,L4) ->
    M1 = merge(L1,L2),
    M2 = merge(L3,L4),
    merge(M1,M2).

%%merge8
merge8(L1,L2,L3,L4,L5,L6,L7,L8) ->
    M1 = merge(L1,L2),
    M2 = merge(L3,L4),
    M3 = merge(L5,L6),
    M4 = merge(L7,L8),
    M5 = merge(M1,M2),
    M6 = merge(M3,M4),
    merge(M5,M6).
%%test code: main:merge8([1],[2],[3,4],[5,6,7],[77],[99],[12],[564]).



%% sel_sort( List ) sorts List by splitting it
%% in half, sorting each half with selection_sort,
%% then merging the sorted halves.

sel_sort( List ) ->
    { L1, L2 } = split( List ),
    S1 = selection_sort( L1 ),
    S2 = selection_sort( L2 ),
    merge( S1, S2 ).


%% run_sort( ) is meant to run in a process.
%% It waits for a message of the form 
%% {Pid, List}, sorts List, and send the
%% sorted list back to Pid.

run_sort( ) ->
    receive
        { Pid, List } -> 
            Sorted = selection_sort( List ),
            Pid ! Sorted;
        _ -> io:format( "Error!" )
    end.

%%run sort2 (Quick sort)
run_sort2( ) ->
    receive
        { Pid, List } -> 
            Sorted = quick_sort( List ),
            Pid ! Sorted;
        _ -> io:format( "Error!" )
    end.

%% parallel selection sort 
parallel_selection_sort( [] ) -> [];

parallel_selection_sort( [X] ) -> [X];

parallel_selection_sort( List ) ->
    { Front, Back } = split( List ),
    Pid1 = spawn( main, run_sort, [] ),
    Pid2 = spawn( main, run_sort, [] ),
    Pid1 ! { self(), Front },
    Pid2 ! { self(), Back },
    receive
        X -> Sorted1 = X
    end,
    receive
        Y -> Sorted2 = Y
    end,
    merge( Sorted1, Sorted2 ).

%% parallel selection sort 4 
parallel_selection_sort4( [] ) -> [];

parallel_selection_sort4( [X] ) -> [X];

parallel_selection_sort4( List ) ->
    { L1,L2,L3,L4 } = split4( List ),
    Pid1 = spawn( main, run_sort, [] ),
    Pid2 = spawn( main, run_sort, [] ),
    Pid3 = spawn( main, run_sort, [] ),
    Pid4 = spawn( main, run_sort, [] ),
    Pid1 ! { self(), L1 },
    Pid2 ! { self(), L2 },
    Pid3 ! { self(), L3 },
    Pid4 ! { self(), L4 },
    receive
        A -> Sorted1 = A
    end,
    receive
        B -> Sorted2 = B
    end,
    receive
        C -> Sorted3 = C
    end,
    receive
        D -> Sorted4 = D
    end,
    merge4( Sorted1, Sorted2, Sorted3, Sorted4 ).

%% parallel selection sort 8
parallel_selection_sort8( List ) ->
    { L1,L2,L3,L4,L5,L6,L7,L8 } = split8( List ),
    Pid1 = spawn( main, run_sort, [] ),
    Pid2 = spawn( main, run_sort, [] ),
    Pid3 = spawn( main, run_sort, [] ),
    Pid4 = spawn( main, run_sort, [] ),
    Pid5 = spawn( main, run_sort, [] ),
    Pid6 = spawn( main, run_sort, [] ),
    Pid7 = spawn( main, run_sort, [] ),
    Pid8 = spawn( main, run_sort, [] ),
    Pid1 ! { self(), L1 },
    Pid2 ! { self(), L2 },
    Pid3 ! { self(), L3 },
    Pid4 ! { self(), L4 },
    Pid5 ! { self(), L5 },
    Pid6 ! { self(), L6 },
    Pid7 ! { self(), L7 },
    Pid8 ! { self(), L8 },
    receive
        A -> S1 = A
    end,
    receive
        B -> S2 = B
    end,
    receive
        C -> S3 = C
    end,
    receive
        D -> S4 = D
    end,
    receive
        E -> S5 = E
    end,
    receive
        F -> S6 = F
    end,
    receive
        G -> S7 = G
    end,
    receive
        H -> S8 = H
    end,
    merge8( S1,S2,S3,S4,S5,S6,S7,S8 ).

%% parallel quick sort
parallel_quick_sort( [] ) -> [];

parallel_quick_sort( [X] ) -> [X];

parallel_quick_sort( List ) ->
    { Front, Back } = split( List ),
    Pid1 = spawn( main, run_sort2, [] ),
    Pid2 = spawn( main, run_sort2, [] ),
    Pid1 ! { self(), Front },
    Pid2 ! { self(), Back },
    receive
        X -> Sorted1 = X
    end,
    receive
        Y -> Sorted2 = Y
    end,
    merge( Sorted1, Sorted2 ).
    
%% parallel quick sort 4
parallel_quick_sort4( List ) ->
    { L1,L2,L3,L4 } = split4( List ),
    Pid1 = spawn( main, run_sort2, [] ),
    Pid2 = spawn( main, run_sort2, [] ),
    Pid3 = spawn( main, run_sort2, [] ),
    Pid4 = spawn( main, run_sort2, [] ),
    Pid1 ! { self(), L1 },
    Pid2 ! { self(), L2 },
    Pid3 ! { self(), L3 },
    Pid4 ! { self(), L4 },
    receive
        A -> Sorted1 = A
    end,
    receive
        B -> Sorted2 = B
    end,
    receive
        C -> Sorted3 = C
    end,
    receive
        D -> Sorted4 = D
    end,
    merge4( Sorted1, Sorted2, Sorted3, Sorted4 ).

%% parallel quick sort 8
parallel_quick_sort8( List ) ->
    { L1,L2,L3,L4,L5,L6,L7,L8 } = split8( List ),
    Pid1 = spawn( main, run_sort2, [] ),
    Pid2 = spawn( main, run_sort2, [] ),
    Pid3 = spawn( main, run_sort2, [] ),
    Pid4 = spawn( main, run_sort2, [] ),
    Pid5 = spawn( main, run_sort2, [] ),
    Pid6 = spawn( main, run_sort2, [] ),
    Pid7 = spawn( main, run_sort2, [] ),
    Pid8 = spawn( main, run_sort2, [] ),
    Pid1 ! { self(), L1 },
    Pid2 ! { self(), L2 },
    Pid3 ! { self(), L3 },
    Pid4 ! { self(), L4 },
    Pid5 ! { self(), L5 },
    Pid6 ! { self(), L6 },
    Pid7 ! { self(), L7 },
    Pid8 ! { self(), L8 },
    receive
        A -> S1 = A
    end,
    receive
        B -> S2 = B
    end,
    receive
        C -> S3 = C
    end,
    receive
        D -> S4 = D
    end,
    receive
        E -> S5 = E
    end,
    receive
        F -> S6 = F
    end,
    receive
        G -> S7 = G
    end,
    receive
        H -> S8 = H
    end,
    merge8( S1,S2,S3,S4,S5,S6,S7,S8 ).