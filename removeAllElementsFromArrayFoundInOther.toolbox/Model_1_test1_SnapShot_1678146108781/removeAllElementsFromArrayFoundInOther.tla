--------------- MODULE removeAllElementsFromArrayFoundInOther ---------------
EXTENDS Integers, Sequences, TLC
CONSTANT input1, input2

(*

the goal of this algorithm is to keep all elements in input1 that are not found in input2.

--algorithm removeAllElementsFromArr {
    variable i = 1, j = 1, output = <<>>, duplicateFound = FALSE;
    
    {
        while(i <= Len(input1)) {
            j := 1;
            duplicateFound := FALSE;
            while(j <= Len(input2)) {
                if(i # j /\ (input1[i] = input2[j])) {
                    duplicateFound := TRUE;       
                };
                j := j + 1;
            };
            
            if(duplicateFound = FALSE) {
                output := Append(output, input1[i]);
            };
            duplicateFound := FALSE;
            i := i + 1;
        };
        
        \* first assertion to ensure that all output values were originally in the input1 constant.
        assert (\A x \in 1..Len(output) : 
        (\E y \in 1..Len(input1) : (output[x] = input1[y]))
        );
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "a241bc1a" /\ chksum(tla) = "58cee846")
VARIABLES i, j, output, duplicateFound, pc

vars == << i, j, output, duplicateFound, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = <<>>
        /\ duplicateFound = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input1)
               THEN /\ j' = 1
                    /\ duplicateFound' = FALSE
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(output) :
                              (\E y \in 1..Len(input1) : (output[x] = input1[y]))
                              ), 
                              "Failure of assertion at line 31, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << j, duplicateFound >>
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input2)
               THEN /\ IF i # j /\ (input1[i] = input2[j])
                          THEN /\ duplicateFound' = TRUE
                          ELSE /\ TRUE
                               /\ UNCHANGED duplicateFound
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << i, output >>
               ELSE /\ IF duplicateFound = FALSE
                          THEN /\ output' = Append(output, input1[i])
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ duplicateFound' = FALSE
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ j' = j

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 18:41:43 EST 2023 by jorra04
\* Created Mon Mar 06 18:30:35 EST 2023 by jorra04
