* @ValidationCode : MjotMTkwNTkyOTYxOTpDcDEyNTI6MTY4MTIwODUyOTQ2MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 15:52:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.LY.INP.DIS.FIELDS.M
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.LY.INP.DIS.FIELDS.M
* ODR NO      : ODR-2009-12-0276
* HD REFERNCE : HD1102522 & HD1102517
*----------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.LY.MODALITY,CREATE version
* The functionality is to disable some fields according with the modality
* type,form.generation & Product.type to apply for point generation and also validate fields among them.
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:  REDO.LY.MODALITY
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, SM TO @SM
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.MODALITY
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
*This main para is used to disable fields based on field values
    Y.PRD.GROUP = R.NEW(REDO.MOD.PRODUCT.GROUP)
    Y.TYPE = R.NEW(REDO.MOD.TYPE)
    Y.FORM.GEN = R.NEW(REDO.MOD.FORM.GENERATION)
    IF Y.TYPE NE '1' AND Y.TYPE NE '6' AND Y.TYPE NE '7' THEN
        R.NEW(REDO.MOD.FORM.GENERATION)='1'
        T(REDO.MOD.CHANNEL)<3>='NOINPUT'
        T(REDO.MOD.APP.TXN)<3>='NOINPUT'
        T(REDO.MOD.TXN.CODE)<3>='NOINPUT'
        T(REDO.MOD.FORM.GENERATION)<3>='NOINPUT'
        T(REDO.MOD.PRODUCT.GROUP)<3>='NOINPUT'
        T(REDO.MOD.MIN.DISBURSE.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.POINTS)<3>='NOINPUT'
        T(REDO.MOD.INT.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.UP.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.INT.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.EVENT)<3>='NOINPUT'
        T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
        GOSUB PROCESS1
        R.NEW(REDO.MOD.EVENT) = ''
        R.NEW(REDO.MOD.EX.PROD.AS) = ''
        GOSUB CHECK.AMT
    END
    IF Y.TYPE EQ '6' THEN
        R.NEW(REDO.MOD.FORM.GENERATION)='1'
        T(REDO.MOD.CHANNEL)<3>='NOINPUT'
        T(REDO.MOD.APP.TXN)<3>='NOINPUT'
        T(REDO.MOD.TXN.CODE)<3>='NOINPUT'
        T(REDO.MOD.FORM.GENERATION)<3>='NOINPUT'
        T(REDO.MOD.PRODUCT.GROUP)<3>='NOINPUT'
        T(REDO.MOD.MIN.DISBURSE.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.POINTS)<3>='NOINPUT'
        T(REDO.MOD.INT.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.UP.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.UP.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.INT.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
        GOSUB PROCESS1
        R.NEW(REDO.MOD.LOW.LIM.AMT) = ''
        R.NEW(REDO.MOD.UP.LIM.AMT) = ''
        R.NEW(REDO.MOD.EX.PROD.AS)= ''
        Y.FIELD.VALUE = R.NEW(REDO.MOD.EVENT)
        AF = REDO.MOD.EVENT
        GOSUB ERROR.CHECK
        GOSUB CHK.AMT
    END
    IF Y.TYPE EQ '7' THEN
        R.NEW(REDO.MOD.FORM.GENERATION)='1'
        T(REDO.MOD.CHANNEL)<3>='NOINPUT'
        T(REDO.MOD.APP.TXN)<3>='NOINPUT'
        T(REDO.MOD.TXN.CODE)<3>='NOINPUT'
        T(REDO.MOD.FORM.GENERATION)<3>='NOINPUT'
        T(REDO.MOD.PRODUCT.GROUP)<3>='NOINPUT'
        T(REDO.MOD.MIN.DISBURSE.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.POINTS)<3>='NOINPUT'
        T(REDO.MOD.INT.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.UP.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.UP.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.INT.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.EVENT)<3>='NOINPUT'
        GOSUB PROCESS1
        R.NEW(REDO.MOD.EVENT) = ''
        R.NEW(REDO.MOD.LOW.LIM.AMT) = ''
        R.NEW(REDO.MOD.UP.LIM.AMT) = ''
        Y.FIELD.VALUE = R.NEW(REDO.MOD.EX.PROD.AS)
        AF = REDO.MOD.EX.PROD.AS
        GOSUB ERROR.CHECK
        GOSUB CHK.AMT
    END
    IF Y.TYPE EQ '1' THEN
        T(REDO.MOD.EVENT)<3> = 'NOINPUT'
        T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
        R.NEW(REDO.MOD.EVENT) = ''
        R.NEW(REDO.MOD.EX.PROD.AS) = ''
        GOSUB CHECK.FIELD.VALUES
    END
    IF Y.TYPE EQ '1' AND Y.FORM.GEN EQ '1' THEN
        T(REDO.MOD.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.INT.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.EVENT)<3> = 'NOINPUT'
        T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
        GOSUB CHECK.POINTS
        R.NEW(REDO.MOD.EVENT) = ''
        R.NEW(REDO.MOD.EX.PROD.AS) = ''
    END
    IF Y.TYPE EQ '1' AND Y.FORM.GEN EQ '2' THEN
        T(REDO.MOD.GEN.POINTS)<3> = 'NOINPUT'
        T(REDO.MOD.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.UP.LIM.AMT)<3> = 'NOINPUT'
        T(REDO.MOD.INT.GEN.POINTS)<3>='NOINPUT'
        T(REDO.MOD.INT.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.UP.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.EVENT)<3>='NOINPUT'
        T(REDO.MOD.EX.PROD.AS)<3> = 'NOINPUT'
        GOSUB CHECK.FACTOR
        R.NEW(REDO.MOD.EVENT) = ''
        R.NEW(REDO.MOD.EX.PROD.AS) = ''
    END
RETURN
*--------------
CHECK.POINTS:
*--------------
*This para is used to disable the fields based on PRODUCT GROUP, TYPE & FORM.GENERATION values
    IF Y.PRD.GROUP EQ '1' OR Y.PRD.GROUP EQ '4' THEN
        T(REDO.MOD.INT.GEN.POINTS)<3>='NOINPUT'
        T(REDO.MOD.INT.LOW.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.INT.UP.LIM.AMT)<3>='NOINPUT'
        T(REDO.MOD.MIN.DISBURSE.AMT)<3> = 'NOINPUT'
        GOSUB PROCESS2
        R.NEW(REDO.MOD.MIN.DISBURSE.AMT) = ''
    END ELSE
        IF Y.PRD.GROUP EQ '2' THEN
            T(REDO.MOD.INT.GEN.POINTS)<3>='NOINPUT'
            T(REDO.MOD.INT.LOW.LIM.AMT)<3>='NOINPUT'
            T(REDO.MOD.INT.UP.LIM.AMT)<3>='NOINPUT'
            GOSUB PROCESS2
        END ELSE
            T(REDO.MOD.GEN.POINTS)<3>='NOINPUT'
            T(REDO.MOD.LOW.LIM.AMT)<3>='NOINPUT'
            T(REDO.MOD.UP.LIM.AMT)<3>='NOINPUT'
            GOSUB PROCESS3
        END
    END
RETURN
*-------------
CHECK.FACTOR:
*-------------
*This para is used to disable the fields based on PRODUCT GROUP, TYPE & FORM.GENERATION values
    IF Y.PRD.GROUP EQ '1' OR Y.PRD.GROUP EQ '4' THEN
        T(REDO.MOD.INT.GEN.FACTOR)<3>='NOINPUT'
        T(REDO.MOD.INT.MIN.GEN)<3>='NOINPUT'
        T(REDO.MOD.INT.MAX.GEN)<3>='NOINPUT'
        T(REDO.MOD.MIN.DISBURSE.AMT)<3> = 'NOINPUT'
        R.NEW(REDO.MOD.MIN.DISBURSE.AMT) = ''
        GOSUB PROCESS4
    END ELSE
        IF Y.PRD.GROUP EQ '2' THEN
            T(REDO.MOD.INT.GEN.FACTOR)<3>='NOINPUT'
            T(REDO.MOD.INT.MIN.GEN)<3>='NOINPUT'
            T(REDO.MOD.INT.MAX.GEN)<3>='NOINPUT'
            GOSUB PROCESS4
        END ELSE
            T(REDO.MOD.GEN.FACTOR)<3> = 'NOINPUT'
            T(REDO.MOD.MIN.GEN)<3>='NOINPUT'
            T(REDO.MOD.MAX.GEN)<3> = 'NOINPUT'
            GOSUB PROCESS5
        END
    END
RETURN
*--------------------------------------------
PROCESS1:
*--------------------------------------------
    R.NEW(REDO.MOD.CHANNEL)=''
    R.NEW(REDO.MOD.APP.TXN)=''
    R.NEW(REDO.MOD.TXN.CODE)=''
    R.NEW(REDO.MOD.PRODUCT.GROUP)=''
    R.NEW(REDO.MOD.MIN.DISBURSE.AMT)=''
    R.NEW(REDO.MOD.INT.GEN.POINTS)=''
    R.NEW(REDO.MOD.INT.LOW.LIM.AMT)=''
    R.NEW(REDO.MOD.INT.UP.LIM.AMT)=''
    R.NEW(REDO.MOD.INT.GEN.FACTOR)=''
    R.NEW(REDO.MOD.INT.MIN.GEN)=''
    R.NEW(REDO.MOD.INT.MAX.GEN)=''
    R.NEW(REDO.MOD.GEN.FACTOR)=''
    R.NEW(REDO.MOD.MIN.GEN)=''
    R.NEW(REDO.MOD.MAX.GEN)=''
RETURN
*--------------------------------------------
*-----------------------------------------
PROCESS2:
*-----------------------------------------
    R.NEW(REDO.MOD.INT.GEN.POINTS) = ''
    R.NEW(REDO.MOD.INT.LOW.LIM.AMT) = ''
    R.NEW(REDO.MOD.INT.UP.LIM.AMT)= ''
RETURN
*-----------------------------------------
PROCESS3:
*-----------------------------------------
    R.NEW(REDO.MOD.GEN.POINTS) = ''
    R.NEW(REDO.MOD.LOW.LIM.AMT) = ''
    R.NEW(REDO.MOD.UP.LIM.AMT) = ''
RETURN
*-----------------------------------------
PROCESS4:
*-----------------------------------------
    R.NEW(REDO.MOD.INT.GEN.FACTOR) = ''
    R.NEW(REDO.MOD.INT.MIN.GEN) = ''
    R.NEW(REDO.MOD.INT.MAX.GEN) = ''
RETURN
*------------------------------------------
PROCESS5:
*------------------------------------------
    R.NEW(REDO.MOD.GEN.FACTOR) = ''
    R.NEW(REDO.MOD.MIN.GEN) = ''
    R.NEW(REDO.MOD.MAX.GEN) = ''
RETURN
*-------------------------------------------
ERROR.CHECK:
*-------------------------------------------
*This para is used to validate the fieldsd based on TYPE field
    IF Y.FIELD.VALUE EQ '' THEN
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END
RETURN
*----------------------------------------------
CHECK.AMT:
*--------------------------------------------------
    Y.FIELD.VALUE = R.NEW(REDO.MOD.GEN.POINTS)
    CHANGE @VM TO @FM IN Y.FIELD.VALUE
    FIELD.CNT=DCOUNT(Y.FIELD.VALUE,@FM)
    IF FIELD.CNT THEN
        FOR CNT=1 TO FIELD.CNT
            Y.LOW.AMT =  R.NEW(REDO.MOD.LOW.LIM.AMT)<1,CNT>
            Y.UP.AMT =R.NEW(REDO.MOD.UP.LIM.AMT)<1,CNT>
            Y.GEN.AMT = Y.FIELD.VALUE<CNT>
            BEGIN CASE
                CASE Y.GEN.AMT EQ ''
                    AF = REDO.MOD.GEN.POINTS
                    GOSUB AMT.ERROR
                CASE Y.LOW.AMT EQ ''
                    AF = REDO.MOD.LOW.LIM.AMT
                    GOSUB AMT.ERROR
                CASE Y.UP.AMT EQ ''
                    AF = REDO.MOD.UP.LIM.AMT
                    GOSUB AMT.ERROR
            END CASE
        NEXT CNT
    END ELSE
        AF = REDO.MOD.GEN.POINTS
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END
RETURN
*---------------------------------------------------
AMT.ERROR:
*----------------------------------------------------
    AV = CNT
    ETEXT = 'EB-REDO.CHECK.AMT':@FM:Y.TYPE
    CALL STORE.END.ERROR
RETURN
*-----------------------------------------------------
CHK.AMT:
*-----------------------------------------------------
    Y.VALUE.POINT = R.NEW(REDO.MOD.GEN.POINTS)
    CHANGE @VM TO @FM IN Y.VALUE.POINT
    FIELD.CNT=DCOUNT(Y.VALUE.POINT,@FM)
    IF FIELD.CNT THEN
        IF FIELD.CNT GT 1 THEN
            AF = REDO.MOD.GEN.POINTS
            ETEXT = 'EB-REDO.CHECK.MULTIVALUE':@FM:Y.TYPE
            CALL STORE.END.ERROR
        END ELSE
            IF Y.VALUE.POINT EQ '' THEN
                AF = REDO.MOD.GEN.POINTS
                ETEXT = 'EB-REDO.CHECK.AMT':@FM:Y.TYPE
                CALL STORE.END.ERROR
            END
        END
    END ELSE
        AF = REDO.MOD.GEN.POINTS
        ETEXT = 'EB-REDO.CHECK.AMT':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END
RETURN
*-----------------------------------------------------
CHECK.FIELD.VALUES:
*-----------------------------------------------------
    Y.VALUE.CHANNEL = R.NEW(REDO.MOD.CHANNEL)
    Y.VALUE.APP.TXN =  R.NEW(REDO.MOD.APP.TXN)
    Y.VALUE.TXN.CODE = R.NEW(REDO.MOD.TXN.CODE)
    Y.VALUE.FORM.GEN  = R.NEW(REDO.MOD.FORM.GENERATION)
    Y.VALUE.PDT.GRP = R.NEW(REDO.MOD.PRODUCT.GROUP)
    GOSUB CHK.CHANNEL
    GOSUB CHK.APP
    GOSUB CHK.TXN.CODE
    GOSUB CHK.FORM.GEN
    GOSUB CHK.PDT.GRP
RETURN
*--------------------------------------------------------
CHK.CHANNEL:
*---------------------------------------------------------
    CHANGE @VM TO @FM IN Y.VALUE.CHANNEL
    FIELD.CNT=DCOUNT(Y.VALUE.CHANNEL,@FM)
    IF FIELD.CNT THEN
        FOR CNT=1 TO FIELD.CNT
            Y.CHANNEL = Y.VALUE.CHANNEL<CNT>
            IF Y.CHANNEL EQ '' THEN
                AF = REDO.MOD.CHANNEL
                GOSUB AMT.ERROR
            END
        NEXT CNT
    END ELSE
        AF = REDO.MOD.CHANNEL
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------
CHK.APP:
*---------------------------------------------------------
    CHANGE @VM TO @FM IN Y.VALUE.APP.TXN
    FIELD.CNT=DCOUNT(Y.VALUE.APP.TXN,@FM)
    IF FIELD.CNT THEN
        FOR CNT=1 TO FIELD.CNT
            Y.APP.TXN = Y.VALUE.APP.TXN<CNT>
            IF Y.APP.TXN EQ '' THEN
                AF = REDO.MOD.APP.TXN
                GOSUB AMT.ERROR
            END
        NEXT CNT
    END ELSE
        AF = REDO.MOD.APP.TXN
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------
CHK.TXN.CODE:
*--------------------------------------------------------
    VM.FIELD.CNT=DCOUNT(Y.VALUE.TXN.CODE,@VM)
    IF VM.FIELD.CNT THEN
        FOR VM.CNT=1 TO VM.FIELD.CNT
            Y.TXN.CODE = Y.VALUE.TXN.CODE<1,VM.CNT>
            SM.FIELD.CNT = DCOUNT(Y.TXN.CODE,@SM)
            FOR SM.CNT = 1 TO SM.FIELD.CNT
                Y.TXN.CODE.VAL = Y.VALUE.TXN.CODE<1,VM.CNT,SM.CNT>
                IF Y.TXN.CODE.VAL EQ '' THEN
                    AF = REDO.MOD.TXN.CODE
                    AV = VM.CNT
                    AS = SM.CNT
                    ETEXT = 'EB-REDO.CHECK.AMT':@FM:Y.TYPE
                    CALL STORE.END.ERROR
                END
            NEXT SM.CNT
        NEXT VM.CNT
    END ELSE
        AF = REDO.MOD.TXN.CODE
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END
RETURN
*--------------------------------------------------------
CHK.FORM.GEN:
*---------------------------------------------------------
    IF Y.VALUE.FORM.GEN EQ '' THEN
        AF = REDO.MOD.FORM.GENERATION
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END
RETURN
*--------------------------------------------------------
CHK.PDT.GRP:
*---------------------------------------------------------
    IF Y.VALUE.PDT.GRP EQ '' THEN
        AF = REDO.MOD.PRODUCT.GROUP
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END
RETURN
*---------------------------------------------
END
