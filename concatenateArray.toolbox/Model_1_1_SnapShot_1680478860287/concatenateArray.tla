-------------------------- MODULE concatenateArray --------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm concatenateArr {
    variable i = 1, output = <<>>;
    
    {
        while(i <= 2 * Len(input)) {
            if((i % Len(input)) = 0) {
                output := Append(output, input[Len(input)]);
            } else {
                output := Append(output, input[(i % Len(input))]);
            };
            
            
            i := i + 1;
        };
        
        assert Len(output) = (2 * Len(input));
        assert (\A a \in 1..Len(input) : output[a] = input[a]) /\ (\A b \in (Len(input) + 1)..Len(output) : output[b] = input[b]) ;
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "8c19fdfe" /\ chksum(tla) = "66da6318")
VARIABLES i, output, pc

vars == << i, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = <<>>
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= 2 * Len(input)
               THEN /\ IF (i % Len(input)) = 0
                          THEN /\ output' = Append(output, input[Len(input)])
                          ELSE /\ output' = Append(output, input[(i % Len(input))])
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert(Len(output) = (2 * Len(input)), 
                              "Failure of assertion at line 21, column 9.")
                    /\ Assert((\A a \in 1..Len(input) : output[a] = input[a]) /\ (\A b \in (Len(input) + 1)..Len(output) : output[b] = input[b]), 
                              "Failure of assertion at line 22, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 19:40:45 EDT 2023 by jorra04
\* Created Sun Apr 02 19:03:48 EDT 2023 by jorra04
