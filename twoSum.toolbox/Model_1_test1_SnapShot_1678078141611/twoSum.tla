------------------------------- MODULE twoSum -------------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, target


(*
--algorithm twoSum {

    variable output = <<>>,
    i= 1,
    j = 1;
    
    {
        while(i <= Len(input)) {
            j := i + 1;
            while( j <= Len(input)) {
                if((i /= j) /\ ((input[i] + input[j]) = target)) {
                    output := output \o <<i,j>>;
                };
                j := j + 1;
            };
            
            i := i + 1;
        };
        
        assert (\A x \in 1..Len(input) : 
        (\A y \in 1..Len(input) : 
        ((x /= y) /\ (input[x] + input[y] = target)) => ((output[1] = x ) /\ (output[2] = y ))
        ));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "139c1b74" /\ chksum(tla) = "4cabbf0b")
VARIABLES output, i, j, pc

vars == << output, i, j, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ i = 1
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ j' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                              (\A y \in 1..Len(input) :
                              ((x /= y) /\ (input[x] + input[y] = target)) => ((output[1] = x ) /\ (output[2] = y ))
                              )), 
                              "Failure of assertion at line 26, column 9.")
                    /\ pc' = "Done"
                    /\ j' = j
         /\ UNCHANGED << output, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ IF (i /= j) /\ ((input[i] + input[j]) = target)
                          THEN /\ output' = output \o <<i,j>>
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ i' = i
               ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << output, j >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Mar 05 23:48:56 EST 2023 by jorra04
\* Created Sun Mar 05 23:25:37 EST 2023 by jorra04
