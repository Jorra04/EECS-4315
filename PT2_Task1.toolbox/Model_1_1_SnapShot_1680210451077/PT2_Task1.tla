----------------------------- MODULE PT2_Task1 -----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm containsDuplicates {
    variable i = 1, j = 1, output = FALSE;
    
    {
        while(i <= Len(input)) {
        j := 1;
        while( j <= Len(input)) {
            if(input[i] = input[j]) {
                output := TRUE;
                j := Len(input) + 1;
            };
            
            j := j + 1;
        };
        
            i := i + 1;
        };
        
        assert ((output = TRUE) => (\E k,l \in Len(input) : (k # l) /\ (input[k] = input[l]) ));
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "65fd7f26" /\ chksum(tla) = "5278647")
VARIABLES i, j, output, pc

vars == << i, j, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ j' = 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(((output = TRUE) => (\E k,l \in Len(input) : (k # l) /\ (input[k] = input[l]) )), 
                              "Failure of assertion at line 24, column 9.")
                    /\ pc' = "Done"
                    /\ j' = j
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ IF input[i] = input[j]
                          THEN /\ output' = TRUE
                               /\ j' = Len(input) + 1
                          ELSE /\ TRUE
                               /\ UNCHANGED << j, output >>
                    /\ pc' = "Lbl_3"
                    /\ i' = i
               ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << j, output >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ j' = j + 1
         /\ pc' = "Lbl_2"
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
\* Last modified Thu Mar 30 17:06:50 EDT 2023 by jorra04
\* Created Thu Mar 30 16:53:28 EDT 2023 by jorra04
