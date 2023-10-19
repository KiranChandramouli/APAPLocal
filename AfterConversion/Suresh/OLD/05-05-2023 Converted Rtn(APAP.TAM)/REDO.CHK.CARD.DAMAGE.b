* @ValidationCode : MjotMTM0NjEyNTgyODpDcDEyNTI6MTY4MDY4OTc1Mjg5NDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:45:52
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
SUBROUTINE REDO.CHK.CARD.DAMAGE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SWAMINATHAN
* PROGRAM NAME: REDO.CHK.CARD.DAMAGE
* ODR NO      : ODR-2010-03-0400
*----------------------------------------------------------------------
*DESCRIPTION: This routine is validation routine to check card status activation
*REDO.CARD.DAMAGE,CREATE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*9.03.2011  Swaminathan    ODR-2010-03-0400  INITIAL CREATION
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          VM TO @VM, SM TO @SM, -- TO -=, ++ TO +=
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION        NOCHANGE
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CARD.DAMAGE


    IF V$FUNCTION EQ 'I' THEN
        Y.COUNT = DCOUNT(R.NEW(REDO.CARD.DAM.CARD.TYPE),@VM)
        Y.CNT = 1
        LOOP
        WHILE Y.CNT LE Y.COUNT
            Y.DAM.VAL = R.NEW(REDO.CARD.DAM.REASON)<1,Y.CNT>
            Y.DAM = DCOUNT(Y.DAM.VAL,@SM)
            Y.DAM.COUNT = 1
            LOOP
            WHILE Y.DAM GT Y.DAM.COUNT
                DEL R.NEW(REDO.CARD.DAM.REASON)<1,Y.CNT,Y.DAM>
                DEL R.NEW(REDO.CARD.DAM.REMARKS)<1,Y.CNT,Y.DAM>
                DEL R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,Y.CNT,Y.DAM>
                Y.DAM -= 1 ;*AUTO R22 CODE CONVERSION

            REPEAT
            Y.CNT += 1 ;*AUTO R22 CODE CONVERSION

        REPEAT
        R.NEW(REDO.CARD.DAM.REASON)<1,1> =  ''
        R.NEW(REDO.CARD.DAM.REMARKS)<1,1> =  ''
        R.NEW(REDO.CARD.DAM.CARD.NUMBER)<1,1> = ''
    END
RETURN
END
