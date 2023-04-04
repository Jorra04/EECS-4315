---------------------------- MODULE isArithmetic ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm isArithmetic {
    variable i = 3, arithDiff = -1, output = TRUE;
    
    {
        if(Len(input) = 2) {
            output := TRUE;
        } else if(Len(input) < 2) {
            output := FALSE;
        } else {
            arithDiff := input[2] - input[1];
            while(i <= Len(input)) {
                if((input[i] - input[i-1]) # arithDiff) {
                    output := FALSE;
                };
                
                i := i + 1;
            };
            
        };
    
        assert (output = TRUE) <=> (\A x,y \in 1..(Len(input)-1) : (
        (y = x + 1) => ((input[y] - input[x]) = (input[y+1] - input[y]))
        ));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "3f63342c" /\ chksum(tla) = "c72bddc1")
VARIABLES i, arithDiff, output, pc

vars == << i, arithDiff, output, pc >>

Init == (* Global variables *)
        /\ i = 3
        /\ arithDiff = -1
        /\ output = TRUE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF Len(input) = 2
               THEN /\ output' = TRUE
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED arithDiff
               ELSE /\ IF Len(input) < 2
                          THEN /\ output' = FALSE
                               /\ pc' = "Lbl_3"
                               /\ UNCHANGED arithDiff
                          ELSE /\ arithDiff' = input[2] - input[1]
                               /\ pc' = "Lbl_2"
                               /\ UNCHANGED output
         /\ i' = i

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ IF (input[i] - input[i-1]) # arithDiff
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Lbl_3"
                    /\ UNCHANGED << i, output >>
         /\ UNCHANGED arithDiff

Lbl_3 == /\ pc = "Lbl_3"
         /\ Assert(       (output = TRUE) <=> (\A x,y \in 1..(Len(input)-1) : (
                   (y = x + 1) => ((input[y] - input[x]) = (input[y+1] - input[y]))
                   )), "Failure of assertion at line 26, column 9.")
         /\ pc' = "Done"
         /\ UNCHANGED << i, arithDiff, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 03 20:05:29 EDT 2023 by jorra04
\* Created Mon Apr 03 19:55:36 EDT 2023 by jorra04
