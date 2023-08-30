* @ValidationCode : MjotMTc2MDUyMjUwNjpDcDEyNTI6MTY4MjQyMTEwNDc2NDozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 16:41:44
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
SUBROUTINE REDO.FC.S.VALID.COLL

*------------------------------------------------------------------------------------------------------------------
* Developer    : mgudino@temenos.com
* Date         : 2011-06-13
* Description  : Manage the execute way of Validations Rutines
*
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :
* Out :
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
* 1.0              2011-06-13    Marcelo Gudi First Version
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           FM TO @FM, VM TO @VM
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FC.BH.VALIDATIONS
*
    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*----------
PROCESS:
*----------
*
    GOSUB PROCESS.VERSION
RETURN

*-----------------
PROCESS.VERSION:
*-----------------
*
    Y.VERSION.NAME = SUBSTRINGS (Y.VERSION.NAME, 2, Y.COUNT.VERSION)
    CALL CACHE.READ(FN.REDO.FC.BH.VALIDATIONS, Y.VERSION.NAME, R.REDO.FC.BH.VALIDATIONS, Y.ERR)

    IF Y.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.REDO.FC.BH.VALIDATIONS
        CALL STORE.END.ERROR
    END ELSE
        Y.COUNT.VAL = DCOUNT(R.REDO.FC.BH.VALIDATIONS<REDO.BH.NAME.RUTINE>,@VM)
* To Iterate in R.REDO.FC.BH.VALIDATIONS records
        FOR Y.I = 1 TO Y.COUNT.VAL
            Y.RUTINE.NAME = R.REDO.FC.BH.VALIDATIONS<REDO.BH.NAME.RUTINE,Y.I>
            IF Y.RUTINE.NAME THEN
                GOSUB PROCESS.ROUTINE
            END
        NEXT
    END

RETURN

*-----------------
PROCESS.ROUTINE:
*-----------------
*
    CALL @Y.RUTINE.NAME

RETURN

*------------
INITIALISE:
*------------
*
    YERR = ''
    Y.APP.NAME = ''
    Y.VERSION.NAME = PGM.VERSION
    Y.COUNT.VERSION = LEN(Y.VERSION.NAME)
    Y.RUTINE.NAME = ''
    Y.CONT.VAL = 0

    FN.REDO.FC.BH.VALIDATIONS = 'F.REDO.FC.BH.VALIDATIONS'
    F.REDO.FC.BH.VALIDATIONS = ''


RETURN
*------------
OPENFILES:
*------------
*   Paragraph that open files
*

RETURN
*------------
END
