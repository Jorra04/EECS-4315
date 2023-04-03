---------------------- MODULE intersectionOfTwoArrays ----------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input1, input2

(*
--algorithm intersectionOfArrays {
    variable i = 1, j = 1, output = <<>>, input1Set = {}, input2Set= {}, outputSet = {};
    
    {
        while(i <= Len(input1)) {
            input1Set := input1Set \cup {input1[i]};
            i := i + 1;
        };
        
        while(j <= Len(input2)) {
            input2Set := input2Set \cup {input2[j]};
            j := j + 1;
        };
        
        outputSet := input1Set \cap input2Set;
        i:= 1;
        j := 1;
        while(i <= Len(input1)) {
            if(input1[i] \in outputSet) {
                output := Append(output, input1[i]);
            };
            i := i + 1;
        };
        
        while(j <= Len(input2)) {
            if(input2[j] \in outputSet) {
                output := Append(output, input2[j]);
            };
            j := j + 1;
        };
        
        
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "dd779548" /\ chksum(tla) = "909dfb0b")
VARIABLES i, j, output, input1Set, input2Set, outputSet, pc

vars == << i, j, output, input1Set, input2Set, outputSet, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = <<>>
        /\ input1Set = {}
        /\ input2Set = {}
        /\ outputSet = {}
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input1)
               THEN /\ input1Set' = (input1Set \cup {input1[i]})
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Lbl_2"
                    /\ UNCHANGED << i, input1Set >>
         /\ UNCHANGED << j, output, input2Set, outputSet >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input2)
               THEN /\ input2Set' = (input2Set \cup {input2[j]})
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << i, outputSet >>
               ELSE /\ outputSet' = (input1Set \cap input2Set)
                    /\ i' = 1
                    /\ j' = 1
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED input2Set
         /\ UNCHANGED << output, input1Set >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF i <= Len(input1)
               THEN /\ IF input1[i] \in outputSet
                          THEN /\ output' = Append(output, input1[i])
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_3"
               ELSE /\ pc' = "Lbl_4"
                    /\ UNCHANGED << i, output >>
         /\ UNCHANGED << j, input1Set, input2Set, outputSet >>

Lbl_4 == /\ pc = "Lbl_4"
         /\ IF j <= Len(input2)
               THEN /\ IF input2[j] \in outputSet
                          THEN /\ output' = Append(output, input2[j])
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ j' = j + 1
                    /\ pc' = "Lbl_4"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << j, output >>
         /\ UNCHANGED << i, input1Set, input2Set, outputSet >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3 \/ Lbl_4
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 03 18:11:02 EDT 2023 by jorra04
\* Created Mon Apr 03 17:48:23 EDT 2023 by jorra04
