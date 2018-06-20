% Ankit Babber (#1304527)
% Paul Uy (#0867616)
% COSC 4368 - Homework 2

% database of unidirectional edges and weights as they appear in the graph

connect(a, b, 5).
connect(a, c, 8).
connect(a, d, 10).
connect(b, d, 2).
connect(b, e, 9).
connect(c, d, 4).
connect(c, f, 5).
connect(d, e, 6).
connect(d, f, 11).
connect(d, g, 4).
connect(e, g, 2).
connect(f, g, 1).


% Call info(). in SWI Prolog to get information on the program and the queries that can be performed.

info() :-
  write('This program determines all possible paths between two nodes and the length of a path.'),
  nl,
  write('To find all possible paths between two nodes: path(node1, node2, Length, Path).'),
  nl,
  write('To find the length of a path: pathLength([node1, node2, node3, nodeN], Length).').


% path() is used to determine all paths and their lengths given start and end atoms

path(Start, End, Length, Path) :-
	connect(Start, End, Length),
	atom_concat(Start, End, Path).
path(Start, End, Length, Path) :-
	connect(Start, X, Length1),
	path(X, End, Length2, Path1),
	atom_concat(Start, Path1, Path),
	Length is Length1 + Length2.

/*
  When path() is called by the user, it is queried with the entered atoms for
  the Start and End variables. The first path() rule is intended for a path
  with only two nodes, and it goes through the database searching for that
  connection and it's length. The first rule has two predicates. The connect()
  predicate checks the database for the existence of a particular
  specification, and the atom_concat() predicate is used to combine the Start
  and End variables into the Path variable. The second rule is used for paths
  with more than two nodes, and it recursively finds all paths from Start to
  End and their corresponding length. The second rule has 4 predicates. The
  predicates used are connect(), a recursive call to path(), atom_concat(), and
  a final predicate that calculates the total Length by adding Length1 and
  Length2. The connect() predicate uses variable X to check for the
  intermediary nodes between Start and End; additionally, the Length1 variable
  records the current length of the path between Start and X. The next
  predicate is a recursive call to path() in which Start is replaced with X,
  End remains the same, a new Length2 variable records the next length, and a
  new Path1 variable that records the next path. The atom_concat() predicate
  concatenates Start and Path1 into Path. Finally, the last predicate adds
  Length1 and Length2 in the running total Length. The program traverses the
  database until the end of the path has been reached, and then it returns the
  path and it's length to the console. The program continues to find all paths
  and their lengths until no more paths can be found (each next path and length
  is presented to the user when the user hits the space bar in SWI Prolog). If
  there is no path between the Start and End node, then the program will
  return false.
*/

% pathLength() uses recursion to determine the length of a path entered as a list by the user.

pathLength([Start, End], Length) :-
  connect(Start, End, Length).
pathLength([Start, End|Tail], Length) :-
	connect(Start, End, Length1),
	pathLength([End|Tail], Length2),
	Length is Length1 + Length2.

/*
  When pathLength() is called by the user, it is queried with the entered
  atoms in the list []. pathLength() has two rules that return the length of a
  path entered by the user. The first rule, is for a path between two nodes
  Start and	End. If there is a connection between the two nodes, the value of
  Length is returned to the user with the connect() predicate. The second
  pathLength() rule is intended for paths that have more than two nodes. In
  this instance of pathLength(), the list is split into two lists, one with the
  first two nodes and the other containing the rest of the nodes. The connect()
  predicate checks the database for the path, and then it proceeds to the next
  predicate. The pathLength() predicate is a recursive call with End at the
  head of the list, Tail representing the rest of the list, and Length2 for the
  length of the next path. The last predicate represents the total Length. The
  program continues through the database until the end of the path is reached,
  and then it returns the total length for the path. If the path does not
  exist, then the program will return false.
*/
