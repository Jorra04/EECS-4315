---------------------------- MODULE AllDistinct ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm allDistinct {
    variable i = 1, j = 1, output = TRUE;
    
    {
        while(i <= Len(input)) {
            j := 1;
            while(j <= Len(input)) {
                if(i # j /\ input[i] = input[j]) {
                    output := FALSE;
                };
                
                j := j + 1;
            };
            
            i := i + 1;
        }
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "4f5475b3" /\ chksum(tla) = "1cddb320")
VARIABLES i, j, output, pc

vars == << i, j, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = TRUE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ j' = 1
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ j' = j
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ IF i # j /\ input[i] = input[j]
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ i' = i
               ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << j, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sat Apr 01 21:42:55 EDT 2023 by jorra04
\* Created Sat Apr 01 21:21:52 EDT 2023 by jorra04
