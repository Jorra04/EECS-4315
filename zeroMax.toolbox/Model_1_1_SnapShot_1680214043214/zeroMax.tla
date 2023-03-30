------------------------------ MODULE zeroMax ------------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm zeroMax {
    variable i = 1, j = 1, currMax = -1, output = <<>>;
    
    {
        while(i <= Len(input)) {
            if(input[i] = 0) {
                j := i;
                currMax := input[i];
                while(j <= Len(input)) {
                    if(input[j] >= currMax) {
                        currMax := input[j];
                    };
                    j := j + 1;
                };
                
                output[i] := currMax;
            } else {
                output[i] := input[i];
                print("entered");
            };
            
            i := i + 1;
        };
        
        
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "448d0527" /\ chksum(tla) = "347ddf76")
VARIABLES i, j, currMax, output, pc

vars == << i, j, currMax, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ currMax = -1
        /\ output = <<>>
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] = 0
                          THEN /\ j' = i
                               /\ currMax' = input[i]
                               /\ pc' = "Lbl_2"
                               /\ UNCHANGED output
                          ELSE /\ output' = [output EXCEPT ![i] = input[i]]
                               /\ PrintT(("entered"))
                               /\ pc' = "Lbl_3"
                               /\ UNCHANGED << j, currMax >>
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << j, currMax, output >>
         /\ i' = i

Lbl_3 == /\ pc = "Lbl_3"
         /\ i' = i + 1
         /\ pc' = "Lbl_1"
         /\ UNCHANGED << j, currMax, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ IF input[j] >= currMax
                          THEN /\ currMax' = input[j]
                          ELSE /\ TRUE
                               /\ UNCHANGED currMax
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED output
               ELSE /\ output' = [output EXCEPT ![i] = currMax]
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED << j, currMax >>
         /\ i' = i

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_3 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Thu Mar 30 18:07:16 EDT 2023 by jorra04
\* Created Thu Mar 30 17:59:11 EDT 2023 by jorra04
