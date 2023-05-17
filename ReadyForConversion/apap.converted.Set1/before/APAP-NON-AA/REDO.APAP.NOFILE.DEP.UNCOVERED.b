*-----------------------------------------------------------------------------
* <Rating>-77</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOFILE.DEP.UNCOVERED(Y.ENQ.OUT)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RASHMITHA M
* PROGRAM NAME: REDO.APAP.NOFILE.DEP.UNCOVERED
* ODR NO      : ODR-2009-10-0346
*----------------------------------------------------------------------
*DESCRIPTION:REDO.APAP.NOFILE.DEP.UNCOVERED is a no-file enquiry
*routine used to generate report on deposits which are uncovered by loans
*These values are fetched from the local template REDO.APAP.CPH.DETAIL
*whose percentage difference between total outstanding amount and deposit
*maturity amount is less than Excess percentage defined in parameter file
*or whose loan status not of allowed status in parameter file

*IN PARAMETER: NA
*OUT PARAMETER: Y.ENQ.OUT
*LINKED WITH: REDO.APAP.ENQ.DEP.UNCOVERED

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE                WHO               REFERENCE         DESCRIPTION
*29.07.2010       RASHMITHA M      ODR-2009-10-0346    INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.APAP.MORTGAGES.DETAIL
$INSERT I_F.REDO.APAP.CPH.PARAMETER
$INSERT I_F.REDO.APAP.CPH.DETAIL

  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
  FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'
  F.REDO.APAP.CPH.PARAMETER=''
  CALL OPF(FN.REDO.APAP.CPH.PARAMETER,F.REDO.APAP.CPH.PARAMETER)

  FN.REDO.APAP.CPH.DETAIL='F.REDO.APAP.CPH.DETAIL'
  F.REDO.APAP.CPH.DETAIL=''
  CALL OPF(FN.REDO.APAP.CPH.DETAIL,F.REDO.APAP.CPH.DETAIL)

  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
! If deposit act no is entered in the selection field

  Y.DEP.ID=''
  LOCATE 'DEP.ACT.NO' IN D.FIELDS<1> SETTING Y.DEP.ACT.NO.POS THEN
    Y.DEP.ID=D.RANGE.AND.VALUE<Y.DEP.ACT.NO.POS>
  END

  IF Y.DEP.ID THEN
    SEL.LIST=Y.DEP.ID
  END ELSE
    SEL.CMD='SELECT ':FN.REDO.APAP.CPH.DETAIL     ;*If deposit act no is not entered in the selection field
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
  END

  LOOP
    REMOVE Y.DEP.ID FROM SEL.LIST SETTING Y.DEP.POS
  WHILE Y.DEP.ID:Y.DEP.POS
    GOSUB READ.CPH.DET
    GOSUB READ.CPH.PARAMETER
    GOSUB CHECK.EXCESS.PERC
  REPEAT
  RETURN

*----------------------------------------------------------------------
READ.CPH.DET:
*----------------------------------------------------------------------
! Extract all details from REDO.APAP.CPH.DETAIL
  CALL F.READ(FN.REDO.APAP.CPH.DETAIL,Y.DEP.ID,R.REDO.APAP.CPH.DETAIL,F.REDO.APAP.CPH.DETAIL,CPH.ERR)
  Y.DEP.ACT.NAME=R.REDO.APAP.CPH.DETAIL<CPH.DET.DEP.ACT.NAME>
  Y.START.DATE=R.REDO.APAP.CPH.DETAIL<CPH.DET.START.DATE>
  Y.END.DATE=R.REDO.APAP.CPH.DETAIL<CPH.DET.END.DATE>
  Y.PRINCIPAL =R.REDO.APAP.CPH.DETAIL<CPH.DET.PRINCIPAL>
  Y.DEP.MAT.AMT =R.REDO.APAP.CPH.DETAIL<CPH.DET.MATURITY.AMT>
  Y.LOAN.ACT.NO=R.REDO.APAP.CPH.DETAIL<CPH.DET.LOAN.ACT.NO>
  Y.ARR.ID=R.REDO.APAP.CPH.DETAIL<CPH.DET.ARR.ID>
  Y.ACT.NAME=R.REDO.APAP.CPH.DETAIL<CPH.DET.ACT.NAME>
  Y.STATUS=R.REDO.APAP.CPH.DETAIL<CPH.DET.STATUS>
  Y.OUTS.AMTS=R.REDO.APAP.CPH.DETAIL<CPH.DET.OUTS.PRINCIPAL>
  RETURN

*----------------------------------------------------------------------
READ.CPH.PARAMETER:
*----------------------------------------------------------------------

  Y.PARA.ID='SYSTEM'
  CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,Y.PARA.ID,R.REDO.APAP.CPH.PARAMETER,PARA.ERR)
  Y.ALLOWED.STAT=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.ALLOWED.STATUS>
  CHANGE VM TO FM IN Y.ALLOWED.STAT
  Y.EXCESS.PERC=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.EXCESS.PERCENTAGE>

  RETURN

*----------------------------------------------------------------------
CHECK.EXCESS.PERC:
*----------------------------------------------------------------------
! Check if deposit is uncovered by loan
  Y.TOT.OUTS.AMT=SUM(Y.OUTS.AMTS)
  Y.DIFF.PERC=(Y.TOT.OUTS.AMT-Y.DEP.MAT.AMT)/(100*Y.DEP.MAT.AMT)
  Y.REMARKS=''
  Y.FLAG=''
  STATUS.NOT.FOUND=0
  IF Y.DIFF.PERC LT Y.EXCESS.PERC THEN
    Y.REMARKS='Uncovered'
    Y.FLAG='L'
  END ELSE
    Y.FLAG='G'
  END
  GOSUB CHECK.STATUS
  RETURN
*----------------------------------------------------------------------
CHECK.STATUS:
*----------------------------------------------------------------------
! Check if status is allowed or not

  Y.LN.STATUS=Y.STATUS
  CHANGE SM TO FM IN Y.LN.STATUS
  CHANGE VM TO FM IN Y.LN.STATUS
  Y.STATUS.COUNT=DCOUNT(Y.LN.STATUS,FM)
  Y.COUNT=1
  LOOP
  WHILE Y.COUNT LE Y.STATUS.COUNT
    Y.STAT= Y.LN.STATUS<Y.COUNT>
    LOCATE Y.STAT IN Y.ALLOWED.STAT SETTING POS3 THEN
      STATUS.NOT.FOUND++
    END
    Y.COUNT++
  REPEAT
  IF Y.FLAG='L' AND STATUS.NOT.FOUND NE 0 AND Y.STATUS.COUNT NE 0 THEN
    Y.REMARKS:=',Unallowed Loan status'
    GOSUB RETURN.VALUES
    RETURN
  END
  IF Y.FLAG='L' AND STATUS.NOT.FOUND EQ 0 AND Y.STATUS.COUNT NE 0 THEN
    GOSUB RETURN.VALUES
    RETURN
  END
  IF Y.FLAG='L' AND Y.STATUS.COUNT EQ 0 THEN
    GOSUB RETURN.VALUES
    RETURN
  END

  IF Y.FLAG='G' AND STATUS.NOT.FOUND NE 0 AND Y.STATUS.COUNT NE 0 THEN
    Y.REMARKS='Unallowed Loan status'
    GOSUB RETURN.VALUES
    RETURN
  END
  RETURN
*------------------------------------------------------------------------
RETURN.VALUES:
*------------------------------------------------------------------------
! Return all the deposits which are uncovered and the deposits whose loans have unallowed status

  IF Y.ENQ.OUT EQ '' THEN
    Y.ENQ.OUT=Y.DEP.ID:'*':Y.DEP.ACT.NAME:'*':Y.START.DATE:'*':Y.END.DATE:'*':Y.PRINCIPAL:'*':Y.DEP.MAT.AMT:'*':Y.LOAN.ACT.NO:'*':Y.ARR.ID:'*':Y.ACT.NAME:'*':Y.STATUS:'*':Y.OUTS.AMTS:'*':Y.DIFF.PERC:'*':Y.REMARKS
  END ELSE
    Y.ENQ.OUT:=FM:Y.DEP.ID:'*':Y.DEP.ACT.NAME:'*':Y.START.DATE:'*':Y.END.DATE:'*':Y.PRINCIPAL:'*':Y.DEP.MAT.AMT:'*':Y.LOAN.ACT.NO:'*':Y.ARR.ID:'*':Y.ACT.NAME:'*':Y.STATUS:'*':Y.OUTS.AMTS:'*':Y.DIFF.PERC:'*':Y.REMARKS
  END
  RETURN


END
