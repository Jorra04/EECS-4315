------------------------------ MODULE tripleUp ------------------------------
EXTENDS Sequences, Integers, TLC
CONSTANT input

(*
--algorithm tripleUp {
    variable i = 1, tripleFound = FALSE;

    {
        assert (Len(input) >=3);
        while(i <= Len(input) - 2) {
            if((input[i] + 1 = input[i+1]) /\ (input[i+1] + 1 = input[i+2])) {
                tripleFound := TRUE;
            };
            i := i + 1;
        };
        
        assert (tripleFound => 
        (\E x,y,z \in 1..Len(input) :
        ((x + 1 = y)/\ (y+1 = z)/\  (input[x] + 1 = input[y])/\ (input[y] + 1 = input[z])  ))
        );
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "85d44107" /\ chksum(tla) = "715b865a")
VARIABLES i, tripleFound, pc

vars == << i, tripleFound, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ tripleFound = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert((Len(input) >=3), 
                   "Failure of assertion at line 10, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << i, tripleFound >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input) - 2
               THEN /\ IF (input[i] + 1 = input[i+1]) /\ (input[i+1] + 1 = input[i+2])
                          THEN /\ tripleFound' = TRUE
                          ELSE /\ TRUE
                               /\ UNCHANGED tripleFound
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (tripleFound =>
                              (\E x,y,z \in 1..Len(input) :
                              ((x + 1 = y)/\ (y+1 = z)/\  (input[x] + 1 = input[y])/\ (input[y] + 1 = input[z])  ))
                              ), 
                              "Failure of assertion at line 18, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, tripleFound >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 22:23:43 EST 2023 by jorra04
\* Created Mon Mar 06 22:12:58 EST 2023 by jorra04
