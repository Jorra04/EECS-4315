------------------ MODULE largestNumberAtLeastDoubleOthers ------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm largestAtLeastDouble {
    variable i = 1, output = TRUE, max = -1, indexFound = 1;
    
    {
        max := input[1];
        indexFound := 1;
        while(i <= Len(input)) {
            if(input[i] >= max) {
                max := input[i];
                indexFound := i;
            };
            i := i + 1;
        };
        i := 1;
        while(i <= Len(input)) {
            if(~(max >= 2 * input[i]) /\ (i # indexFound)) {
                output := FALSE;
            };
            i := i + 1;
        };
        
        assert output = TRUE <=> (\E x \in 1..Len(input) : (\A y \in 1..Len(input) : (x # y) => (input[x] >= 2 * input[y])));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "a85bdb02" /\ chksum(tla) = "e4bfff6")
VARIABLES i, output, max, indexFound, pc

vars == << i, output, max, indexFound, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = TRUE
        /\ max = -1
        /\ indexFound = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ max' = input[1]
         /\ indexFound' = 1
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] >= max
                          THEN /\ max' = input[i]
                               /\ indexFound' = i
                          ELSE /\ TRUE
                               /\ UNCHANGED << max, indexFound >>
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ i' = 1
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED << max, indexFound >>
         /\ UNCHANGED output

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF i <= Len(input)
               THEN /\ IF ~(max >= 2 * input[i]) /\ (i # indexFound)
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_3"
               ELSE /\ Assert(output = TRUE <=> (\E x \in 1..Len(input) : (\A y \in 1..Len(input) : (x # y) => (input[x] >= 2 * input[y]))), 
                              "Failure of assertion at line 27, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>
         /\ UNCHANGED << max, indexFound >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 03 23:25:25 EDT 2023 by jorra04
\* Created Mon Apr 03 22:17:26 EDT 2023 by jorra04
