(*
 * Copyright 2016, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(NICTA_GPL)
 *)

(*
 * Check for COGENT constructs that we can't handle yet.
 * This is meant to document known limitations in the COGENT-C refinement tool
 * and give clearer error messages.
 *)
theory COGENT_Corres_Sanity_Check imports
  "../cogent/isa/COGENT"
begin

ML {*
structure COGENT_Corres_Sanity_Check = struct

(* Indirect calls are not supported. *)
fun check_indirect_calls COGENT_functions ctxt =
  COGENT_functions
  |> filter (fn f => let
       val def = Proof_Context.get_thm ctxt (f ^ "_def")
       in exists_subterm (fn t => case t of
              Const (@{const_name App}, _) $ (Const (@{const_name  Fun}, _) $ _ $ _) => false
            | Const (@{const_name App}, _) $ (Const (@{const_name AFun}, _) $ _ $ _) => false
            | Const (@{const_name App}, _) $ _ => true
            | _ => false)
            (Thm.prop_of def) end)
  |> (fn fs => if null fs then [] else
                 map (fn f => "Not supported: indirect function application in " ^ f) fs
                 @ ["Hint: avoid \"let f = expr in f x\"; instead use \"(expr) x\""])



(* Most higher-order function calls are not supported.
 * We inspect each function's argument type to determine its order.
 * NB: this checks all functions, even those that are not called. *)

fun max a b = if a < b then b else a
fun maximum [] = error "maximum: empty list"
  | maximum [x] = x
  | maximum (x::xs) = max x (maximum xs)

fun COGENT_function_order (Const (@{const_name TFun}, _) $ argT $ retT) =
      COGENT_function_order argT + 1
  | COGENT_function_order (Const (@{const_name TVar}, _) $ idx) =
      error "Impossible: monomorphised program should have no TVars"
  | COGENT_function_order (Const (@{const_name TVarBang}, _) $ idx) =
      error "Impossible: monomorphised program should have no TVars"
  | COGENT_function_order (Const (@{const_name TCon}, _) $ _ $ _ $ _) =
      (* Abstract types can contain function pointers. However, let's not
       * worry about that for now. *)
      0
  | COGENT_function_order (Const (@{const_name TPrim}, _) $ primT) =
      0
  | COGENT_function_order (Const (@{const_name TSum}, _) $ variants) =
      HOLogic.dest_list variants |> map (HOLogic.dest_prod #> snd #> COGENT_function_order) |> maximum
  | COGENT_function_order (Const (@{const_name TProduct}, _) $ T1 $ T2) =
      max (COGENT_function_order T1) (COGENT_function_order T2)
  | COGENT_function_order (Const (@{const_name TRecord}, _) $ fields $ sigil) =
      HOLogic.dest_list fields |> map (HOLogic.dest_prod #> fst #> COGENT_function_order) |> maximum
  | COGENT_function_order (Const (@{const_name TUnit}, _)) =
      0
  | COGENT_function_order t = raise TERM ("COGENT_function_order: expected a COGENT.Type", [t])

fun rhs_of_eq (Const (@{const_name "Trueprop"}, _) $ eq) = rhs_of_eq eq
  | rhs_of_eq (Const (@{const_name "Pure.eq"}, _) $ _ $ r) = r
  | rhs_of_eq (Const (@{const_name "HOL.eq"}, _) $ _ $ r) = r
  | rhs_of_eq t = raise (TERM ("rhs_of_eq", [t]))

fun check_function_order functions max_order ctxt = let
  val type_abbrevs = Proof_Context.get_thms ctxt "abbreviated_type_defs"
  in functions
     |> maps (fn f => let
               val fT = Proof_Context.get_thm ctxt (f ^ "_type_def")
                        |> Simplifier.rewrite_rule ctxt type_abbrevs
                        |> Thm.prop_of |> rhs_of_eq
               val (fTEnv, (fArgT, fRetT)) = HOLogic.dest_prod fT |> apsnd HOLogic.dest_prod
               val ord = COGENT_function_order fArgT
               in if ord <= max_order then [] else [(f, ord)] end)
     |> map (fn (f, ord) => "Not supported: function " ^ f ^ " is order-" ^ string_of_int ord ^
                            ", maximum is order-" ^ string_of_int max_order)
  end


(* COGENT allows function names to contain the prime symbol (').
 * But the prime mark isn't legal in C, so the compiler mangles it to "_prime".
 * Unfortunately, parts of the verification tools aren't aware of this yet. *)
fun check_function_names all_functions ctxt =
  all_functions
  |> filter (fn f => member op= (String.explode f) #"'")
  |> map (fn f => "Not supported: name of function " ^ f ^ " contains prime mark (')")


fun check_all COGENT_functions abstract_functions ctxt = let
  fun join_errors err_blocks =
        filter (not o null) err_blocks
        |> maps (fn b => b @ [""])
  val err1 = check_indirect_calls COGENT_functions ctxt
  val err2 = check_function_order COGENT_functions 0 ctxt
  val err3 = check_function_order abstract_functions 1 ctxt
  val err4 = check_function_names (COGENT_functions @ abstract_functions) ctxt
  in case join_errors [err1, err2, err3, err4] of
         [] => ()
       | errs => error (space_implode "\n" errs) end

end
*}

end