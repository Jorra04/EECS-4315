------------------------- MODULE MutualExclusion_V1 -------------------------
EXTENDS Integers
CONSTANT Procs
(*
--algorithm Alternate {
  variable turn \in Procs;
  process (p \in Procs) {
    ncs: while (TRUE) {
           skip ;
  enter:   await turn = self ;
     cs:   skip ;
   exit:   turn := 1 - self 
         }
  }  
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "df287080" /\ chksum(tla) = "812ece42")
VARIABLES turn, pc

vars == << turn, pc >>

ProcSet == (Procs)

Init == (* Global variables *)
        /\ turn \in Procs
        /\ pc = [self \in ProcSet |-> "ncs"]

ncs(self) == /\ pc[self] = "ncs"
             /\ TRUE
             /\ pc' = [pc EXCEPT ![self] = "enter"]
             /\ turn' = turn

enter(self) == /\ pc[self] = "enter"
               /\ turn = self
               /\ pc' = [pc EXCEPT ![self] = "cs"]
               /\ turn' = turn

cs(self) == /\ pc[self] = "cs"
            /\ TRUE
            /\ pc' = [pc EXCEPT ![self] = "exit"]
            /\ turn' = turn

exit(self) == /\ pc[self] = "exit"
              /\ turn' = 1 - self
              /\ pc' = [pc EXCEPT ![self] = "ncs"]

p(self) == ncs(self) \/ enter(self) \/ cs(self) \/ exit(self)

Next == (\E self \in Procs: p(self))

Spec == Init /\ [][Next]_vars

\* END TRANSLATION 

(*Start of invariants*)
\* Invariant1, the Safety property.
MutualExclusion == (\A i, j \in  Procs : ((i # j) => ~((pc[i] = "cs")/\(pc[j] = "cs"))))

\* Liveness property.

Liveness == \A i \in Procs : []<>(pc[i] = "cs")

=============================================================================
\* Modification History
\* Last modified Thu Mar 30 16:08:51 EDT 2023 by jorra04
\* Created Wed Mar 29 18:36:15 EDT 2023 by jorra04
