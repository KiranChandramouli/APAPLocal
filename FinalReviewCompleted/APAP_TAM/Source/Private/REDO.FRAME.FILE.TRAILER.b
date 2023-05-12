* @ValidationCode : MjoxMTYyNDI3NzQ3OkNwMTI1MjoxNjgzMDkxODUxNzk2OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 May 2023 11:00:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.FRAME.FILE.TRAILER
*********************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.FRAME.FILE.TRAILER
***********************************************************************************
*Description:    This routine will frame the trailer message based on values updated
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*07.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
** 06-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 06-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.VISA.STLMT.MAPPING


    GOSUB INIT
    GOSUB PROCESS

RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.REDO.VISA.STLMT.MAPPING='F.REDO.VISA.STLMT.MAPPING'
    F.REDO.VISA.STLMT.MAPPING=''
    CALL OPF(FN.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING)

    TRAILER.LINE=''
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


    SYSTEM.ID ='920'
    CALL F.READ(FN.REDO.VISA.STLMT.MAPPING,SYSTEM.ID,R.REDO.VISA.STLMT.MAPPING,F.REDO.VISA.STLMT.MAPPING,VISA.STLMT.MAPPING.ERR)
    TRAILER.LINE = ''
    FIELD.NAME  = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.FIELD.NAME>
    Y.FLD.COUNT=DCOUNT(FIELD.NAME,@VM)
    Y.VAR.NO=1

    LOOP

    WHILE Y.VAR.NO LE Y.FLD.COUNT
        Y.FIELD.VALUE=''

        IF R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.CONSTANT,Y.VAR.NO>  NE '' THEN
            Y.FIELD.VALUE = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.CONSTANT,Y.VAR.NO>
        END

        OUT.VERIFY.RTN = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.VERIFY.OUT.RTN,Y.VAR.NO>

        IF OUT.VERIFY.RTN NE '' THEN
            CALL @OUT.VERIFY.RTN
        END

        PADDING.STR = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.PADDING,Y.VAR.NO>
        END.POS  = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.END.POS,Y.VAR.NO>
        START.POS = R.REDO.VISA.STLMT.MAPPING<STLMT.MAP.START.POS,Y.VAR.NO>
*LEN.FIELD = END.POS - START.POS + 1
        LEN.FIELD = END.POS
*CALL APAP.TAM.REDO.FMT.OUT.PADDING
        CALL APAP.TAM.redoFmtOutPadding()
        TRAILER.LINE = TRAILER.LINE:Y.FIELD.VALUE
        Y.VAR.NO += 1 ;* R22 Auto conversion
    REPEAT

    FILE.TRAILER=TRAILER.LINE
RETURN

END
