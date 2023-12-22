* @ValidationCode : MjotOTA5ODg2NTA4OkNwMTI1MjoxNzAzMTUwMTQzNTE4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 14:45:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.BCR.REPORT.BUILD
*-----------------------------------------------------------------------------
*** Simple SUBROUTINE template
* @author youremail@temenos.com
* @stereotype subroutine
* @package infra.eb
*!
*-------------------------------------------------------------------------------------
*Modification
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION FM TO @FM AND ++ TO += 1
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*20/12/2023           Suresh              R22 Manual Conversion   F.READ TO CACHE.READ
*--------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_REDO.B.BCR.REPORT.BUILD.COMMON
    $USING APAP.TAM
    $USING APAP.REDOCHNLS
    $USING APAP.LAPAP
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    IF Y.RID.LIST EQ "" THEN    ;* Nothing to do
        RETURN
    END

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    K.INT.CODE=''
    K.INT.TYPE='BATCH'
    K.BAT.NO=1
    K.BAT.TOT=DCOUNT(Y.RID.LIST,@FM)
    K.INFO.OR=''
    K.INFO.DE=''
    K.ID.PROC=K.BAT.NO
    K.MON.TP=''
    K.DESC=''
    K.REC.CON=''
    K.EX.USER='OPERATOR'
    K.EX.PC='TNO'

    LOOP
        REMOVE Y.REDO.INT.PARAM.ID FROM Y.RID.LIST SETTING Y.POS
    WHILE Y.POS : Y.REDO.INT.PARAM.ID
*  CALL F.READ(FN.REDO.INT.PARAM, Y.REDO.INT.PARAM.ID, R.REDO.INT.PARAM, F.REDO.INT.PARAM, Y.ERR)
        CALL CACHE.READ(FN.REDO.INT.PARAM, Y.REDO.INT.PARAM.ID, R.REDO.INT.PARAM,Y.ERR) ;*R22 Manual Conversion
        
        IF Y.ERR NE '' THEN
            TEXT = "ERROR AL PROCESAR BURO CREDITO " : Y.ERR
            CALL FATAL.ERROR('REDO.B.BCR.REPORT.BUILD' : Y.REDO.INT.PARAM.ID)
        END
        E=''
*       CALL REDO.R.BCR.REPORT.BUILD(Y.REDO.INT.PARAM.ID,'BATCH',R.REDO.INT.PARAM)
        APAP.LAPAP.redoRBcrReportBuild() ;*R22 Manual Code Conversion
        IF E NE '' THEN
            K.INT.CODE=Y.REDO.INT.PARAM.ID
*           CALL REDO.INTERFACE.REC.ACT(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC)
            APAP.REDOCHNLS.redoInterfaceRecAct(K.INT.CODE,K.INT.TYPE,K.BAT.NO,K.BAT.TOT,K.INFO.OR,K.INFO.DE,K.ID.PROC,K.MON.TP,K.DESC,K.REC.CON,K.EX.USER,K.EX.PC) ;*R22 Manual Code Conversion
        END
        K.BAT.NO += 1
    REPEAT

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    Y.RID.LIST = ''   ;* List of the records into REDO.INTERFACE.PARAM to process
* Check if there are some to process
*    CALL REDO.R.BCR.REPORT.GEN.LIST.GET(Y.RID.LIST)
    APAP.TAM.redoRBcrReportGenListGet(Y.RID.LIST) ;*R22 Manual Code Conversion
    IF Y.RID.LIST EQ "" THEN
        RETURN          ;* Process must not be continued
    END

    FN.REDO.INT.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INT.PARAM = ''
    CALL OPF(FN.REDO.INT.PARAM, F.REDO.INT.PARAM)


RETURN

END
