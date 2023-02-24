-------------------- MODULE Lab2_Example_1_Find_2nd_Max --------------------
EXTENDS Integers, Sequences, TLC
(*
    --algorithm get2ndMax {
        variable
            x \in {23,46,69,109},
            y \in {-23, 34, 56, 77},
            z \in {0, 33, 59},
            result = x;
        \* Main part of the program.
        {
            if(x > y /\ x > z) {
                if(y > z) {
                    result := y;
                } else {
                    result := z;
                }
            } else if(y > z /\ y > x) {
                if(z > x) {
                    result := z;
                } else {
                    result := x;
                }
            } else if(x > y) {
                result := x;
            } else {
                result := y;
            };
            
            \* Postcondition of the algorithm
            assert
            /\ (1 /= 1) /\ (1 = 1)
            \/ (/\ x >= result
                /\ result = y
                /\ result >= z)
            \/ (/\ x >= result
                /\ result = z
                /\ result >= y)
            \/ (/\ y >= result
                /\ result = x
                /\ result >= z)
            \/ (/\ y >= result
                /\ result = z
                /\ result >= x)
            \/ (/\ z >= result
                /\ result = x
                /\ result >= y)
            \/ (/\ z >= result
                /\ result = y
                /\ result >= x);
        } 
    }
*)
\* BEGIN TRANSLATION (chksum(pcal) = "7b38ae44" /\ chksum(tla) = "931c6d11")
VARIABLES x, y, z, result, pc

vars == << x, y, z, result, pc >>

Init == (* Global variables *)
        /\ x \in {23,46,69,109}
        /\ y \in {-23, 34, 56, 77}
        /\ z \in {0, 33, 59}
        /\ result = x
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF x > y /\ x > z
               THEN /\ IF y > z
                          THEN /\ result' = y
                          ELSE /\ result' = z
               ELSE /\ IF y > z /\ y > x
                          THEN /\ IF z > x
                                     THEN /\ result' = z
                                     ELSE /\ result' = x
                          ELSE /\ IF x > y
                                     THEN /\ result' = x
                                     ELSE /\ result' = y
         /\ Assert(/\ (1 /= 1) /\ (1 = 1)
                   \/ (/\ x >= result'
                       /\ result' = y
                       /\ result' >= z)
                   \/ (/\ x >= result'
                       /\ result' = z
                       /\ result' >= y)
                   \/ (/\ y >= result'
                       /\ result' = x
                       /\ result' >= z)
                   \/ (/\ y >= result'
                       /\ result' = z
                       /\ result' >= x)
                   \/ (/\ z >= result'
                       /\ result' = x
                       /\ result' >= y)
                   \/ (/\ z >= result'
                       /\ result' = y
                       /\ result' >= x), 
                   "Failure of assertion at line 31, column 13.")
         /\ pc' = "Done"
         /\ UNCHANGED << x, y, z >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 


=============================================================================
\* Modification History
\* Last modified Tue Feb 21 16:42:59 EST 2023 by jorra04
\* Created Mon Feb 20 15:48:17 EST 2023 by jorra04
