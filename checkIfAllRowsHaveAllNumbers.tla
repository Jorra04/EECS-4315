-------------------- MODULE checkIfAllRowsHaveAllNumbers --------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm checkIfAllRowHaveAllNumbers {
    variable i = 1, j = 1, output = TRUE, set ={};
    
    {
        while(i <= Len(input)) {
            set := {};
            while(j <= Len(input)) {
                set := set \cup {input[i][j]};
                j := j + 1;
            };
            j := 1;
            while(j <= Len(input)) {
                if(~(j \in set)) {
                    output := FALSE;
                };
                j := j + 1;
            };
            
            i:= i + 1;
        }
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "35ee110c" /\ chksum(tla) = "881cd76a")
VARIABLES i, j, output, set, pc

vars == << i, j, output, set, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = TRUE
        /\ set = {}
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ set' = {}
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ set' = set
         /\ UNCHANGED << i, j, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ set' = (set \cup {input[i][j]})
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ j' = 1
                    /\ pc' = "Lbl_3"
                    /\ set' = set
         /\ UNCHANGED << i, output >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF j <= Len(input)
               THEN /\ IF ~(j \in set)
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ j' = j + 1
                    /\ pc' = "Lbl_3"
                    /\ i' = i
               ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << j, output >>
         /\ set' = set

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 23:11:07 EDT 2023 by jorra04
\* Created Sun Apr 02 22:50:08 EDT 2023 by jorra04
