* @ValidationCode : MjotMzU5Njg1NTA2OkNwMTI1MjoxNjgxMjA5OTY1MjYxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 16:16:05
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
SUBROUTINE REDO.LY.V.EX.PROD.AS
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RMONDRAGON
* PROGRAM NAME: REDO.LY.V.EX.PROD.AS
* ODR NO      : ODR-2011-06-0243
*----------------------------------------------------------------------
*DESCRIPTION: This subroutine is performed in REDO.LY.MODALITY,CREATE version
* The functionality is to validate the exisiting active products
* when the modality by existing active products is defined.

*PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:  REDO.LY.MODALITY
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*17.11.2011  RMONDRAGON    ODR-2011-06-0243    FIRST VERSION
*23.05.2012  RMONDRAGON    ODR-2011-06-0243    MODIFICATION TO VALIDATE
*                                              PRODUCT,NO.PRODS & AMOUNT.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, ++ TO +=, F.READ TO CACHE.READ
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.MODALITY

    IF VAL.TEXT THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END

RETURN

*----------
OPEN.FILES:
*----------

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

RETURN

*-------
PROCESS:
*-------

    Y.TYPE = R.NEW(REDO.MOD.TYPE)
    Y.EX.PROD.AS = R.NEW(REDO.MOD.EX.PROD.AS)

    IF Y.TYPE EQ '7' AND Y.EX.PROD.AS EQ '' THEN
        AF = REDO.MOD.EX.PROD.AS
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
        RETURN
    END

    Y.EX.PROD.AS.CNT = DCOUNT(Y.EX.PROD.AS,@VM)
    Y.EPA.CNT = 1
    LOOP
    WHILE Y.EPA.CNT LE Y.EX.PROD.AS.CNT
        Y.FIELDVAL = FIELD(Y.EX.PROD.AS,@VM,Y.EPA.CNT)
        AF = REDO.MOD.EX.PROD.AS
        AV = Y.EPA.CNT
        Y.FIELDVAL.CNT = DCOUNT(Y.FIELDVAL,',')
        IF Y.FIELDVAL.CNT NE 3 THEN
            ETEXT = 'EB-REDO.LY.V.EPA.FORMAT'
            CALL STORE.END.ERROR
            RETURN
        END
        Y.PR = FIELD(Y.FIELDVAL,',',1)
        GOSUB VAL.PR
        Y.FLG.FOR.NO = 'Y'
        Y.NO = FIELD(Y.FIELDVAL,',',2)
        Y.VAL.NO = Y.NO
        GOSUB VAL.NO
        Y.FLG.FOR.NO = 'N'
        Y.AMT = FIELD(Y.FIELDVAL,',',3)
        Y.VAL.NO = Y.AMT
        GOSUB VAL.NO
        Y.EPA.CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN

*------
VAL.PR:
*------

    R.CATEGORY = ''; CAT.ERR = ''
    CALL CACHE.READ(FN.CATEGORY, Y.PR, R.CATEGORY, CAT.ERR) ;*AUTO R22 CODE CONVERSION
    IF R.CATEGORY THEN
        RETURN
    END ELSE
        ETEXT = 'EB-REDO.LY.V.PR'
        CALL STORE.END.ERROR
    END

RETURN

*------
VAL.NO:
*------

    IF Y.VAL.NO EQ '' THEN
        ETEXT = 'EB-REDO.LY.V.EPA.FORMAT'
        CALL STORE.END.ERROR
        RETURN
    END

    IF Y.FLG.FOR.NO EQ 'Y' THEN
        IF NOT(ISDIGIT(Y.VAL.NO)) OR Y.VAL.NO LT 1 THEN
            ETEXT = 'EB-REDO.LY.V.NO'
            CALL STORE.END.ERROR
            RETURN
        END
    END ELSE
        IF Y.FLG.FOR.NO EQ 'N' AND NOT(NUM(Y.VAL.NO)) THEN
            ETEXT = 'EB-REDO.CHECK.FIELDS.F.NONUM.2'
            CALL STORE.END.ERROR
        END
    END

RETURN

END
