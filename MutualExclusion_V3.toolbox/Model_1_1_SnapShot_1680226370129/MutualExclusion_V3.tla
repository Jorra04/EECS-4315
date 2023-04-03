------------------------- MODULE MutualExclusion_V3 -------------------------
EXTENDS Integers
CONSTANT Procs
(*--algorithm 1BitNoDeadlock {
    variables flag = [i \in Procs |-> FALSE] ;
    process (P \in Procs) {
      ncs: while (TRUE) {
             skip ; 
      enter: flag[self] := TRUE ; 
         e2: if (flag[1 - self]) {              
         e3:   flag[self] := FALSE ;
               goto enter 
             } ;
         cs: skip ;
       exit: flag[self] := FALSE ;            
      }
    }
}*)
\* BEGIN TRANSLATION (chksum(pcal) = "9d32cdbc" /\ chksum(tla) = "d1ca8b46")
VARIABLES flag, pc

vars == << flag, pc >>

ProcSet == (Procs)

Init == (* Global variables *)
        /\ flag = [i \in Procs |-> FALSE]
        /\ pc = [self \in ProcSet |-> "ncs"]

ncs(self) == /\ pc[self] = "ncs"
             /\ TRUE
             /\ pc' = [pc EXCEPT ![self] = "enter"]
             /\ flag' = flag

enter(self) == /\ pc[self] = "enter"
               /\ flag' = [flag EXCEPT ![self] = TRUE]
               /\ pc' = [pc EXCEPT ![self] = "e2"]

e2(self) == /\ pc[self] = "e2"
            /\ IF flag[1 - self]
                  THEN /\ pc' = [pc EXCEPT ![self] = "e3"]
                  ELSE /\ pc' = [pc EXCEPT ![self] = "cs"]
            /\ flag' = flag

e3(self) == /\ pc[self] = "e3"
            /\ flag' = [flag EXCEPT ![self] = FALSE]
            /\ pc' = [pc EXCEPT ![self] = "enter"]

cs(self) == /\ pc[self] = "cs"
            /\ TRUE
            /\ pc' = [pc EXCEPT ![self] = "exit"]
            /\ flag' = flag

exit(self) == /\ pc[self] = "exit"
              /\ flag' = [flag EXCEPT ![self] = FALSE]
              /\ pc' = [pc EXCEPT ![self] = "ncs"]

P(self) == ncs(self) \/ enter(self) \/ e2(self) \/ e3(self) \/ cs(self)
              \/ exit(self)

Next == (\E self \in Procs: P(self))

Spec == Init /\ [][Next]_vars

\* END TRANSLATION 
\* Invariant1, the Safety property.
MutualExclusion == (\A i, j \in  Procs : ((i # j) => ~((pc[i] = "cs")/\(pc[j] = "cs"))))

(* the below is for starvation freedom which is added in the properties section of the TLC checker.

StarvationFree == \A i \in Procs : (pc[i] = "enter") ~> (pc[i] = "cs")

\* version 2
\A i \in Procs : []<>(pc[i] = "cs")

*)

=============================================================================
\* Modification History
\* Last modified Thu Mar 30 21:25:56 EDT 2023 by jorra04
\* Created Wed Mar 29 19:48:52 EDT 2023 by jorra04
