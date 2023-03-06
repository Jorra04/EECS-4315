------------------------- MODULE getRightShifts_v2 -------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, n

(*
--algorithm getRightShifts {
    variable output = input,  
    i = 1,
    j = 1,
    tail = input[Len(input)],
    numShift = (n % Len(input));
    {
        while(i <= n) {
            tail := output[Len(output)];
            j := Len(output);
          while(j > 1) {
             output[j] := output[j-1];
             j := j - 1;
          };
          output[1] := tail;
          i := i + 1;  
        };
        
        assert (\A x \in 1..Len(input) : 
        IF  (x + numShift) % Len(input) = 0
        THEN output[Len(output)] = input[x]
        ELSE (output[(x + numShift) % Len(input)] = input[x])
        );

\*        assert (\A x \in 1..Len(input) : 
\*            (output[(x + numShift) % Len(input)] = input[x])
\*        );

    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "4ccbe5be" /\ chksum(tla) = "b1ce379d")
VARIABLES output, i, j, tail, numShift, pc

vars == << output, i, j, tail, numShift, pc >>

Init == (* Global variables *)
        /\ output = input
        /\ i = 1
        /\ j = 1
        /\ tail = input[Len(input)]
        /\ numShift = (n % Len(input))
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= n
               THEN /\ tail' = output[Len(output)]
                    /\ j' = Len(output)
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                              IF  (x + numShift) % Len(input) = 0
                              THEN output[Len(output)] = input[x]
                              ELSE (output[(x + numShift) % Len(input)] = input[x])
                              ), 
                              "Failure of assertion at line 24, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << j, tail >>
         /\ UNCHANGED << output, i, numShift >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j > 1
               THEN /\ output' = [output EXCEPT ![j] = output[j-1]]
                    /\ j' = j - 1
                    /\ pc' = "Lbl_2"
                    /\ i' = i
               ELSE /\ output' = [output EXCEPT ![1] = tail]
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ j' = j
         /\ UNCHANGED << tail, numShift >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Mar 05 22:40:35 EST 2023 by jorra04
\* Created Sun Mar 05 22:13:22 EST 2023 by jorra04
