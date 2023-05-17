 *-------------------------------------------------------------------------
* <Rating>-92</Rating>
 *-------------------------------------------------------------------------
     PROGRAM AA.AH.VIEW

     $INSERT I_COMMON
     $INSERT I_EQUATE

     $INSERT I_F.AA.ARRANGEMENT
     $INSERT I_F.AA.ACTIVITY.HISTORY

     GOSUB INITIALISE
     GOSUB GET.ARR.ID
     GOSUB READ.ACTIVITY.HISTORY
     GOSUB DO.DISPLAY

     RETURN

 INITIALISE:

     FN.AH = 'F.AA.ACTIVITY.HISTORY'
     F.AH = ''

     CALL OPF(FN.AH, F.AH)

     RETURN

 GET.ARR.ID:

     PRINT "Enter Arrangement id"
     INPUT ARR.ID

 *    PRINT "Do you want to show REVERSED activities -Y/N?"
 *    INPUT REV.Y.N
 REV.Y.N = 'Y'

 *    PRINT "Do you want in Ascending order - Y/N?"
 *    INPUT ASC.Y
 ASC.Y = 'N'

     RETURN
 READ.ACTIVITY.HISTORY:

     CALL F.READ(FN.AH, ARR.ID, R.AH, F.AH, IO.ERR)
     RETURN

 DO.DISPLAY:

     TOT.MV = DCOUNT(R.AH<AA.AH.EFFECTIVE.DATE>,VM)
     CRT @(-1)
     PLINE = 1

     IF ASC.Y = 'Y' THEN
         START.VAL = TOT.MV
         END.VAL = 1
         STEP.VAL = -1

     END ELSE
         START.VAL = 1
         END.VAL = TOT.MV
         STEP.VAL = 1
     END

    FOR NO.MV = START.VAL TO END.VAL STEP STEP.VAL

         EFF.DATE = R.AH<AA.AH.EFFECTIVE.DATE,NO.MV>
         TOT.ACT = DCOUNT(R.AH<AA.AH.ACTIVITY.REF,NO.MV>,SM)

         CRT @(1,PLINE):EFF.DATE:

         FOR NO.SV = 1 TO TOT.ACT

             ACT.REF = R.AH<AA.AH.ACTIVITY.REF,NO.MV,NO.SV>
             ACTIVITY = R.AH<AA.AH.ACTIVITY,NO.MV, NO.SV>
             SYS.DATE = R.AH<AA.AH.SYSTEM.DATE, NO.MV, NO.SV>
             ACT.STATUS = R.AH<AA.AH.ACT.STATUS, NO.MV, NO.SV>
             INITIATION = R.AH<AA.AH.INITIATION, NO.MV, NO.SV>

             IF ACT.STATUS = 'REV-AUTH' AND REV.Y.N = 'N' THEN
                 CONTINUE
             END

             CRT @(10,PLINE): SYS.DATE:
             CRT @(19,PLINE): ACT.REF:
             CRT  @(38,PLINE): ACTIVITY:
             CRT @(90,PLINE): ACT.STATUS:
             CRT @(100,PLINE): INITIATION

             PLINE += 1

         NEXT NO.SV
     NEXT NO.MV
     RETURN

 END
