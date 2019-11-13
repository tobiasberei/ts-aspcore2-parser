import { AspCore2ILFParser } from './../AspCore2ILFParser';
import { AspCore2ILFParserDefaultErrorListener } from './../AspCore2ILFParserDefaultErrorListener';

test('AspCore2ILFParser', () => {
  expect(executeValidAspCode().length).toBe(0);
  expect(executeInalidAspCode_MissingDot().length).toBe(1);
});

// ####### HELPER FUNCTIONS ##########

export function executeValidAspCode(): string[] {
  const parser = new AspCore2ILFParser();
  const defErrorListener = new AspCore2ILFParserDefaultErrorListener();
  parser.addErrorListener(defErrorListener);

  const errors = parser.parse(`% Facts
    vtx(1). vtx(2). vtx(3). vtx(4). vtx(5). 
    edge(1, 2). edge(2, 3). edge(3, 4). edge(4, 5). edge(3, 2). edge(1, 3). edge(2, 4). edge(5, 1).
    start(1).
    
    inPath(X, Y) | outPath(X, Y) :- edge(X, Y).
    
    
    % Auxiliary rules
    reached(X) :- inPath(Y, X), reached(Y).
    reached(X) :- start(X).
    
    
    % Checking part: specify constraints on solution.
    
    % All vertexes must be in the path.
    :- vtx(X), not reached(X).
    % A Target Node of the path cannot be the start node.
    :- start(X), inPath(_, X).
    % Each vertex in the path must have
    % at most one incoming and one outgoing edge.
    :- vtx(X), #count{Y : inPath(X, Y)} > 1.
    :- vtx(X), #count{Y : inPath(Y, X)} > 1.`);

  return defErrorListener.errors;
}

export function executeInalidAspCode_MissingDot(): string[] {
  const parser = new AspCore2ILFParser();
  const defErrorListener = new AspCore2ILFParserDefaultErrorListener();
  parser.addErrorListener(defErrorListener);

  const errors = parser.parse(`% Facts
    vtx(1). vtx(2). vtx(3). vtx(4). vtx(5). 
    edge(1, 2). edge(2, 3). edge(3, 4). edge(4, 5). edge(3, 2). edge(1, 3). edge(2, 4). edge(5, 1).
    start(1).
    
    inPath(X, Y) | outPath(X, Y) :- edge(X, Y).
    
    
    % Auxiliary rules
    reached(X) :- inPath(Y, X), reached(Y).
    reached(X) :- start(X)
    
    
    % Checking part: specify constraints on solution.
    
    % All vertexes must be in the path.
    :- vtx(X), not reached(X).
    % A Target Node of the path cannot be the start node.
    :- start(X), inPath(_, X).
    % Each vertex in the path must have
    % at most one incoming and one outgoing edge.
    :- vtx(X), #count{Y : inPath(X, Y)} > 1.
    :- vtx(X), #count{Y : inPath(Y, X)} > 1.`);

  return defErrorListener.errors;
}
