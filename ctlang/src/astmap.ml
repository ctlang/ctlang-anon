open Util
open Pos
open Err
open Ast

class ast_visitor =
  object (visit)
    val mutable _cur_fn : fun_name = fake_pos @> ""
    val mutable _pre_inject : statement list = []
    val mutable _post_inject : statement list = []

    method ctlang_module m =
      let Module(sdecs,fdecs) = m in
      let fdecs' = List.map visit#fdec fdecs in
        Module(sdecs,fdecs')

    method fdec =
      (wrap @@ fun p -> function
          | FunDec(fn,ft,rt,params,body) ->
            _cur_fn <- fn;
            let params' = List.map visit#param params in
            let body' = visit#block body in
              FunDec(fn,ft,rt,params',body')
          | CExtern(fn,ft,rt,params) ->
            _cur_fn <- fn;
            let params' = List.map visit#param params in
              CExtern(fn,ft,rt,params'))
      %> visit#fdec_post
    method fdec_post fdec = fdec

    method param =
      wrap @@ fun p -> function
        | Param(x,bty) -> Param(visit#varname x,bty)

    method varname x = x

    method block blk =
      let pre_save = _pre_inject in
      let post_save = _post_inject in
        _pre_inject <- [];
        _post_inject <- [];
        let res = visit#stms blk in
          _pre_inject <- pre_save;
          _post_inject <- post_save;
          res

    method stms stms_ =
      List.flatten @@ List.map
                        (fun stm ->
                           let stms' = visit#stm stm in
                           let stms' = (List.rev _pre_inject) @ stms' @ (List.rev _post_inject) in
                             _pre_inject <- [];
                             _post_inject <- [];
                             stms')
                        stms_

    method stm' =
      xwrap @@ fun p -> function
        | Block blk -> [Block (visit#block blk)]
        | VarDec (x,bty,e) ->
          let x' = visit#varname x in
          let e' = visit#expr e in
            [VarDec (x',bty,e')]
        | FnCall (x,bty,fn,args) ->
          let x' = visit#varname x in
          let args' = List.map visit#expr args in
            [FnCall (x',bty,fn,args')]
        | VoidFnCall (fn,args) ->
          let args' = List.map visit#expr args in
            [VoidFnCall (fn,args')]
        | Assign (e1,e2) ->
          let e1' = visit#expr e1 in
          let e2' = visit#expr e2 in
            [Assign (e1',e2')]
        | If (cond,thens,elses) ->
          let cond' = visit#expr cond in
          let thens' = visit#block thens in
          let elses' = visit#block elses in
            [If (cond',thens',elses')]
        | RangeFor (x,bty,e1,e2,blk) ->
          let x' = visit#varname x in
          let e1' = visit#expr e1 in
          let e2' = visit#expr e2 in
          let blk' = visit#block blk in
            [RangeFor (x',bty,e1',e2',blk')]
        | ArrayFor (x,bty,e,blk) ->
          let x' = visit#varname x in
          let e' = visit#expr e in
          let blk' = visit#block blk in
            [ArrayFor (x',bty,e',blk')]
        | Return e ->
          let e' = visit#expr e in
            [Return e']
        | VoidReturn -> [VoidReturn]
        | Assume e ->
          let e' = visit#expr e in
            [Assume e']
        | BigFor (i,n1,n2,blk) ->
          let i' = visit#varname i in
          let blk' = visit#block blk in
            [BigFor (i',n1,n2,blk')]

    method stm stm_ =
      let p = stm_.pos in
      let stms' = visit#stm' stm_ in
      let stms' = List.map (fun s -> (make_ast p s)) stms' in
        List.map visit#stm_post stms'
    method stm_post stm = stm

    method expr e_ =
      let p = e_.pos in
      let e_' = make_ast p @@
        match e_.data with
          | True
          | False
          | UntypedIntLiteral _
          | IntLiteral (_,_) -> e_.data
          | Variable x -> Variable (visit#varname x)
          | ArrayLen e ->
            let e' = visit#expr e in
              ArrayLen e'
          | Cast (bty,e) ->
            let e' = visit#expr e in
              Cast (bty,e')
          | UnOp (op,e) ->
            let e' = visit#expr e in
              UnOp (op,e')
          | BinOp (op,e1,e2) ->
            let e1' = visit#expr e1 in
            let e2' = visit#expr e2 in
              BinOp (op,e1',e2')
          | TernOp (e1,e2,e3) ->
            let e1' = visit#expr e1 in
            let e2' = visit#expr e2 in
            let e3' = visit#expr e3 in
              TernOp (e1',e2',e3')
          | Select (e1,e2,e3) ->
            let e1' = visit#expr e1 in
            let e2' = visit#expr e2 in
            let e3' = visit#expr e3 in
              Select (e1',e2',e3')
          | Declassify e ->
            let e' = visit#expr e in
              Declassify e'
          | Enref e ->
            Enref (visit#expr e)
          | Deref e ->
            let e' = visit#expr e in
              Deref e'
          | ArrayGet (e,lexpr) ->
            let e' = visit#expr e in
            let lexpr' = visit#lexpr lexpr in
              ArrayGet (e', lexpr')
          | ArrayLit es ->
            ArrayLit (List.map visit#expr es)
          | ArrayZeros lexpr ->
            ArrayZeros (visit#lexpr lexpr)
          | ArrayCopy e ->
            ArrayCopy (visit#expr e)
          | ArrayView (e,index,len) ->
            ArrayView (visit#expr e,
                       visit#lexpr index,
                       visit#lexpr len)
          | VectorLit ns -> VectorLit ns
          | Shuffle (e,ns) ->
            Shuffle (visit#expr e, ns)
          | StructLit entries ->
            StructLit (List.map
                         (fun (field,e) ->
                            (field,visit#expr e))
                         entries)
          | StructGet (e,field) ->
            StructGet (visit#expr e,field)
          | StringLiteral _ -> raise @@ err p
          | FnCallExpr (fn,args) ->
            let args' = List.map visit#expr args in
              FnCallExpr (fn,args')
      in
        visit#expr_post e_'
    method expr_post e = e

    method lexpr =
      wrap @@ fun p -> function
        | LExpression e ->
          let e' = visit#expr e in
            LExpression e'
        | LUnspecified as e -> e

  end
