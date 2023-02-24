------------------------ MODULE decideRPSGameResult ------------------------
EXTENDS Integers, Sequences, TLC

(*
--algorithm decideRPS {
    variable p1r1 \in {"R", "P", "S"},
    p1r2 \in {"R", "P", "S"},
    p2r1 \in {"R", "P", "S"},
    p2r2 \in {"R", "P", "S"},
    numWins_p1 = 0,
    numWins_p2 = 0,
    p1_wins = FALSE,
    p2_wins = FALSE,
    tie = FALSE,
    currentRound = 0;
    {
        \* precondition
        assert p1_wins = FALSE /\ p2_wins = FALSE /\ tie = FALSE /\ numWins_p1 = 0 /\ numWins_p2 = 0;
        
        if(p1r1 = p2r1 ) {
            currentRound := currentRound + 1;
        } else if(p1r1 = "R" /\ p2r1 = "P") {
            numWins_p2 := numWins_p2 + 1;
        } else if(p1r1 = "P" /\ p2r1 = "R") {
            numWins_p1 := numWins_p1 + 1;
        }else if(p1r1 = "R" /\ p2r1 = "S") {
            numWins_p1 := numWins_p1 + 1;
        } else if(p1r1 = "S" /\ p2r1 = "R") {
            numWins_p2 := numWins_p2 + 1;
        }else if(p1r1 = "P" /\ p2r1 = "S") {
            numWins_p2 := numWins_p2 + 1;
        } else if(p1r1 = "S" /\ p2r1 = "P") {
            numWins_p1 := numWins_p1 + 1;
        };
        
        if(p1r2 = p2r2 ) {
            currentRound := currentRound + 1;
        } else if(p1r2 = "R" /\ p2r2 = "P") {
            numWins_p2 := numWins_p2 + 1;
        } else if(p1r2 = "P" /\ p2r2 = "R") {
            numWins_p1 := numWins_p2 + 1;
        }else if(p1r2 = "R" /\ p2r2 = "S") {
            numWins_p1 := numWins_p1 + 1;
        } else if(p1r2 = "S" /\ p2r2 = "R") {
            numWins_p2 := numWins_p2 + 1;
        }else if(p1r2 = "P" /\ p2r2 = "S") {
            numWins_p2 := numWins_p2 + 1;
        } else if(p1r2 = "S" /\ p2r2 = "P") {
            numWins_p1 := numWins_p1 + 1;
        };
        
        if(numWins_p1 > numWins_p2) {
            p1_wins := TRUE;
        } else if(numWins_p1 < numWins_p2) {
            p2_wins := TRUE;
        } else {
            tie := TRUE
        };
        
        \* Postcondition
        assert \/ (numWins_p1 = numWins_p2 /\ tie = TRUE /\ p1_wins = FALSE /\ p2_wins = FALSE) 
                              \/ (numWins_p1 > numWins_p2 /\ p1_wins = TRUE /\ p2_wins = FALSE)
                              \/ (numWins_p1 < numWins_p2 /\ p2_wins = TRUE /\ p1_wins = FALSE)

    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "888e8326" /\ chksum(tla) = "30a095cd")
VARIABLES p1r1, p1r2, p2r1, p2r2, numWins_p1, numWins_p2, p1_wins, p2_wins, 
          tie, currentRound, pc

vars == << p1r1, p1r2, p2r1, p2r2, numWins_p1, numWins_p2, p1_wins, p2_wins, 
           tie, currentRound, pc >>

Init == (* Global variables *)
        /\ p1r1 \in {"R", "P", "S"}
        /\ p1r2 \in {"R", "P", "S"}
        /\ p2r1 \in {"R", "P", "S"}
        /\ p2r2 \in {"R", "P", "S"}
        /\ numWins_p1 = 0
        /\ numWins_p2 = 0
        /\ p1_wins = FALSE
        /\ p2_wins = FALSE
        /\ tie = FALSE
        /\ currentRound = 0
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(p1_wins = FALSE /\ p2_wins = FALSE /\ tie = FALSE /\ numWins_p1 = 0 /\ numWins_p2 = 0, 
                   "Failure of assertion at line 18, column 9.")
         /\ IF p1r1 = p2r1
               THEN /\ currentRound' = currentRound + 1
                    /\ UNCHANGED << numWins_p1, numWins_p2 >>
               ELSE /\ IF p1r1 = "R" /\ p2r1 = "P"
                          THEN /\ numWins_p2' = numWins_p2 + 1
                               /\ UNCHANGED numWins_p1
                          ELSE /\ IF p1r1 = "P" /\ p2r1 = "R"
                                     THEN /\ numWins_p1' = numWins_p1 + 1
                                          /\ UNCHANGED numWins_p2
                                     ELSE /\ IF p1r1 = "R" /\ p2r1 = "S"
                                                THEN /\ numWins_p1' = numWins_p1 + 1
                                                     /\ UNCHANGED numWins_p2
                                                ELSE /\ IF p1r1 = "S" /\ p2r1 = "R"
                                                           THEN /\ numWins_p2' = numWins_p2 + 1
                                                                /\ UNCHANGED numWins_p1
                                                           ELSE /\ IF p1r1 = "P" /\ p2r1 = "S"
                                                                      THEN /\ numWins_p2' = numWins_p2 + 1
                                                                           /\ UNCHANGED numWins_p1
                                                                      ELSE /\ IF p1r1 = "S" /\ p2r1 = "P"
                                                                                 THEN /\ numWins_p1' = numWins_p1 + 1
                                                                                 ELSE /\ TRUE
                                                                                      /\ UNCHANGED numWins_p1
                                                                           /\ UNCHANGED numWins_p2
                    /\ UNCHANGED currentRound
         /\ IF p1r2 = p2r2
               THEN /\ pc' = "Lbl_2"
               ELSE /\ IF p1r2 = "R" /\ p2r2 = "P"
                          THEN /\ pc' = "Lbl_3"
                          ELSE /\ IF p1r2 = "P" /\ p2r2 = "R"
                                     THEN /\ pc' = "Lbl_4"
                                     ELSE /\ IF p1r2 = "R" /\ p2r2 = "S"
                                                THEN /\ pc' = "Lbl_5"
                                                ELSE /\ IF p1r2 = "S" /\ p2r2 = "R"
                                                           THEN /\ pc' = "Lbl_6"
                                                           ELSE /\ IF p1r2 = "P" /\ p2r2 = "S"
                                                                      THEN /\ pc' = "Lbl_7"
                                                                      ELSE /\ IF p1r2 = "S" /\ p2r2 = "P"
                                                                                 THEN /\ pc' = "Lbl_8"
                                                                                 ELSE /\ pc' = "Lbl_9"
         /\ UNCHANGED << p1r1, p1r2, p2r1, p2r2, p1_wins, p2_wins, tie >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ currentRound' = currentRound + 1
         /\ pc' = "Lbl_9"
         /\ UNCHANGED << p1r1, p1r2, p2r1, p2r2, numWins_p1, numWins_p2, 
                         p1_wins, p2_wins, tie >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ numWins_p2' = numWins_p2 + 1
         /\ pc' = "Lbl_9"
         /\ UNCHANGED << p1r1, p1r2, p2r1, p2r2, numWins_p1, p1_wins, p2_wins, 
                         tie, currentRound >>

Lbl_4 == /\ pc = "Lbl_4"
         /\ numWins_p1' = numWins_p2 + 1
         /\ pc' = "Lbl_9"
         /\ UNCHANGED << p1r1, p1r2, p2r1, p2r2, numWins_p2, p1_wins, p2_wins, 
                         tie, currentRound >>

Lbl_5 == /\ pc = "Lbl_5"
         /\ numWins_p1' = numWins_p1 + 1
         /\ pc' = "Lbl_9"
         /\ UNCHANGED << p1r1, p1r2, p2r1, p2r2, numWins_p2, p1_wins, p2_wins, 
                         tie, currentRound >>

Lbl_6 == /\ pc = "Lbl_6"
         /\ numWins_p2' = numWins_p2 + 1
         /\ pc' = "Lbl_9"
         /\ UNCHANGED << p1r1, p1r2, p2r1, p2r2, numWins_p1, p1_wins, p2_wins, 
                         tie, currentRound >>

Lbl_7 == /\ pc = "Lbl_7"
         /\ numWins_p2' = numWins_p2 + 1
         /\ pc' = "Lbl_9"
         /\ UNCHANGED << p1r1, p1r2, p2r1, p2r2, numWins_p1, p1_wins, p2_wins, 
                         tie, currentRound >>

Lbl_8 == /\ pc = "Lbl_8"
         /\ numWins_p1' = numWins_p1 + 1
         /\ pc' = "Lbl_9"
         /\ UNCHANGED << p1r1, p1r2, p2r1, p2r2, numWins_p2, p1_wins, p2_wins, 
                         tie, currentRound >>

Lbl_9 == /\ pc = "Lbl_9"
         /\ IF numWins_p1 > numWins_p2
               THEN /\ p1_wins' = TRUE
                    /\ UNCHANGED << p2_wins, tie >>
               ELSE /\ IF numWins_p1 < numWins_p2
                          THEN /\ p2_wins' = TRUE
                               /\ tie' = tie
                          ELSE /\ tie' = TRUE
                               /\ UNCHANGED p2_wins
                    /\ UNCHANGED p1_wins
         /\ Assert(\/ (numWins_p1 = numWins_p2 /\ tie' = TRUE /\ p1_wins' = FALSE /\ p2_wins' = FALSE)
                                  \/ (numWins_p1 > numWins_p2 /\ p1_wins' = TRUE /\ p2_wins' = FALSE)
                                  \/ (numWins_p1 < numWins_p2 /\ p2_wins' = TRUE /\ p1_wins' = FALSE), 
                   "Failure of assertion at line 61, column 9.")
         /\ pc' = "Done"
         /\ UNCHANGED << p1r1, p1r2, p2r1, p2r2, numWins_p1, numWins_p2, 
                         currentRound >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3 \/ Lbl_4 \/ Lbl_5 \/ Lbl_6 \/ Lbl_7
           \/ Lbl_8 \/ Lbl_9
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Fri Feb 24 03:48:15 EST 2023 by jorra04
\* Created Fri Feb 24 03:13:38 EST 2023 by jorra04
