--------------------------- MODULE largestInArray ---------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm largestInArray {
    variable i=1, output = -999999;
    
    {
        assert Len(input) > 0;
        
        output := input[1];
        
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
\* BEGIN TRANSLATION (chksum(pcal) = "fde498bc" /\ chksum(tla) = "f9e8f4f6")
VARIABLES i, output, pc

vars == << i, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = -999999
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(Len(input) > 0, 
                   "Failure of assertion at line 10, column 9.")
         /\ output' = input[1]
         /\ pc' = "Lbl_2"
         /\ i' = i

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] >= output
                          THEN /\ output' = input[i]
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert((\A a \in 1..Len(input) : output >= input[a]), 
                              "Failure of assertion at line 21, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 19:01:18 EDT 2023 by jorra04
\* Created Sun Apr 02 18:52:44 EDT 2023 by jorra04
