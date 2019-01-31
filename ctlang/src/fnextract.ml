open Util
open Pos
open Err
open Ast
open Ast_util
open Astmap

class fn_extractor =
  object (visit)
    inherit Astmap.ast_visitor as super
    val _frets : (fun_name * ret_type) mlist = ref []

    method ctlang_module m =
      let Module(_,fdecs) = m in
        List.iter
          (fun fdec ->
             match fdec.data with
               | FunDec(fn,_,rt,_,_)
               | CExtern(fn,_,rt,_) ->
                 mlist_push (fn,rt) _frets)
          fdecs;
        super#ctlang_module m

    method expr_post =
      wrap @@ fun p -> function
        | FnCallExpr (fn,args) ->
          let var = p@>(make_fresh fn.data) in
          let rt = match mlist_find ~equal:vequal !_frets fn with
            | Some rt -> rt
            | None ->
              if Stdlib.contains fn then
                Some (p@>FillInLater)
              else raise @@ cerr p
                              "couldn't find function: '%s'"
                              fn.data in
          let rt' = match rt with
            | Some rt' -> rt'
            | None -> raise @@ cerr p
                                 "cannot use void function in expression: %s"
                                 fn.data in
          let fcall = p@>FnCall(var,rt',fn,args) in
            _pre_inject <- fcall :: _pre_inject;
            Variable var
        | e -> e

  end

let transform m =
  let visit = new fn_extractor in
    visit#ctlang_module m
