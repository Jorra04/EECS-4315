--------------------------- MODULE getLeftShifts ---------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, n

(*
    --algorithm getLeftShift {
        variable output = input, i = 1, j = 1, head = input[1], numShifts = n % Len(input);
        
        {
            while(i <= numShifts) {
                j := 1;
                head := output[1];
                while(j < Len(input)) {
                    output[j] := output[j + 1];
                    j := j + 1;
                };
                output[Len(output)] := head;
                
                i := i + 1;
            };
            
\*            assert (\A x \in 1..Len(input) :
\*            IF((((x-1) + (numShifts * Len(input))) % Len(input)) = 0)
\*            THEN input[x] = output[Len(output)]
\*            ELSE input[x] = output[((x-1) +(numShifts * Len(input))) % Len(input)]
\*            )

            assert (\A x \in 1..Len(input) :
               IF( (((x - 1) % Len(input)) + Len(input)) = 0 )
               THEN input[x] = output[Len(output)]
               ELSE input[x] = output[((x - 1) % Len(output)) +Len(output)]
            );
        }
    }
*)
\* BEGIN TRANSLATION (chksum(pcal) = "7ca40a2d" /\ chksum(tla) = "90c72278")
VARIABLES output, i, j, head, numShifts, pc

vars == << output, i, j, head, numShifts, pc >>

Init == (* Global variables *)
        /\ output = input
        /\ i = 1
        /\ j = 1
        /\ head = input[1]
        /\ numShifts = n % Len(input)
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= numShifts
               THEN /\ j' = 1
                    /\ head' = output[1]
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                                 IF( (((x - 1) % Len(input)) + Len(input)) = 0 )
                                 THEN input[x] = output[Len(output)]
                                 ELSE input[x] = output[((x - 1) % Len(output)) +Len(output)]
                              ), 
                              "Failure of assertion at line 28, column 13.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << j, head >>
         /\ UNCHANGED << output, i, numShifts >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j < Len(input)
               THEN /\ output' = [output EXCEPT ![j] = output[j + 1]]
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ i' = i
               ELSE /\ output' = [output EXCEPT ![Len(output)] = head]
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ j' = j
         /\ UNCHANGED << head, numShifts >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 13:12:23 EST 2023 by jorra04
\* Created Mon Mar 06 12:22:45 EST 2023 by jorra04
