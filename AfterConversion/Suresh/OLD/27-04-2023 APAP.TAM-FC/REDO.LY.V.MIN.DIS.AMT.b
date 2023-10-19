* @ValidationCode : MjotMjA2MzQ2MTk0NzpDcDEyNTI6MTY4MTIxMDI1NjU2MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 16:20:56
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
SUBROUTINE  REDO.LY.V.MIN.DIS.AMT
*-----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the amount for minimum
*              disburse amount if modality is configured with product group
*              related to Loans.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.MIN.DIS.AMT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*23.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.MODALITY
    $INSERT I_F.REDO.LY.PDT.TYPE

    IF VAL.TEXT THEN
        GOSUB PROCESS
    END

RETURN

***********
OPEN.FILES:
***********

    FN.REDO.LY.PDT.TYPE = 'F.REDO.LY.PDT.TYPE'
    F.REDO.LY.PDT.TYPE = ''
    CALL OPF(FN.REDO.LY.PDT.TYPE,F.REDO.LY.PDT.TYPE)

RETURN

********
PROCESS:
********

    Y.PROD.GRP = R.NEW(REDO.MOD.PRODUCT.GROUP)

    GOSUB OPEN.FILES

    R.REDO.LY.PDT.TYPE = '' ; PDT.TYPE.ERR = ''
    CALL F.READ(FN.REDO.LY.PDT.TYPE,Y.PROD.GRP,R.REDO.LY.PDT.TYPE,F.REDO.LY.PDT.TYPE,PDT.TYPE.ERR)
    IF R.REDO.LY.PDT.TYPE THEN
        Y.PROD = R.REDO.LY.PDT.TYPE<REDO.PDT.PRODUCT.TYPE>
    END

    IF Y.PROD EQ 'Prestamo' THEN
        GOSUB VAL.FIELD
    END

RETURN

**********
VAL.FIELD:
**********

    Y.MIN.DIS.AMT = R.NEW(REDO.MOD.MIN.DISBURSE.AMT)
    IF Y.MIN.DIS.AMT EQ '' THEN
        AF = REDO.MOD.MIN.DISBURSE.AMT
        ETEXT = 'EB-REDO.LY.V.MIN.DIS.AMT'
        CALL STORE.END.ERROR
    END

RETURN

END
