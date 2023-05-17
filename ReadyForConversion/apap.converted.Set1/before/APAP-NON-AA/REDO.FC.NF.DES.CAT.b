*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.NF.DES.CAT(DATA.OUT)
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
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
* Development for :
* Development by  :
* Date            :
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.CIUU.LOAN.DESTINATION
$INSERT I_F.REDO.CATEGORY.CIUU



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

  LOCATE "DEST.LOAN" IN D.FIELDS<1> SETTING DEST.POS THEN
    ID.DEST.LOAN = D.RANGE.AND.VALUE<DEST.POS>

    CALL F.READ(FN.REDO.CIUU.LOAN.DESTINATION, ID.DEST.LOAN, R.REDO.CIUU.LOAN.DESTINATION, F.REDO.CIUU.LOAN.DESTINATION, Y.ERR.CIUU)

    Y.CIU.LN.CATEG.CIUU=R.REDO.CIUU.LOAN.DESTINATION<CIU.LN.CATEG.CIUU>
    Y.COUNT.C = DCOUNT(Y.CIU.LN.CATEG.CIUU,VM)

    FOR Y.C = 1 TO Y.COUNT.C

      CALL F.READ(FN.REDO.CATEGORY.CIUU, Y.CIU.LN.CATEG.CIUU<1,Y.C>, R.REDO.CATEGORY.CIUU, F.REDO.CATEGORY.CIUU, Y.ERR.CAT.CIUU)
      Y.CATEGORY.CIUU.ID = R.REDO.CATEGORY.CIUU<CAT.CIU.DESCRIPTION>
      Y.CAT.H = R.REDO.CATEGORY.CIUU<CAT.CIU.CATEGORIA>
      DATA.OUT.AUX = Y.CIU.LN.CATEG.CIUU<1,Y.C>:"*":Y.CAT.H:"*":Y.CATEGORY.CIUU.ID
      DATA.OUT<-1> = DATA.OUT.AUX

    NEXT Y.C

  END

  RETURN
*
* =========
OPEN.FILES:
* =========
*
  CALL OPF(FN.REDO.CIUU.LOAN.DESTINATION, F.REDO.CIUU.LOAN.DESTINATION)
  CALL OPF(FN.REDO.CATEGORY.CIUU,F.REDO.CATEGORY.CIUU)

  RETURN
*
* =========
INITIALISE:
* =========
*

  LOOP.CNT = 1
  MAX.LOOPS = 1
  PROCESS.GOAHEAD = 1

  FN.REDO.CIUU.LOAN.DESTINATION = "F.REDO.CIUU.LOAN.DESTINATION"
  F.REDO.CIUU.LOAN.DESTINATION=""

  FN.REDO.CATEGORY.CIUU="F.REDO.CATEGORY.CIUU"
  F.REDO.CATEGORY.CIUU=""


  RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
*
  RETURN
*

END
