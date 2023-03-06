----------------------- MODULE secondLargestFromArray -----------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm secondMax {
    variable output = -99999, i = 1, max = input[1];
    
    {
        while(i <= Len(input)) {
            if(input[i] > max) {
                max := input[i];
            };
            i := i + 1;
        };
        i := 1;
        while(i <= Len(input)) {
            if(input[i] > output /\ input[i] < max) {
                output := input[i];
            };
            i := i + 1;
        };
        
\*        assert (\A x \in 1..Len(input):
\*        (x = max) => (\A y \in 1..Len(input) : (x # y) => (x > y) )
\*        /\
\*        (x = output) => (\A y \in 1..Len(input): (x # y) => ((x > y)/\ x < max))
\*         );
        
        assert (\A x \in 1..Len(input) : 
        (((x = max) => (\A y \in 1..Len(input) : (x # y) => (x > y) ))/\((x = output) => (\A y \in 1..Len(input): ((x # y)/\(y # max)) => ((x > y)/\ x < max)))));
        
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "bbe0f175" /\ chksum(tla) = "6a95b362")
VARIABLES output, i, max, pc

vars == << output, i, max, pc >>

Init == (* Global variables *)
        /\ output = -99999
        /\ i = 1
        /\ max = input[1]
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] > max
                          THEN /\ max' = input[i]
                          ELSE /\ TRUE
                               /\ max' = max
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ i' = 1
                    /\ pc' = "Lbl_2"
                    /\ max' = max
         /\ UNCHANGED output

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] > output /\ input[i] < max
                          THEN /\ output' = input[i]
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                              (((x = max) => (\A y \in 1..Len(input) : (x # y) => (x > y) ))/\((x = output) => (\A y \in 1..Len(input): ((x # y)/\(y # max)) => ((x > y)/\ x < max))))), 
                              "Failure of assertion at line 30, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << output, i >>
         /\ max' = max

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 01:29:54 EST 2023 by jorra04
\* Created Mon Mar 06 01:12:16 EST 2023 by jorra04
