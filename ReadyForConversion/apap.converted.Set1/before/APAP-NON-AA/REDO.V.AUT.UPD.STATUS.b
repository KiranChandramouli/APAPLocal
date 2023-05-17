*----------------------------------------------------------------------------------------------------------------------
* <Rating>-103</Rating>
*----------------------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUT.UPD.STATUS
*----------------------------------------------------------------------------------------------------------------------
* Developer   : TAM
* Date        : 14.05.2010
* Description : AUTH ROUTINE FOR VERSIONS AS FOLLOWS
* FUNDS.TRANSFER          : REVERSE.CHQ, REINSTATE
* TELLER                  : CASH.CHQ, REINSTATE, PAY.CHQ, PAY.EXPIRE.CHQ
* REDO.ADMIN.CHQ.DETAILS  : STOP.PAY
*----------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*----------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*----------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date         Name                           Reference         Description
* -------      ----                           ---------         ------------
* 14-05-2010   VIGNESH A.S/Mohammed Anies K   ODR-2010-03-0447  Initial creation
* 12-02-2011   Ganesh R                       HD1052250         Modification to restrict Ac entries waive charge is Yes
* 18-02-2011   KAVITHA                        HD1052812
* 23-02-2011   Sudharsanan S                  HD1052811
* 04-08-2013   VIGNESH KUMAAR M R             PACS00304986      FATAL ERROR: NO DEBE APARECER ESTE ERROR
*----------------------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_F.USER
$INSERT I_F.TELLER
$INSERT I_F.ACCOUNT
$INSERT I_F.STMT.ENTRY
$INSERT I_F.CATEG.ENTRY
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.FT.COMMISSION.TYPE
*
$INSERT I_F.REDO.H.ADMIN.CHEQUES
$INSERT I_F.REDO.ADMIN.CHQ.DETAILS
$INSERT I_F.REDO.ADMIN.CHQ.PARAM
*
  GOSUB INITIALIZE
  GOSUB SELECT.APP
*
  RETURN
*
***********
INITIALIZE:
***********
  Y.CHEQUE.NUMBER=""; Y.TYPE=""; ENTRY.REC=""; YENTRY.REC=""; YENTRY.REC=""

  FN.REDO.H.ADMIN.CHEQUES= "F.REDO.H.ADMIN.CHEQUES"
  F.REDO.H.ADMIN.CHEQUES= ""
  R.REDO.H.ADMIN.CHEQUES= ''

  FN.REDO.ADMIN.CHQ.DETAILS= "F.REDO.ADMIN.CHQ.DETAILS"
  F.REDO.ADMIN.CHQ.DETAILS= ""
  R.REDO.ADMIN.CHQ.DETAILS= ''

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  R.ACCOUNT = ''

  FN.STMT.ENTRY='F.STMT.ENTRY'
  F.STMT.ENTRY=''

  FN.CATEG.ENTRY='F.CATEG.ENTRY'
  F.CATEG.ENTRY=''

  FN.REDO.ADMIN.CHQ.PARAM='F.REDO.ADMIN.CHQ.PARAM'
  F.REDO.ADMIN.CHQ.PARAM=''
  R.REDO.ADMIN.CHQ.PARAM=''

  FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
  F.FT.COMMISSION.TYPE=''
  R.FT.COMMISSION.TYPE=''

  CALL OPF(FN.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES)
  CALL OPF(FN.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS)
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL OPF(FN.CATEG.ENTRY,F.CATEG.ENTRY)
  CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
  CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)
  CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

  DIM R.MAT.CHQ.REC(REDO.ADMIN.AUDIT.DATE.TIME)
  DIM  R.MAT.DET.REC(ADMIN.CHQ.DET.AUDIT.DATE.TIME)
*
  EB.ACCT.ERR.MSG=''
*
  RETURN
*
***********
SELECT.APP:
***********
*
* Selection of application
*
  IF APPLICATION EQ "FUNDS.TRANSFER" THEN
    Y.CHEQUE.NUMBER = R.NEW(FT.CREDIT.THEIR.REF)
*HD1052812 - S
    IF Y.CHEQUE.NUMBER THEN
      IF PGM.VERSION EQ ",CHQ.REV.AUTH" AND V$FUNCTION EQ "A" THEN
        GOSUB UPDATE.CANCEL.DETAILS
      END ELSE
        GOSUB UPDATE.CHQ.DETAILS
      END
    END

  END

  IF APPLICATION EQ "TELLER" THEN

    Y.CHEQUE.NUMBER = R.NEW(TT.TE.CHEQUE.NUMBER)

    IF Y.CHEQUE.NUMBER THEN
      GOSUB UPDATE.CHQ.DETAILS
    END

  END

*HD1052812 -E

  IF APPLICATION EQ "REDO.ADMIN.CHQ.DETAILS" THEN
    GOSUB UPDATE.CURRENT.TABLE
  END
*
  RETURN
*
*********************
UPDATE.CANCEL.DETAILS:
*********************
  CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NUMBER,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,Y.ERR.REDO.ADMIN.CHQ.DETAILS)
  IF R.REDO.ADMIN.CHQ.DETAILS THEN
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS> =  'CANCELLED'
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.PAID.DATE> = ""
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.ADDITIONAL.INFO,-1> = "CANCELLED-" : ID.NEW : "-" : TODAY
  END

  GOSUB UPDATE.AUDIT.CHEQUE.DETAILS
  MATPARSE R.MAT.DET.REC FROM R.REDO.ADMIN.CHQ.DETAILS
  CALL EB.HIST.REC.WRITE(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NUMBER,MAT R.MAT.DET.REC,ADMIN.CHQ.DET.AUDIT.DATE.TIME)

  REDO.H.ADMIN.CHEQUES.ID = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.CHQ.SEQ.NUM>
  CALL F.READ(FN.REDO.H.ADMIN.CHEQUES, REDO.H.ADMIN.CHEQUES.ID, R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,Y.ERR.REDO.H.ADMIN.CHEQUES)
  IF R.REDO.H.ADMIN.CHEQUES THEN
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS> =  'CANCELLED'

* Fix for PACS00304986 [FATAL ERROR: NO DEBE APARECER ESTE ERROR #1]

*    END
    GOSUB UPDATE.AUDIT.ADMIN.CHEQUE
    MATPARSE R.MAT.CHQ.REC FROM R.REDO.H.ADMIN.CHEQUES
    CALL EB.HIST.REC.WRITE(FN.REDO.H.ADMIN.CHEQUES, REDO.H.ADMIN.CHEQUES.ID, MAT R.MAT.CHQ.REC,REDO.ADMIN.AUDIT.DATE.TIME)
  END

* End of Fix

  RETURN
*******************
UPDATE.CHQ.DETAILS:
*******************
* Selection for PGM.VERSIONS
* HD1O52811 - To change the auth version name CASH.CHQ.AUT

  CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NUMBER,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,Y.ERR.REDO.ADMIN.CHQ.DETAILS)
  IF R.NEW(V-8)[1,1] EQ "I" THEN
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>    = "PAID"
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.PAID.DATE> = TODAY
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.ADDITIONAL.INFO,-1> = "PAID-" : ID.NEW : "-" : TODAY
  END ELSE
    IF R.NEW(V-8)[1,1] EQ "R" THEN
      R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>    = "ISSUED"
      R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.PAID.DATE> = ""
      R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.ADDITIONAL.INFO,-1> = "REVERSE.PAID-" : ID.NEW : "-" : TODAY
    END
  END

  GOSUB UPDATE.AUDIT.CHEQUE.DETAILS

  MATPARSE R.MAT.DET.REC FROM R.REDO.ADMIN.CHQ.DETAILS
  CALL EB.HIST.REC.WRITE(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NUMBER,MAT R.MAT.DET.REC,ADMIN.CHQ.DET.AUDIT.DATE.TIME)

*
*Now update the Other Table REDO.H.ADMIN.CHEQUES
*
  REDO.H.ADMIN.CHEQUES.ID = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.CHQ.SEQ.NUM>

  CALL F.READ(FN.REDO.H.ADMIN.CHEQUES, REDO.H.ADMIN.CHEQUES.ID, R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,Y.ERR.REDO.H.ADMIN.CHEQUES)
  IF R.NEW(V-8)[1,1] EQ "I" THEN
    IF R.REDO.H.ADMIN.CHEQUES THEN
      R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS> = "PAID"
    END
  END ELSE
    IF R.NEW(V-8)[1,1] EQ "R" THEN
      IF R.REDO.H.ADMIN.CHEQUES THEN
        R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS> = "ISSUED"
      END
    END
  END

  GOSUB UPDATE.AUDIT.ADMIN.CHEQUE

* Fix for PACS00304986 [FATAL ERROR: NO DEBE APARECER ESTE ERROR #2]

  IF REDO.H.ADMIN.CHEQUES.ID THEN
    MATPARSE R.MAT.CHQ.REC FROM R.REDO.H.ADMIN.CHEQUES
    CALL EB.HIST.REC.WRITE(FN.REDO.H.ADMIN.CHEQUES, REDO.H.ADMIN.CHEQUES.ID, MAT R.MAT.CHQ.REC,REDO.ADMIN.AUDIT.DATE.TIME)
  END

* End of Fix
*
  RETURN
*
****
*
CODIGO.VIEJO:

  IF PGM.VERSION EQ ",REVERSE.CHQ" OR PGM.VERSION EQ ",CHQ.REV.AUTH" OR PGM.VERSION EQ ",CASH.CHQ.AUT" OR V$FUNCTION EQ "R" THEN
    CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NUMBER,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,Y.ERR.REDO.ADMIN.CHQ.DETAILS)
    IF R.REDO.ADMIN.CHQ.DETAILS THEN
      R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>            = "CANCELLED"
      R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.CANCELLATION.DATE> = TODAY
      GOSUB UPDATE.AUDIT.CHEQUE.DETAILS

      MATPARSE R.MAT.DET.REC FROM R.REDO.ADMIN.CHQ.DETAILS
      CALL EB.HIST.REC.WRITE(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NUMBER,MAT R.MAT.DET.REC,ADMIN.CHQ.DET.AUDIT.DATE.TIME)
    END
    CALL F.READ(FN.REDO.H.ADMIN.CHEQUES,Y.CHEQUE.NUMBER,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,Y.ERR.REDO.H.ADMIN.CHEQUES)
    IF R.REDO.H.ADMIN.CHEQUES THEN
      R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS> = "CANCELLED"
      GOSUB UPDATE.AUDIT.ADMIN.CHEQUE
      MATPARSE R.MAT.CHQ.REC FROM R.REDO.H.ADMIN.CHEQUES
      CALL EB.HIST.REC.WRITE(FN.REDO.H.ADMIN.CHEQUES,Y.CHEQUE.NUMBER,MAT R.MAT.CHQ.REC,REDO.ADMIN.AUDIT.DATE.TIME)
    END
  END

  IF PGM.VERSION EQ ",REINSTATE" THEN
    CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NUMBER,R.REDO.ADMIN.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,Y.ERR.REDO.ADMIN.CHQ.DETAILS)
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>="REINSTATED"
    R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.REINSTATED.DATE>=TODAY
    GOSUB UPDATE.AUDIT.CHEQUE.DETAILS

    MATPARSE R.MAT.DET.REC FROM R.REDO.ADMIN.CHQ.DETAILS
    CALL EB.HIST.REC.WRITE(FN.REDO.ADMIN.CHQ.DETAILS,Y.CHEQUE.NUMBER,MAT R.MAT.DET.REC,ADMIN.CHQ.DET.AUDIT.DATE.TIME)
  END
*
  RETURN
*
****
*
*********************
UPDATE.CURRENT.TABLE:
*********************
* To Stop payment ADMIN.CHEQUES
  CALL F.READ(FN.REDO.H.ADMIN.CHEQUES,ID.NEW,R.REDO.H.ADMIN.CHEQUES,F.REDO.H.ADMIN.CHEQUES,Y.ERR.REDO.H.ADMIN.CHEQUES)
  IF R.REDO.H.ADMIN.CHEQUES THEN
    R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.STATUS>="STOPPED"
    GOSUB UPDATE.AUDIT.ADMIN.CHEQUE

    MATPARSE R.MAT.CHQ.REC FROM R.REDO.H.ADMIN.CHEQUES
    CALL EB.HIST.REC.WRITE(FN.REDO.H.ADMIN.CHEQUES,ID.NEW,MAT R.MAT.CHQ.REC,REDO.ADMIN.AUDIT.DATE.TIME)
  END

  RETURN
*******************


****************************
UPDATE.AUDIT.CHEQUE.DETAILS:
****************************
*
* To update Audit fields
*
  Y.INPUTTER.CHQ   = DCOUNT(R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.INPUTTER>,VM)
  Y.DATE.TIME.CHQ  = DCOUNT(R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.DATE.TIME>,VM)
  GOSUB TIME.MANU
*
  R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.CURR.NO>                   = R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.CURR.NO> + 1
  R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.INPUTTER,Y.INPUTTER.CHQ>   = TNO:"_":OPERATOR
  R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.AUTHORISER,Y.INPUTTER.CHQ> = TNO:"_":OPERATOR
  R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.CO.CODE>                   = ID.COMPANY
  R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.DEPT.CODE>                 = R.USER<EB.USE.DEPARTMENT.CODE>
  R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.RECORD.STATUS>             = ""
  R.REDO.ADMIN.CHQ.DETAILS<ADMIN.CHQ.DET.DATE.TIME,Y.DATE.TIME.CHQ> = DATE.TIME
*
  RETURN

**************************
UPDATE.AUDIT.ADMIN.CHEQUE:
**************************
*
* To update Audit fields
*
  Y.INPUTTER.CHEQUE    = DCOUNT(R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.INPUTTER>,VM)
  Y.DATE.TIME.CHEQUE   = DCOUNT(R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DATE.TIME>,VM)
  GOSUB TIME.MANU
*
  R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.CURR.NO>                      = R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.CURR.NO> + 1
  R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.INPUTTER,Y.INPUTTER.CHEQUE>   = TNO:"_":OPERATOR
  R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.AUTHORISER,Y.INPUTTER.CHEQUE> = TNO:"_":OPERATOR
  R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.CO.CODE>                      = ID.COMPANY
  R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DEPT.CODE>                    = R.USER<EB.USE.DEPARTMENT.CODE>
  R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.RECORD.STATUS>                = ""
  R.REDO.H.ADMIN.CHEQUES<REDO.ADMIN.DATE.TIME,Y.DATE.TIME.CHEQUE> = DATE.TIME
*
  RETURN
*
**********
TIME.MANU:
**********
* To update date and time
  CON.DATE  = OCONV(DATE(),"D-")
  DATE.TIME = CON.DATE[9,2]:CON.DATE[1,2]:CON.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
*
  RETURN
*
END
