*-----------------------------------------------------------------------------
* <Rating>-36</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.VAL.PYMNT.VP
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.25.2013
* Description  : Routine for validating a new credit card payment
* Type         : Input Routine
* Attached to  : Vision Plus Transactionsal VERSIONs (TT y FT)
* Dependencies :
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
*-----------------------------------------------------------------------------

* <region name="INSERTS">

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System
    $INSERT I_F.REDO.VISION.PLUS.TXN
    $INSERT I_GTS.COMMON

* </region>

    IF OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB INIT
        GOSUB PROCESS
    END

    RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize
INIT:
***********************
    IF APPLICATION EQ 'TELLER' THEN
        Y.LET = 'T'
        Y.OVERRIDE.LOCAL.REF = TT.TE.OVERRIDE
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.LET = 'F'
        Y.OVERRIDE.LOCAL.REF = FT.OVERRIDE
    END

    ALLOW.OFFLINE = ''
    TXN.RESULT = ''
    R.REDO.VISION.PLUS.TXN = ''
    FN.REDO.VISION.PLUS.TXN = 'F.REDO.VISION.PLUS.TXN'
    F.REDO.VISION.PLUS.TXN = ''
    R.REDO.VISION.PLUS.TXN = ''
    REDO.VISION.PLUS.TXN.ID = ''
    CALL OPF(FN.REDO.VISION.PLUS.TXN,F.REDO.VISION.PLUS.TXN)
    TXN.VERSION = APPLICATION : PGM.VERSION

    Y.LOCAL.REF = 'LOCAL.REF'

    Y.LOCAL.FIELDS = ''
    Y.LOCAL.FIELDS.POS = ''

    Y.LOCAL.FIELDS<1,1> = 'L.':Y.LET:'T.MSG.CODE'

    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    MSG.CODE.POS = Y.LOCAL.FIELDS.POS<1,1>

    RETURN

***********************
* Main Process
PROCESS:
***********************

    IF APPLICATION EQ 'TELLER'  THEN
        BEGIN CASE
* Pago Caja Efectivo/TFR
        CASE TXN.VERSION MATCHES '...CASHIN...' OR TXN.VERSION MATCHES '...TFR...'
            ALLOW.OFFLINE = 1
            CALL REDO.VP.CC.PAYMENT(ALLOW.OFFLINE, TXN.RESULT)

* Pago Cheque
* Estos pagos no se registran en linea, solo por archivo monetario
        CASE TXN.VERSION MATCHES '...CHQ...'
            GOSUB SET.OFFLINE.TXN
        END CASE
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        ALLOW.OFFLINE = 1
        CALL REDO.VP.CC.PAYMENT(ALLOW.OFFLINE, TXN.RESULT)
    END

    IF TXN.RESULT<1> EQ 'OFFLINE' OR TXN.RESULT<1> EQ 'ERROR' THEN

        CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL003', 'ONLINE', '04', 'Email PAGO SE APLICARA OFFLINE - ID: ':ID.NEW , ' ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')

        EXT.USER.ID = System.getVariable("EXT.EXTERNAL.USER")
        IF EXT.USER.ID EQ 'EXT.EXTERNAL.USER' THEN

            TEXT    = 'ST-VP-NO.ONLINE.PYMNT'
            CURR.NO = DCOUNT(R.NEW(Y.OVERRIDE.LOCAL.REF),VM)+ 1
            CALL STORE.OVERRIDE(CURR.NO)
        END

        FINDSTR 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS.FM.OVER THEN
            DEL E<POS.FM.OVER>
        END

        GOSUB SET.OFFLINE.TXN
    END

    RETURN

*************************************
* Set Transaction Offline Processing
SET.OFFLINE.TXN:
*************************************


    R.NEW(Y.LOCAL.REF)<1,MSG.CODE.POS> = '000000'

    RETURN

* </region>

END
