* @ValidationCode : MjoxMzQ4MjA3NTg6Q3AxMjUyOjE2ODI1OTgwMTYxMjE6c2FtYXI6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:16
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
SUBROUTINE REDO.CARD.PIN.RESET.UPD

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
*11-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM FREAD TO CACHEREAD
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION           CALL RTN METHOD ADDED
*----------------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.ERROR
    $INSERT I_F.REDO.CARD.PIN.RESET
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT JBC.h
    $USING APAP.REDOCHNLS
    GOSUB INIT
    GOSUB PROCESS
RETURN
*----
INIT:
*-----
    FN.REDO.CARD.BIN='F.REDO.CARD.BIN'
    F.REDO.CARD.BIN=''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    FN.LATAM.CARD.ORDER ='F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER =''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    FN.EB.ERROR='F.EB.ERROR'
    F.EB.ERROR=''
    CALL OPF(FN.EB.ERROR,F.EB.ERROR)

RETURN
*-------
PROCESS:
*-------

    CALL CACHE.READ('F.REDO.APAP.H.PARAMETER','SYSTEM',R.APAP.PARAM,PARAM.ERR)
    Y.DEM=R.APAP.PARAM<PARAM.DELIMITER>
    VAR.ID = ID.NEW[1,6]
    CALL F.READ(FN.REDO.CARD.BIN,VAR.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,ERR)
    Y.CARD.TYPE=R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    CHANGE @VM TO @FM IN Y.CARD.TYPE
    Y.TOT.CARD.TYPE=DCOUNT(Y.CARD.TYPE,@FM)
    Y.CARD.CNT=1
    LOOP
    WHILE Y.CARD.CNT LE Y.TOT.CARD.TYPE
        Y.LATAM.CARD.ID=Y.CARD.TYPE<Y.CARD.CNT>:'.':ID.NEW
        Y.CARD.ERR=''
        CALL F.READ(FN.LATAM.CARD.ORDER,Y.LATAM.CARD.ID,R.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER,Y.CARD.ERR)
        ACTIVATION = "APAP_EMBOZADO_WEBSERVICES"

        IF NOT(Y.CARD.ERR) THEN
            INPUT_PARAM = "IST_ResetPinOffsetRequest":Y.DEM:ID.NEW:Y.DEM:OPERATOR
            Y.RESPONSE = CALLJEE(ACTIVATION,INPUT_PARAM)
            Y.OUTPUT=INPUT_PARAM
            CHANGE Y.DEM TO @FM IN Y.OUTPUT
            IF Y.OUTPUT<1> NE 'FAIL' THEN
                IF Y.OUTPUT<4> NE '0' THEN
                    AF=RCPR.NAME.ON.PLASTIC
                    E="EB-RESET.FAILED"
                    CALL STORE.END.ERROR
                    CALL CACHE.READ(FN.EB.ERROR, "EB-UPD.NO.PROCESS", R.EB.ERROR, ERR) ;* R22 CODE CONVERSION
                    DESC=R.EB.ERROR<EB.ERR.ERROR.MSG,1>:' ':Y.OUTPUT<4>
                    GOSUB LOG.C22.UPDATE
                END
            END
            ELSE
                AF=RCPR.NAME.ON.PLASTIC
                E="EB-RESET.FAILED"
                CALL STORE.END.ERROR
                CALL CACHE.READ(FN.EB.ERROR, "EB-CONNECT.FAIL", R.EB.ERROR, ERR) ;* R22 CODE CONVERSION
                DESC=R.EB.ERROR<EB.ERR.ERROR.MSG,1>
                GOSUB LOG.C22.UPDATE
            END
        END
        Y.CARD.CNT += 1
    REPEAT
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
*CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP.REJ,DESC,REC.CON,EX.USER,EX.PC)
    CALL APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP.REJ,DESC,REC.CON,EX.USER,EX.PC) ;*MANUAL R22 CODE CONVERSION

RETURN
END
