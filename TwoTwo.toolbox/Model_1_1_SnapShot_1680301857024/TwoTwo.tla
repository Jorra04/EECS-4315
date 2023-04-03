------------------------------- MODULE TwoTwo -------------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm twoTwo {
    variable i = 2, output = TRUE;
    
    {
        
        if(input[1] = 2 /\ input[2] # 2) {
            output := FALSE;
            i := Len(input);
        };
        if(input[Len(input)] = 2 /\ input[Len(input) - 1] # 2) {
            output := FALSE;
            i := Len(input);
        };
        while(i <= Len(input) -1) {
            if(input[i] = 2 /\ ~((input[i-1] # 2)\/(input[i + 1] # 2))) {
                output := FALSE;
            };
            
            i := i + 1;
        };
        
        
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "a7cd09ea" /\ chksum(tla) = "9dbf4777")
VARIABLES i, output, pc

vars == << i, output, pc >>

Init == (* Global variables *)
        /\ i = 2
        /\ output = TRUE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF input[1] = 2 /\ input[2] # 2
               THEN /\ output' = FALSE
                    /\ i' = Len(input)
               ELSE /\ TRUE
                    /\ UNCHANGED << i, output >>
         /\ IF input[Len(input)] = 2 /\ input[Len(input) - 1] # 2
               THEN /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Lbl_3"

Lbl_2 == /\ pc = "Lbl_2"
         /\ output' = FALSE
         /\ i' = Len(input)
         /\ pc' = "Lbl_3"

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF i <= Len(input) -1
               THEN /\ IF input[i] = 2 /\ ~((input[i-1] # 2)\/(input[i + 1] # 2))
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_3"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Fri Mar 31 18:30:48 EDT 2023 by jorra04
\* Created Fri Mar 31 18:12:30 EDT 2023 by jorra04
