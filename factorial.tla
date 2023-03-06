----------------------------- MODULE factorial -----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input


(*
--algorithm computeFactorial {
    variable i = input - 1, result = input;
    
    {
        while(i > 1) {
            result := result * i;
            i:= i - 1;
        }
       
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "1615e526" /\ chksum(tla) = "f075017c")
VARIABLES i, result, pc

vars == << i, result, pc >>

Init == (* Global variables *)
        /\ i = input - 1
        /\ result = input
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i > 1
               THEN /\ result' = result * i
                    /\ i' = i - 1
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << i, result >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Mar 05 23:02:51 EST 2023 by jorra04
\* Created Sun Mar 05 23:00:21 EST 2023 by jorra04
