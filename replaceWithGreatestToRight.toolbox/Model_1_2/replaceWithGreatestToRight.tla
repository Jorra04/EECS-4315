--------------------- MODULE replaceWithGreatestToRight ---------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm replaceWithGreatestToRight {
    variables i = 1, j = 1, output = <<>>, max = -1;
    
    {
        while(i <= Len(input)) {
            j := i + 1;
            max := -1;
            while(j <= Len(input)) {
                if(input[j] > max) {
                    max := input[j];
                };
                
                j := j + 1;
            };
            output := Append(output, max);
            i := i + 1;
        };
        
        assert (\A a \in 1..Len(output) : (\A b \in (a +1)..Len(output) : output[a] >= output[b] ));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "42a9654" /\ chksum(tla) = "f752143c")
VARIABLES i, j, output, max, pc

vars == << i, j, output, max, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = <<>>
        /\ max = -1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ j' = i + 1
                    /\ max' = -1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert((\A a \in 1..Len(output) : (\A b \in (a +1)..Len(output) : output[a] >= output[b] )), 
                              "Failure of assertion at line 24, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << j, max >>
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ IF input[j] > max
                          THEN /\ max' = input[j]
                          ELSE /\ TRUE
                               /\ max' = max
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << i, output >>
               ELSE /\ output' = Append(output, max)
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << j, max >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 21:32:18 EDT 2023 by jorra04
\* Created Sun Apr 02 19:58:26 EDT 2023 by jorra04
