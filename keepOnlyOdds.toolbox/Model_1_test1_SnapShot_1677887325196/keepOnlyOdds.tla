---------------------------- MODULE keepOnlyOdds ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm keepOddsOnly {

    variable output = <<>>,
    i = 1;
    {
        assert /\ (Len(input) > 0) /\ (i = 1) /\ (Len(output) = 0);
        
        while(i <= Len(input)) {
            if(input[i] % 2 = 0) {
                output := Append(output, input[i]);
            };
            i := i + 1;
        };
        \* Asserts that every element in the output was originally in the input, and, the element in the output is even.
        assert /\ (\A x \in 1..Len(output) : (\E y \in 1..Len(input) : input[y] = output[x]) /\ (output[x] % 2 = 0) );
    }
    
   
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "b26f65dd" /\ chksum(tla) = "4511d034")
VARIABLES output, i, pc

vars == << output, i, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ i = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (Len(input) > 0) /\ (i = 1) /\ (Len(output) = 0), 
                   "Failure of assertion at line 11, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << output, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] % 2 = 0
                          THEN /\ output' = Append(output, input[i])
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(/\ (\A x \in 1..Len(output) : (\E y \in 1..Len(input) : input[y] = output[x]) /\ (output[x] % 2 = 0) ), 
                              "Failure of assertion at line 20, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << output, i >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Fri Mar 03 18:48:06 EST 2023 by jorra04
\* Created Fri Mar 03 18:16:33 EST 2023 by jorra04
