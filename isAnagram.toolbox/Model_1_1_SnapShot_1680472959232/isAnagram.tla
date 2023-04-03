----------------------------- MODULE isAnagram -----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input1, input2

(*
--algorithm isAnagram {
    variable i = 1, j = 1, output = TRUE, set = {};
    
    {
        if(Len(input1) # Len(input2)) {
            output := FALSE;
            i := Len(input1) + 1;
        };
        while(i <= Len(input1)) {
            set := set \cup {input1[i]};
            i:= i + 1;
        };
        i:= 1;
        while(i <= Len(input2)) {
            if(~(input2[i] \in set)) {
                output := FALSE;
            };
            i:= i + 1;
        };
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "c9739e4b" /\ chksum(tla) = "2d50d920")
VARIABLES i, j, output, set, pc

vars == << i, j, output, set, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = TRUE
        /\ set = {}
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF Len(input1) # Len(input2)
               THEN /\ output' = FALSE
                    /\ i' = Len(input1) + 1
               ELSE /\ TRUE
                    /\ UNCHANGED << i, output >>
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << j, set >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input1)
               THEN /\ set' = (set \cup {input1[i]})
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ i' = 1
                    /\ pc' = "Lbl_3"
                    /\ set' = set
         /\ UNCHANGED << j, output >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF i <= Len(input2)
               THEN /\ IF ~(input2[i] \in set)
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_3"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>
         /\ UNCHANGED << j, set >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 18:01:41 EDT 2023 by jorra04
\* Created Sun Apr 02 17:48:58 EDT 2023 by jorra04
