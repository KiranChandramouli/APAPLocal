*-----------------------------------------------------------------------------
* <Rating>-61</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.COMPLAINTS.CLAIM(Y.FIN.ARR)
*--------------------------------------------------------
* Description: This routine is a nofile enquiry routine to display the details
* of the loan along with interest rate.

* In  Argument:
* Out Argument: Y.OUT.ARRAY

*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*10 Sep 2011     H Ganesh         Massive rate - B.16  INITIAL CREATION
* -----------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.ISSUE.COMPLAINTS


  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN
*-----------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------
  Y.OUT.ARRAY = ''

  FN.REDO.ISS.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
  F.REDO.ISS.COMPLAINTS  = ''
  CALL OPF(FN.REDO.ISS.COMPLAINTS,F.REDO.ISS.COMPLAINTS)


  RETURN
*-----------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

  FILE.NAME = FN.REDO.ISS.COMPLAINTS
  Y.FIXED = 'STATUS EQ "IN-PROCESS"':FM:'CLOSING.STATUS EQ ""'
  CALL REDO.E.FORM.SEL.STMT(FILE.NAME, Y.FIXED, '', SEL.ISS.CMD)

  CALL EB.READLIST(SEL.ISS.CMD,CLAIM.IDS,'',NO.OF.REC,SEL.ERR)
  Y.INIT = 1
  GOSUB GET.DETAILS

  RETURN
*-------------------------------------------------------------------
GET.DETAILS:
  LOOP
    REMOVE Y.CLAIM.ID FROM CLAIM.IDS SETTING Y.CLAIM.POS
  WHILE Y.INIT LE NO.OF.REC
    GOSUB READ.CLAIMS
    Y.CUSTOMER.CODE   = R.REDO.ISS.COMPLAINTS<ISS.COMP.CUSTOMER.CODE>
    Y.CUST.ID.NUMBER  = R.REDO.ISS.COMPLAINTS<ISS.COMP.CUST.ID.NUMBER>
    Y.SHORT.NAME      = Y.CUSTOMER.CODE
    Y.CLAIM.TYPE      = R.REDO.ISS.COMPLAINTS<ISS.COMP.CLAIM.TYPE>
    Y.CLAIMS.ID       = Y.CLAIM.ID
    Y.STATUS          = R.REDO.ISS.COMPLAINTS<ISS.COMP.STATUS>
    Y.SUPPORT.GROUP   = R.REDO.ISS.COMPLAINTS<ISS.COMP.SUPPORT.GROUP>
    Y.SEGMENTO        = Y.CUSTOMER.CODE
    GOSUB FORM.ARRAY
    Y.INIT++
  REPEAT
  RETURN
*-----------------------------------------------------------------
FORM.ARRAY:
  Y.FIN.ARR<-1> = Y.CUSTOMER.CODE:'*':Y.CUST.ID.NUMBER:'*':Y.SHORT.NAME:'*':Y.CLAIM.TYPE:'*':Y.CLAIMS.ID:'*':Y.STATUS:'*':Y.SUPPORT.GROUP:'*':Y.SEGMENTO
  RETURN
*-------------------------------------------------------------------
READ.CLAIMS:

  R.REDO.ISS.COMPLAINTS = ''
  CALL F.READ(FN.REDO.ISS.COMPLAINTS,Y.CLAIM.ID,R.REDO.ISS.COMPLAINTS,F.REDO.ISS.COMPLAINTS,CLAIM.ERR)

  RETURN
END
