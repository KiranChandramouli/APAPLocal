* @ValidationCode : MjotMjMzNzQ5MTQyOkNwMTI1MjoxNjgyNTk4MDE1NzA1OnNhbWFyOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.GENERATION.WS
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.GENERATION.WS
*--------------------------------------------------------------------------------------------------------
*Description  : This is a authorisation routine to
*Linked With  : REDO.CARD.GENERATION
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                      Reference               Description
*   ------         ------                    -------------            -------------
* 03 Aug 2010    Mohammed Anies K           ODR-2010-03-0400         Initial Creation
* 1 Feb 2011     Kavitha                    ODR-2010-03-0400         HD1101688  Fix
* 8-Apr-2011     Kavitha                    ODR-2010-03-0400         PACS00036007  fix
* 13-MAY-2011    KAVITHA                    ODR-2010-08-0467         PACS00055017  FIX
*10 JUN 2011     KAVITHA                    ODR-2010-08-0467         PACS00063138 FIX
* 11-04-2023     CONVERSION TOOL            AUTO R22 CODE CONVERSION     VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
* 11-04-2023     jayasurya H                MANUAL R22 CODE CONVERSION   CALL RTN METHOD ADDED
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.CARD.TYPE
    $INSERT JBC.h
    $INSERT I_TSS.COMMON
    $INSERT I_F.EB.ERROR
    $INSERT I_F.REDO.CARD.GENERATION
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_REDO.CARD.GEN.COMMON
    $USING APAP.REDOCHNLS
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:



    ACTIVATION = "APAP_EMBOZADO_WEBSERVICES"


    MAX.ALLOWED.CARDS = R.APAP.PARAM<PARAM.MAX.CARDS.ALLOW>
    GOSUB UPDATE.WEB.SERVICE

RETURN
*---------------------------------------------------------------------------------------------------------
UPDATE.WEB.SERVICE:
********************
    CHANGE @VM TO '*' IN INPUT_PARAM_CMSACT.REQUEST
    CHANGE @VM TO '*' IN INPUT_PARAM_CMS.CARD.REQUEST
    CHANGE @VM TO '*' IN INPUT_PARAM_CARD.REQUEST

    INT.CODE='EMB005'
    INT.TYPE='ONLINE'
    MON.TP     = '03'
    ID.PROC=ID.NEW

    AF=REDO.CARD.GEN.QTY

    IF Y.CARD.QTY LT MAX.ALLOWED.CARDS THEN
        MAX.LOOP.CNTR = 1
        FIRST.POS = 1
        LAST.POS = Y.CARD.QTY
    END ELSE
        QUOTIENT = INT(Y.CARD.QTY / MAX.ALLOWED.CARDS)
        REMAINDER = MOD(Y.CARD.QTY,MAX.ALLOWED.CARDS)

        IF REMAINDER GT 0 THEN
            MAX.LOOP.CNTR = QUOTIENT + 1
        END ELSE
            MAX.LOOP.CNTR = QUOTIENT
        END
        FIRST.POS = 1
        LAST.POS = MAX.ALLOWED.CARDS
    END


    LOOP.CNTR = 1
    LOOP
    WHILE LOOP.CNTR LE MAX.LOOP.CNTR
        Y.RET=''
        FETCH_PARAM_CARD.REQUEST      = 'ISTTSF_UpdateCardRequest':Y.DEM:FIELD(INPUT_PARAM_CARD.REQUEST,'*',FIRST.POS,MAX.ALLOWED.CARDS)
        FETCH_PARAM_CMS.CARD.REQUEST  = 'ISTTSF_UpdateCMSCardRequest':Y.DEM:FIELD(INPUT_PARAM_CMS.CARD.REQUEST,'*',FIRST.POS,MAX.ALLOWED.CARDS)
        FETCH_PARAM_CMSACT.REQUEST    = 'ISTTSF_UpdateCMSActRequest':Y.DEM:FIELD(INPUT_PARAM_CMSACT.REQUEST,'*',FIRST.POS,MAX.ALLOWED.CARDS)

        ERROR.CODE.CARD.REQUEST = CALLJEE(ACTIVATION,FETCH_PARAM_CARD.REQUEST)
        Y.ERROR.CODE=ERROR.CODE.CARD.REQUEST
        Y.PARAM=FETCH_PARAM_CARD.REQUEST

        GOSUB EXCEP.PROCESS
        IF Y.RET THEN
            RETURN
        END

        ERROR.CODE.CMS.CARD.REQUEST = CALLJEE(ACTIVATION,FETCH_PARAM_CMS.CARD.REQUEST)
        Y.ERROR.CODE=ERROR.CODE.CMS.CARD.REQUEST
        Y.PARAM     =FETCH_PARAM_CMS.CARD.REQUEST

        GOSUB EXCEP.PROCESS
        IF Y.RET THEN
            RETURN
        END

        ERROR.CODE.CMSACT.REQUEST = CALLJEE(ACTIVATION,FETCH_PARAM_CMSACT.REQUEST)
        Y.ERROR.CODE=ERROR.CODE.CMSACT.REQUEST
        Y.PARAM     =FETCH_PARAM_CMSACT.REQUEST

        GOSUB EXCEP.PROCESS
        IF Y.RET THEN
            RETURN
        END

*        GOSUB WEB.SERV.RESP.UPDATE

        FIRST.POS += MAX.ALLOWED.CARDS
        LAST.POS += MAX.ALLOWED.CARDS

        LOOP.CNTR += 1

    REPEAT

    FIRST.POS = 1

    GOSUB WEB.SERV.RESP.UPDATE
    GOSUB FILE.UPD.CHECK
RETURN
*-------------------------------------------------------------------------------
*******************
WEB.SERV.RESP.UPDATE:
*******************


    IF R.CARD.REQUEST THEN
        IF R.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD> EQ 'URGENTE' THEN
            UrgentCards = 'Y'
        END ELSE
            UrgentCards = 'N'
        END

        IF R.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD> EQ '' THEN
            PreEmbossedCards ='Y'
        END ELSE
            PreEmbossedCards ='N'
        END
    END

    InstitutionId = Y.BIN.NO
    FromDate = TODAY
    ToDate  = TODAY

    Y.VAL.SUB = FIELD(Y.CARD.NO,@VM,1)
*    Y.SUB.CNT = DCOUNT(Y.VAL.SUB,SM)

    FromCardNumber =Y.VAL.SUB<1,1,FIRST.POS>
    IF LAST.POS GT Y.CARD.QTY THEN
        LAST.POS = Y.CARD.QTY
    END
    ToCardNumber =Y.VAL.SUB<1,1,LAST.POS>
    Y.CardType = Y.CARD.TYPE

    CALL F.READ(FN.CARD.TYPE,Y.CardType,R.CARD.TYPE,F.CARD.TYPE,Y.ERR.CARD.TYPE)
    IF R.CARD.TYPE THEN
        Y.BIN.ID = R.CARD.TYPE<CARD.TYPE.LOCAL.REF,POS.L.CT.BIN>
    END

    CALL F.READ(FN.REDO.CARD.BIN,Y.BIN.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,Y.ERR.CARD.BIN)
    IF R.REDO.CARD.BIN THEN
        Y.ENT.ID = R.REDO.CARD.BIN<REDO.CARD.BIN.ENTITY.ID>
    END

    CardType = Y.ENT.ID
    RepeadInProduction = 1


    AF=REDO.CARD.GEN.QTY
    INPUT_PARAM = 'ISTCMSActivityFileExpRequest':Y.DEM:InstitutionId:Y.DEM:FromDate:Y.DEM:ToDate:Y.DEM:FromCardNumber:Y.DEM:ToCardNumber:Y.DEM:CardType:Y.DEM:BranchId:Y.DEM:UrgentCards:Y.DEM:PreEmbossedCards:Y.DEM:RepeadInProduction
    ERROR.CODE = CALLJEE(ACTIVATION,INPUT_PARAM)

    IF FIELD(INPUT_PARAM,':',1) EQ 'FAILED' THEN
        E='EB-CONNECT.FAIL'
        Y.CARD.AB.LIST=R.NEW(REDO.CARD.GEN.CARD.NUMBERS)
        CHANGE @VM TO ' ' IN Y.CARD.AB.LIST
        CHANGE @SM TO ' ' IN Y.CARD.AB.LIST
        DESC='Java API Failure,Card Nos:':Y.CARD.AB.LIST
*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*MANUAL R22 CODE CONVERSION
        R.NEW(REDO.CARD.GEN.RESPONSE.MSG)='ERROR'
    END

    R.NEW(REDO.CARD.GEN.EXPORT.RECORDS)<1,Y.INIT.COUNT> = FIELD(INPUT_PARAM,Y.DEM,2)
    R.NEW(REDO.CARD.GEN.RESPONSE.MSG)<1,Y.INIT.COUNT> = FIELD(INPUT_PARAM,Y.DEM,3)
RETURN
*--------------
EXCEP.PROCESS:
*--------------
    IF Y.ERROR.CODE THEN
        GOSUB IST.UPD.INTF.FAIL
        Y.RET=1
        RETURN
    END
    Y.CONNECT.IND=FIELD(Y.PARAM,Y.DEM,1)
    GOSUB IST.UPD.WS.CON
    IF Y.CONNECT.IND EQ 'FAILED' THEN
        Y.RET=1
        RETURN
    END

    Y.PARAM.SUC.FAIL=FIELD(Y.PARAM,Y.DEM,3)
    IF Y.PARAM.SUC.FAIL THEN

        GOSUB IST.UPD.WS.RESP
        Y.RET=1
    END
RETURN

*--------------
FILE.UPD.CHECK:
*--------------
    IF FIELD(INPUT_PARAM,Y.DEM,2) EQ 0 THEN
        E=FIELD(INPUT_PARAM,Y.DEM,3)

        Y.CARD.AB.LIST=R.NEW(REDO.CARD.GEN.CARD.NUMBERS)
        CHANGE @VM TO ' ' IN Y.CARD.AB.LIST
        CHANGE @SM TO ' ' IN Y.CARD.AB.LIST

*        DESC=FIELD(INPUT_PARAM,Y.DEM,3):R.NEW(REDO.CARD.GEN.CARD.NUMBERS)
        DESC='Update could not be processed,Card Nos:':Y.CARD.AB.LIST
*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);*MANUAL R22 CODE CONVERSION
        R.NEW(REDO.CARD.GEN.RESPONSE.MSG)='ERROR'
    END

RETURN
*--------------
IST.UPD.WS.RESP:
*--------------

    FN.EB.ERROR='F.EB.ERROR'
    F.EB.ERROR=''
    CALL OPF(FN.EB.ERROR,F.EB.ERROR)

    CALL CACHE.READ(FN.EB.ERROR, "EB-UPD.NO.PROCESS", R.EB.ERROR, ERR) ;*AUTO R22 CODE CONVERSION
    Y.RESP.ERR=R.EB.ERROR<EB.ERR.ERROR.MSG>:' ':Y.PARAM.SUC.FAIL:',Card Nos:'
    Y.CARD.AB.LIST=R.NEW(REDO.CARD.GEN.CARD.NUMBERS)
    CHANGE @VM TO ' ' IN Y.CARD.AB.LIST
    CHANGE @SM TO ' ' IN Y.CARD.AB.LIST
    DESC=Y.RESP.ERR:Y.CARD.AB.LIST
    INT.CODE='EMB005'
    INT.TYPE='ONLINE'
    E='EB-UPD.NO.PROC.DISP'

*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION
    R.NEW(REDO.CARD.GEN.RESPONSE.MSG)='ERROR'
RETURN
*---------------
IST.UPD.WS.CON:
*---------------
    INT.CODE='EMB005'
    INT.TYPE='ONLINE'
    Y.CONNECT.IND=FIELD(Y.CONNECT.IND,':',1)
    IF Y.CONNECT.IND EQ 'FAILED' THEN
        E='EB-CONNECT.FAIL'
        Y.CARD.AB.LIST=R.NEW(REDO.CARD.GEN.CARD.NUMBERS)
        CHANGE @VM TO ' ' IN Y.CARD.AB.LIST
        CHANGE @SM TO ' ' IN Y.CARD.AB.LIST
        DESC='Java API Failure,Card Nos:':Y.CARD.AB.LIST
*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION
        R.NEW(REDO.CARD.GEN.RESPONSE.MSG)='ERROR'
    END
RETURN
*----------------
IST.UPD.INTF.FAIL:
*----------------
    E='EB-CONNECT.FAIL'
    Y.CARD.AB.LIST=R.NEW(REDO.CARD.GEN.CARD.NUMBERS)
    CHANGE @VM TO ' ' IN Y.CARD.AB.LIST
    CHANGE @SM TO ' ' IN Y.CARD.AB.LIST

    DESC='Java API Failure,Card Nos:':Y.CARD.AB.LIST
*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION
    R.NEW(REDO.CARD.GEN.RESPONSE.MSG)='ERROR'
RETURN

END
