C    Copyright(C) 1999-2020 National Technology & Engineering Solutions
C    of Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C    
C    See packages/seacas/LICENSE for details

C
C
C
      SUBROUTINE SKINIT (STACK, NDIM, LENGTH, IERROR)
C***********************************************************************
C
C  SUBROUTINE SKINIT = STACK MANAGEMENT ROUTINE
C
C***********************************************************************
C
C** PARAMETERS
C      STACK  = STACK ARRAY
C      NDIM   = DIMENSIONED SIZE OF STACK IN CALLING PROGRAM
C      LENGTH = LENGTH OF STACK .LE. NDIM - 2
C      IERROR = 0 - NO ERROR
C               1 - STACK TOO SHORT (I.E. LENGTH > NDIM - 2
C               2 - STACK EMPTY
C               3 - STACK FULL
C               4 - INVALID STACK TYPE
C
C**********************************************************************
C
      PARAMETER (LSYOUT = 6)
      CHARACTER*(*) TYPE
      INTEGER STACK(NDIM)
C
      IF (NDIM .LT. LENGTH + 2) THEN
         IERROR = 1
      ELSE
         STACK(1) = 0
         STACK(2) = LENGTH
         IERROR = 0
      END IF
C
      RETURN
C
C=======================================================================
      ENTRY SKPOP (STACK, NDIM, IVALUE, IERROR)
C
      IF (STACK(1) .EQ. 0) THEN
         IERROR = 2
      ELSE
         IVALUE = STACK(STACK(1) + 2)
         STACK(1) = STACK(1) - 1
         IERROR = 0
      END IF
C
      RETURN
C
C=======================================================================
      ENTRY SKPUSH (STACK, NDIM, IVALUE, IERROR)
C
      IF (STACK(1) .EQ. STACK(2)) THEN
         IERROR = 3
      ELSE
         STACK(1) = STACK(1) + 1
         STACK(STACK(1) + 2) = IVALUE
         IERROR = 0
      END IF
C
      RETURN
C
C=======================================================================
      ENTRY SKEROR (LOUT, IERROR)
C
      IF (LOUT .EQ. 0) THEN
         LUNIT = LSYOUT
      ELSE
         LUNIT = LOUT
      END IF
C
      IF (IERROR .EQ. 0) THEN
      ELSE IF (IERROR .EQ. 1) THEN
         WRITE (LUNIT, '(A)') ' STACK ERROR:  ARRAY TOO SHORT'
      ELSE IF (IERROR .EQ. 2) THEN
         WRITE (LUNIT, '(A)') ' STACK ERROR:  STACK EMPTY'
      ELSE IF (IERROR .EQ. 3) THEN
         WRITE (LUNIT, '(A)') ' STACK ERROR:  STACK FULL'
      ELSE IF (IERROR .EQ. 4) THEN
         WRITE (LUNIT, '(A)') ' STACK ERROR:  INVALID TYPE'
      ELSE
         WRITE (LUNIT, '(A)') ' STACK ERROR:  UNKNOWN ERROR'
      END IF
C
      IERROR = 0
      RETURN
C
C=======================================================================
      ENTRY SKPRIN (LOUT, STACK, NDIM, TYPE, IERROR)
C
      IF (LOUT .EQ. 0) THEN
         LUNIT = LSYOUT
      ELSE
         LUNIT = LOUT
      END IF
C
      IF (STACK(1) .EQ. 0) THEN
         IERROR = 2
      ELSE IF (TYPE .EQ. 'I') THEN
         WRITE (LUNIT, '(2I8)') (I, STACK(I + 2),
     &      I = STACK(1), 1, -1)
      ELSE IF (TYPE .EQ. 'R') THEN
         CALL SKPRNT (LUNIT, STACK(1), STACK(1), NDIM)
      ELSE
         IERROR = 4
      END IF
C
      RETURN
C
      END
