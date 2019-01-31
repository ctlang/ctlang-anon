open Pos

type size = int [@@deriving show]

type var_name' = string [@@deriving show]
and var_name = var_name' pos_ast [@@deriving show]

type fun_name' = string [@@deriving show]
and fun_name = fun_name' pos_ast [@@deriving show]

type struct_name' = string [@@deriving show]
and struct_name = struct_name' pos_ast [@@deriving show]

type mutability' =
  | R
  | W
  | RW
[@@deriving show]
and mutability = mutability' pos_ast [@@deriving show]

and label' =
  | Public
  | Secret
[@@deriving show]
and label = label' pos_ast [@@deriving show]

and var_attr = { cache_aligned : bool }

and field' =
  | Field of var_name * base_type
[@@deriving show]
and field = field' pos_ast [@@deriving show]
and fields = field list [@@deriving show]

and basic_type' =
  | BaseBool
  | BaseUInt of size
  | BaseInt of size
[@@deriving show]
and basic_type = basic_type' pos_ast [@@deriving show]

and base_type' =
  | Bool of label
  | UInt of size * label
  | Int of size * label
  | Ref of base_type * mutability
  | Arr of base_type * lexpr * var_attr
  | UVec of size * int * label  (* this is really a special case of Arr[UInt(size, label), int] *)
  | Struct of struct_name
  | String  (* for debug functions *)
  | FillInLater
[@@deriving show]
and base_type = base_type' pos_ast [@@deriving show]

and lexpr' =
  | LExpression of expr
  | LUnspecified
[@@deriving show]
and lexpr = lexpr' pos_ast [@@deriving show]

and expr' =
  (* Blessable *)
  | True
  | False
  | UntypedIntLiteral of int
  | IntLiteral of int * basic_type
  | Variable of var_name
  | ArrayLen of expr
  | Cast of basic_type * expr
  | UnOp of unop * expr
  | BinOp of binop * expr * expr
  | TernOp of expr * expr * expr
  | Select of expr * expr * expr  (* ct version of TernOp *)
  | Declassify of expr
  (* Non-blessable *)
  | Enref of expr
  | Deref of expr
  | ArrayGet of expr * lexpr
  | ArrayLit of expr list
  | ArrayZeros of lexpr
  | ArrayCopy of expr
  | ArrayView of expr * lexpr * lexpr
  | VectorLit of int list
  | Shuffle of expr * int list
  | StructLit of (var_name * expr) list
  | StructGet of expr * var_name
  (* Auxilliary *)
  | StringLiteral of string
  | FnCallExpr of fun_name * args
[@@deriving show]
and expr = expr' pos_ast [@@deriving show]

and unop =
  | Neg
  | LogicalNot
  | BitwiseNot
[@@deriving show]

and binop =
  | Plus
  | Minus
  | Multiply
  | Divide
  | Modulo
  | Equal
  | NEqual
  | GT
  | GTE
  | LT
  | LTE
  | LogicalAnd
  | LogicalOr
  | BitwiseAnd
  | BitwiseOr
  | BitwiseXor
  | LeftShift
  | RightShift
  | LeftRotate
  | RightRotate
[@@deriving show]

and cond = expr [@@deriving show]
and thenblock = block [@@deriving show]
and elseblock = block [@@deriving show]

and args = expr list [@@deriving show]
and block = statements [@@deriving show]

and statement' =
  | Block of block
  | VarDec of var_name * base_type * expr
  | FnCall of var_name * base_type * fun_name * args
  | VoidFnCall of fun_name * args
  | Assign of expr * expr
  | If of cond * thenblock * elseblock
  | RangeFor of var_name * basic_type * expr * expr * block
  | ArrayFor of var_name * basic_type * expr * block
  | Return of expr
  | VoidReturn
  | Assume of expr
  | BigFor of var_name * int * int * block
[@@deriving show]
and statement = statement' pos_ast [@@deriving show]
and statements = statement list [@@deriving show]

and param' =
  | Param of var_name * base_type
[@@deriving show]
and param = param' pos_ast [@@deriving show]
and params = param list [@@deriving show]

and ret_type = base_type option [@@deriving show]

and fn_type = { export : bool; inline : inline }
and inline =
  | Default
  | Always
  | Never

and cfn_type = { benign : bool }

and function_dec' =
  | FunDec of fun_name * fn_type * ret_type * params * block
  | CExtern of fun_name * cfn_type * ret_type * params
[@@deriving show]
and function_dec = function_dec' pos_ast [@@deriving show]
and function_decs = function_dec list [@@deriving show]

and struct_type' =
  | StructDef of struct_name * fields
and struct_type = struct_type' pos_ast [@@deriving show]

and structs = struct_type list
[@@deriving show]

and ctlang_module =
  | Module of structs * function_decs
[@@deriving show]

let default_var_attr = { cache_aligned=false; }
