---------------------------- MODULE isMonotonic ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm isMonotonic {
    variables i = 1, output = FALSE, isIncreasing = TRUE, isDecreasing = TRUE;
    
    {
        while(i < Len(input)) {
            isIncreasing := isIncreasing /\ (input[i] <= input[i + 1]);
            isDecreasing := isDecreasing /\ (input[i] >= input[i + 1]);
            output := isIncreasing \/ isDecreasing;
            i := i + 1;
        };
            
          assert output = TRUE <=> (\A x \in 1..(Len(input)-1) : input[x] <= input[x + 1]) \/ 
          (\A x \in 1..(Len(input)-1) : input[x] >= input[x + 1])
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "16a1c004" /\ chksum(tla) = "d936dd61")
VARIABLES i, output, isIncreasing, isDecreasing, pc

vars == << i, output, isIncreasing, isDecreasing, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = FALSE
        /\ isIncreasing = TRUE
        /\ isDecreasing = TRUE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i < Len(input)
               THEN /\ isIncreasing' = (isIncreasing /\ (input[i] <= input[i + 1]))
                    /\ isDecreasing' = (isDecreasing /\ (input[i] >= input[i + 1]))
                    /\ output' = (isIncreasing' \/ isDecreasing')
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert(       output = TRUE <=> (\A x \in 1..(Len(input)-1) : input[x] <= input[x + 1]) \/
                              (\A x \in 1..(Len(input)-1) : input[x] >= input[x + 1]), 
                              "Failure of assertion at line 17, column 11.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output, isIncreasing, isDecreasing >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 03 22:04:58 EDT 2023 by jorra04
\* Created Mon Apr 03 21:42:55 EDT 2023 by jorra04
