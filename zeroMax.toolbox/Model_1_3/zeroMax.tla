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
                
                output := Append(output, currMax);
            } else {
                output := Append(output, input[i]);
                print("entered");
            };
            
            i := i + 1;
        };
        
        
        \* Assertion 1
        assert (\A k \in 1..Len(input) :
        ((input[k] = 0) => (\A l \in k..Len(output) : (output[k] >= output[l])))
        );
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "851f36d7" /\ chksum(tla) = "581cd726")
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
                          ELSE /\ output' = Append(output, input[i])
                               /\ PrintT(("entered"))
                               /\ pc' = "Lbl_3"
                               /\ UNCHANGED << j, currMax >>
               ELSE /\ Assert(       (\A k \in 1..Len(input) :
                              ((input[k] = 0) => (\A l \in k..Len(output) : (output[k] >= output[l])))
                              ), 
                              "Failure of assertion at line 32, column 9.")
                    /\ pc' = "Done"
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
               ELSE /\ output' = Append(output, currMax)
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
\* Last modified Thu Mar 30 18:11:08 EDT 2023 by jorra04
\* Created Thu Mar 30 17:59:11 EDT 2023 by jorra04
