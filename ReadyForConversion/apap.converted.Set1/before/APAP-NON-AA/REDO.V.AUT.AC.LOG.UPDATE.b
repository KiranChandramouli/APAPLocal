*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUT.AC.LOG.UPDATE
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : This Auth routine is used to Update the Log CR.CONTACT.LOG table
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.V.AUT.AC.LOG.UPDATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE         DESCRIPTION
* 25-AUG-2010       RENUGADEVI B       ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CR.CONTACT.LOG
$INSERT I_F.ACCOUNT

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****
  R.CR.CONTACT.LOG             = ''
  FN.CR.CONTACT.LOG            = 'F.CR.CONTACT.LOG'
  F.CR.CONTACT.LOG             = ''
  CALL OPF(FN.CR.CONTACT.LOG, F.CR.CONTACT.LOG)

  FN.ACCOUNT                   = 'F.ACCOUNT'
  F.ACCOUNT                    = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  LREF.APPL                    = 'CR.CONTACT.LOG'
  LREF.FIELDS                  = 'L.CR.PROD.REQ'
  LREF.POS                     = ''
  CALL MULTI.GET.LOC.REF(LREF.APPL, LREF.FIELDS, LREF.POS)
  L.CR.PROD.REQ.POS            = LREF.POS<1,1>

  RETURN
********
PROCESS:
********

  Y.ID                  = ID.NEW
  Y.SAM.TIME            = TIMEDATE()
  Y.TIME                = Y.SAM.TIME[1,5]
  Y.CUST.ID             = R.NEW(AC.CUSTOMER)
  Y.INPUTTER            = R.NEW(AC.INPUTTER)
  Y.USER                = FIELD(Y.INPUTTER,'-',2)
  GOSUB UPDATE.LOG
  RETURN

***********
UPDATE.LOG:
***********

  CALL F.READ(FN.CR.CONTACT.LOG,Y.LOG.ID,R.CR.CONTACT.LOG,F.CR.CONTACT.LOG,CR.ERR)

  R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CLIENT>                 = Y.CUST.ID
  R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.STATUS>                 = "NEW"
  R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.TYPE>                   = "AUTOMATICO"
  R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DESC>                   = "ACCOUNT"
  R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.CHANNEL>                = "BRANCH"
  R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.DATE>                   = TODAY
  R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.TIME>                   = Y.TIME
  R.CR.CONTACT.LOG<CR.CONT.LOG.CONTRACT.ID>                    = Y.ID
  R.CR.CONTACT.LOG<CR.CONT.LOG.CONTACT.STAFF>                  = Y.USER
  R.CR.CONTACT.LOG<CR.CONT.LOG.LOCAL.REF,L.CR.PROD.REQ.POS>    = "ACCOUNT"

  OFS.SOURCE.ID            = 'OFS.LOG.UPDATE'
  APPLICATION.NAME         = 'CR.CONTACT.LOG'
  TRANS.FUNC.VAL           = 'I'
  TRANS.OPER.VAL           = 'PROCESS'
  APPLICATION.NAME.VERSION = 'CR.CONTACT.LOG,LOG.INTERACT'
  NO.AUT                   = '0'
  OFS.MSG.ID               = ''
  APPLICATION.ID           = ''
  OFS.POST.MSG             = ''

  CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.CR.CONTACT.LOG,OFS.REQ.MSG)
  CALL OFS.POST.MESSAGE(OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

  RETURN
END
