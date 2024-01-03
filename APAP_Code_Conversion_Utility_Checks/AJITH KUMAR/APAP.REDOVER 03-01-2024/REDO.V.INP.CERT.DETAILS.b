* @ValidationCode : Mjo2NDAyNjcyNjc6Q3AxMjUyOjE2ODI0MTIzNDgxMjI6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CERT.DETAILS
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at the Input level for the Following versions
* of TELLER,CHEQUE.GOVERNMENT.TAX and TELLER,CHEQUE.GOVERNMENT.NOTAX and TELLER,CHEQUE.GOVERNMENT.BENEFICIARY
* This Routine is used to update the Cheque Informations of Transaction Reference and the
* User Information in the Local table CERTIFIED.CHEQUE.STOCK
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
* Linked : TELLER
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.INP.CERT.DETAILS
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 16.03.2010      SUDHARSANAN S     ODR-2009-10-0319  INITIAL CREATION
* 09.05.2011      Sudharsanan S     PACS00033391      Remove some lines and modify as per requirement
* 05.02.2012                                          Chq No duplication
*
* -----------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*11-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*------------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
*
$INSERT I_F.TELLER
$INSERT I_F.USER
$INSERT I_F.TELLER.TRANSACTION
*
$INSERT I_F.CERTIFIED.CHEQUE.STOCK
$INSERT I_F.CERTIFIED.CHEQUE.DETAILS
$INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
*

GOSUB INIT
GOSUB OPEN.FILES
GOSUB CHECK.PRELIM.CONDITIONS
IF PROCESS.GOAHEAD THEN
GOSUB PROCESS
END
*
RETURN

*-------------------------------------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------------------------------------
*
* Update trans.ref details to the cheque no
*

IF V$FUNCTION EQ 'I' OR V$FUNCTION EQ 'A' THEN
GOSUB CERT.CHEQ.INFORMATION
END

IF V$FUNCTION EQ 'D' THEN
GOSUB CERT.CHEQ.CANCELLED
END
*
RETURN
*
*-------------------------------------------------------------------------------------------------------------
CERT.CHEQ.INFORMATION:
*-------------------------------------------------------------------------------------------------------------
*Block the next available cheque. So Update Stock table with ISSUED status.
*
R.NEW(TT.TE.LOCAL.REF)<1,CERT.CHEQ.POS> = Y.CERT.CHEQ.NO
*
*** Commented after Discussion with Jorge. this is not requred for Certified Cheques.***
*    IF WCHEQUE.TYPE EQ 'NON.GOVT' THEN
*        R.NEW(TT.TE.CHEQUE.NUMBER) = Y.CERT.CHEQ.NO
*    END

*
R.CERT.CHEQ.STO<CERT.STO.TRANS.REF> = ID.NEW
R.CERT.CHEQ.STO<CERT.STO.USER>      = OPERATOR
R.CERT.CHEQ.STO<CERT.STO.STATUS>    = 'ISSUED'

CALL F.WRITE(FN.CERTIFIED.CHEQUE.STOCK, Y.CERT.CHEQ.NO, R.CERT.CHEQ.STO)

RETURN

*-------------------------------------------------------------------------------------------------------------
CERT.CHEQ.CANCELLED:
*-------------------------------------------------------------------------------------------------------------
*In case of INAU record deletion
R.CERT.CHEQ.STO<CERT.STO.STATUS> = 'AVAILABLE'
R.CERT.CHEQ.STO<CERT.STO.TRANS.REF> = ""
R.CERT.CHEQ.STO<CERT.STO.TRANS.REF> = ""

CALL F.WRITE(FN.CERTIFIED.CHEQUE.STOCK,Y.CERT.CHEQ.NO,R.CERT.CHEQ.STO)

RETURN
*
* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
IF Y.ERR.MSG THEN
ETEXT           = Y.ERR.MSG
CALL STORE.END.ERROR
END
*
RETURN
*
* ===================
GET.TRANSACTION.INFO:
* ===================
*
CALL CACHE.READ(FN.TELLER.TRANSACTION,TT.CODE,R.TELLER.TRANSACTION,TT.ERR)
WCHEQUE.TYPE = R.TELLER.TRANSACTION<TT.TR.LOCAL.REF,GOV.POS>
*
CALL CACHE.READ(FN.CERTIFIED.CHEQUE.PARAMETER,ID.COMPANY,R.CERT.CHEQ.PARAM,CHEQ.ERR)
TYPE.VALUE    = R.CERT.CHEQ.PARAM<CERT.CHEQ.TYPE>
ACCOUNT.VALUE = R.CERT.CHEQ.PARAM<CERT.CHEQ.ACCOUNT.NO>

CHANGE @VM TO @FM IN TYPE.VALUE
CHANGE @VM TO @FM IN ACCOUNT.VALUE

LOCATE WCHEQUE.TYPE IN TYPE.VALUE SETTING POS THEN
WSERIAL.START = R.CERT.CHEQ.PARAM<CERT.CHEQ.START.SERIAL.NO,POS>
END
*
RETURN
*
*-------------------------------------------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------------------------------------
*
PROCESS.GOAHEAD = 1
*
FN.CERTIFIED.CHEQUE.STOCK = 'F.CERTIFIED.CHEQUE.STOCK'
F.CERTIFIED.CHEQUE.STOCK  = ''
*
FN.CERTIFIED.CHEQUE.PARAMETER = 'F.CERTIFIED.CHEQUE.PARAMETER'
F.CERTIFIED.CHEQUE.PARAMETER  = ''
*
FN.CERTIFIED.CHEQUE.DETAILS = 'F.CERTIFIED.CHEQUE.DETAILS'
F.CERTIFIED.CHEQUE.DETAILS  = ''
*
FN.TELLER.TRANSACTION = "F.TELLER.TRANSACTION"
F.TELLER.TRANSACTION  = ""
*
LREF.APP       = 'TELLER' : @FM : "TELLER.TRANSACTION"
LREF.FIELD     = 'CERT.CHEQUE.NO' : @VM : 'L.COMMENTS' : @VM: "L.TT.BENEFICIAR" : @FM : "L.TT.GOV.TYPE"
LREF.POS       = ''
Y.CONTENT      = ''
Y.LOCK.CONTENT = ''
FLAG           = ''
CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
CERT.CHEQ.POS = LREF.POS<1,1>
COMMENTS.POS  = LREF.POS<1,2>
Y.TT.BENEF    = LREF.POS<1,3>
*
GOV.POS       = LREF.POS<2,1>
*
CURR.NO = R.NEW(TT.TE.CURR.NO)
TT.CODE = R.NEW(TT.TE.TRANSACTION.CODE)
*
RETURN
*
*-------------------------------------------------------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------------------------------------------------------
*
CALL OPF(FN.CERTIFIED.CHEQUE.STOCK,F.CERTIFIED.CHEQUE.STOCK)
CALL OPF(FN.CERTIFIED.CHEQUE.PARAMETER,F.CERTIFIED.CHEQUE.PARAMETER)
CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS)
CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
LOOP
WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
BEGIN CASE

CASE LOOP.CNT EQ 1
IF OFS.VAL.ONLY OR V$FUNCTION EQ "R" THEN
PROCESS.GOAHEAD = ""
END

CASE LOOP.CNT EQ 2
IF V$FUNCTION NE 'R' AND V$FUNCTION NE 'D' THEN
GOSUB GET.TRANSACTION.INFO
END

CASE LOOP.CNT EQ 3
IF V$FUNCTION NE 'D' THEN
GOSUB GET.NEXT.AVAILABLE.CHEQUE.NUMBER
END

CASE LOOP.CNT EQ 4
IF V$FUNCTION EQ 'D' THEN
Y.CERT.CHEQ.NO = R.NEW(TT.TE.LOCAL.REF)<1,CERT.CHEQ.POS>
END

*CALL F.READ(FN.CERTIFIED.CHEQUE.STOCK,Y.CERT.CHEQ.NO,R.CERT.CHEQ.STO,F.CERTIFIED.CHEQUE.STOCK,STO.ERR)
CALL F.READU(FN.CERTIFIED.CHEQUE.STOCK,Y.CERT.CHEQ.NO,R.CERT.CHEQ.STO,F.CERTIFIED.CHEQUE.STOCK,STO.ERR,'');* R22 AUTO CONVERSION
IF R.CERT.CHEQ.STO<CERT.STO.STATUS> EQ 'ISSUED' AND (V$FUNCTION EQ "I" OR V$FUNCTION EQ "A") THEN
AF    = TT.TE.LOCAL.REF
AV    = CERT.CHEQ.POS
Y.ERR.MSG = 'TT-NO.CHEQUE.MOD'
PROCESS.GOAHEAD = ""
END ELSE
IF (V$FUNCTION EQ 'D') AND R.CERT.CHEQ.STO<CERT.STO.STATUS> NE 'ISSUED' THEN
AF    = TT.TE.LOCAL.REF
AV    = CERT.CHEQ.POS
Y.ERR.MSG = 'TT-NO.CHEQUE.MOD'
PROCESS.GOAHEAD = ""
END
END
END CASE
*
GOSUB CONTROL.MSG.ERROR

LOOP.CNT += 1

REPEAT

RETURN
*
*---------------------------------
GET.NEXT.AVAILABLE.CHEQUE.NUMBER:
*---------------------------------

SEL.CMD  = 'SSELECT ':FN.CERTIFIED.CHEQUE.STOCK
SEL.CMD := ' WITH STATUS EQ AVAILABLE AND @ID LIKE ' : WSERIAL.START : '...'

CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)

IF NOT(SEL.LIST) THEN
AF = TT.TE.LOCAL.REF
AV = CERT.CHEQ.POS
Y.ERR.MSG = 'EB-REDO.NO.AVAIL.CHEQUE'
PROCESS.GOAHEAD = ""
END ELSE
GOSUB CONTINUE.GETTING.NUMBER
END

RETURN

*-----------------------
CONTINUE.GETTING.NUMBER:
*-----------------------

CHEQUE.FOUND = ""
*
LOOP
REMOVE X.NEXT.AVAILABLE.ID FROM SEL.LIST SETTING Y.POS
WHILE X.NEXT.AVAILABLE.ID:Y.POS AND NOT(CHEQUE.FOUND)

Y.NEXT.AVAILABLE.ID = X.NEXT.AVAILABLE.ID
CALL F.READU(FN.CERTIFIED.CHEQUE.STOCK, Y.NEXT.AVAILABLE.ID, R.CERT.CHEQ.STO, F.CERTIFIED.CHEQUE.STOCK, ERR, "I")

IF ERR NE 'RECORD LOCKED' THEN
IF R.CERT.CHEQ.STO THEN
IF R.CERT.CHEQ.STO<CERT.STO.STATUS> EQ "AVAILABLE" THEN
R.CERT.CHEQ.STO<CERT.STO.STATUS> = "ISSUED"
Y.CERT.CHEQ.NO = Y.NEXT.AVAILABLE.ID
CHEQUE.FOUND = 1    ;* exit the loop else go for next id
END
END
END

REPEAT

IF NOT(CHEQUE.FOUND) THEN
AF    = TT.TE.LOCAL.REF
AV    = CERT.CHEQ.POS
Y.ERR.MSG = 'EB-REDO.NO.AVAIL.CHEQUE'
PROCESS.GOAHEAD = ""
END

RETURN


*-------------------------------------------------------------------------------------------------------------
END
*------------------------------------------------------------------------------------------------------------
