--------------------------- MODULE largestInArray ---------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm largestInArray {
    variable i=1, output = -999999;
    
    {
        while(i <= Len(input)) {
            if(input[i] >= output) {
                output := input[i];
            };
            i := i + 1;
        };
        
        assert (\A a \in 1..Len(input) : output >= input[a]);
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "40024ec0" /\ chksum(tla) = "74936598")
VARIABLES i, output, pc

vars == << i, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = -999999
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] >= output
                          THEN /\ output' = input[i]
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert((\A a \in 1..Len(input) : output >= input[a]), 
                              "Failure of assertion at line 17, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 18:59:28 EDT 2023 by jorra04
\* Created Sun Apr 02 18:52:44 EDT 2023 by jorra04
