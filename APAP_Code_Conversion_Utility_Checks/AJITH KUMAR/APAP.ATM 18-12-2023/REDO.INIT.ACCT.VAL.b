* @ValidationCode : MjotMjAxOTA0NjM1MzpDcDEyNTI6MTcwMjYxNTcxMjUxMjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Dec 2023 10:18:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
SUBROUTINE REDO.INIT.ACCT.VAL
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.INIT.ACCT.VAL
*--------------------------------------------------------------------------------------------------------
*Description  : This validation is to check the account status and throw error well before transactions validation occurs
*               This routine has to be attached to versions used in ATM transaction. Application can be FT,AC.LOCKED.EVENTS
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 28 Oct 2010     SWAMINATHAN            ODR-2009-12-0291         Initial Creation
* 1 OCT  2011     KAVITHA                PACS00137917             * PACS00137917 FIX
* 11/10/2023	 CONVERSION TOOL    AUTO R22 CODE CONVERSION	  $INCLUDE TO $INSERT,ATM.BP is removed in insertfile , VM TO @VM, SM TO @SM, Y.VAR1++ TO Y.VAR1+ =1, F.READ TO CACHE.READ
* 11/10/2023	 VIGNESHWARI        MANUAL R22 CODE CONVERSION      Call rtn modified, Y.CARD.ACCT ="" ( Assing value to null)
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.OVERRIDE
    $INSERT I_F.REDO.L.AC.STATUS.CODE
    $INSERT I_F.REDO.NOTIFY.STATUS.MESSAGE
    $INSERT I_F.REDO.ACCT.IST.RESP.MAP
    $INSERT I_F.REDO.CR.DB.MAP
    $INSERT I_AT.ISO.COMMON     ;*AUTO R22 CODE CONVERSION - $INCLUDE TO $INSERT ,ATM.BP IS REMOVED
    $INSERT I_F.LIMIT
    $INSERT I_ATM.BAL.ENQ.COMMON
    $INSERT I_POST.COMMON
    $USING APAP.TAM  ;*MANUAL R22 CODE CONVERSION
    IF V$FUNCTION EQ 'R' THEN
        RETURN
    END

    IF APPLICATION EQ 'ENQUIRY.SELECT' THEN
        IF ENQ.ERROR.COM EQ '' THEN
            Y.ACCT.NUM=Y.ACCT.NO
            GOSUB OPEN.FILES
            GOSUB PROCESS
        END
    END ELSE
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
    IF NOT(Y.FLAG.POST) THEN
*CALL REDO.CHK.POST.REST
        APAP.TAM.redoChkPostRest() ;*MANUAL R22 CODE CONVERSION -Call rtn modified
    END

RETURN
*--------------------------------------------------------------------------------------------------------
OPEN.FILES:
************

    FN.REDO.LAC.STATUS.CODE = 'F.REDO.L.AC.STATUS.CODE'
    F.REDO.LAC.STATUS.CODE = ''
    CALL OPF(FN.REDO.LAC.STATUS.CODE,F.REDO.LAC.STATUS.CODE)


    FN.REDO.ACCT.IST.RESP.MAP ='F.REDO.ACCT.IST.RESP.MAP'
    F.REDO.ACCT.IST.RESP.MAP =''
    CALL OPF(FN.REDO.ACCT.IST.RESP.MAP,F.REDO.ACCT.IST.RESP.MAP)

    FN.REDO.CR.DB.MAP  = 'F.REDO.CR.DB.MAP'
    F.REDO.CR.DB.MAP = ''
    CALL OPF(FN.REDO.CR.DB.MAP,F.REDO.CR.DB.MAP)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
*Get the local refernce field L.AC.STATUS2
*
    LOC.REF.ACC.APPL='ACCOUNT'

    LOC.REF.ACC.FIELDS='L.AC.STATUS1':@VM:'L.AC.TRANS.LIM':@VM:'L.AC.AV.BAL':@VM:'L.AC.TRAN.AVAIL':@VM:'L.AC.NOTIFY.1'
    LOC.REF.ACC.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.ACC.APPL,LOC.REF.ACC.FIELDS,LOC.REF.ACC.POS)

    POS.AC.STAT=LOC.REF.ACC.POS<1,1>
    LOC.L.AC.TRANSIT.LIM  = LOC.REF.ACC.POS<1,2>
    LOC.L.AC.AV.BAL.POS = LOC.REF.ACC.POS<1,3>
    TRAN.AVAIL.POS = LOC.REF.ACC.POS<1,4>
    NOTIFY.POS     = LOC.REF.ACC.POS<1,5>

    ZERO.FLAG = ''

    FN.LIMIT= 'F.LIMIT'
    F.LIMIT = ''
    CALL OPF(FN.LIMIT,F.LIMIT)
    Y.FLAG.POST=0
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*********
* If application is 'FUNDS.TRANSFER' then take DEBIT.ACCT.NO field value as account number
* If application is 'AC.LOCKED.EVENTS' then AC.LCK.ACCOUNT.NUMBER field value as account number


    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.ACCT.NUM = R.NEW(FT.DEBIT.ACCT.NO)
    END
    IF APPLICATION EQ 'AC.LOCKED.EVENTS' THEN
        Y.ACCT.NUM =  R.NEW(AC.LCK.ACCOUNT.NUMBER)
    END
    IF Y.ACCT.NUM EQ '' THEN
        Y.ACCT.NUM = AT$INCOMING.ISO.REQ(102)
    END
    
    IF Y.ACCT.NUM[1,3] EQ 'DOP' OR Y.ACCT.NUM[1,3] EQ 'USD' THEN
        Y.CARD.ACCT ="" ;*MANUAL R22 CODE CONVERSION- ASSIGN VARIABLE AS NULL
        Y.ACCT.NUM=Y.CARD.ACCT
    END
* PACS00137917-S
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NUM,R.ACCOUNT,F.ACCOUNT,Y.ERR.AC)
    Y.CARD.CUST.ID=R.ACCOUNT<AC.CUSTOMER>
    Y.CERITO.ACCT=Y.ACCT.NUM

    IF R.ACCOUNT NE '' THEN
        Y.AC.STAT   = R.ACCOUNT<AC.LOCAL.REF,POS.AC.STAT,1>
        Y.POST.ID   = R.ACCOUNT<AC.POSTING.RESTRICT>
        Y.NOTIFY.ID = R.ACCOUNT<AC.LOCAL.REF,NOTIFY.POS>
*Read the REDO.ACCT.STATUS.CODE table and get the previous text and locate with the value of local refernce field L.AC.STATUS2
*
        ID.VAR = 'SYSTEM' ;*R22 MANUAL CODE CONVERSION

        CALL CACHE.READ(FN.REDO.LAC.STATUS.CODE,ID.VAR,R.REDO.LAC.STATUS.CODE,Y.ERR.STAT)

        Y.PREV.TEXT = R.REDO.LAC.STATUS.CODE<REDO.LAC.STAT.PREV.TEXT>
        Y.PREV.STAT = R.REDO.LAC.STATUS.CODE<REDO.LAC.STAT.L.AC.STATUS>

        LOCATE Y.AC.STAT IN Y.PREV.STAT<1,1> SETTING STAT.POS THEN
            Y.STATUS.CODE = R.REDO.LAC.STATUS.CODE<REDO.LAC.STAT.STATUS.CODE,STAT.POS>
            IF Y.STATUS.CODE NE '' THEN
                GOSUB ACCT.RESP.MAP
            END
        END ELSE
            ETEXT = 'ST-ACCT.STAT.NT.MAPPED'
            CALL STORE.END.ERROR
        END

    END


* PACS00137917-E

RETURN

*------------------------------------------------------------------------------------------------------
ACCT.RESP.MAP:
**************
*Read the REDO.ACCT.IST.RESP.MAP table
*Locate for 0 in the record R.REDO.CARD.IST.RESP.CODE of field CR.DB
*Assign RESP.MAP.IST.RESPONSE to ISO.RESP variable
*
    IF Y.STATUS.CODE EQ '00' THEN
        GOSUB NOTIFY.CHECK
        RETURN
    END

    CALL F.READ(FN.REDO.ACCT.IST.RESP.MAP,Y.STATUS.CODE,R.REDO.ACCT.IST.RESP.MAP,F.REDO.ACCT.IST.RESP.MAP,Y.ERR.IST.ACCT.RES)
    IF R.REDO.ACCT.IST.RESP.MAP NE '' THEN
        Y.CR.DB.ACCT.IST = R.REDO.ACCT.IST.RESP.MAP<REDO.ACCT.IST.RESP.MAP.CR.DB>
        LOCATE '0' IN Y.CR.DB.ACCT.IST<1,1> SETTING ZERO.POS THEN
            Y.ERR.MSG.ID = R.REDO.ACCT.IST.RESP.MAP<REDO.ACCT.IST.RESP.MAP.ERR.MSG.ID,ZERO.POS>
            ISO.RESP = R.REDO.ACCT.IST.RESP.MAP<REDO.ACCT.IST.RESP.MAP.IST.RESPONSE,ZERO.POS>
            IF Y.ERR.MSG.ID NE '' THEN
                Y.FLAG.POST=1
                ETEXT = Y.ERR.MSG.ID
                CALL STORE.END.ERROR
            END
            ZERO.FLAG = '1'
        END
*If ZERO.FLAG doesnt exist, Get the processing code from incoming message
*
        IF ZERO.FLAG NE '1'  THEN
            Y.INCOMING.MSG.ATM = AT$INCOMING.ISO.REQ(3)
            Y.INCOMING.MSG = Y.INCOMING.MSG.ATM[1,2]
*
*Read REDO.CR.DB.MAP table and get the TXN type
*
*CALL F.READ(FN.REDO.CR.DB.MAP,"SYSTEM",R.REDO.CR.DB.MAP,F.REDO.CR.DB.MAP,Y.ERR.CR.DB)

           
            CALL CACHE.READ(FN.REDO.CR.DB.MAP,ID.VAR,R.REDO.CR.DB.MAP,Y.ERR.CR.DB)
            Y.TXN.CODE = R.REDO.CR.DB.MAP<REDO.CR.DB.MAP.TXN.TYPE>
            GOSUB INCOME.MSG
        END

    END ELSE

        IF APPLICATION EQ 'ENQUIRY.SELECT' THEN
            ENQ.ERROR.COM = 'ST-ACCT.STAT.NT.MAPPED'
        END ELSE
            ETEXT='ST-ACCT.STAT.NT.MAPPED'
            CALL STORE.END.ERROR
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------
INCOME.MSG:
************
*Locate incoming message in TXN type of REDO.CR.DB.MAP table and get the value of CR.DB
*
    LOCATE Y.INCOMING.MSG IN Y.TXN.CODE<1,1> SETTING POS.CR.DB THEN
        Y.CR.DB.ID = R.REDO.CR.DB.MAP<REDO.CR.DB.MAP.CR.DB,POS.CR.DB>
*
*Locate the value of CR.DB in REDO.ACCT.IST.RESP.MAP table
*Assign RESP.MAP.IST.RESPONSE to ISO.RESP variable
*
        LOCATE Y.CR.DB.ID IN Y.CR.DB.ACCT.IST<1,1> SETTING POS.CR.DB.ACCT.IST THEN
            Y.ERR.MSG.ID = R.REDO.ACCT.IST.RESP.MAP<REDO.ACCT.IST.RESP.MAP.ERR.MSG.ID,POS.CR.DB.ACCT.IST>
            ISO.RESP = R.REDO.ACCT.IST.RESP.MAP<REDO.ACCT.IST.RESP.MAP.IST.RESPONSE,POS.CR.DB.ACCT.IST>

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
            END ELSE

                GOSUB NOTIFY.CHECK
            END
        END
    END

RETURN
*--------------------------------------------------------------------------------------------------------
NOTIFY.CHECK:

    FN.REDO.NOTIFY.MESSAGE = 'F.REDO.NOTIFY.STATUS.MESSAGE'
    F.REDO.NOTIFY.MESSAGE  = ''
    CALL OPF(FN.REDO.NOTIFY.MESSAGE,F.REDO.NOTIFY.MESSAGE)

    FN.OVERRIDE = 'F.OVERRIDE'
    F.OVERRIDE  = ''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)

    IF APPLICATION EQ 'ENQUIRY.SELECT' THEN
        Y.APPLICATION = 'FUNDS.TRANSFER'
    END ELSE
        Y.APPLICATION = APPLICATION
    END
    CALL F.READ(FN.REDO.NOTIFY.MESSAGE,Y.APPLICATION,R.REDO.NOTIFY.STATUS,F.REDO.NOTIFY.MESSAGE,NOTIFY.ERR)
    IF R.REDO.NOTIFY.STATUS THEN
        IF R.REDO.NOTIFY.STATUS THEN
            Y.FIELD.POS.LIST = R.REDO.NOTIFY.STATUS<REDO.NOTIF.ACCT.FIELD.POS>
        END
        Y.TOTAL.FIELD.COUNT = DCOUNT(Y.FIELD.POS.LIST,@VM)
        Y.INIT = 1
        GOSUB CONT.PROC
    END
RETURN

CONT.PROC:
    Y.NOTIFY.CNT=DCOUNT(Y.NOTIFY.ID,@SM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.NOTIFY.CNT
        Y.NOTIFY=Y.NOTIFY.ID<1,1,Y.VAR1>
        GOSUB RAISE.OVERRIDE
        Y.VAR1 += 1  ;*AUTO R22 CODE CONVERSION - Y.VAR1++ TO Y.VAR1+ =1
    REPEAT

RETURN

RAISE.OVERRIDE:
* This part gets the override message from REDO.NOTIFY.STATUS.MESSAGE application and raise the override

    Y.OVERRIDE   = R.REDO.NOTIFY.STATUS<REDO.NOTIF.OVERRIDE.MSG>
    CHANGE @VM TO @FM IN Y.OVERRIDE
    Y.NOTIFY.MSG = R.REDO.NOTIFY.STATUS<REDO.NOTIF.NOTIFY.MSG>
    CHANGE @VM TO @FM IN Y.NOTIFY.MSG

    LOCATE Y.NOTIFY IN Y.NOTIFY.MSG SETTING NOTIFY.POS THEN
        Y.OVERRIDE.ID=Y.OVERRIDE<NOTIFY.POS>
    END ELSE
        Y.OVERRIDE.ID=''
    END
    IF Y.OVERRIDE.ID THEN
        CALL CACHE.READ(FN.OVERRIDE, Y.OVERRIDE.ID, R.OVERRIDE, ERR.OVERRIDE)  ;*AUTO R22 CODE CONVERSION - F.READ TO CACHE.READ
        Y.CLASS=''
        LOCATE APPLICATION IN R.OVERRIDE<EB.OR.APPLICATION,1>  SETTING Y.OVR.APP.POS THEN
            Y.CLASS = R.OVERRIDE<EB.OR.CLASS,Y.OVR.APP.POS>
        END
        IF Y.CLASS THEN
            Y.ERR.MSG.ID = 'EB-REDO.NOTIFY.MSG'
            IF Y.CR.DB.ID NE '3' THEN
                ETEXT = Y.ERR.MSG.ID
                CALL STORE.END.ERROR
            END ELSE
                ENQ.ERROR.COM = Y.ERR.MSG.ID
            END
        END
    END
RETURN
END
