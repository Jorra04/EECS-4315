---------------------- MODULE intersectionOfTwoArrays ----------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input1, input2

(*
--algorithm intersectionOfArrays {
    variable i = 1, j = 1, output = <<>>, input1Set = {}, input2Set= {};
    
    {
        while(i <= Len(input1)) {
            input1Set := input1Set \cup {input1[i]};
            i := i + 1;
        };
        
        while(j <= Len(input2)) {
            input2Set := input2Set \cup {input2[j]};
            j := j + 1;
        };
        i:= 1;
        j := 1;
        while(i <= Len(input1)) {
            if((input1[i] \in input1Set) /\ (input1[i] \in input2Set)) {
                output := Append(output, input1[i]);
            };
            i := i + 1;
        };
        
        assert Len(output) <= Len(input1) /\ Len(output) <= Len(input2);
        assert (\A k \in 1..Len(output) : (\E l \in 1..Len(input1) : input1[l] = output[k]) /\ (\E m \in 1..Len(input2) : input2[m] = output[k]))
        
        
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "574e4555" /\ chksum(tla) = "c71186c7")
VARIABLES i, j, output, input1Set, input2Set, pc

vars == << i, j, output, input1Set, input2Set, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = <<>>
        /\ input1Set = {}
        /\ input2Set = {}
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input1)
               THEN /\ input1Set' = (input1Set \cup {input1[i]})
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Lbl_2"
                    /\ UNCHANGED << i, input1Set >>
         /\ UNCHANGED << j, output, input2Set >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input2)
               THEN /\ input2Set' = (input2Set \cup {input2[j]})
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ i' = i
               ELSE /\ i' = 1
                    /\ j' = 1
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED input2Set
         /\ UNCHANGED << output, input1Set >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF i <= Len(input1)
               THEN /\ IF (input1[i] \in input1Set) /\ (input1[i] \in input2Set)
                          THEN /\ output' = Append(output, input1[i])
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_3"
               ELSE /\ Assert(Len(output) <= Len(input1) /\ Len(output) <= Len(input2), 
                              "Failure of assertion at line 28, column 9.")
                    /\ Assert((\A k \in 1..Len(output) : (\E l \in 1..Len(input1) : input1[l] = output[k]) /\ (\E m \in 1..Len(input2) : input2[m] = output[k])), 
                              "Failure of assertion at line 29, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>
         /\ UNCHANGED << j, input1Set, input2Set >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 03 18:18:25 EDT 2023 by jorra04
\* Created Mon Apr 03 17:48:23 EDT 2023 by jorra04
