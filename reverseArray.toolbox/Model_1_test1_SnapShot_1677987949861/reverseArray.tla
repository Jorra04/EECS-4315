---------------------------- MODULE reverseArray ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm reverseArr {
    variable output = <<>>,
    i = Len(input);
    
    {
        assert /\ (i = Len(input)) /\ (Len(input) = 0);
        
        while(i >= 1 /\ i <= Len(input)) {
            output := Append(output, input[i]);
            i := i - 1;
        };
        
        assert (\A x \in 1..Len(input) : input[x] = output[Len(output) - x + 1]);
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "d65b23e5" /\ chksum(tla) = "ccf65161")
VARIABLES output, i, pc

vars == << output, i, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ i = Len(input)
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (i = Len(input)) /\ (Len(input) = 0), 
                   "Failure of assertion at line 11, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << output, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i >= 1 /\ i <= Len(input)
               THEN /\ output' = Append(output, input[i])
                    /\ i' = i - 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert((\A x \in 1..Len(input) : input[x] = output[Len(output) - x + 1]), 
                              "Failure of assertion at line 18, column 9.")
                    /\ pc' = "Done"
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
\* Last modified Sat Mar 04 22:45:21 EST 2023 by jorra04
\* Created Sat Mar 04 22:38:45 EST 2023 by jorra04
