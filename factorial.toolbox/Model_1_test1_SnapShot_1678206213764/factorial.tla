----------------------------- MODULE factorial -----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm calculateFactorial {
    variable output = <<1>>,
    i = 2;
    
    {
        assert /\ (Len(output) = 1) /\ (output[1] = 1) /\ (i = 2);
    
        while(i <= input) {
            output := Append(output, i * output[i-1]);
            i := i + 1;
        }
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "98cc3d" /\ chksum(tla) = "db4fd763")
VARIABLES output, i, pc

vars == << output, i, pc >>

Init == (* Global variables *)
        /\ output = <<1>>
        /\ i = 2
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (Len(output) = 1) /\ (output[1] = 1) /\ (i = 2), 
                   "Failure of assertion at line 11, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << output, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= input
               THEN /\ output' = Append(output, i * output[i-1])
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << output, i >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Tue Mar 07 11:23:22 EST 2023 by jorra04
\* Created Tue Mar 07 11:12:48 EST 2023 by jorra04
