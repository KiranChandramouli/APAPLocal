* @ValidationCode : MjoxMDMxMzk2MzYxOkNwMTI1MjoxNzAyOTg4MjUwNTY2OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:47:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
SUBROUTINE REDO.INIT.CARD.VAL
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.INIT.CARD.VAL
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine to check the card is valid or not for transaction well before transaction validations happen
*               This routine has to be attached to versions used in ATM transaction. Application can be FT,AC.LOCKED.EVENTS
*               to find out whether the status entered is valid or not
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27 Oct 2010     SWAMINATHAN          ODR-2009-12-0291          Initial Creation
* 11/10/2023	 CONVERSION TOOL   AUTO R22 CODE CONVERSION	      NOCHANGE
* 11/10/2023	 VIGNESHWARI       MANUAL R22 CODE CONVERSION       NOCHANGE
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.REDO.CARD.IST.RESP.MAP
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.REDO.CR.DB.MAP
    $INSERT I_AT.ISO.COMMON
    $INSERT I_ATM.BAL.ENQ.COMMON
*--------------------------------------------------------------------------------------------------------
    IF V$FUNCTION EQ 'R' THEN

        RETURN

    END

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*--------------------------------------------------------------------------------------------------------
OPEN.FILES:
************
    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.REDO.CARD.IST.RESP.MAP = 'F.REDO.CARD.IST.RESP.MAP'
    F.REDO.CARD.IST.RESP.MAP = ''
    CALL OPF(FN.REDO.CARD.IST.RESP.MAP,F.REDO.CARD.IST.RESP.MAP)

    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    FN.REDO.CR.DB.MAP  = 'F.REDO.CR.DB.MAP'
    F.REDO.CR.DB.MAP = ''
    CALL OPF(FN.REDO.CR.DB.MAP,F.REDO.CR.DB.MAP)

    LOC.REF.APPLICATION="CARD.TYPE"
    LOC.REF.FIELDS='L.CT.BIN'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.CT.BIN = LOC.REF.POS<1,1>
    ZERO.FLAG = ''
*
*Get the latam card number
*
    Y.CARD.NUMBER = AT$INCOMING.ISO.REQ(2)
*
*Get the bin id
*
    Y.BIN.ID = Y.CARD.NUMBER[1,6]
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*********
*Using the BIN you can find the CARD.TYPE
*

    CALL F.READ(FN.REDO.CARD.BIN,Y.BIN.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,Y.ERR.BIN)
    Y.BIN.OWNER = R.REDO.CARD.BIN<REDO.CARD.BIN.BIN.OWNER>
    IF Y.BIN.OWNER EQ 'APAP' THEN
        Y.CARD.ID = R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
        GOSUB VALIDATE.PROC
    END

RETURN
*----------------------------------------------------------------------------------------------------------
VALIDATE.PROC:
****************
*
*Form the latam id and Check the status of latam card
*
* changing code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279
    FLAG.CRD.TYP=1
    LOOP
        REMOVE CRD.TYP FROM Y.CARD.ID SETTING POS.CRD
    WHILE CRD.TYP:POS.CRD

        IF FLAG.CRD.TYP THEN
            Y.LATAM.ID = CRD.TYP:'.':Y.CARD.NUMBER
            CALL F.READ(FN.LATAM.CARD.ORDER,Y.LATAM.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,Y.ERR.LCO)
            IF R.LATAM.CARD.ORDER THEN
                Y.CARD.ID=CRD.TYP
                Y.CARD.ACCT=R.LATAM.CARD.ORDER<CARD.IS.ACCOUNT>
                FLAG.CRD.TYP=0
            END
        END
    REPEAT

    IF FLAG.CRD.TYP EQ 1 THEN
        Y.ERR.MSG.ID='EB-INVALD.DC.NUMBER'
        IF APPLICATION EQ 'ENQUIRY.SELECT' THEN
            ENQ.ERROR.COM =Y.ERR.MSG.ID
        END ELSE
            ETEXT = Y.ERR.MSG.ID
            CALL STORE.END.ERROR
        END

    END

*changing end code to accomadate multivalue of CARD.TYPE in REDO.CARD.BIN for issue PACS00033279

    IF R.LATAM.CARD.ORDER NE '' THEN
        Y.CARD.STATUS = R.LATAM.CARD.ORDER<CARD.IS.CARD.STATUS>
        DATE.TOADY=DATE()
        DATE.VAL=OCONV(DATE.TOADY, "DY4"):FMT(OCONV(DATE.TOADY, "DM"),"R%2"):FMT(OCONV(DATE.TOADY, "DD"),"R%2")
        Y.EXP.DATE=R.LATAM.CARD.ORDER<CARD.IS.EXPIRY.DATE>

        IF Y.EXP.DATE LT DATE.VAL THEN
            Y.CARD.STATUS=97
        END
*
*Read REDO.CARD.IST.RESP.MAP table with the status id
*
        CALL F.READ(FN.REDO.CARD.IST.RESP.MAP,Y.CARD.STATUS,R.REDO.CARD.IST.RESP.MAP,F.REDO.CARD.IST.RESP.MAP,Y.ERR.IST.CARD.RES)

        IF R.REDO.CARD.IST.RESP.MAP NE '' THEN
            Y.CR.DB.CARD.IST = R.REDO.CARD.IST.RESP.MAP<REDO.CARD.IST.RESP.MAP.CR.DB>
*
*Locate for 0 in the record R.REDO.CARD.IST.RESP.CODE of field CR.DB
*Assign RESP.MAP.IST.RESPONSE to ISO.RESP variable
*
            GOSUB CHECK.APP
*
*If ZERO.FLAG doesnt exist, Get the processing code from incoming message
*
            IF ZERO.FLAG NE '1' THEN
*
*Get the processing code from incoming message
*
                Y.INCOMING.MSG.ATM = AT$INCOMING.ISO.REQ(3)
                Y.INCOMING.MSG = Y.INCOMING.MSG.ATM[1,2]
*
*Read REDO.CR.DB.MAP table and get the TXN type
*
*                CALL F.READ(FN.REDO.CR.DB.MAP,"SYSTEM",R.REDO.CR.DB.MAP,F.REDO.CR.DB.MAP,Y.ERR.CR.DB)

                ID.VAR = 'SYSTEM' ;*R22 MAN UAL CODE CONVERSION

                CALL CACHE.READ('F.REDO.CR.DB.MAP',ID.VAR,R.REDO.CR.DB.MAP,PARAM.ERR)

                Y.TXN.CODE = R.REDO.CR.DB.MAP<REDO.CR.DB.MAP.TXN.TYPE>
*
                GOSUB INCOME.MSG.PROC
            END
        END ELSE
            GOSUB CHECK.CARD.ST
        END
    END
RETURN
*------------------
CHECK.APP:
*------------------
    LOCATE '0' IN Y.CR.DB.CARD.IST<1,1> SETTING ZERO.POS THEN
        Y.ERR.MSG.ID = R.REDO.CARD.IST.RESP.MAP<REDO.CARD.IST.RESP.MAP.ERR.MSG.ID,ZERO.POS>
        ISO.RESP = R.REDO.CARD.IST.RESP.MAP<REDO.CARD.IST.RESP.MAP.IST.RESPONSE,ZERO.POS>
        IF Y.ERR.MSG.ID NE '' THEN
            IF APPLICATION EQ 'ENQUIRY.SELECT' THEN
                ENQ.ERROR.COM =Y.ERR.MSG.ID
            END ELSE
                ETEXT = Y.ERR.MSG.ID
                CALL STORE.END.ERROR
            END
        END
        ZERO.FLAG = '1'
    END
RETURN
*---------------
CHECK.CARD.ST:
*---------------
    IF APPLICATION EQ 'ENQUIRY.SELECT' THEN
        ENQ.ERROR.COM = 'ST-CRD.STAT.NT.MAPPED'
    END ELSE
        ETEXT='ST-CRD.STAT.NT.MAPPED'
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------------------------------------------------------------------
INCOME.MSG.PROC:
**************
*Locate incoming message in TXN type of REDO.CR.DB.MAP table and get the value of CR.DB
*
    LOCATE Y.INCOMING.MSG IN Y.TXN.CODE<1,1> SETTING POS.CR.DB THEN
        Y.CR.DB.ID = R.REDO.CR.DB.MAP<REDO.CR.DB.MAP.CR.DB,POS.CR.DB>
*
*Locate the value of CR.DB in REDO.CARD.IST.RESP.MAP table
*Assign RESP.MAP.IST.RESPONSE to ISO.RESP variable
*
        LOCATE Y.CR.DB.ID IN Y.CR.DB.CARD.IST<1,1> SETTING POS.CR.DB.CARD.IST THEN
            Y.ERR.MSG.ID = R.REDO.CARD.IST.RESP.MAP<REDO.CARD.IST.RESP.MAP.ERR.MSG.ID,POS.CR.DB.CARD.IST>
            ISO.RESP = R.REDO.CARD.IST.RESP.MAP<REDO.CARD.IST.RESP.MAP.IST.RESPONSE,POS.CR.DB.CARD.IST>
            GOSUB ASSIGN.ERR.MSG
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------------
ASSIGN.ERR.MSG:
*--------------
    IF Y.ERR.MSG.ID NE '' THEN
        IF Y.CR.DB.ID NE '3' THEN
            ETEXT = Y.ERR.MSG.ID
            CALL STORE.END.ERROR
        END ELSE
*
*If Y.CR.DB.ID is '3' then its enquiry
*
            ENQ.ERROR.COM = Y.ERR.MSG.ID
        END
    END
RETURN
END
