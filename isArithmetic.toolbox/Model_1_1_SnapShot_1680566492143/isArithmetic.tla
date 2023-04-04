---------------------------- MODULE isArithmetic ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm isArithmetic {
    variable i = 3, arithDiff = -1, output = FALSE;
    
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
    
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "d05b506a" /\ chksum(tla) = "b4b164c2")
VARIABLES i, arithDiff, output, pc

vars == << i, arithDiff, output, pc >>

Init == (* Global variables *)
        /\ i = 3
        /\ arithDiff = -1
        /\ output = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF Len(input) = 2
               THEN /\ output' = TRUE
                    /\ pc' = "Done"
                    /\ UNCHANGED arithDiff
               ELSE /\ IF Len(input) < 2
                          THEN /\ output' = FALSE
                               /\ pc' = "Done"
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
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>
         /\ UNCHANGED arithDiff

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 03 20:00:49 EDT 2023 by jorra04
\* Created Mon Apr 03 19:55:36 EDT 2023 by jorra04
