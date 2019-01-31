open Pos

exception NotImplemented of string

exception ParseError of string
exception SyntaxError of string
exception TypeError of string
exception LabelError of string
exception UnknownType of string
exception CallError of string
exception ForError of string
exception InternalCompilerError of string

exception VariableNotDefined of string
exception FunctionNotDefined of string
exception UnclassifiedError of string

exception SMTSolverError of string

exception TransformError of string

let werr p =
  Printf.ksprintf
    (fun s ->
       InternalCompilerError("warning: " ^ s << p))
let cerr p =
  Printf.ksprintf
    (fun s ->
       InternalCompilerError("error: " ^ s << p))
let err p = cerr p "compile error"

let warn (InternalCompilerError s) =
  let ss = Str.bounded_split (Str.regexp_string " ") s 3 in
    ANSITerminal.(eprintf [white]         "%s " (List.nth ss 0));
    ANSITerminal.(eprintf [Bold; magenta] "%s " (List.nth ss 1));
    Printf.eprintf                        "%s\n" (List.nth ss 2)

let errParseType p t =
  TypeError("Unknown type: "^t << p)
let errSyntax p =
  TypeError("Syntax error" << p)

let errTypeError p =
  TypeError("Types cannot be unified for given operation" << p)
let errFlowError p =
  TypeError("Invalid type flow" << p)
let errPassError p =
  TypeError("Cannot call function with this type" << p)
let errPassErrorS p sty1 sty2 =
  TypeError("Cannot call function with these types: "^sty1^", "^sty2 << p)

let errRedefVar {data=v;pos=p} =
  UnclassifiedError("Redefinition of variable `"^v^"`" << p)
let errVarNotDefined {data=v;pos=p} =
  VariableNotDefined("Variable `" ^ v ^ "` not defined" << p)
let errFnNotDefined {data=v;pos=p} =
  FunctionNotDefined("Function `" ^ v ^ "` not defined" << p)
let errFoundNotVar {data=v;pos=p} =
  TypeError("Cannot use `" ^ v ^ "` as variable" << p)
let errFoundNotArr {data=v;pos=p} =
  TypeError("Cannot use `" ^ v ^ "` as array" << p)
let errFoundNotFn {data=v;pos=p} =
  TypeError("Cannot use `" ^ v ^ "` as function" << p)

