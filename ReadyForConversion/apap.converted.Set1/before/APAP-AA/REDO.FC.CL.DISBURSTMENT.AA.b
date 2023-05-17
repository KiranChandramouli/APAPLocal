*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.CL.DISBURSTMENT.AA
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - REGISTER DISBURSTMENT FOR REDO.CREATE.ARRANGEMENT TO CREDIT FACTORY
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for :APAP
* Development by  :btorresalbornoz@temenos.com
* Date            :June 2011


*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.FC.CL.BALANCE
$INSERT I_REDO.FC.COMMON
$INSERT I_F.REDO.CREATE.ARRANGEMENT

*
*************************************************************************
*
  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

*
  RETURN
*
* ======
PROCESS:
* ======

  CALL F.READ(FN.REDO.FC.CL.BALANCE,DES.AA.ID,R.REDO.FC.CL.BALANCE,F.REDO.FC.CL.BALANCE,ERR.MSJ)
  IF R.REDO.FC.CL.BALANCE THEN
    DES.AMOUNT.OG = R.REDO.FC.CL.BALANCE<FC.CL.AA.AMOUNT>
    DES.AMOUNT.BALANCE= R.REDO.FC.CL.BALANCE<FC.CL.AA.BALANCE>
    DES.AMOUNT.BALANCE=DES.AMOUNT.BALANCE+ DES.AMOUNT

    IF DES.AMOUNT.BALANCE <= DES.AMOUNT.OG THEN
      R.REDO.FC.CL.BALANCE<FC.CL.AA.BALANCE>    = DES.AMOUNT.BALANCE
      CALL F.WRITE(FN.REDO.FC.CL.BALANCE,DES.AA.ID,R.REDO.FC.CL.BALANCE)

    END ELSE
      AF = REDO.FC.AVAIL.COLL.BAL.BR
      ETEXT = "EB-FC-NOT-PAY-MORE"
      CALL STORE.END.ERROR


    END
  END

  RETURN
*
* =========
OPEN.FILES:
* =========
*
  CALL OPF(FN.REDO.FC.CL.BALANCE,F.REDO.FC.CL.BALANCE)

  RETURN
*
* =========
INITIALISE:
* =========
*
  LOOP.CNT        = 1
  MAX.LOOPS       = 1
  PROCESS.GOAHEAD = 1



  FN.REDO.FC.CL.BALANCE="F.REDO.FC.CL.BALANCE"
  F.REDO.FC.CL.BALANCE=""

* Y.DIS.AMOUNT=R.NEW(FT.DEBIT.AMOUNT)
* DES.AA.ID=R.NEW(FT.IN.DEBIT.ACCT.NO)

  RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1

    END CASE

    LOOP.CNT +=1
  REPEAT
*
  RETURN
*

END
