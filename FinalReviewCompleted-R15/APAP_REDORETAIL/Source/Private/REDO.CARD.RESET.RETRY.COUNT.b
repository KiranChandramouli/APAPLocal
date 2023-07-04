* @ValidationCode : MjotMTE4NjEzMTAxMTpDcDEyNTI6MTY4MjU5ODAxNzE2MTpzYW1hcjotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:17
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
SUBROUTINE REDO.CARD.RESET.RETRY.COUNT

****************************************************************
*DESCRIPTION:
*------------
*This routine is used to reset the CARD.STATUS to Active in LATAM.CARD.ORDER table
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 12-05-2011           Prabhu.N      PACS00054646         Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*----------------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.ERROR
    $INSERT I_F.REDO.CARD.PIN.RESET
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_TSS.COMMON
    $INSERT JBC.h
    $USING APAP.REDOCHNLS
    GOSUB INIT
    GOSUB PROCESS
RETURN
*----
INIT:
*-----
    FN.EB.ERROR='F.EB.ERROR'
    F.EB.ERROR=''
    CALL OPF(FN.EB.ERROR,F.EB.ERROR)

    CALL CACHE.READ('F.REDO.APAP.H.PARAMETER','SYSTEM',R.APAP.PARAM,PARAM.ERR)
    Y.DEM=R.APAP.PARAM<PARAM.DELIMITER>
RETURN
*-------
PROCESS:
*-------
    Y.PREV.STATUS=R.OLD(CARD.IS.CARD.STATUS)
    Y.NEW.STATUS =R.NEW(CARD.IS.CARD.STATUS)
    IF Y.PREV.STATUS NE '75' OR Y.NEW.STATUS NE '94' THEN
        AF=CARD.IS.CARD.STATUS
        ETEXT="EB-RESET.CNT.FAILED"
        CALL STORE.END.ERROR
        RETURN
    END
    ACTIVATION = "APAP_EMBOZADO_WEBSERVICES"
    Y.PAN=FIELD(ID.NEW,'.',2)
    INPUT_PARAM="IST_ResetPinRetryCountRequest": Y.DEM : Y.PAN : Y.DEM : OPERATOR : Y.DEM : TSS$CLIENTIP
    Y.RESPONSE = CALLJEE(ACTIVATION,INPUT_PARAM)
    Y.OUTPUT=INPUT_PARAM
    CHANGE Y.DEM TO @FM IN Y.OUTPUT
    IF Y.OUTPUT<1>[1,4] NE 'FAIL' THEN
        IF Y.OUTPUT<4> NE '0' THEN
            AF=CARD.IS.CARD.STATUS
            ETEXT="EB-RESET.CNT.FAILED"
            CALL STORE.END.ERROR
            CALL CACHE.READ(FN.EB.ERROR, "EB-UPD.NO.PROCESS", R.EB.ERROR, ERR) ;* AUTO R22 CODE CONVERSION
            DESC=R.EB.ERROR<EB.ERR.ERROR.MSG,1>:' ':Y.OUTPUT<4>
            GOSUB LOG.C22.UPDATE
        END
    END
    ELSE
        AF=CARD.IS.CARD.STATUS
        ETEXT="EB-RESET.CNT.FAILED"
        CALL STORE.END.ERROR
        CALL CACHE.READ(FN.EB.ERROR, "EB-CONNECT.FAIL", R.EB.ERROR, ERR) ;* AUTO R22 CODE CONVERSION
        DESC=R.EB.ERROR<EB.ERR.ERROR.MSG,1>
        GOSUB LOG.C22.UPDATE
    END

RETURN
*------------------
LOG.C22.UPDATE:
*-----------------
    FN.REDO.INTERFACE.MON.TYPE='F.REDO.INTERFACE.MON.TYPE'
    F.REDO.INTERFACE.MON.TYPE=''
    CALL OPF(FN.REDO.INTERFACE.MON.TYPE,F.REDO.INTERFACE.MON.TYPE)

    BAT.NO     = ''
    BAT.TOT    = ''
    INFO.OR    = ''
    INFO.DE    = ''
    REC.CON=''
    EX.USER=OPERATOR
    EX.PC      = ''
    ID.PROC=ID.NEW
    SEL.CMD='SELECT ':FN.REDO.INTERFACE.MON.TYPE:' WITH MNEMONIC EQ REJ'
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    MON.TP.REJ=SEL.LIST<1>
    INT.CODE='EMB002'
    INT.TYPE='ONLINE'
*APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP.REJ,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP.REJ,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION

RETURN
END
